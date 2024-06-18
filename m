Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A4E153810;
	Tue, 18 Jun 2024 12:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715328; cv=none; b=Djv5y7DbncjWw6ucDcgvrLwb5nLeU2lLptC4ztz9/UstqlKSop3Q+GOAGGJfqxCgh/krjLHXhCHg+4iszMH0j/8US26CakX0PGhUYp+D/A/+i9A8ggrYtntHnrL8uBYDs62QfOhTg4+OmYvX4Pjf3N8FxXXWVEWIIq4EfBNKT04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715328; c=relaxed/simple;
	bh=9yLYTuHIdtZcBsPv2tTsS0id8bKXyKY2RlewUiDA7iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+gmuIwE2UNQ5nP1UPfXdJXL9fcRYN9I2er9T7vKD+P4ZBM2f2XsizNbcOdg7r9yoAyUVAJJ+BxeywWfTeFF6/ZDqHrP1AXvSwwDjnRWCwynhNVCPm4Y+p+YIjtRgRt9tY0HcPmSEgzrlA6qgsVm7v2gn56wn1yxAVgExt3aG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px14B9I/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px14B9I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE634C32786;
	Tue, 18 Jun 2024 12:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715328;
	bh=9yLYTuHIdtZcBsPv2tTsS0id8bKXyKY2RlewUiDA7iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px14B9I/iYELIR6tU/LYZHtY6UXRvx2BawXQRkmdcuB1ONLl8vXFrWTtOKhaftEmQ
	 QGE5cAT8gM7IhxDgEKm1mQjp764vB29/X1ZdLwl9J7cy7kKfjGQvgfCD6flXuD05Y5
	 Gs/TiDw8sShjGS1ZZYBX+ey5dRVMry0p7e5GrWqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/770] NFSD: Add nfsd_clid_verf_mismatch tracepoint
Date: Tue, 18 Jun 2024 14:32:03 +0200
Message-ID: <20240618123417.693889207@linuxfoundation.org>
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

[ Upstream commit 744ea54c869cebe41fbad5f53f8a8ca5d93a5c97 ]

Record when a client presents a different boot verifier than the
one we know about. Typically this is a sign the client has
rebooted, but sometimes it signals a conflicting client ID, which
the client's administrator will need to address.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 ++++++++---
 fs/nfsd/trace.h     | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2e18b1ad889d7..8169625fdd233 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3213,6 +3213,7 @@ nfsd4_exchange_id(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out_copy;
 		}
 		/* case 5, client reboot */
+		trace_nfsd_clid_verf_mismatch(conf, rqstp, &verf);
 		conf = NULL;
 		goto out_new;
 	}
@@ -4018,9 +4019,13 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (unconf)
 		unhash_client_locked(unconf);
 	/* We need to handle only case 1: probable callback update */
-	if (conf && same_verf(&conf->cl_verifier, &clverifier)) {
-		copy_clid(new, conf);
-		gen_confirm(new, nn);
+	if (conf) {
+		if (same_verf(&conf->cl_verifier, &clverifier)) {
+			copy_clid(new, conf);
+			gen_confirm(new, nn);
+		} else
+			trace_nfsd_clid_verf_mismatch(conf, rqstp,
+						      &clverifier);
 	}
 	new->cl_minorversion = 0;
 	gen_callback(new, setclid, rqstp);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index bec85fc8be01a..0ab46a0c911d2 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -564,6 +564,38 @@ TRACE_EVENT(nfsd_clid_cred_mismatch,
 	)
 )
 
+TRACE_EVENT(nfsd_clid_verf_mismatch,
+	TP_PROTO(
+		const struct nfs4_client *clp,
+		const struct svc_rqst *rqstp,
+		const nfs4_verifier *verf
+	),
+	TP_ARGS(clp, rqstp, verf),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__array(unsigned char, cl_verifier, NFS4_VERIFIER_SIZE)
+		__array(unsigned char, new_verifier, NFS4_VERIFIER_SIZE)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+	),
+	TP_fast_assign(
+		__entry->cl_boot = clp->cl_clientid.cl_boot;
+		__entry->cl_id = clp->cl_clientid.cl_id;
+		memcpy(__entry->cl_verifier, (void *)&clp->cl_verifier,
+		       NFS4_VERIFIER_SIZE);
+		memcpy(__entry->new_verifier, (void *)verf,
+		       NFS4_VERIFIER_SIZE);
+		memcpy(__entry->addr, &rqstp->rq_xprt->xpt_remote,
+			sizeof(struct sockaddr_in6));
+	),
+	TP_printk("client %08x:%08x verf=0x%s, updated=0x%s from addr=%pISpc",
+		__entry->cl_boot, __entry->cl_id,
+		__print_hex_str(__entry->cl_verifier, NFS4_VERIFIER_SIZE),
+		__print_hex_str(__entry->new_verifier, NFS4_VERIFIER_SIZE),
+		__entry->addr
+	)
+);
+
 TRACE_EVENT(nfsd_clid_inuse_err,
 	TP_PROTO(const struct nfs4_client *clp),
 	TP_ARGS(clp),
-- 
2.43.0



