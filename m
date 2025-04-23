Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01331293B57;
	Wed, 23 Apr 2025 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422249; cv=none; b=TonN1+TPPW53zDHeH85lZzTI2tezzkxC7sK9LPmxMgYVNYwWYxyFQL2esblGD4wLaLg8GvyCzXZAHXSxY9nU5uKP9ubtEPpM/3N4OnGBzXaWTKXa4i/v4oCCVHs7Xk2e18dzjFQpLFONyWnM2kp4VLp9XAQNUlqe/So1U3sOjoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422249; c=relaxed/simple;
	bh=sONtULOyiWBZU0jH+oLwPIfhVHl2WFoUEMZRZSDGfas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8L+MX+casyo2iDjSJKO9XosLg8HwWj5QkDqSVVMcTggNKJY3gCsxYz1AVsUyiMU0h12eczmmvH4CfR8kv37rSwvl++/VPBejxY6ntJprHiDZxCdC5mIlLbnrzMgIIr/iIoFa0XhP+kIlq7KG3+bp2JRs/6UcZFrfXk/GEh9tS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndCox2BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndCox2BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888A8C4CEE2;
	Wed, 23 Apr 2025 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422248;
	bh=sONtULOyiWBZU0jH+oLwPIfhVHl2WFoUEMZRZSDGfas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndCox2BJrliEB1eNGdgEek4kxv0baouWf3kqrCYjN2i7wrdF5fy5Xdr47f9lcG8uy
	 0VHNt4ctGrUOWm9Ya7HhC0+Iuah5li2+nfPNmmT0xn4LCto70c1Opx64HsCOHqZFVw
	 DEZthLxcofcU4h4HwmW6cczKqPK69aus+0lKgSok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/393] nfsd: decrease sc_count directly if fail to queue dl_recall
Date: Wed, 23 Apr 2025 16:43:23 +0200
Message-ID: <20250423142656.013246204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 140784446ad22..e2875706e6bfd 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4938,7 +4938,7 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	queued = nfsd4_run_cb(&dp->dl_recall);
 	WARN_ON_ONCE(!queued);
 	if (!queued)
-		nfs4_put_stid(&dp->dl_stid);
+		refcount_dec(&dp->dl_stid.sc_count);
 }
 
 /* Called from break_lease() with flc_lock held. */
-- 
2.39.5



