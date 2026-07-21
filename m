Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BF646D093;
	Tue, 21 Jul 2026 17:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656184; cv=none; b=pUqMD0FT4PcUcl6rDaXk7Y3OI1apmWdkM6zjAcIuqfqua1SiKHHdNJnlx+d21nXnrKL8ODKw2h1PskYenTiyG2sikCD6UVvNMTxxLsGRv6sDRM8/cRY/rsoh07ZW3PfPguAd6IFDgC7yFBKx9VjsUyQj1Rev8uUiSf/CeuHsB7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656184; c=relaxed/simple;
	bh=g7+ckOah/GSQP0CS5aajrhab68axSqw0d2/kuBTaqT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLKeKLL6ylqIsfVgyu8BoAfoDQ7tyAMMIvWZU3LBoqpA2zEEcUBYhkQ8MpfbjOMjOiTERFQVDT1pSH/rRfbge/j+DrldwxV8knIyj+AUFy7uPTUX0VSLVUEbFjYQvh64hpGrXkGZUBv+uVn2GHX2cMsqImAhBSBh03dsHPqjifo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kem8lQKx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kem8lQKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245201F000E9;
	Tue, 21 Jul 2026 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656183;
	bh=9qyEBXQuN7Kz6alkDnns5CIRaqj7LXBheFs3Xk5nYs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kem8lQKx6W2iu+9ZsmmxIU8JgcWKzimWhjTxZzcTf/IldLBIhJt0fXSh82V5OVE/8
	 aqhXPmlzAMAK/4adEvKg6K7R33fQUgsqIpHC5/A3SWfkMH/tDRSvkfuYG6dxIiJLh4
	 pS20duJIYDXoD9Z0C2U3j/eZyiZQrKIla9C0dvLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0292/1611] NFSD: Fix delegation reference leak in nfsd4_revoke_states
Date: Tue, 21 Jul 2026 17:06:48 +0200
Message-ID: <20260721152521.633515000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 625981c8f3da0cc2d236d7b46c39dd75554b8276 ]

When revoking delegation state, nfsd4_revoke_states() takes an extra
reference on the stid before calling unhash_delegation_locked(). If
unhash_delegation_locked() returns false (the delegation was already
unhashed by a concurrent path), dp is set to NULL and
revoke_delegation() is skipped, but the extra reference is never
released. Each occurrence permanently pins the stid in memory. The
leaked reference also prevents nfs4_put_stid() from decrementing
cl_admin_revoked, leaving the counter permanently inflated.

Drop the extra reference in the failure path.

Fixes: 8dd91e8d31fe ("nfsd: fix race between laundromat and free_stateid")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a3e6076a3e645e..efa7e103cf190f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1375,7 +1375,8 @@ static void destroy_delegation(struct nfs4_delegation *dp)
  * stateid or it's called from a laundromat thread (nfsd4_landromat()) that
  * determined that this specific state has expired and needs to be revoked
  * (both mark state with the appropriate stid sc_status mode). It is also
- * assumed that a reference was taken on the @dp state.
+ * assumed that a reference was taken on the @dp state. This function
+ * consumes that reference.
  *
  * If this function finds that the @dp state is SC_STATUS_FREED it means
  * that a FREE_STATEID operation for this stateid has been processed and
@@ -1822,6 +1823,10 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 					mutex_unlock(&stp->st_mutex);
 					break;
 				case SC_TYPE_DELEG:
+					/* Extra reference guards against concurrent
+					 * FREE_STATEID; revoke_delegation() consumes
+					 * it, otherwise release it directly.
+					 */
 					refcount_inc(&stid->sc_count);
 					dp = delegstateid(stid);
 					spin_lock(&state_lock);
@@ -1831,6 +1836,8 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 					spin_unlock(&state_lock);
 					if (dp)
 						revoke_delegation(dp);
+					else
+						nfs4_put_stid(stid);
 					break;
 				case SC_TYPE_LAYOUT:
 					ls = layoutstateid(stid);
-- 
2.53.0



