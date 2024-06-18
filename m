Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C761B16DC1D;
	Tue, 18 Jun 2024 12:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715360; cv=none; b=XZNXu2GAMxTYDXO5kqnfeArYb72QMxMi/Ooh0ZJiOIr7qRHGOcjTsIjVzIcdgkfFYB/IRJwW62+t+ddwnu95s0i553NSxacS7ftXzClRqpfRGF+Yg9Pp7AhqP8HrMuK5y+rrylI40cYT2jcJd0mmVJWYn6MirBYnCfFES4/MycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715360; c=relaxed/simple;
	bh=G/sxxMh386s0zVbIlm4dJ2pnHM0mXnVmLXxLQL0AQyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE+WqxKPOppESU0N9DdMP/C84eXNMxTN+Uh1EzBmKkTurX5df7uTd8tu9WjaKQGlF6d8GGwTgv/eudz99L2TXVLB9CVDABfloaWs8R9ziz35JCeWayJp7tdSk9ZA+C2JnQQ70HeHcb5alI7pQQzS8Tm7Nhl8hq7H0n1lpV9REqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6JGLzYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6JGLzYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F36C3277B;
	Tue, 18 Jun 2024 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715360;
	bh=G/sxxMh386s0zVbIlm4dJ2pnHM0mXnVmLXxLQL0AQyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6JGLzYxnCv3MxlkVhGGiAsaosvP/oTVt3yLSnL47BoOO0WX7Be3GzTQOq75fWN3k
	 j2pphbYJUlFHIl1c1r9/rH2chSZm9uwU3DUgM3bCY9YOrJ2QFdwVFSpImD/2rhs0hy
	 aP7SKJWAaX/55rMpeUMwKFNqZvo3HkH5HVDU0Ecg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/770] NFSD: Add a couple more nfsd_clid_expired call sites
Date: Tue, 18 Jun 2024 14:32:08 +0200
Message-ID: <20240618123417.883122812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 2958d2ee71021b6c44212ec6c2a39cc71d9cd4a9 ]

Improve observation of NFSv4 lease expiry.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 9 ++++++---
 fs/nfsd/trace.h     | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6f04a84f76c0e..7e8752f4affda 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2687,6 +2687,8 @@ static void force_expire_client(struct nfs4_client *clp)
 	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 	bool already_expired;
 
+	trace_nfsd_clid_admin_expired(&clp->cl_clientid);
+
 	spin_lock(&nn->client_lock);
 	clp->cl_time = 0;
 	spin_unlock(&nn->client_lock);
@@ -3233,6 +3235,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = mark_client_expired_locked(conf);
 		if (status)
 			goto out;
+		trace_nfsd_clid_replaced(&conf->cl_clientid);
 	}
 	new->cl_minorversion = cstate->minorversion;
 	new->cl_spo_must_allow.u.words[0] = exid->spo_must_allow[0];
@@ -3472,6 +3475,7 @@ nfsd4_create_session(struct svc_rqst *rqstp,
 				old = NULL;
 				goto out_free_conn;
 			}
+			trace_nfsd_clid_replaced(&old->cl_clientid);
 		}
 		move_to_confirmed(unconf);
 		conf = unconf;
@@ -4112,6 +4116,7 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 				old = NULL;
 				goto out;
 			}
+			trace_nfsd_clid_replaced(&old->cl_clientid);
 		}
 		move_to_confirmed(unconf);
 		conf = unconf;
@@ -5550,10 +5555,8 @@ nfs4_laundromat(struct nfsd_net *nn)
 		clp = list_entry(pos, struct nfs4_client, cl_lru);
 		if (!state_expired(&lt, clp->cl_time))
 			break;
-		if (mark_client_expired_locked(clp)) {
-			trace_nfsd_clid_expired(&clp->cl_clientid);
+		if (mark_client_expired_locked(clp))
 			continue;
-		}
 		list_add(&clp->cl_lru, &reaplist);
 	}
 	spin_unlock(&nn->client_lock);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 3aca6dcba90a5..3271d925abf2e 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -514,7 +514,8 @@ DEFINE_EVENT(nfsd_clientid_class, nfsd_clid_##name, \
 DEFINE_CLIENTID_EVENT(reclaim_complete);
 DEFINE_CLIENTID_EVENT(confirmed);
 DEFINE_CLIENTID_EVENT(destroyed);
-DEFINE_CLIENTID_EVENT(expired);
+DEFINE_CLIENTID_EVENT(admin_expired);
+DEFINE_CLIENTID_EVENT(replaced);
 DEFINE_CLIENTID_EVENT(purged);
 DEFINE_CLIENTID_EVENT(renew);
 DEFINE_CLIENTID_EVENT(stale);
-- 
2.43.0



