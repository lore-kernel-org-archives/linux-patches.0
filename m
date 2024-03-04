Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30191F92C;
	Mon,  4 Mar 2024 21:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588813; cv=none; b=LHrZbGQB/3bJHo73AK9jWyPShb3xBpRn5M0qKqpvlEF8PuZJaB/ILpFGBwZREJJIjSKEKQLpvnIqWMHb4U7FUzD6VqKxByzkdPYpYxU7hPqWZ7EjgO5k8yzj71Lxxu8XpfuwKFosNyKsif44gV97d8OtlpNLauHvoIx4k4R5DAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588813; c=relaxed/simple;
	bh=Twy/NCTY7Z3qguKNn2evexJcUwTuOhb4MDZCF7yf51M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh1bZytrRoMcJbZNahXJVOoDfyONZuGV6StXUHFfvhrAGX/DfDa/yQdGqqiOMr4HdapkmLY/y9Sk6STAqBlRjDhCZYur3xq8PPr7++EsHaJ2Vl02usaFnITawVco2uzOdSPCetkyTscMEA48UFNtW8+p+y4Ecxu/nCQf4YO0NHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kpl83nMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kpl83nMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46708C433F1;
	Mon,  4 Mar 2024 21:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588813;
	bh=Twy/NCTY7Z3qguKNn2evexJcUwTuOhb4MDZCF7yf51M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kpl83nMhrqH63XW8R6BNuuX8k1JL02SO2AxSF5ErqvIVsqBY2lFDMtjF6HOwWl5l1
	 PHAiX+j+hdYy6GrX3XfS183bfdbxNYM2Wu7nOPu2rCVy/l2Wspq1rEsVNRXW+JKrGM
	 GLuaGw+LM68G3Ygnw2fqP6g+MFUJ5sK/5YvM4pmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Wei Chen <harperchen1110@gmail.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.1 107/215] RDMA/core: Refactor rdma_bind_addr
Date: Mon,  4 Mar 2024 21:22:50 +0000
Message-ID: <20240304211600.430007582@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

commit 8d037973d48c026224ab285e6a06985ccac6f7bf upstream.

Refactor rdma_bind_addr function so that it doesn't require that the
cma destination address be changed before calling it.

So now it will update the destination address internally only when it is
really needed and after passing all the required checks.

Which in turn results in a cleaner and more sensible call and error
handling flows for the functions that call it directly or indirectly.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/3d0e9a2fd62bc10ba02fed1c7c48a48638952320.1672819273.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/cma.c |  253 +++++++++++++++++++++---------------------
 1 file changed, 130 insertions(+), 123 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3547,121 +3547,6 @@ err:
 	return ret;
 }
 
