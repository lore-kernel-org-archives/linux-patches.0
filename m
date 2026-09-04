Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4843634F24A;
	Fri,  4 Sep 2026 05:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498687; cv=none; b=KOvG8AGztwkDs5EN9/j97Nv49PdygAmgBJXe+Rrkt1sh0wdViWXmaYJ02ZhYIEbgAxmO/xp3J3su0I1JLObcFQlQodkVWnwjuBFt5zr2tDcJ4Mi1Cm3NFDCuanemVf/wt3tH7pGYEcLGbERHxqxUWOVlmJ/Z8/f5h+niC+gPDzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498687; c=relaxed/simple;
	bh=UzR37Wt9GJiwHzMix79iHuGY+u9+utNbOkKhLPD215M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd3QKlnHS+FPQBo+Ir1TUmUkwsYGCh978GN0E0dVrEH8yoKofa/YX+zRhWaYZ9DH+Gg+EJQv251qFDSuhhqFUCoy5kEKZ8uU/3FVdhBZcUpOi6TBgJUd5ObQIMIp6AKA/zJDEOEHzz/Xgxwmfyi0msH4hUUSE0lAElxgHWSeFjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6quHz1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6quHz1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C511F00A3D;
	Fri,  4 Sep 2026 05:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498686;
	bh=w51Aqa8bmZTqidVReFkfHrI9ntUzopymVA1ZrjYsiKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6quHz1/17LuEqjgHKHcNMgvY96TT9p8MoL96cm/nPIdm5k865tmxkcX76bnmF1fI
	 YVT/ltYP4in77tuqXzA7vaaI+otsWtO8UJFiyAqpxAgujX53RFHHqot9Zxusyz5Coq
	 oD1KY8iOPA5BSP49hv+k+0FNuA2uPIYeE49Qkaww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 151/713] nfsd: restore rq_status_counter to even on all nfsd_dispatch() exit paths
Date: Fri,  4 Sep 2026 06:51:59 +0200
Message-ID: <20260904045807.212718520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit f6045886fe3f14f269f683d64021b004a50d0efa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -960,6 +960,20 @@ nfsd(void *vrqstp)
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
@@ -1022,14 +1036,9 @@ int nfsd_dispatch(struct svc_rqst *rqstp
 	if (!proc->pc_encode(rqstp, &rqstp->rq_res_stream))
 		goto out_encode_err;
 
-	/*
-	 * Release rq_status_counter setting it to an even value after the rpc
-	 * request has been properly processed.
-	 */
-	smp_store_release(&rqstp->rq_status_counter, rqstp->rq_status_counter + 1);
-
 	nfsd_cache_update(rqstp, rp, ntli->ntli_cachetype, nfs_reply);
 out_cached_reply:
+	nfsd_status_counter_set_idle(rqstp);
 	return 1;
 
 out_decode_err:
@@ -1040,12 +1049,14 @@ out_decode_err:
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
 


