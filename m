Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372F737BE64;
	Sat, 17 Oct 2026 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254822; cv=none; b=EJ6DTmg1xbkN7QdG84FutnQ9zf7e9XwbozX8G0gC7+/fEAjwPCNyYgdI4yU0f5Q8XzRuX6BsfPEuzrY6CZ/Eup3K5Hu5b78Xxw0DHWC2ZbHlh0jil8aGuoPgaFvr1ssLS2tGgmu/1Jcu/KDdGKMEzcBfSpz0wzEWG1mYXZ8ODss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254822; c=relaxed/simple;
	bh=qblh2ciCyFZj9SjMHKkAHMPUAn6zaDPROBQXF+imPk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGailff83AHNGjxNATvEMULRNukLHtor+LAJFZ5KBIhLBMxjP/FfA1gCQsjdMW41GcJ1NaWNsVYRiIXqdoKv+hqqSRZZqV/pkoojh93Fg4sJ6MZ3vX/E0LGZGL/Vgo5eEsCUcHb8ltYDnZmRUkwxxX8Vei8sFjU+JVOnhZH+4zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXt0lYjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXt0lYjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875C11F000C4;
	Sat, 17 Oct 2026 16:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254821;
	bh=y9N5ndZoL1c3lIiiN0nJ6cPuLuuvmncrte+m/fCg0JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXt0lYjjV6jdkdBqPnPbiS/Bvydh55+DvhkX15Q/nhxJU6PbbcxWBFpNrRPfs1ehs
	 zPeR6UQhbM6zjjpJpXHv0BKtw1/c+GqurtpiC5D/ZYaP891+TUdqhNLFzsJQe5WzCE
	 fJWgM+J5Ln2tLW7b8fOWxtPd0blRjrQ0wnIjZd+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 574/869] nfsd: restore rq_status_counter to even on all nfsd_dispatch() exit paths
Date: Sat, 17 Oct 2026 17:56:55 +0200
Message-ID: <20261017160051.780834142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit f6045886fe3f14f269f683d64021b004a50d0efa ]

nfsd_dispatch() sets rq_status_counter to an odd value once a request has
been decoded, and back to an even value once it has been fully processed,
forming a seq-lock like protocol with the lockless reader in
nfsd_nl_rpc_status_get_dumpit().

Only the fully successful path restored the counter to even. The cache-hit
(RC_REPLY), drop (RC_DROPIT / RQ_DROPME) and encode-error paths all return
after the odd-valued store without ever bringing the counter back to even.
Once one of those paths is taken, rq_status_counter is left odd: the next
request's decode ORs in 1 (still odd) and only a subsequent successful
encode restores even. While stuck odd, the dumpit reader treats the rqstp
fields as stable and its retry check compares against the same unchanging
odd value, so it never detects concurrent mutation. This exposes actively
mutating fields (e.g. args->ops / args->opcnt during compound decode and
release) to the lockless reader, which can read past the end of the
8-element inline ops array.

Add a helper that advances the counter to the next even value and call it
on every return path that follows the odd-valued store. The decode-error
path is left untouched as it is reached before the counter is set odd.

Fixes: bd9d6a3efa97 ("NFSD: add rpc_status netlink support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-19-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 421f474b75ce8..57754dfacf9cb 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -974,6 +974,20 @@ nfsd(void *vrqstp)
 	return 0;
 }
 
+/*
+ * Set rq_status_counter back to an even value, indicating that the rqstp
+ * fields are no longer meaningful to a lockless reader. This pairs with the
+ * odd-valued store made once the request has been decoded, and must run on
+ * every return path that follows it so that the seq-lock like protocol used
+ * by nfsd_nl_rpc_status_get_dumpit() is not left permanently odd. The store
+ * also advances the counter so a concurrent reader detects the transition.
+ */
+static void nfsd_status_counter_set_idle(struct svc_rqst *rqstp)
+{
+	smp_store_release(&rqstp->rq_status_counter,
+			  (rqstp->rq_status_counter | 1) + 1);
+}
+
 /**
  * nfsd_dispatch - Process an NFS or NFSACL or LOCALIO Request
  * @rqstp: incoming request
@@ -1035,14 +1049,9 @@ int nfsd_dispatch(struct svc_rqst *rqstp)
 	if (!proc->pc_encode(rqstp, &rqstp->rq_res_stream))
 		goto out_encode_err;
 
-	/*
-	 * Release rq_status_counter setting it to an even value after the rpc
-	 * request has been properly processed.
-	 */
-	smp_store_release(&rqstp->rq_status_counter, rqstp->rq_status_counter + 1);
-
 	nfsd_cache_update(rqstp, rp, rqstp->rq_cachetype, nfs_reply);
 out_cached_reply:
+	nfsd_status_counter_set_idle(rqstp);
 	return 1;
 
 out_decode_err:
@@ -1053,12 +1062,14 @@ int nfsd_dispatch(struct svc_rqst *rqstp)
 out_update_drop:
 	nfsd_cache_update(rqstp, rp, RC_NOCACHE, NULL);
 out_dropit:
+	nfsd_status_counter_set_idle(rqstp);
 	return 0;
 
 out_encode_err:
 	trace_nfsd_cant_encode_err(rqstp);
 	nfsd_cache_update(rqstp, rp, RC_NOCACHE, NULL);
 	*statp = rpc_system_err;
+	nfsd_status_counter_set_idle(rqstp);
 	return 1;
 }
 
-- 
2.53.0



