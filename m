Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042ED438FEE;
	Tue, 21 Jul 2026 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670276; cv=none; b=FRjXq6dS7hPBaVMbSAk8GtMukNq2ZJWN1yWIRuPZh05B0nV3uhIHdYcbsjT9YgOyjZ2jrNd6BJGFzKr0Oz1Lsx+gxt3BZYypeTvMcmD7qtmFj8pWevNjqKSHmdo4idxTYY7gE1sZ1tnSl2TXbLc/1AGzEGGr1gJkkhh+3AUFGcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670276; c=relaxed/simple;
	bh=69hWt2MV3TtlEkDoR56Xrsk23Gg2D/lgGyqTDUykkBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRH6YrILPE8zAaL5yb5N5GoMpanBa8WYNbuuG3SC9Wug8okKhZJOA1wZLzB8WjHDBZ4wm/bF3A3oFAfqqB+9u9WTK4KolUUillC4DfuWJLgPrsSiAZpOuyfutOzgMb8++7XtfOeUNfuuOoE3VENnxG9twIyKVIHEeWb9Vs6Dojk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f545FVZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f545FVZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695301F00A3A;
	Tue, 21 Jul 2026 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670274;
	bh=XcZmPcvoNH2yp2A2hPHQJDdpMipQ7vT/k5PBc0bEcE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f545FVZoNQcy5/yoyOtca7R0IipoTDQ5Yx0EiNRXpWaI8mJjB58FZtSvKJwTJY34H
	 fwe9WUGv6EFd5FMKL/jRjHGcNoeYpa21pITwsZoYOrUowqofr00C4BZEHsoxcLEmQJ
	 KJiJriDLp1t6yLGV+N8HunexHC0rf/np43PSUGcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0870/1067] net/mlx5e: macsec: fix use-after-free of metadata_dst on RX SC delete
Date: Tue, 21 Jul 2026 17:24:31 +0200
Message-ID: <20260721152443.997956973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit de74d8fd10291763d97b218f09adcc7513c975e4 upstream.

When an offloaded MACsec RX SC is deleted, macsec_del_rxsc_ctx() freed
the per-SC metadata_dst with metadata_dst_free(), which kfree()s the
object unconditionally and ignores the dst reference count. The RX
datapath in mlx5e_macsec_offload_handle_rx_skb() looks up the SC under
rcu_read_lock() via xa_load(), takes a reference with dst_hold() and
attaches the dst to the skb with skb_dst_set(). A reader that already
obtained the rx_sc pointer can race with the delete path and operate on
freed memory.

Fix the owner side by dropping the reference with dst_release() instead
of freeing unconditionally, and convert the RX datapath to
dst_hold_safe() so a reader racing the SC delete cannot attach a dst
whose last reference was just dropped; only attach it when a reference
was actually taken.

mlx5e_macsec_add_rxsc() also published sc_xarray_element via xa_alloc()
before rx_sc->md_dst was allocated and initialised, so a datapath reader
that looked the SC up by fs_id could observe rx_sc with md_dst still
NULL or, on weakly-ordered architectures, a non-NULL md_dst pointer
whose contents were not yet visible. NULL-check the xa_load() result and
md_dst on the datapath, and reorder add_rxsc() so the xa_alloc() publish
happens only after md_dst is fully initialised; the xarray RCU publish
then pairs with the rcu_read_lock()/xa_load() in the datapath.

Note: macsec_del_rxsc_ctx() also kfree()s rx_sc->sc_xarray_element
without an RCU grace period while the same datapath reads it under
rcu_read_lock(); that is a separate pre-existing issue left to a
follow-up patch.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260627223059.29917-1-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c |   47 ++++++++------
 1 file changed, 28 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -735,34 +735,43 @@ static int mlx5e_macsec_add_rxsc(struct
 	}
 
 	sc_xarray_element->rx_sc = rx_sc;
