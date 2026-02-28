Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAD135AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302744; cv=none; b=SBQeiy2GDu7HfgL22d2uupAL0Xp1BUv0KZER/q32lLpouU6MCGCmTffVBt17fXbn2R0hMeYcuC0crwbAhXQWmPql3Kq9KVWxUUP6Xnx5d13/chfkHqW8YB0d5C6vsQVavLHUJymWYrZbixcVWeG3z3fsLTdHJLM+t4Yrt0392m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302744; c=relaxed/simple;
	bh=YOJEfol6tkw8o6Y6Rs10hqcPDUObsB4SeUFiPNcektI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvMgUMWb5yMyuu1Da9TwvHjtQK7Lwk2mrio2WKJdNEcvUkz6mHVSfVhWAPd5763DSXg8fm7cPU+0YNEq3e+5PlGHhK7AyBB3ZxdltK8eUDIXufA3AlffluiGS270QCdlJA2mBFmfSroCWbc9k5GpM8Tk6FGlSIzx8lyxA7+CD+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLbrLViA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLbrLViA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E655C19424;
	Sat, 28 Feb 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302743;
	bh=YOJEfol6tkw8o6Y6Rs10hqcPDUObsB4SeUFiPNcektI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLbrLViAcn0DdFPasqw397cnn+T+FzuDcm2vvfOt8CLlFISAxzooEk42AyOA96zPo
	 3FEeFYl5DBJ3rXSm9E1WULH53EBgnkN3XkfrbgwzJWxP2OUjId6Au83T9Y5MBs9kEM
	 2zAAQXq6368y8/b5xPnGF9srTpMaVBuJ8dPODIGeEN68BmJJupCi6upChtyDuKYe01
	 APErHDl8WL8PT4lTMmqkvaYWmVaSKNTMYddLpPSLM3KJREOQO/T0cD4Z4G1G1Dy8M0
	 /Twk9FhGC4xHmwHqJsfQS2VaN5mhAwglVb4H7eJdkQjLrvTHWmy4ABdall+2mZB56G
	 jlM+iBMXRxZow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/147] pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN
Date: Sat, 28 Feb 2026 13:16:58 -0500
Message-ID: <20260228181736.1605592-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 5248d8474e594d156bee1ed10339cc16e207a28b ]

It is possible to have a task get stuck on waiting on the
NFS_LAYOUT_DRAIN in the following scenario

1. cpu a: waiter test NFS_LAYOUT_DRAIN (1) and plh_outstanding (1)
2. cpu b: atomic_dec_and_test() -> clear bit -> wake up
3. cpu c: sets NFS_LAYOUT_DRAIN again
4. cpu a: calls wait_on_bit() sleeps forever.

To expand on this we have say 2 outstanding pnfs write IO that get
ESTALE which causes both to call pnfs_destroy_layout() and set the
NFS_LAYOUT_DRAIN bit but the 1st one doesn't call the
pnfs_put_layout_hdr() yet (as that would prevent the 2nd ESTALE write
from trying to call pnfs_destroy_layout()). If the 1st ESTALE write
is the one that initially sets the NFS_LAYOUT_DRAIN so that new IO
on this file initiates new LAYOUTGET. Another new write would find
NFS_LAYOUT_DRAIN set and phl_outstanding>0 (step 1) and would
wait_on_bit(). LAYOUTGET completes doing step 2. Now, the 2nd of
ESTALE writes is calling pnfs_destory_layout() and set the
NFS_LAYOUT_DRAIN bit (step 3). Finally, the waiting write wakes up
to check the bit and goes back to sleep.

The problem revolves around the fact that if NFS_LAYOUT_INVALID_STID
was already set, it should not do the work of
pnfs_mark_layout_stateid_invalid(), thus NFS_LAYOUT_DRAIN will not
be set more than once for an invalid layout.

Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Fixes: 880265c77ac4 ("pNFS: Avoid a live lock condition in pnfs_update_layout()")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index c5dd301c43d7b..e0317a889a3af 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -464,7 +464,8 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 	};
 	struct pnfs_layout_segment *lseg, *next;
 
-	set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags);
+	if (test_and_set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags))
+		return !list_empty(&lo->plh_segs);
 	clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(lo->plh_inode)->flags);
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		pnfs_clear_lseg_state(lseg, lseg_list);
-- 
2.51.0

