Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834053C8C62;
	Sat, 17 Oct 2026 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260014; cv=none; b=D/tu+ry7DC+wtRwBpQXlEdDg8OCHrX8hrecUffoW5N7BgK7asp9ZzrV+uXs5OORqnRXn1XRBjQ99aDNYA1PKitoEEQjegcnkXyv7zn31gG4+Ntfy+/1+PwIVl/B6rvNKCOPQsxqlvUK+SNg5g8nm5OcJoX5cNZHMcNRWyr4K0b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260014; c=relaxed/simple;
	bh=bDmiMwDs6VFQjVyN2UONUAwbXHTP2yMrIel6PkNeNZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crGMI2FZoriCyMXdTgq/3uANrFi7tgHtokcf6sogaMa7RDN4trfsXtMIfOMEsRPIFri+TuDvK2vugaA0wyMMvPZKn/mEG7HOSKUrBjJitCgJzW6kCrtdV9Mt7+TTevljkWHJqfTpLCtG6BQU5Uy7kqwtzDEmrA8iRr8ckIaaAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJbi5pOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJbi5pOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7C61F000C5;
	Sat, 17 Oct 2026 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260013;
	bh=lvPEMXWLRBrM4Xn5MYhWIofAwPbGtV41JM2jQVv4iY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJbi5pODwT7NZ7mhG1eow0K3WZBnBzEVaFAwWMrN/KLCcENIaKc46nS3r0X4I+UHl
	 WbZVUf64p2vqpFKZ5kj+GSyFBUsDSs6b1LD2zCmrGIwmcqfBN+4irsGQ8xIcZJqvfH
	 9Riel+Ny2eOig7d+vVNOaxYDboms0QnOagl4KQD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1367/1674] NFSD: Prevent client use-after-free during close_lru reaping
Date: Sat, 17 Oct 2026 18:00:39 +0200
Message-ID: <20261017160506.243841092@linuxfoundation.org>
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

[ Upstream commit 2330b788d732f43668b965b3105b37ceb276dfea ]

An nfs4_openowner left on nn->close_lru after its final CLOSE keeps
its last closed stateid in oo_last_closed_stid, holding only a raw
pointer to its nfs4_client. The laundromat reaps timed-out entries,
drops nn->client_lock, and calls nfs4_put_stid(), which dereferences
the client through cl_lock. Nothing pins the client across that
window, so a concurrent force_expire_client() can free it and
nfs4_put_stid() reads freed memory. __destroy_client() hits the same
race, walking clp->cl_openowners without cl_lock.

Pin the client with cl_rpc_users before dropping client_lock, and
skip clients already expiring. __destroy_client() then cleans up its
own close_lru entries through release_last_closed_stateid(), so
teardown no longer races the laundromat.

Fixes: 217526e7ecc9 ("nfsd: protect the close_lru list and oo_last_closed_stid with client_lock")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-8-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2d57a042f3bf1..456c1d703d51f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6382,11 +6382,18 @@ nfs4_laundromat(struct nfsd_net *nn)
 		if (!state_expired(&lt, oo->oo_time))
 			break;
 		list_del_init(&oo->oo_close_lru);
+		clp = oo->oo_owner.so_client;
+		if (is_client_expired(clp))
+			continue;
 		stp = oo->oo_last_closed_stid;
 		oo->oo_last_closed_stid = NULL;
+		atomic_inc(&clp->cl_rpc_users);
 		spin_unlock(&nn->client_lock);
 		nfs4_put_stid(&stp->st_stid);
 		spin_lock(&nn->client_lock);
+		if (atomic_dec_and_test(&clp->cl_rpc_users) &&
+		    is_client_expired(clp))
+			wake_up_all(&expiry_wq);
 	}
 	spin_unlock(&nn->client_lock);
 
-- 
2.53.0



