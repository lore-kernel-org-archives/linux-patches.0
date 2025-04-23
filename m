Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D624A28CF6D;
	Wed, 23 Apr 2025 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420742; cv=none; b=OCwSqRymNRWW4JUbb+muZrITo8zDu6SPTwRCavjL7/GLHT2wMhXQWSdEeVrl6FA2UzWEGtY1qwM8hovOY5mIEKZMc7ETkm9Xo+nIKEviMna3n8/BjHNDidbJWv9ZPf/spkRT0KLKxuCcuQQ3c30sTVCgf6xuwLBQ65FRFlEW+JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420742; c=relaxed/simple;
	bh=i0LyLaJC9N025siif2MOL3fWEnvEqIM3DsaI+DJ6hsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQZenrOsBX07N7D+lhjocZUpaH131DT2Q3rc2voMPKGn7ua1WHoHHhgCeY+1PGhlEffPPPIqZ3RcXHeKeCnhCJb64763hLmdooAd3KYiDdvBFYLNjU4fIRAz6UJTtQ/63dMFvYU4GiBGQVNexeL6NCm58QtOSRPWfYWIH53/6jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsa0jtKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsa0jtKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B75DC4CEE2;
	Wed, 23 Apr 2025 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420742;
	bh=i0LyLaJC9N025siif2MOL3fWEnvEqIM3DsaI+DJ6hsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsa0jtKvCh+wamCcsYnO2fUO7+pRZQjbA7KT4Vjy1uryNtheHLBnOUzUnzpDrLEce
	 mBICF1d7ky3khD4qkacUUFF/OpRkkn+i7eDxXccWDRqDlDz9cMX68XeqPpE5PPuDYb
	 3fGZ3ZGJWa4+hMaLbE/2bh0YKmG5073kAcdyXe4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 118/241] nfsd: decrease sc_count directly if fail to queue dl_recall
Date: Wed, 23 Apr 2025 16:43:02 +0200
Message-ID: <20250423142625.403326285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit a1d14d931bf700c1025db8c46d6731aa5cf440f9 ]

A deadlock warning occurred when invoking nfs4_put_stid following a failed
dl_recall queue operation:
            T1                            T2
                                nfs4_laundromat
                                 nfs4_get_client_reaplist
                                  nfs4_anylock_blockers
__break_lease
 spin_lock // ctx->flc_lock
                                   spin_lock // clp->cl_lock
                                   nfs4_lockowner_has_blockers
                                    locks_owner_has_blockers
                                     spin_lock // flctx->flc_lock
 nfsd_break_deleg_cb
  nfsd_break_one_deleg
   nfs4_put_stid
    refcount_dec_and_lock
     spin_lock // clp->cl_lock

When a file is opened, an nfs4_delegation is allocated with sc_count
initialized to 1, and the file_lease holds a reference to the delegation.
The file_lease is then associated with the file through kernel_setlease.

The disassociation is performed in nfsd4_delegreturn via the following
call chain:
nfsd4_delegreturn --> destroy_delegation --> destroy_unhashed_deleg -->
nfs4_unlock_deleg_lease --> kernel_setlease --> generic_delete_lease
The corresponding sc_count reference will be released after this
disassociation.

Since nfsd_break_one_deleg executes while holding the flc_lock, the
disassociation process becomes blocked when attempting to acquire flc_lock
in generic_delete_lease. This means:
1) sc_count in nfsd_break_one_deleg will not be decremented to 0;
2) The nfs4_put_stid called by nfsd_break_one_deleg will not attempt to
acquire cl_lock;
3) Consequently, no deadlock condition is created.

Given that sc_count in nfsd_break_one_deleg remains non-zero, we can
safely perform refcount_dec on sc_count directly. This approach
effectively avoids triggering deadlock warnings.

Fixes: 230ca758453c ("nfsd: put dl_stid if fail to queue dl_recall")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2de49e2d6ac48..613bee7edb81e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5432,7 +5432,7 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	queued = nfsd4_run_cb(&dp->dl_recall);
 	WARN_ON_ONCE(!queued);
 	if (!queued)
-		nfs4_put_stid(&dp->dl_stid);
+		refcount_dec(&dp->dl_stid.sc_count);
 }
 
 /* Called from break_lease() with flc_lock held. */
-- 
2.39.5



