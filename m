Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665F37C109;
	Sat, 17 Oct 2026 18:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260162; cv=none; b=fEHkt+hhfF62eEGpQvP79Zl84nE67pcQs8GW+4wbDlWjb7O3Mj9X3aSeWSpeUgUsWDcNGVvPUHShvPd77grK5EyYwPIz1zifZSXzgYfBiITh0ThX0fp17lRBjMuh5kLVav+j656H/qHtqByV1e/MMMlSpvWaIAM7VSN4bYPVniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260162; c=relaxed/simple;
	bh=9JgVqVAEopmDEhAimqSWK+TfOUeWN7XmUDOEZ9fMqGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVQJevydNMeKBkbJVRKABAlldCv1kO0jmcr7xHJcFWrvWiTPyYDnp+s4ARZZ4DYb8MHXmzs3QedrQD4nkaSXldowjDrsmlq/j8uaQKQrKv1FZxiVJT0xjaJI37OVexEMnWsnJN3z3HktYyxFUUoT5rJqT8RzOSnw4RypJI3RWJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocFTnV0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocFTnV0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17851F000C4;
	Sat, 17 Oct 2026 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260161;
	bh=eH67nMci5MCPGLmQ+4RJororF99kV+gXQ9u3eD6CuSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocFTnV0CUqOHtfsVtt8SHRZOKDt81g1HvtLhosllMFsJrusS3fFqPjZT7sQJreynt
	 REJvoAC7Ek0igmWSFb1fSQYY35GEsRKebvwGkeyzF/AslwAKxrbXlaLt6km6I4ll1Q
	 0NnaSQlBg8Yt/m4J9mTna4bTOxnQkzc7PNbf8i2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1413/1674] NFS: Return a delegation the client fails to record
Date: Sat, 17 Oct 2026 18:01:25 +0200
Message-ID: <20261017160507.448786122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bbd582d8a7dc9..af7751f05bbd7 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -436,11 +436,14 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
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
@@ -482,12 +485,16 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
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
@@ -514,8 +521,11 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
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