-static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
-			 const struct sockaddr *dst_addr)
-{
-	struct sockaddr_storage zero_sock = {};
-
-	if (src_addr && src_addr->sa_family)
-		return rdma_bind_addr(id, src_addr);
-
-	/*
-	 * When the src_addr is not specified, automatically supply an any addr
-	 */
-	zero_sock.ss_family = dst_addr->sa_family;
-	if (IS_ENABLED(CONFIG_IPV6) && dst_addr->sa_family == AF_INET6) {
-		struct sockaddr_in6 *src_addr6 =
-			(struct sockaddr_in6 *)&zero_sock;
-		struct sockaddr_in6 *dst_addr6 =
-			(struct sockaddr_in6 *)dst_addr;
-
-		src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
-		if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
-			id->route.addr.dev_addr.bound_dev_if =
-				dst_addr6->sin6_scope_id;
-	} else if (dst_addr->sa_family == AF_IB) {
-		((struct sockaddr_ib *)&zero_sock)->sib_pkey =
-			((struct sockaddr_ib *)dst_addr)->sib_pkey;
-	}
-	return rdma_bind_addr(id, (struct sockaddr *)&zero_sock);
-}
-
-/*
- * If required, resolve the source address for bind and leave the id_priv in
- * state RDMA_CM_ADDR_BOUND. This oddly uses the state to determine the prior
- * calls made by ULP, a previously bound ID will not be re-bound and src_addr is
- * ignored.
- */
-static int resolve_prepare_src(struct rdma_id_private *id_priv,
-			       struct sockaddr *src_addr,
-			       const struct sockaddr *dst_addr)
-{
-	int ret;
-
-	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
-	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY)) {
-		/* For a well behaved ULP state will be RDMA_CM_IDLE */
-		ret = cma_bind_addr(&id_priv->id, src_addr, dst_addr);
-		if (ret)
-			goto err_dst;
-		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
-					   RDMA_CM_ADDR_QUERY))) {
-			ret = -EINVAL;
-			goto err_dst;
-		}
-	}
-
-	if (cma_family(id_priv) != dst_addr->sa_family) {
-		ret = -EINVAL;
-		goto err_state;
-	}
-	return 0;
-
-err_state:
-	cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY, RDMA_CM_ADDR_BOUND);
-err_dst:
-	memset(cma_dst_addr(id_priv), 0, rdma_addr_size(dst_addr));
-	return ret;
-}
-
-int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
-		      const struct sockaddr *dst_addr, unsigned long timeout_ms)
-{
-	struct rdma_id_private *id_priv =
-		container_of(id, struct rdma_id_private, id);
-	int ret;
-
-	ret = resolve_prepare_src(id_priv, src_addr, dst_addr);
-	if (ret)
-		return ret;
-
-	if (cma_any_addr(dst_addr)) {
-		ret = cma_resolve_loopback(id_priv);
-	} else {
-		if (dst_addr->sa_family == AF_IB) {
-			ret = cma_resolve_ib_addr(id_priv);
-		} else {
-			/*
-			 * The FSM can return back to RDMA_CM_ADDR_BOUND after
-			 * rdma_resolve_ip() is called, eg through the error
-			 * path in addr_handler(). If this happens the existing
-			 * request must be canceled before issuing a new one.
-			 * Since canceling a request is a bit slow and this
-			 * oddball path is rare, keep track once a request has
-			 * been issued. The track turns out to be a permanent
-			 * state since this is the only cancel as it is
-			 * immediately before rdma_resolve_ip().
-			 */
-			if (id_priv->used_resolve_ip)
-				rdma_addr_cancel(&id->route.addr.dev_addr);
-			else
-				id_priv->used_resolve_ip = 1;
-			ret = rdma_resolve_ip(cma_src_addr(id_priv), dst_addr,
-					      &id->route.addr.dev_addr,
-					      timeout_ms, addr_handler,
-					      false, id_priv);
-		}
-	}
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY, RDMA_CM_ADDR_BOUND);
-	return ret;
-}
-EXPORT_SYMBOL(rdma_resolve_addr);
-
 int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse)
 {
 	struct rdma_id_private *id_priv;
@@ -4064,27 +3949,26 @@ err:
 }
 EXPORT_SYMBOL(rdma_listen);
 
-int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
+static int rdma_bind_addr_dst(struct rdma_id_private *id_priv,
+			      struct sockaddr *addr, const struct sockaddr *daddr)
 {
-	struct rdma_id_private *id_priv;
+	struct sockaddr *id_daddr;
 	int ret;
-	struct sockaddr  *daddr;
 
 	if (addr->sa_family != AF_INET && addr->sa_family != AF_INET6 &&
 	    addr->sa_family != AF_IB)
 		return -EAFNOSUPPORT;
 
-	id_priv = container_of(id, struct rdma_id_private, id);
 	if (!cma_comp_exch(id_priv, RDMA_CM_IDLE, RDMA_CM_ADDR_BOUND))
 		return -EINVAL;
 
-	ret = cma_check_linklocal(&id->route.addr.dev_addr, addr);
+	ret = cma_check_linklocal(&id_priv->id.route.addr.dev_addr, addr);
 	if (ret)
 		goto err1;
 
 	memcpy(cma_src_addr(id_priv), addr, rdma_addr_size(addr));
 	if (!cma_any_addr(addr)) {
-		ret = cma_translate_addr(addr, &id->route.addr.dev_addr);
+		ret = cma_translate_addr(addr, &id_priv->id.route.addr.dev_addr);
 		if (ret)
 			goto err1;
 
@@ -4104,8 +3988,10 @@ int rdma_bind_addr(struct rdma_cm_id *id
 		}
 #endif
 	}
-	daddr = cma_dst_addr(id_priv);
-	daddr->sa_family = addr->sa_family;
+	id_daddr = cma_dst_addr(id_priv);
+	if (daddr != id_daddr)
+		memcpy(id_daddr, daddr, rdma_addr_size(addr));
+	id_daddr->sa_family = addr->sa_family;
 
 	ret = cma_get_port(id_priv);
 	if (ret)
@@ -4121,6 +4007,127 @@ err1:
 	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
 	return ret;
 }
