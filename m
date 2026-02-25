Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CA02D77FF;
	Wed, 25 Feb 2026 06:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002628; cv=none; b=GGkAcywx0TcW8qfVs1aXrstNS/Y9UdTdfujma3Uv4jTafcIt8N+FToMXuvXTmF3PHmgHNbSiFexdZ90sIznFaxBDBCOsmhYmL0HX0rn+F2YV0glJQbww7nlXk/YKf0ComYwp1TK19mOa5cDr492rpqYxxb+ocxKYSrQc959KR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002628; c=relaxed/simple;
	bh=hV3lftL4dOf2KDNb9fpWvaDBbDi0o43Tj+XBN8+/7GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1QnTLI0GmtfOlxa0kuspWzESvMt9lVSIDtoEj/QeWJG3E5Fi39uQ+ml27wxBNgfym/SBVBtInUIFdkeh0A6CSk9qjbvB+FVQG0ftls4fur9U3+jFKisQQrEDMNWO+n42FW2RHQ9BNOAP+ePmlwNR1qwQrA7qGEqoLkjztZmAjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNe1MImJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNe1MImJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D10AC116D0;
	Wed, 25 Feb 2026 06:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002628;
	bh=hV3lftL4dOf2KDNb9fpWvaDBbDi0o43Tj+XBN8+/7GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNe1MImJRqoeyc4OIIUmQ5s+4hOT+h7zDHlUpJeiD5tCgMaEuq6ZGuTZmKygl1haT
	 ZPaXURyyO9AnQg/kBhfoNB/ShtFsAHEIpmd/rRb2cKOzHwzhFnZu9QFfnglGc215lP
	 crWzKSPrDaP35UTl8xk1xYKWMXUognU+MvFvXdMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/641] pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN
Date: Tue, 24 Feb 2026 17:21:56 -0800
Message-ID: <20260225012358.028144475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 33bc6db0dc92f..b3cb5ee9d821e 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -463,7 +463,8 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
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



