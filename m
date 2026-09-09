Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130C8531AFC;
	Wed,  9 Sep 2026 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961646; cv=none; b=qM+cetWFAVoepQEY/DRyP6cdbI8feQOj+2mU7fp/LT5FzsYEc1Yrix/N0fP9/fv7UMSW8IXMGkDaXBBsKrTtxCQBwzPbRBpiN1Dnxr3Rb4DmPN73JKijt/+mFmhBt4XWxsMv3/o01Yh5w/OpWxkeUCCUWbBMb6lopCrmT4ti+5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961646; c=relaxed/simple;
	bh=R+S9MztcnBnJ2LEgy8+BBEyejBQd5rp+BiEcNkWD8Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRCdyJ2zU6r2Mpbloiu3sLySa0e+AT7gxzpOHUU6zwGA0VkL3sEIjyiOneHCVpe1YUQx4zHNCJhrwfko1ni/tVNGSe2qjK7VUTNcGsSZxmga/Nq24gV35RmQFhIchC3tfJ2QGxBjn8hNQKrbC4IM9NIQnb1D7UPKX2/4boOZPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edcW7SlD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edcW7SlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB681F00A3A;
	Wed,  9 Sep 2026 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961645;
	bh=JrP67vhU0G3qlNujgTw3inMfslDbXrzesfkuHGw1d6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edcW7SlD2KrivvsupnWcWRvzH4TqqX9Hys31QNvndFxoFUqgCGMZvu0w+a0KSu+96
	 8Y47RDwjrD6fSOMqX9HLpJUM1mfvR8Y//uJNGGtH02dwshOno6fq4nuOD3m2kb0e+l
	 563cXgVwLKWYMiWJ2h0rkHwC+nV8GMdJZ4VuMnQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 020/556] NFSD: Prevent client use-after-free during export state revocation
Date: Wed,  9 Sep 2026 15:35:00 +0200
Message-ID: <20260909134231.198660213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

[ Upstream commit 2108de53568a64936a0da3e04d85c35df98d3fb6 ]

nfsd4_revoke_export_states() has the same use-after-free as
nfsd4_revoke_states(): it drops nn->client_lock across
revoke_one_stid() and the following read of clp->cl_minorversion, but
the stateid reference it holds does not pin the client.  A teardown
racing the dropped lock can free the client while revoke_one_stid()
still dereferences it.

exportfs -u drives this path through NFSD_CMD_UNLOCK_EXPORT, so an
administrator removing an export can race a client expiry.

Skip a client that is already expiring and otherwise pin it with
cl_rpc_users under client_lock before dropping the lock, matching
nfsd4_revoke_states().

Fixes: 2eac189bb059 ("NFSD: Add NFSD_CMD_UNLOCK_EXPORT netlink command")
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-4-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: 2330b788d732 ("NFSD: Prevent client use-after-free during close_lru reaping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2056,10 +2056,14 @@ void nfsd4_revoke_export_states(struct n
 		struct nfs4_client *clp;
 	retry:
 		list_for_each_entry(clp, head, cl_idhash) {
-			struct nfs4_stid *stid = find_one_export_stid(
-							clp, path,
-							sc_types);
+			struct nfs4_stid *stid;
+
+			/* Skip or pin clp as in nfsd4_revoke_states(). */
+			if (is_client_expired(clp))
+				continue;
+			stid = find_one_export_stid(clp, path, sc_types);
 			if (stid) {
+				atomic_inc(&clp->cl_rpc_users);
 				spin_unlock(&nn->client_lock);
 				revoke_one_stid(nn, clp, stid);
 				nfs4_put_stid(stid);
@@ -2067,6 +2071,9 @@ void nfsd4_revoke_export_states(struct n
 				if (clp->cl_minorversion == 0)
 					nn->nfs40_last_revoke =
 						ktime_get_boottime_seconds();
+				if (atomic_dec_and_test(&clp->cl_rpc_users) &&
+				    is_client_expired(clp))
+					wake_up_all(&expiry_wq);
 				goto retry;
 			}
 		}


