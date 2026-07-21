Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F01A408039;
	Tue, 21 Jul 2026 19:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661819; cv=none; b=RHTkPEfmh61IeaVyAGkD1wlZ4Atb+cKu4MG7fnvCMZh7qXw67jEPNM+HC4E81qhwAM5qrDQB9IT0YHgCecwTXM1fy6rGV1ITvLfjQXrQw0oxRvbIB1bD5pwweS8yDik9uLX+03rPdLHsmJgw6MA8vtK4UDxjcSKgYlibJRcMNl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661819; c=relaxed/simple;
	bh=6FlIcYg7K63W5QVu1aczTiUkyZgkIWWInMrdt4P6WoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMDV7eqyr9QJ7omeUahf+/fKqngOZuWqVhcFuJ/5IFjJKwR35csmLkhTQ7Q3oj9N7s5jztti+cAjnNMmm7x0NrCFnhCZQYszoPkVJ6cN96hmdCpNISD5wo+mykCjBaJDV8y7Cbm5Ma4hdjtelzIFdYvwoSYjgb9/XdhSyVxhcT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKfzIDUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKfzIDUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E592B1F000E9;
	Tue, 21 Jul 2026 19:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661818;
	bh=HN10vWy/tP7BIJbvtl5Q2jxgixoqLJI2s3mTUXCw6Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKfzIDUqIA1WuShUW4rmaIWu24FIoforXyyHAv+Y6yTZRJBPMJ+Mm3Grw+Aa7PfEo
	 s6EfRrIhOGC25w0A/OA9XoNJKhXI9i/h54FNiYF6O1FwF/4MiY5AD/qKyAjA4QOyjy
	 /UdotwyXNIdwFQlKnqAWIss1TuEgk+GRlZ1WBupI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0210/1276] NFSD: Fix delegation reference leak in nfsd4_revoke_states
Date: Tue, 21 Jul 2026 17:10:53 +0200
Message-ID: <20260721152450.786133345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c13fa68c08a84..f93f5bdfbb077e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1374,7 +1374,8 @@ static void destroy_delegation(struct nfs4_delegation *dp)
  * stateid or it's called from a laundromat thread (nfsd4_landromat()) that
  * determined that this specific state has expired and needs to be revoked
  * (both mark state with the appropriate stid sc_status mode). It is also
- * assumed that a reference was taken on the @dp state.
+ * assumed that a reference was taken on the @dp state. This function
+ * consumes that reference.
  *
  * If this function finds that the @dp state is SC_STATUS_FREED it means
  * that a FREE_STATEID operation for this stateid has been processed and
@@ -1820,6 +1821,10 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
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
@@ -1829,6 +1834,8 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
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



