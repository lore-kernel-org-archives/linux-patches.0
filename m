Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43EE46C4CE;
	Tue, 21 Jul 2026 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649125; cv=none; b=mCmOgA4ps7eIOCYYtQSiya6tAQs5T415st4wbf2cmKXBkqqpN1AEMkia9+j2OYvsazwXke6IfzKA1EOvLduvy38uy4oSvHydkGhly/My0oImM8FtlpfJLO9h5wDJWXWE941GEVbrOPHi6PZvnBOjwWgdsexuswwCL8wtu09Jiz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649125; c=relaxed/simple;
	bh=ofw1gZp600bNP/6FiklDt1k6xR8kPYsSrH2nfj77EHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBGfpAowuXrcZdyt2njlLBH6dcCNbLH4GNeksKN0ZEwef64zq03+erq3a0g8REovo2M9jEg0HWZIn28WQWD8y41//HXz1LmocMwcLcRPLoBXk0HbJgRCLVXApmONi0e3pnbE2WlixP3IajtH3fnJhOLIN7RA5/bCzVXQAIG4SHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmMGdRUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmMGdRUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3360C1F00A3D;
	Tue, 21 Jul 2026 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649123;
	bh=1n+cGFCm15DIFMSsPfZgzPDXsc8F9HO/BcQ4shvEqWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmMGdRUHmc5O+PMJ8guOMwpXMVyReVO/i6PW0H0K3NVOwXSxUgnNbsA3jDyOTEij6
	 DuzmLEu3WHg2FMl0SyXEfY/uCM9kV5XD448F/aEuZeBcNR8Q7UQqq4Uv5/Tc5boG8Q
	 JKd0tnskqBA46LFcqyKt+7BBYAiK/oF+zXe9Oszo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0415/2077] NFSD: Fix delegation reference leak in nfsd4_revoke_states
Date: Tue, 21 Jul 2026 17:01:28 +0200
Message-ID: <20260721152602.523844140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d875e98d4dcbd0..2696a9fef0291c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1376,7 +1376,8 @@ static void destroy_delegation(struct nfs4_delegation *dp)
  * stateid or it's called from a laundromat thread (nfsd4_landromat()) that
  * determined that this specific state has expired and needs to be revoked
  * (both mark state with the appropriate stid sc_status mode). It is also
- * assumed that a reference was taken on the @dp state.
+ * assumed that a reference was taken on the @dp state. This function
+ * consumes that reference.
  *
  * If this function finds that the @dp state is SC_STATUS_FREED it means
  * that a FREE_STATEID operation for this stateid has been processed and
@@ -1839,6 +1840,10 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 					mutex_unlock(&stp->st_mutex);
 					break;
 				case SC_TYPE_DELEG:
+					/* Extra reference guards against concurrent
+					 * FREE_STATEID; revoke_delegation() consumes
+					 * it, otherwise release it directly.
+					 */
 					refcount_inc(&stid->sc_count);
 					dp = delegstateid(stid);
 					spin_lock(&nn->deleg_lock);
@@ -1848,6 +1853,8 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 					spin_unlock(&nn->deleg_lock);
 					if (dp)
 						revoke_delegation(dp);
+					else
+						nfs4_put_stid(stid);
 					break;
 				case SC_TYPE_LAYOUT:
 					ls = layoutstateid(stid);
-- 
2.53.0



