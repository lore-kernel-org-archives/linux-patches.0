Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496B1BDA93;
	Tue, 27 Aug 2024 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772701; cv=none; b=YUjED2tI+tOa4JO4Dn8t5yC50QcYElutKt7Rv43ihwYSksfhpRixRTEsCyUSFgBvQACrbLpKj2KZU+1z5pG740N6OMLVCCTSySJDRoa8u3SCWU8WnK6s17eXAoE1LBsCJEC0ViyS+gpufZ0o5lo6/KKP0etWPU8Zdpg/Crrs6YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772701; c=relaxed/simple;
	bh=yFIFIkPMHdZvvMdAASEezNJIWeZM5T/Fr0Hx9BVtz5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIx2+EERHvzf6TCo5hiPkCuAescNbyQDgrEjD3aQndvPArjNFAgAbPCDKmgpwq3e9Q5VHr0KOEM9zjCQugeMcKl3GcRqJpDdZKX/0OvZCP/U2N/CxFyauhmHBFwXY9gVkAgsCwPDVh6bcLAY1IS2RiO0VgF4izSLkfPJ2LnCO0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcumT58D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcumT58D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D36C4DDF1;
	Tue, 27 Aug 2024 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772700;
	bh=yFIFIkPMHdZvvMdAASEezNJIWeZM5T/Fr0Hx9BVtz5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcumT58D9izpLtwitM2vVK85ZswESTAtmypBY5oWjEMxSC/wE9viQcS9QAshkAOwy
	 7Ep7QWH5wPHNfkHfZoBDkvB5PVq8y0dT2IpdeUsJqvzKV79+oC6R5u3lrVd9CfGhe5
	 4mod0Ohsi++/m5sq5sQYvtMolC9eXH1woZYBVv1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 293/321] nfsd: dont call locks_release_private() twice concurrently
Date: Tue, 27 Aug 2024 16:40:01 +0200
Message-ID: <20240827143849.407616737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 05eda6e75773592760285e10ac86c56d683be17f ]

It is possible for free_blocked_lock() to be called twice concurrently,
once from nfsd4_lock() and once from nfsd4_release_lockowner() calling
remove_blocked_locks().  This is why a kref was added.

It is perfectly safe for locks_delete_block() and kref_put() to be
called in parallel as they use locking or atomicity respectively as
protection.  However locks_release_private() has no locking.  It is
safe for it to be called twice sequentially, but not concurrently.

This patch moves that call from free_blocked_lock() where it could race
with itself, to free_nbl() where it cannot.  This will slightly delay
the freeing of private info or release of the owner - but not by much.
It is arguably more natural for this freeing to happen in free_nbl()
where the structure itself is freed.

This bug was found by code inspection - it has not been seen in practice.

Fixes: 47446d74f170 ("nfsd4: add refcount for nfsd4_blocked_lock")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -318,6 +318,7 @@ free_nbl(struct kref *kref)
 	struct nfsd4_blocked_lock *nbl;
 
 	nbl = container_of(kref, struct nfsd4_blocked_lock, nbl_kref);
+	locks_release_private(&nbl->nbl_lock);
 	kfree(nbl);
 }
 
@@ -325,7 +326,6 @@ static void
 free_blocked_lock(struct nfsd4_blocked_lock *nbl)
 {
 	locks_delete_block(&nbl->nbl_lock);
-	locks_release_private(&nbl->nbl_lock);
 	kref_put(&nbl->nbl_kref, free_nbl);
 }
 


