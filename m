Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DA3B9616;
	Sat, 17 Oct 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258974; cv=none; b=kkM19zU2zIHbfNqc7rasd+X6/l/939sOBZBHdINWJuXJn08uQNWjrs8BSW2IOOWqRkq084NByH6pl9jOjXMqfrGIcDxVtPjOnBDVmEB5vZHuMzAicytOhB+ywcB8zMe3TfTKEVePuveIi/oCoi+PtmbQA+cf3WFXUxbWNHoLBAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258974; c=relaxed/simple;
	bh=zAcNSF9NXfYRdVLYuA651wLj1YveIAbUesA3p0dzfkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZi2NvZ2+UShxdkdBSRJtIT4MzoZoT/TqJS4Kow/NwONKs4OlzgxF0zEX9z3Syp197jpxFFFIa/bb4HFU+EmcgQRqgJKQzXWsO9aXp1Q43HgLzHc0Gi2qawePhsSAAK0NCuvioTPeTEYAY7ZCDBjmTzEkKrGysyo1rdHdfPHnXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCyduE1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCyduE1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606181F000C4;
	Sat, 17 Oct 2026 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258972;
	bh=L7ZW1L3kMLvIXx2XJ3hJ+1FddkEVjq+j2WIovfWvCug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCyduE1c11x1PW20nVICJ1pq3tEgd7MbpsfudILMmDGgHvLo2BU3xEiWvJ1vQk1YV
	 S9KGjJ7rlXBVIxN2uhRXsByRr5ibjHIsGpOi5KfARZPuABprONwmdaw1hoIhHLNMt+
	 LQHRNuvGtnTktvQOxTdLkXvudZ0wfTktsKMUolQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	netdev@vger.kernel.org,
	Willem de Bruijn <willemb@google.com>,
	Stanislav Fomichev <sdf@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1019/1674] bpf: make it easier to add new metadata kfunc
Date: Sat, 17 Oct 2026 17:54:51 +0200
Message-ID: <20261017160457.287623687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit fc45c5b642dbcac3bb10f4f904e4b863233e5369 ]

No functional changes.

Instead of having hand-crafted code in bpf_dev_bound_resolve_kfunc,
move kfunc <> xmo handler relationship into XDP_METADATA_KFUNC_xxx.
This way, any time new kfunc is added, we don't have to touch
bpf_dev_bound_resolve_kfunc.

Also document XDP_METADATA_KFUNC_xxx arguments since we now have
more than two and it might be confusing what is what.

Cc: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20230913171350.369987-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: b69004f5a6ad ("net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp.h    | 16 ++++++++++++----
 kernel/bpf/offload.c |  9 +++++----
 net/core/xdp.c       |  4 ++--
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3d8989096b5d2..59c12ca580396 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -388,14 +388,22 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
+/* Define the relationship between xdp-rx-metadata kfunc and
+ * various other entities:
+ * - xdp_rx_metadata enum
+ * - kfunc name
+ * - xdp_metadata_ops field
+ */
 #define XDP_METADATA_KFUNC_xxx	\
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
-			   bpf_xdp_metadata_rx_timestamp) \
+			   bpf_xdp_metadata_rx_timestamp, \
+			   xmo_rx_timestamp) \
 	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
-			   bpf_xdp_metadata_rx_hash) \
+			   bpf_xdp_metadata_rx_hash, \
+			   xmo_rx_hash) \
 
-enum {
-#define XDP_METADATA_KFUNC(name, _) name,
+enum xdp_rx_metadata {
+#define XDP_METADATA_KFUNC(name, _, __) name,
 XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 MAX_XDP_METADATA_KFUNC,
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 3345de2da15dd..ae0c8e7894586 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -847,10 +847,11 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
 	if (!ops)
 		goto out;
 
-	if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
-		p = ops->xmo_rx_timestamp;
-	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
-		p = ops->xmo_rx_hash;
+#define XDP_METADATA_KFUNC(name, _, xmo) \
+	if (func_id == bpf_xdp_metadata_kfunc_id(name)) p = ops->xmo;
+	XDP_METADATA_KFUNC_xxx
+#undef XDP_METADATA_KFUNC
+
 out:
 	up_read(&bpf_devs_lock);
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 672d971ce4eac..0b312aa7adf5e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -737,7 +737,7 @@ __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
 __diag_pop();
 
 BTF_SET8_START(xdp_metadata_kfunc_ids)
-#define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, KF_TRUSTED_ARGS)
+#define XDP_METADATA_KFUNC(_, name, __) BTF_ID_FLAGS(func, name, KF_TRUSTED_ARGS)
 XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
@@ -748,7 +748,7 @@ static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
 };
 
 BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
-#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
+#define XDP_METADATA_KFUNC(name, str, _) BTF_ID(func, str)
 XDP_METADATA_KFUNC_xxx
 #undef XDP_METADATA_KFUNC
 
-- 
2.53.0



