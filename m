Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A1B36CDF2;
	Wed, 20 May 2026 16:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296111; cv=none; b=S9+TiGPkioKwOXpjW1Nsmof5/zgkTworxmrH8VeYP3Y6sZwpYiarUy/CnESbpQXdNqlQVbrxg0iSSd3Oebz8eTdQpou7Zw87r/4BabtFXBw+zo+6lzmcybfML8qop4my4Kl5XLQkvCiWTORcvr87GCV/qmdHBKiHX1Q22rOyJes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296111; c=relaxed/simple;
	bh=HauQpVYE0SCAmr9R61boVW/FhBfvaXRcXDP7WWkYT/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McY0YxwQ03ZbH62RSQdhR64HN5e3fohSAl+fBUPv5XlucU7JN8uAbRN8xePxeECdIIHauOdhhLGVHlXdqRRl2ik1kHw1OmXSHSEYMQaDgdFCWDoV2liOSHFsFtuOcxSTPA01WiEOMkZdPvhu+mjUzE15L8KlZBMDnacQAEdICnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGHRFfo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGHRFfo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89181F000E9;
	Wed, 20 May 2026 16:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296110;
	bh=lDHtNARbYUh8469Cp7CK2DIMqgTQfjrevNx+fUX9yvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGHRFfo8x8Gvk/xZskYl5+PG8FoMIhF6ymv2FkgGgbQSF3it86putWOU82MVdRSXQ
	 frtYixc2UjWSIwOBJR20cy4qXoosmc7ZHwlF1Kg3arJ5roglDFqgc5nDvh2tDStFm4
	 UKfYW7I2WPeD0ttR1Qt9ciVEq4UI39oLor1mHRpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0675/1146] sunrpc: Kill RPC_IFDEBUG()
Date: Wed, 20 May 2026 18:15:25 +0200
Message-ID: <20260520162203.464117047@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit adcc59114ccd402259c089b0fea24da5e4974563 ]

RPC_IFDEBUG() is used in only two places. In one the user of
the definition is guarded by ifdeffery, in the second one
it's implied due to dprintk() usage. Kill the macro and move
the ifdeffery to the regular condition with the variable defined
inside, while in the second case add the same conditional and
move the respective code there.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 6f57293abb8d ("sunrpc: Fix compilation error (`make W=1`) when dprintk() is no-op")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.c                          |  9 +++++---
 include/linux/sunrpc/debug.h             |  2 --
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 27 ++++++++++++------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index ed85dd43da18e..68b629fbaaeb9 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -105,9 +105,12 @@ static __be32 nfsd_setuser_and_check_port(struct svc_rqst *rqstp,
 {
 	/* Check if the request originated from a secure port. */
 	if (rqstp && !nfsd_originating_port_ok(rqstp, cred, exp)) {
-		RPC_IFDEBUG(char buf[RPC_MAX_ADDRBUFLEN]);
-		dprintk("nfsd: request from insecure port %s!\n",
-		        svc_print_addr(rqstp, buf, sizeof(buf)));
+		if (IS_ENABLED(CONFIG_SUNRPC_DEBUG)) {
+			char buf[RPC_MAX_ADDRBUFLEN];
+
+			dprintk("nfsd: request from insecure port %s!\n",
+			        svc_print_addr(rqstp, buf, sizeof(buf)));
+		}
 		return nfserr_perm;
 	}
 
diff --git a/include/linux/sunrpc/debug.h b/include/linux/sunrpc/debug.h
index eb4bd62df3190..93d1a11ffbfb3 100644
--- a/include/linux/sunrpc/debug.h
+++ b/include/linux/sunrpc/debug.h
@@ -49,12 +49,10 @@ do {									\
 	}								\
 } while (0)
 
-# define RPC_IFDEBUG(x)		x
 #else
 # define ifdebug(fac)		if (0)
 # define dfprintk(fac, fmt, ...)	do {} while (0)
 # define dfprintk_rcu(fac, fmt, ...)	do {} while (0)
-# define RPC_IFDEBUG(x)
 #endif
 
 /*
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 9b623849723ed..f2d72181a6fe8 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -414,7 +414,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device *dev;
 	int ret = 0;
-	RPC_IFDEBUG(struct sockaddr *sap);
 
 	listen_rdma = container_of(xprt, struct svcxprt_rdma, sc_xprt);
 	clear_bit(XPT_CONN, &xprt->xpt_flags);
@@ -560,18 +559,20 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		goto errout;
 	}
 
-#if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
-	dprintk("svcrdma: new connection accepted on device %s:\n", dev->name);
-	sap = (struct sockaddr *)&newxprt->sc_cm_id->route.addr.src_addr;
-	dprintk("    local address   : %pIS:%u\n", sap, rpc_get_port(sap));
-	sap = (struct sockaddr *)&newxprt->sc_cm_id->route.addr.dst_addr;
-	dprintk("    remote address  : %pIS:%u\n", sap, rpc_get_port(sap));
-	dprintk("    max_sge         : %d\n", newxprt->sc_max_send_sges);
-	dprintk("    sq_depth        : %d\n", newxprt->sc_sq_depth);
-	dprintk("    rdma_rw_ctxs    : %d\n", ctxts);
-	dprintk("    max_requests    : %d\n", newxprt->sc_max_requests);
-	dprintk("    ord             : %d\n", conn_param.initiator_depth);
-#endif
+	if (IS_ENABLED(CONFIG_SUNRPC_DEBUG)) {
+		struct sockaddr *sap;
+
+		dprintk("svcrdma: new connection accepted on device %s:\n", dev->name);
+		sap = (struct sockaddr *)&newxprt->sc_cm_id->route.addr.src_addr;
+		dprintk("    local address   : %pIS:%u\n", sap, rpc_get_port(sap));
+		sap = (struct sockaddr *)&newxprt->sc_cm_id->route.addr.dst_addr;
+		dprintk("    remote address  : %pIS:%u\n", sap, rpc_get_port(sap));
+		dprintk("    max_sge         : %d\n", newxprt->sc_max_send_sges);
+		dprintk("    sq_depth        : %d\n", newxprt->sc_sq_depth);
+		dprintk("    rdma_rw_ctxs    : %d\n", ctxts);
+		dprintk("    max_requests    : %d\n", newxprt->sc_max_requests);
+		dprintk("    ord             : %d\n", conn_param.initiator_depth);
+	}
 
 	return &newxprt->sc_xprt;
 
-- 
2.53.0



