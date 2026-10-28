Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215991;
	b=2Bzl3CZ8kRMju4bWd2ukAQNBg1IsZy36isW19j245pflk01BDILL/hJ2+tOue9WZuM0H
	 jR4oRPv7BPxZw7kwFU/W4x8HkEc1mO3SomUKSfQDw116ouDqE8/0B29suEkBoJpkc3Wpt
	 oyH0jYunIUXA/JnZRCDHzn5X/yXNMsXcNLdLKksstU2N3bpa62bZPuK534+OTiNrZICWf
	 OOVRuCI+O+nivnEmR1oLKaqN4qbIn/M9scN9zcCiOazdLAyXea9zfA+2mr1h1lsEsWx2N
	 EcONWbafHUqfxF6M3BwoAfzLvLcOiaJg+BjJBaFFeDiVB+ftBGtWmE3PBOdOPyGcLtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/ZyX6c6DkYC9op6t8z43QGMvhFw3C54NVgY03zHcgA=;
	b=fAYxBsgFTMu59AM6ygQXXqt6mcNN9XqKCHa+95caq0n9quE/gFzKt/ir2yUYLDYb1xVo
	 V113VdSw/86HBBNa+170LZRfnPRpSvdVHP07Q3r8TYVXPB8vdPgjhnzMMyMNTMdQ7T81C
	 8wyoV1nWe0ovkyLAlGktVke21hdyx9lNRBRiJMPJSByeg7GRpfuzbWrrgnVwXIsNqpLd4
	 r9HWzwcG/jrr1E1ZYJo+hZn/8mwbKPIWwUtFoSdi7owfKPwFNRUH3XgUPi3tuDDri9xQo
	 g0Qh4LMfKUaoR36iethH0i9DvLN9WKjH2mQ+fhwlH8NE72x6/46CP5+RyrfqeEg5UjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uufb1nT3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3331B606A31A;
	Wed, 28 Oct 2026 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uufb1nT3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8705A1F01825;
	Wed, 28 Oct 2026 19:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215991;
	bh=0/ZyX6c6DkYC9op6t8z43QGMvhFw3C54NVgY03zHcgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uufb1nT3HUK6cirKggIcvBCmC3brBqopBMo8zJSI4G9aB2AmTZvZga01rlwtDkN5U
	 J8uvrTWLIsdq5aF90XuAkXkZqXMUc0Pe9/kh9k0voW5Mxa4QqcRBeLc30DAZizLzqT
	 wURfWhV5LSRquRkqKcn/YZIYZXRe8Z/iKQGOqet4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1402/1887] SUNRPC: Fix crasher in unwrap_integ_data()
Date: Wed, 28 Oct 2026 17:58:18 +0100
Message-ID: <20261028170531.354453629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4dd9daa9124aad3c3d4ceca4f1d417cc62d59156 ]

If a zero length is passed to kmalloc() it returns 0x10, which is
not a valid address. gss_verify_mic() subsequently crashes when it
attempts to dereference that pointer.

Instead of allocating this memory on every call based on an
untrusted size value, use a piece of dynamically-allocated scratch
memory that is always available.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: a919c5c88769 ("SUNRPC: svcauth_gss: enforce krb5 token minimum length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 55 ++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 36549f6d5e01e..ccb38a5406067 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -49,11 +49,36 @@
 #include <linux/sunrpc/svcauth.h>
 #include <linux/sunrpc/svcauth_gss.h>
 #include <linux/sunrpc/cache.h>
+#include <linux/sunrpc/gss_krb5.h>
 
 #include <trace/events/rpcgss.h>
 
 #include "gss_rpc_upcall.h"
 
+/*
+ * Unfortunately there isn't a maximum checksum size exported via the
+ * GSS API. Manufacture one based on GSS mechanisms supported by this
+ * implementation.
+ */
+#define GSS_MAX_CKSUMSIZE (GSS_KRB5_TOK_HDR_LEN + GSS_KRB5_MAX_CKSUM_LEN)
+
+/*
+ * This value may be increased in the future to accommodate other
+ * usage of the scratch buffer.
+ */
+#define GSS_SCRATCH_SIZE GSS_MAX_CKSUMSIZE
+
+struct gss_svc_data {
+	/* decoded gss client cred: */
+	struct rpc_gss_wire_cred	clcred;
+	/* save a pointer to the beginning of the encoded verifier,
+	 * for use in encryption/checksumming in svcauth_gss_release: */
+	__be32				*verf_start;
+	struct rsc			*rsci;
+
+	/* for temporary results */
+	u8				gsd_scratch[GSS_SCRATCH_SIZE];
+};
 
 /* The rpcsec_init cache is used for mapping RPCSEC_GSS_{,CONT_}INIT requests
  * into replies.
@@ -887,13 +912,11 @@ read_u32_from_xdr_buf(struct xdr_buf *buf, int base, u32 *obj)
 static int
 unwrap_integ_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gss_ctx *ctx)
 {
+	struct gss_svc_data *gsd = rqstp->rq_auth_data;
 	u32 integ_len, rseqno, maj_stat;
-	int stat = -EINVAL;
 	struct xdr_netobj mic;
 	struct xdr_buf integ_buf;
 
-	mic.data = NULL;
-
 	/* NFS READ normally uses splice to send data in-place. However
 	 * the data in cache can change after the reply's MIC is computed
 	 * but before the RPC reply is sent. To prevent the client from
@@ -917,11 +940,9 @@ unwrap_integ_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct g
 	/* copy out mic... */
 	if (read_u32_from_xdr_buf(buf, integ_len, &mic.len))
 		goto unwrap_failed;
-	if (mic.len > RPC_MAX_AUTH_SIZE)
-		goto unwrap_failed;
-	mic.data = kmalloc(mic.len, GFP_KERNEL);
-	if (!mic.data)
+	if (mic.len > sizeof(gsd->gsd_scratch))
 		goto unwrap_failed;
+	mic.data = gsd->gsd_scratch;
 	if (read_bytes_from_xdr_buf(buf, integ_len + 4, mic.data, mic.len))
 		goto unwrap_failed;
 	maj_stat = gss_verify_mic(ctx, &integ_buf, &mic);
@@ -932,20 +953,17 @@ unwrap_integ_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct g
 		goto bad_seqno;
 	/* trim off the mic and padding at the end before returning */
 	xdr_buf_trim(buf, round_up_to_quad(mic.len) + 4);
-	stat = 0;
-out:
-	kfree(mic.data);
-	return stat;
+	return 0;
 
 unwrap_failed:
 	trace_rpcgss_svc_unwrap_failed(rqstp);
-	goto out;
+	return -EINVAL;
 bad_seqno:
 	trace_rpcgss_svc_seqno_bad(rqstp, seq, rseqno);
-	goto out;
+	return -EINVAL;
 bad_mic:
 	trace_rpcgss_svc_mic(rqstp, maj_stat);
-	goto out;
+	return -EINVAL;
 }
 
 static inline int
@@ -1023,15 +1041,6 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	return -EINVAL;
 }
 
-struct gss_svc_data {
-	/* decoded gss client cred: */
-	struct rpc_gss_wire_cred	clcred;
-	/* save a pointer to the beginning of the encoded verifier,
-	 * for use in encryption/checksumming in svcauth_gss_release: */
-	__be32				*verf_start;
-	struct rsc			*rsci;
-};
-
 static int
 svcauth_gss_set_client(struct svc_rqst *rqstp)
 {
-- 
2.53.0



