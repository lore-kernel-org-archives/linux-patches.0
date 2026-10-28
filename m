Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216569;
	b=LZl1Vp/yipCTzVjm7Ib7AQ+aGSL2nSVkMB9JJQ1tnnLR5luDgfNIyQQBt32CNTZhX+Rk
	 R2UsFd5lw2JgEhMvUI4O48wncNRhWOmCk+eoqN4X5GSgOa/WPTTH7aVp76HJmKezY5JcF
	 ++wBkL+NooUk6KzUTQ+QGdq9/JCKfjQT33ZcC2LB9BcygA/4DWBq8W+cKbr2kUGyJ+Lxw
	 fdwacdI83XJ+utER6EekANgl7k9OCe/wQesRLzMKcKO5dMS54VQhTERoiM4zVdooc5epY
	 23mMr5eOnLvNKhZ1264U31rzHWhx9bJeOVhnuGCA2OwHDSRz3wTg/Pxqz6zPof3M+Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2H3YpGyL5SyYK/UlaNyfztpNTXGIYWQOdFbEPFVkHjc=;
	b=WH6vHcGVxlf9PR2vzyTpJ5CQpgeJsRsSLza01Djo1h/Qnzd2b9SC1HV+k1/LQQ3c6SJm
	 uY2XNF4Eyhkau+62nzXFUoc/PxnVECrkRwCircMjJdG8VHPnhefOtqAPlcvfSojxaXB2N
	 76zvP3O+WpgnsCgQ6mca7pVSECN2t9dikkGJXFo3GZGWJVAvc2W4/FO6h/OzIbg6f5SnU
	 tLS0pg97iKeiflN62QOCu//AEsAprUOmdzw1O0FlkiAMWyBsGB1hw/fboHoz1M3iDQCfb
	 z5uqeu+rmEXKPk8Dd/DY9JozoSYQzQHb6a3IFzY5Hc4lvYdXDDsjLzVJ40t464wF4VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GdWo+haW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52803606A31E;
	Wed, 28 Oct 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GdWo+haW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3FB1F01825;
	Wed, 28 Oct 2026 19:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216568;
	bh=2H3YpGyL5SyYK/UlaNyfztpNTXGIYWQOdFbEPFVkHjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdWo+haWRTXGS1+c0ehPezmq/iTYgICDo7qKSIGsnlSrUxjDUqUGFWLuQ3JnrJ6FD
	 gqcfvvyhe2iq3he3jp5xv9mg68AoxHSs5uxMulx5stO1kRnThRJQNhydHlgeylvTIm
	 cj0J1BG30PQ9u9UYuhtWwI5IFwI10pNgnDx2VHd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1558/1887] NFS: Return a delegation the client fails to record
Date: Wed, 28 Oct 2026 18:00:54 +0100
Message-ID: <20261028170534.918876406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 220af23d863995091f0edeb1e6aa0945b3db8b37 ]

When an NFS server grants a delegation in an OPEN reply,
nfs_inode_set_delegation() records it on the client. However, three
of its error flows return without sending DELEGRETURN.

A delegation can be relinquished only by DELEGRETURN (RFC 8881
Section 20.2.4), so dropping one silently leaves the server believing
the client still holds it. If the server happens to recall that
delegation, the client answers CB_RECALL with NFS4ERR_BADHANDLE
because it has no record of the stateid. The server revokes the
delegation and moves it onto its cl_revoked list, because the client
never sends the FREE_STATEID that would drain it. Every subsequent
SEQUENCE reply then carries SEQ4_STATUS_RECALLABLE_STATE_REVOKED,
and the client's state manager loops issuing TEST_STATEID across its
delegations without ever clearing the condition.

The window is easy to reach now that a server offers a write
delegation on any write OPEN: a delegation recalled for one opener
races a re-open that the server answers with a fresh write
delegation.

Instead of dropping it, hand the delegation back during these error
flows.

Fixes: ade04647dd56 ("NFSv4: Ensure we honour NFS_DELEGATION_RETURNING in nfs_inode_set_delegation()")
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 9002b479a125b..64a869d40774b 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -443,11 +443,14 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_delegation *delegation, *old_delegation;
 	struct nfs_delegation *freeme = NULL;
+	bool orphaned = false;
 	int status = 0;
 
 	delegation = kmalloc(sizeof(*delegation), GFP_KERNEL_ACCOUNT);
-	if (delegation == NULL)
+	if (delegation == NULL) {
+		nfs4_proc_delegreturn(inode, cred, stateid, 0);
 		return -ENOMEM;
+	}
 	nfs4_stateid_copy(&delegation->stateid, stateid);
 	refcount_set(&delegation->refcount, 1);
 	delegation->type = type;
@@ -489,12 +492,16 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 			goto out;
 		}
 		if (test_and_set_bit(NFS_DELEGATION_RETURNING,
-					&old_delegation->flags))
+					&old_delegation->flags)) {
+			orphaned = true;
 			goto out;
+		}
 	}
 	freeme = nfs_detach_delegation_locked(nfsi, old_delegation, clp);
-	if (freeme == NULL)
+	if (freeme == NULL) {
+		orphaned = true;
 		goto out;
+	}
 add_new:
 	/*
 	 * If we didn't revalidate the change attribute before setting
@@ -521,8 +528,11 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 	trace_nfs4_set_delegation(inode, type);
 out:
 	spin_unlock(&clp->cl_lock);
-	if (delegation != NULL)
+	if (delegation != NULL) {
+		if (orphaned)
+			nfs_do_return_delegation(inode, delegation, 0);
 		__nfs_free_delegation(delegation);
+	}
 	if (freeme != NULL) {
 		nfs_do_return_delegation(inode, freeme, 0);
 		nfs_free_delegation(freeme);
-- 
2.53.0



