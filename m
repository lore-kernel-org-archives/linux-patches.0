Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773826;
	b=4BHsIIX4i18h2JB6fkAUO/obsX4orSi9HmRUfrQOS21GDV17AZlKn/NFE9t1gwYnOi0k
	 9I0IRz1136ILtDvBwXwqSGmoW7UF9suwiazTIVhWtrQn13bjEUCtysdDMCTSNONNXcJlg
	 uzqGhGkdYhiDWJ6o/qFWEZYDA+zniG2Yi9JBPRxOkp5kPKuXshpokQ9TIplLgG5KiblyT
	 ANlvBJKYLe6ywZGLbIKBFMYPhctPATmFjyPlDLdPUn9Hvjfv3IA1bixHyKLqO+qxXwqho
	 OvngCDkrN7uOreQf8KeguNA2GTfxtMaFTg6gPtCX4ciaFFSFIVSQp0GFO4BXg95Jwvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmmgJH2ZKwuhbfVccSejY5tFeUD6T8TE2DjYYeFOKJY=;
	b=nkhlXVTxk0PHcBVUOJGCscAkFOp2J1QN5MbuBjMyovf6m2QfPKSwrN4CFX7B8Wv7P8Dt
	 wbvCS5ruPWxLDXmauc9JGfavqdwK4BwS81rJELriOWA/OLXDmnixL1YieYRtA/W/Wz7cY
	 aT5rHk/kNtJi8x1HoUdyI0gmXiF5ahHWDZITmuI9ibpCfj6hvRLeqBmPrPjUwJu7h/6Rt
	 iqn+mCNqXh7T+ZHsNN1EPcnET8YXqjqlfcibn6Qf7u6bHVFw5RtK4XeUCLoFURpAtjaPt
	 0+EHsovwde0ZGinb5UNHjfIG8LzRDV9wXoapcHTB0JwVVsqhGci83h4w4iElug2YQ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Up5qHP7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE25606A31E;
	Fri, 23 Oct 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Up5qHP7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7BA1F031E6;
	Fri, 23 Oct 2026 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773825;
	bh=vmmgJH2ZKwuhbfVccSejY5tFeUD6T8TE2DjYYeFOKJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up5qHP7aDCIY2KRI5JqqNkhqf0AOBMZegCdFnolKTPq0oCTOpthQtjSZuXVgdSkZo
	 dRmemUR48uNOxL9BGQvubCJqb1GvnMNIro2nnxxL9D2aCihDfprnZiWV4UTcmf605q
	 kmt9wZUl7pKs07+Akja0bBgFdOjL7NKak+Ei4JUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/193] net/rds: dont let the rdma_cm destroy an id RDS still owns on route failure
Date: Fri, 23 Oct 2026 18:35:06 +0200
Message-ID: <20261023163714.890413372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



