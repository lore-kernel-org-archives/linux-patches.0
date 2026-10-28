Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216865;
	b=ks9zpeBP37LOjJrrk85nHY2Jk9fQxTGu5MKpUhl1AvEsoiwi8wd3JFuwBwDxUjD3QyNK
	 +N+8uWC5pyvbXi93SULtzXVSUUEhywrMNbZssd16jLmlY1cfb6VwK6OspwW/UokMZIA3N
	 7NzHj+n/kdkWS8oVQzCPzAYdop0MxhlvRDPaJxKAxKM3bRg3SwUSqnYOK5LU3D5FUFC+O
	 LPZWYSlpdjainCVciX7jCmwfTA5n/OJAYr6S6QoXZOxNM9LXCq32Zn+Wf1SXgLBnyEL0R
	 EcZf2w6a5ecQdKEoib+XL+GLblqb04J8mS+hSuSK1UnDeCDP8DkiyGg9qAE5ZufpIEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rA4TTIt0X5w1fkozmLg6rFDTObLairy6RXQhpIqOHVg=;
	b=GxTqT/spB7Rnz/6abSlGbx2AYo67fNH02pgOYDUYCWyx1+MceEe3e//Nwfma/2ARW/GV
	 bsJPwHHuGvDRQzw76TnHgIBZr5ApEIXP750kToDAARN/NvWxrO2ms2ls/q5H+S/bM1lnl
	 MB+muXVJBiFjj3Z5Ci69kfOwAcFukvh5Z5YG46pjj0eOoGDnkHXReB7BNJuHCaFrpDne/
	 QVaxpaXyk64cnmx4QjY//K/fljPkzJAdiieHVGBfmfKbM5wljMw3z0cJyOQG+n9cHgfXg
	 wC1T7rAoXlkRkqDfSGf/zvAC1AzoV3OoIssRkJPv/+TUOQKisuuH/IIf5T6Zc6tK/fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aw2JYVHE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F39606A31A;
	Wed, 28 Oct 2026 19:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aw2JYVHE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D565B1F01825;
	Wed, 28 Oct 2026 19:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216865;
	bh=rA4TTIt0X5w1fkozmLg6rFDTObLairy6RXQhpIqOHVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aw2JYVHE/8WOOtmkJ6xO7f0biKITgXWh3QKJFPrrXGBYCirfuHiw+6uEx+0e6ZQf7
	 UL2GKISW5Rs925+IXeqpTrVPgcU3BUOIY4i/yyIgcGp0NpSXNbwQviYN1NQMAW/gcJ
	 5iKJdzqaURcjjTUvc1ogGeY9j8TmRSDdNxK1bjAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1707/1887] net/rds: dont let the rdma_cm destroy an id RDS still owns on route failure
Date: Wed, 28 Oct 2026 18:03:23 +0100
Message-ID: <20261028170538.303186278@linuxfoundation.org>
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



