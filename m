Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04754FDA55;
	Tue, 13 Oct 2026 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894033; cv=none; b=lgkbkMkoQP2ykmN/MSSqOdPF8nube4ezhbwZgXvyukEumeo7RObXswfmE9TqFlVVYr+xtrddPpH1erGxhKt5LZfIyMPWq3BBzxd9Sm9eEP1mX1Ixn3C+tgMvy38Y1JC0iKXi+zdfNiy3IXhFk3ja4DDDLrvV/3c9pqbMRc09DOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894033; c=relaxed/simple;
	bh=/MTJ1XRQLJDtRBJU2Uzp/ZujIxfk0lBlLTmVF+2jxzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvfZCv50ml8tk27IVAr/cR9c9e99LoGcg62KigMkU7v+EsyL2B9einJEYqKmB+oVcfzMSKiN6pamKTWG09nQhBbwejRe8guH44Pauyn9ygwrw3SGUBBjgIo6gJxlSU9nPq2VQfgGfvfhaLaWcDqtegGCAx4GC9Wz07T/cSBjNOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nB0qrGM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nB0qrGM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EBA1F000FF;
	Tue, 13 Oct 2026 12:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894031;
	bh=tNd0Fi1gjqwrlcUb4JjMpI5I+Gp8Mok+Oid29wHoeAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nB0qrGM/x+ZlT93MqhMoB0EsIDGDdWIG0+TsAB1xuPAuBpzLjiZO1b511iRtW54vC
	 UzRMsrACIhJHS9ocGxNY08rwjInbu/50MVm4PFNGXV8USdOS6ad0RB/FVJCG5abvWZ
	 0R9ljm1UFfQ90uN3DxfACDKpalR8rTzHWb03DZ9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 423/621] NFS: Return a delegation the client fails to record
Date: Tue, 13 Oct 2026 13:36:58 +0200
Message-ID: <20261013112930.873163775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index f95707fc0edff..50b002377b8c0 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -468,11 +468,14 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_delegation *delegation, *old_delegation;
 	struct nfs_delegation *freeme = NULL;
+	bool orphaned = false;
 	int status = 0;
 
 	delegation = kmalloc(sizeof(*delegation), GFP_KERNEL_ACCOUNT);
-	if (delegation == NULL)
+	if (delegation == NULL) {
+		nfs4_proc_delegreturn(inode, cred, stateid, NULL, 0);
 		return -ENOMEM;
+	}
 	nfs4_stateid_copy(&delegation->stateid, stateid);
 	refcount_set(&delegation->refcount, 1);
 	delegation->type = type;
@@ -520,12 +523,16 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
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
@@ -559,8 +566,11 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 		nfs_update_delegated_mtime(inode);
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
 		nfs_free_delegation(server, freeme);
-- 
2.53.0



