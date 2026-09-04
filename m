Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D6835AC03;
	Fri,  4 Sep 2026 06:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502155; cv=none; b=YlGjCD3E+ygUVQgPRhvRA5GdfUAE7m+vC5Uvg7MEhfZnFN79fgWZ45rw26A9B5n3PZnF8zfQXhqcWmAx9GHsjldV8PKenmfaSx1OEZ9b/RLZNV+y9ndPE5slABjZP2ZyJvlVA9yDt+a92uUHYZ2rki3lDpIFMwMgN4p3XUqsCnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502155; c=relaxed/simple;
	bh=4LyGgiKchx3YxOuRyD3RQLpTGAx8ACOIdtJ0d4g5MFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfHs7hnY5pEhKhrM/jI5wGk9++5z/MshAs0Kz/+WOH9WfQWZ7RH8LPfz3pRnqlbL1Ue/3xV65YA8LwETPcHh2CA8jCzRVvW8eAVt+w+Zw2a4DtqvyW3LVZFf0oDA1+c4TVthC7sxNQEgIubX+HjOInXL0LuWJkDHQrtQ4dKBQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ7fRFbb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ7fRFbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9951F00A3D;
	Fri,  4 Sep 2026 06:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502154;
	bh=hwU5dEWZis75n41Knt7DjIzZlQhBCdVwu+ybOfM82mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJ7fRFbbo8xJchmnI44Uhb4ger3RtK3jNE7SqjHcHUwJLkdS3MKwz4OYEMJyvtObr
	 0dezJ6ekqv3loQQDNBQwOrZtDJWMLS2N3tiiHDhQDnT77ItMC8s5kgU/ocgy/bC4vv
	 FRoXQq9Xdh9wtYIlTNFU4Dk+raUuDw8H1XWZX/gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 108/403] NFSD: Prevent client use-after-free during NFSv4.0 revoked-state cleanup
Date: Fri,  4 Sep 2026 06:58:31 +0200
Message-ID: <20260904045737.285349066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit 7b4f8a1586c42d3afc3c0ac779af2db7ab1a5c55 upstream.

nfs40_clean_admin_revoked() takes a stateid reference under
clp->cl_lock, drops nn->client_lock, and calls
nfsd4_drop_revoked_stid(), which dereferences the stateid's client
through s->sc_client->cl_lock.  The stateid reference does not pin the
client, so a teardown racing the dropped lock can free the client
while nfsd4_drop_revoked_stid() is still using it.

This cleanup runs from the laundromat, so a periodic sweep can race
force_expire_client() driven by a write to the clients/<id>/ctl file.

Skip a client that is already expiring and otherwise pin it with
cl_rpc_users under client_lock before dropping the lock, matching
nfsd4_revoke_states().

Fixes: d688d8585e6b ("nfsd: allow admin-revoked NFSv4.0 state to be freed.")
Cc: stable@vger.kernel.org
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-5-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6709,16 +6709,22 @@ retry:
 
 		if (atomic_read(&clp->cl_admin_revoked) == 0)
 			continue;
+		if (is_client_expired(clp))
+			continue;
 
 		spin_lock(&clp->cl_lock);
 		idr_for_each_entry_ul(&clp->cl_stateids, stid, tmp, id)
 			if (stid->sc_status & SC_STATUS_ADMIN_REVOKED) {
 				refcount_inc(&stid->sc_count);
+				atomic_inc(&clp->cl_rpc_users);
 				spin_unlock(&nn->client_lock);
 				/* this function drops ->cl_lock */
 				nfsd4_drop_revoked_stid(stid);
 				nfs4_put_stid(stid);
 				spin_lock(&nn->client_lock);
+				if (atomic_dec_and_test(&clp->cl_rpc_users) &&
+				    is_client_expired(clp))
+					wake_up_all(&expiry_wq);
 				goto retry;
 			}
 		spin_unlock(&clp->cl_lock);