+
+static int cma_bind_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
+			 const struct sockaddr *dst_addr)
+{
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
+	struct sockaddr_storage zero_sock = {};
+
+	if (src_addr && src_addr->sa_family)
+		return rdma_bind_addr_dst(id_priv, src_addr, dst_addr);
+
+	/*
+	 * When the src_addr is not specified, automatically supply an any addr
+	 */
+	zero_sock.ss_family = dst_addr->sa_family;
+	if (IS_ENABLED(CONFIG_IPV6) && dst_addr->sa_family == AF_INET6) {
+		struct sockaddr_in6 *src_addr6 =
+			(struct sockaddr_in6 *)&zero_sock;
+		struct sockaddr_in6 *dst_addr6 =
+			(struct sockaddr_in6 *)dst_addr;
+
+		src_addr6->sin6_scope_id = dst_addr6->sin6_scope_id;
+		if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
+			id->route.addr.dev_addr.bound_dev_if =
+				dst_addr6->sin6_scope_id;
+	} else if (dst_addr->sa_family == AF_IB) {
+		((struct sockaddr_ib *)&zero_sock)->sib_pkey =
+			((struct sockaddr_ib *)dst_addr)->sib_pkey;
+	}
+	return rdma_bind_addr_dst(id_priv, (struct sockaddr *)&zero_sock, dst_addr);
+}
+
+/*
+ * If required, resolve the source address for bind and leave the id_priv in
+ * state RDMA_CM_ADDR_BOUND. This oddly uses the state to determine the prior
+ * calls made by ULP, a previously bound ID will not be re-bound and src_addr is
+ * ignored.
+ */
+static int resolve_prepare_src(struct rdma_id_private *id_priv,
+			       struct sockaddr *src_addr,
+			       const struct sockaddr *dst_addr)
+{
+	int ret;
+
+	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY)) {
+		/* For a well behaved ULP state will be RDMA_CM_IDLE */
+		ret = cma_bind_addr(&id_priv->id, src_addr, dst_addr);
+		if (ret)
+			return ret;
+		if (WARN_ON(!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND,
+					   RDMA_CM_ADDR_QUERY)))
+			return -EINVAL;
+
+	}
+
+	if (cma_family(id_priv) != dst_addr->sa_family) {
+		ret = -EINVAL;
+		goto err_state;
+	}
+	return 0;
+
+err_state:
+	cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY, RDMA_CM_ADDR_BOUND);
+	return ret;
+}
+
+int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
+		      const struct sockaddr *dst_addr, unsigned long timeout_ms)
+{
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
+	int ret;
+
+	ret = resolve_prepare_src(id_priv, src_addr, dst_addr);
+	if (ret)
+		return ret;
+
+	if (cma_any_addr(dst_addr)) {
+		ret = cma_resolve_loopback(id_priv);
+	} else {
+		if (dst_addr->sa_family == AF_IB) {
+			ret = cma_resolve_ib_addr(id_priv);
+		} else {
+			/*
+			 * The FSM can return back to RDMA_CM_ADDR_BOUND after
+			 * rdma_resolve_ip() is called, eg through the error
+			 * path in addr_handler(). If this happens the existing
+			 * request must be canceled before issuing a new one.
+			 * Since canceling a request is a bit slow and this
+			 * oddball path is rare, keep track once a request has
+			 * been issued. The track turns out to be a permanent
+			 * state since this is the only cancel as it is
+			 * immediately before rdma_resolve_ip().
+			 */
+			if (id_priv->used_resolve_ip)
+				rdma_addr_cancel(&id->route.addr.dev_addr);
+			else
+				id_priv->used_resolve_ip = 1;
+			ret = rdma_resolve_ip(cma_src_addr(id_priv), dst_addr,
+					      &id->route.addr.dev_addr,
+					      timeout_ms, addr_handler,
+					      false, id_priv);
+		}
+	}
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	cma_comp_exch(id_priv, RDMA_CM_ADDR_QUERY, RDMA_CM_ADDR_BOUND);
+	return ret;
+}
+EXPORT_SYMBOL(rdma_resolve_addr);
+
+int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
+{
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
+
+	return rdma_bind_addr_dst(id_priv, addr, cma_dst_addr(id_priv));
+}
 EXPORT_SYMBOL(rdma_bind_addr);
 
 static int cma_format_hdr(void *hdr, struct rdma_id_private *id_priv)


