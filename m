Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF02724CEEA;
	Sat, 12 Sep 2026 08:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202998; cv=none; b=pRvPNFXPaOmZEXgGod7bBIDbqaIBqDp7eaWRCoW3cjw2Rpqfkm488wUnGNRz8+q0Zxm92lK750u8e6mf/eGlSCzo8FJtPMBVMQwBx6+1I4/oVpGw8rD1sCeQAWn+Xo0R0N6brTA5cjhMELvOdtvNFRl6GGwox+iRg8Fr33ja828=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202998; c=relaxed/simple;
	bh=vXu0eh9QiiIKii9kuj6whXBmIflGsH5sjh9RIa4NBuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enfiLwrGH7h93CpFXwFWYgeHtY8NhKpN6+tAN6hXkMuiC95qHmw48DrmoaMPJ04AK9/l6VJn5m6mhMwy5rErcPg09Me2EBWyOaEaXSztgl/8cqNoOFwVqAaTPtljfLsU+mQJpFV/6J34gdIbQxsdLQD95OQUCHmTSEM7FrRn1u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8W3baui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8W3baui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8311F000FF;
	Sat, 12 Sep 2026 08:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202996;
	bh=48Kdrh6d/ejkFwiYlKmSrnjZdLO8NXKoKLbhC6QzW6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8W3bauiA07cr55NXsYf9qA1KNYhJ1+3za4E/+GLf3k/SwvBm7Ux+vyEX8OBhqi9N
	 e+UQbuMxCW1sKXEoHz26nFbaU9PMnH5NV+sxdBaGsVGhHCEWHVpsIMQnNPxCkYYRWs
	 NqkF0xPo/DbmUeFuOaLArsXIEdvLJY7Adgc+EFoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1317/1815] NFS: Return a delegation the client fails to record
Date: Sat, 12 Sep 2026 08:51:07 +0200
Message-ID: <20260912065719.940001004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9546d2195c25f..284437fa3f872 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -447,11 +447,14 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_delegation *delegation, *old_delegation;
 	struct nfs_delegation *freeme = NULL;
+	bool orphaned = false;
 	int status = 0;
 
 	delegation = kmalloc_obj(*delegation, GFP_KERNEL_ACCOUNT);
-	if (delegation == NULL)
+	if (delegation == NULL) {
+		nfs4_proc_delegreturn(inode, cred, stateid, NULL, 0);
 		return -ENOMEM;
+	}
 	nfs4_stateid_copy(&delegation->stateid, stateid);
 	refcount_set(&delegation->refcount, 1);
 	delegation->type = type;
@@ -500,11 +503,15 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
 			goto out;
 		}
 		if (test_and_set_bit(NFS_DELEGATION_RETURNING,
-					&old_delegation->flags))
+					&old_delegation->flags)) {
+			orphaned = true;
 			goto out;
+		}
 	}
-	if (!nfs_detach_delegations_locked(nfsi, old_delegation, clp))
+	if (!nfs_detach_delegations_locked(nfsi, old_delegation, clp)) {
+		orphaned = true;
 		goto out;
+	}
 	freeme = old_delegation;
 add_new:
 	/*
@@ -539,8 +546,11 @@ int nfs_inode_set_delegation(struct inode *inode, const struct cred *cred,
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
 		nfs_mark_delegation_revoked(server, freeme);
-- 
2.53.0