-	err = xa_alloc(&macsec->sc_xarray, &sc_xarray_element->fs_id, sc_xarray_element,
-		       XA_LIMIT(1, MLX5_MACEC_RX_FS_ID_MAX), GFP_KERNEL);
-	if (err) {
-		if (err == -EBUSY)
-			netdev_err(ctx->netdev,
-				   "MACsec offload: unable to create entry for RX SC (%d Rx SCs already allocated)\n",
-				   MLX5_MACEC_RX_FS_ID_MAX);
-		goto destroy_sc_xarray_elemenet;
-	}
 
 	rx_sc->md_dst = metadata_dst_alloc(0, METADATA_MACSEC, GFP_KERNEL);
 	if (!rx_sc->md_dst) {
 		err = -ENOMEM;
-		goto erase_xa_alloc;
+		goto destroy_sc_xarray_elemenet;
 	}
 
 	rx_sc->sci = ctx_rx_sc->sci;
 	rx_sc->active = ctx_rx_sc->active;
-	list_add_rcu(&rx_sc->rx_sc_list_element, rx_sc_list);
-
 	rx_sc->sc_xarray_element = sc_xarray_element;
 	rx_sc->md_dst->u.macsec_info.sci = rx_sc->sci;
+
+	/*
+	 * Publish the fully-initialised SC last: xa_alloc() makes
+	 * sc_xarray_element->rx_sc (and rx_sc->md_dst) reachable from the RX
+	 * datapath via xa_load().  Doing it only after md_dst is allocated and
+	 * initialised pairs with the rcu_read_lock()/xa_load() in
+	 * mlx5e_macsec_offload_handle_rx_skb(), so a reader can never observe
+	 * a non-NULL md_dst with uninitialised contents.
+	 */
+	err = xa_alloc(&macsec->sc_xarray, &sc_xarray_element->fs_id, sc_xarray_element,
+		       XA_LIMIT(1, MLX5_MACEC_RX_FS_ID_MAX), GFP_KERNEL);
+	if (err) {
+		if (err == -EBUSY)
+			netdev_err(ctx->netdev,
+				   "MACsec offload: unable to create entry for RX SC (%d Rx SCs already allocated)\n",
+				   MLX5_MACEC_RX_FS_ID_MAX);
+		goto destroy_md_dst;
+	}
+
+	list_add_rcu(&rx_sc->rx_sc_list_element, rx_sc_list);
 	mutex_unlock(&macsec->lock);
 
 	return 0;
 
-erase_xa_alloc:
-	xa_erase(&macsec->sc_xarray, sc_xarray_element->fs_id);
+destroy_md_dst:
+	dst_release(&rx_sc->md_dst->dst);
 destroy_sc_xarray_elemenet:
 	kfree(sc_xarray_element);
 destroy_rx_sc:
@@ -847,7 +856,7 @@ static void macsec_del_rxsc_ctx(struct m
 	 */
 	list_del_rcu(&rx_sc->rx_sc_list_element);
 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
-	metadata_dst_free(rx_sc->md_dst);
+	dst_release(&rx_sc->md_dst->dst);
 	kfree(rx_sc->sc_xarray_element);
 	kfree_rcu(rx_sc);
 }
@@ -1755,10 +1764,10 @@ void mlx5e_macsec_offload_handle_rx_skb(
 
 	rcu_read_lock();
 	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
-	rx_sc = sc_xarray_element->rx_sc;
-	if (rx_sc) {
-		dst_hold(&rx_sc->md_dst->dst);
-		skb_dst_set(skb, &rx_sc->md_dst->dst);
+	rx_sc = sc_xarray_element ? sc_xarray_element->rx_sc : NULL;
+	if (rx_sc && rx_sc->md_dst) {
+		if (dst_hold_safe(&rx_sc->md_dst->dst))
+			skb_dst_set(skb, &rx_sc->md_dst->dst);
 	}
 
 	rcu_read_unlock();


