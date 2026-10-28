Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207471;
	b=nmcTiBl6k0j3zOengy4N7YcJtzWJUsVzS4lGKHlPsXtJDOYbxLSpp99hOxr5TJD+SSCa
	 PjlXyAQipDqMNvOmW8CkdYWM7Z48MpcO3DpsoHs9uieSTnq9Z9IuYkuHfDO+FfSpFT4hz
	 +o8aIzvONuLJjKJB6YFMHiQrYJu27xt1/SUc66Um3n7sRVwADUIRZlYZNRMsv/gQ1jd0t
	 D+rldEnEdlaEh3s8qUVVgHTSb8/cPmY1sQlhQnU4I+ABhQMIz4u/2uJn3aaxoCYzy+5Bd
	 +In/47nk1Zqild5rbhTxA7t4wG51k4Hb1DDJFVg0mKEx/Ux0rfK+j+BkqUWIp0kHufA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=odKI7aA5rwSOIn+nU3bh41oqAwU3hssUWuer8i25Lmw=;
	b=nzYo7qluCxvHtNsLuXoh/rtdQcrh4WLbfRQSa1SaSPWI+xwxQ22RZpfmsytv8eP6QGma
	 ocAZlBEdo3peN9eIa5npeMi1Rl5K+WAwyNIzhvQ4oZJtuHs7ojS7nB8qyU9GZVYnpgSGh
	 7Pw7//8Ow3cKmog+Wwvs4HbdWsk6j0FJuOJ79x6WXMzf3RNyz7YR4bIsVa3xI4s8Jn+TL
	 RaUueVhVM/SQlN+jVBFKk+7U4LcDeliaq3ZUx5wmClP79HIdp5jVqC34xYXssbZKVK/2r
	 W7UtcOELgHq5tyvqTjJWgQfBtkXQZXF8kqv0xWdoJslwIzRM4jhbVHP9Zv6vd8D/6EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LDTgy6m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC77606A31E;
	Wed, 28 Oct 2026 17:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LDTgy6m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1611F01828;
	Wed, 28 Oct 2026 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207470;
	bh=odKI7aA5rwSOIn+nU3bh41oqAwU3hssUWuer8i25Lmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LDTgy6muTMxgPA3GG0xBsGGSyaIKd1uK/itweBjz1KI8iHxZs9mvbCNyYB0SOfaJ
	 pA8CxNvmPRlv1mr4dLvJfEYEXkHws6LoV1uYIwQNFbSXLPTyc3hF08+yeJfpGPjvyv
	 fMnSFZ+f11q0SttvsMOmFGRwSS7bQmK4YxSL24Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/247] net/rds: dont let the rdma_cm destroy an id RDS still owns on route failure
Date: Wed, 28 Oct 2026 17:57:11 +0100
Message-ID: <20261028165948.033930079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 98d446b7c013254a8a7b49720557676a3a851fde ]

rds_rdma_cm_event_handler_cmn() hands the return value of
rdma_resolve_route() straight back to the rdma_cm on
RDMA_CM_EVENT_ADDR_RESOLVED.  A synchronous failure there - -ENOMEM
from the route work allocation, an SA query that cannot be set up, a
RoCE route with no usable device - makes addr_handler() destroy the
id the event was delivered on.  That id is ic->i_cm_id, and nothing
clears the pointer: the connection sits in RDS_CONN_CONNECTING with a
freed id until its shutdown calls rdma_disconnect() and
rdma_destroy_id() on it.

The ROUTE_RESOLVED case already avoids this: rds_ib_cm_initiate_connect()
forces a zero return while ic->i_cm_id == cm_id, as the comment there
explains.  Do the same here - drop the connection and return 0 - so
the id stays RDS's to destroy from the shutdown, and the reconnect
gets a fresh one.

Fixes: 55b7ed0b582f ("RDS: Common RDMA transport code")
Assisted-by: LLM
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261003163408.250568-3-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/rdma_transport.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a2..21738a5690917 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -89,9 +89,19 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 		if (conn) {
 			rdma_set_service_type(cm_id, conn->c_tos);
 			rdma_set_min_rnr_timer(cm_id, IB_RNR_TIMER_000_32);
-			/* XXX do we need to clean up if this fails? */
 			ret = rdma_resolve_route(cm_id,
 						 RDS_RDMA_RESOLVE_TIMEOUT_MS);
+			if (ret) {
+				/* A non-zero return has the rdma_cm destroy
+				 * the id, but it is still ic->i_cm_id, which
+				 * the connection's shutdown would then
+				 * disconnect and destroy again.  Drop the
+				 * connection and keep the id for that
+				 * shutdown.
+				 */
+				rds_conn_drop(conn);
+				ret = 0;
+			}
 		}
 		break;
 
-- 
2.53.0



