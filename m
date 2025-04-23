Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65BB175BF;
	Wed, 23 Apr 2025 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420094; cv=none; b=NFoJ3kwfEAIjUQ+NtzX3Ud/82MxFSTbCNj/wFdKqspm1wk5jk4dUHfTCmJr63xFz0oaK4E7PFJkRt6BXPAU9Pj9AkCVImU+IrhOaBfjxppdW0W0A+Sygx7aO6ZrhTWeoUh3r5EnrXMntj6+/VCuOp6NFsxQR2UtJYBX/BIOpO6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420094; c=relaxed/simple;
	bh=Bd3XZmNilA0UXR96QzzM9G5V5VT5p2t8hrHzcuSwiXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQIXw8WtDhZf9yBlAy9svYazJo3QqoeXZ25mYq7I8EFHd2sNmgguQse9WJUNwBtGn60f3NdoZhY6+qlujnQKXF/qAkViCSiOG/RIbI4tqvH3AtIk+pWB3XcKSHSyxkeTnic+LUlSbYH70muJY3imY7bWeJal38vewwZypRJZeKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX5GNOTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX5GNOTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56172C4CEE2;
	Wed, 23 Apr 2025 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420094;
	bh=Bd3XZmNilA0UXR96QzzM9G5V5VT5p2t8hrHzcuSwiXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX5GNOTIpJcBsUK7beuwD8UE6rbiF3bmXwA35EF4a+Y4M1mqyhdGATLBTG443rx7q
	 DhK4KoskJ7UU6yJhHOITRFOXtajaBuB5XGWTyxpqJel2v3fD+kBDiyK0D1RO+OHXO6
	 8Gerg3eTdV/2egJKH9CNcs5IcOy6crkyJ5lfIA9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/223] nfsd: decrease sc_count directly if fail to queue dl_recall
Date: Wed, 23 Apr 2025 16:42:51 +0200
Message-ID: <20250423142621.147776478@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5e81c819c3846..c50839a015e94 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5287,7 +5287,7 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	queued = nfsd4_run_cb(&dp->dl_recall);
 	WARN_ON_ONCE(!queued);
 	if (!queued)
-		nfs4_put_stid(&dp->dl_stid);
+		refcount_dec(&dp->dl_stid.sc_count);
 }
 
 /* Called from break_lease() with flc_lock held. */
-- 
2.39.5



