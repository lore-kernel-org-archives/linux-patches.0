Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211704;
	b=2kbZ/zqjBhORce/NCR827eSPc/T+FbRw1h7rjtDf1MSWZpkilFZAjfCbDIQRPEZQzHc8
	 8G50rDWFsFosZlhwh6rsnx0aCx8WSbTqKh4Wy3FUIHWcFBQaAUvNl4LO8bgGCdQzmVm8u
	 CEcvSTMxENWQOIT/lhUFHy/ToGMNIk3fQKvFqvlXfZoOqT8oZyIAept/UiXws5KXhMe/5
	 +23eDqaHgTNXAr8DNvNLbX8eLFgLs5yaMGMyQxBsje5OB7m0WlujbnWGpy8m69cH9JhXy
	 uSdaHFJbgIe/HGgtQ6bkLfJ8lXmAdShziPiOkAZ1qfJJTnvYH5JtLc27wGYCDMXtI+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZITwQFsz24P8y5QzvI7ENnUcWXEya/ZAuiVveWVXWUQ=;
	b=5OGtxC2iksgKMEhefGLnxDMo/jGLDJJTAwCpE7FiLkOa5MMstkCgmsbpzpLVsSyMYn6o
	 3FJUYsjT+GbA9wREBRndTtqxCtcx+vIthtyohrzVYqYScRCuos+nXBGjf3+qNy/i8NzHb
	 uUFfMRQXmaIVO7+yNlnQy/EomRtK/Mb7JFzSSFkoT7FEr/P9iWt/hffhJWKrND/34yY4u
	 TNO90fEZmHpNCO4RN3TOnhzoiI9Yf7+2T89KVZnQLGFzfHBEDSK6wsi4tQz4rUF8QGY+U
	 GTRAe68wPaxh3+bjwztTUfz4ELkFkxvJZfpDSeE3al/XzTH706C6Y7THCXPkGHp96TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksQF+EFG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE23606A31A;
	Wed, 28 Oct 2026 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksQF+EFG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDAD1F01825;
	Wed, 28 Oct 2026 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211703;
	bh=ZITwQFsz24P8y5QzvI7ENnUcWXEya/ZAuiVveWVXWUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksQF+EFGeR2A+0xzDYF0eGfo4IjwMidx/9nsXIE8NUB1G89YWTJNF++hExbtjXoZn
	 EZclA47g1ydEGDOgLERo0tcbYxvoDrCwiR6sAChmeOrvOifiQ5Y9T8KX7sG/7eSmHk
	 5CQv3lBZXp0lyAJbe5mrBJmG+v/JcoDNSATFZnNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 472/571] net/rds: dont let the rdma_cm destroy an id RDS still owns on route failure
Date: Wed, 28 Oct 2026 18:00:19 +0100
Message-ID: <20261028170019.221374398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f71f073fd27ac..af9510c9e9702 100644
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



