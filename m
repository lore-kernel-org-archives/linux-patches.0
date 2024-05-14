Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639BA1CFB2;
	Tue, 14 May 2024 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687572; cv=none; b=REp8AX8cRGOVmoJ+9MKQVwZYSaLGwtiZPqB4Jk4XkD7wXuwbXIUh4ihcQ3XXUWISLKrOkuIqV30bSjxoEligjsRJwOFUTWU7nFVy8NpUSLjykmgRSU7yfdywQITFdkuVNWfpApm7mwDyFALv7iTv99JsGAkwgmACtBG66ivyEIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687572; c=relaxed/simple;
	bh=le+XP8FyJC1Sace4F9vh040h9KzAGpY4jGZNTZddwlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLYWTn1A4Qn605b7yCVyUO9A/raA+gYKvQeljDt3CB1zxpan8h8j94WCWs6GZR4xocxTBVUyZvaEPn074uNF22O/U5fIK2JAVnx/Lrz5F+j7Op/OklzweZnJB0FgFUqzbt5V0sRbskrTpFZ2r16tu4KbzVHlKYqChL01nXijXsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPtnP5a8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPtnP5a8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE640C2BD10;
	Tue, 14 May 2024 11:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687572;
	bh=le+XP8FyJC1Sace4F9vh040h9KzAGpY4jGZNTZddwlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPtnP5a8hRoBAO+ol5QSXP7FAcNbJ+XemUsx+2N0ToBm/dE/poyA4O8ZRMj/kh9eA
	 bOQhgLflFyZOKojLMPT97ruj+8ko2srqI7CSLlAfs8KLJ73PUj2JeE+U3Ox+wgJpV9
	 Gu7xfmmeo4IkS49J3ipk3aeySj49ebRSi/qo+5r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/168] xdp: Move conversion to xdp_frame out of map functions
Date: Tue, 14 May 2024 12:18:48 +0200
Message-ID: <20240514101007.828358275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit d53ad5d8b218a885e95080d4d3d556b16b91b1b9 ]

All map redirect functions except XSK maps convert xdp_buff to xdp_frame
before enqueueing it. So move this conversion of out the map functions
and into xdp_do_redirect(). This removes a bit of duplicated code, but more
importantly it makes it possible to support caller-allocated xdp_frame
structures, which will be added in a subsequent commit.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220103150812.87914-5-toke@redhat.com
Stable-dep-of: 5bcf0dcbf906 ("xdp: use flags field to disambiguate broadcast redirect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 20 ++++++++++----------
 kernel/bpf/cpumap.c |  8 +-------
 kernel/bpf/devmap.c | 32 +++++++++++---------------------
 net/core/filter.c   | 24 +++++++++++++++++-------
 4 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 74a26cabc084e..4236de05a8e70 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1651,17 +1651,17 @@ void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
 struct btf *bpf_get_btf_vmlinux(void);
 
 /* Map specifics */
-struct xdp_buff;
+struct xdp_frame;
 struct sk_buff;
 struct bpf_dtab_netdev;
 struct bpf_cpu_map_entry;
 
 void __dev_flush(void);
-int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+int dev_xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx);
-int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
+int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx);
-int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+int dev_map_enqueue_multi(struct xdp_frame *xdpf, struct net_device *dev_rx,
 			  struct bpf_map *map, bool exclude_ingress);
 int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
 			     struct bpf_prog *xdp_prog);
@@ -1670,7 +1670,7 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 			   bool exclude_ingress);
 
 void __cpu_map_flush(void);
-int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
+int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx);
 int cpu_map_generic_redirect(struct bpf_cpu_map_entry *rcpu,
 			     struct sk_buff *skb);
@@ -1823,26 +1823,26 @@ static inline void __dev_flush(void)
 {
 }
 
-struct xdp_buff;
+struct xdp_frame;
 struct bpf_dtab_netdev;
 struct bpf_cpu_map_entry;
 
 static inline
-int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+int dev_xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx)
 {
 	return 0;
 }
 
 static inline
-int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
+int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx)
 {
 	return 0;
 }
 
 static inline
-int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+int dev_map_enqueue_multi(struct xdp_frame *xdpf, struct net_device *dev_rx,
 			  struct bpf_map *map, bool exclude_ingress)
 {
 	return 0;
@@ -1870,7 +1870,7 @@ static inline void __cpu_map_flush(void)
 }
 
 static inline int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu,
-				  struct xdp_buff *xdp,
+				  struct xdp_frame *xdpf,
 				  struct net_device *dev_rx)
 {
 	return 0;
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index a8429cfb4ae8c..0848d5691fd15 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -764,15 +764,9 @@ static void bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 		list_add(&bq->flush_node, flush_list);
 }
 
-int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
+int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx)
 {
-	struct xdp_frame *xdpf;
-
-	xdpf = xdp_convert_buff_to_frame(xdp);
-	if (unlikely(!xdpf))
-		return -EOVERFLOW;
-
 	/* Info needed when constructing SKB on remote CPU */
 	xdpf->dev_rx = dev_rx;
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index b591073c5f83d..bbf3ec03aa591 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -468,24 +468,19 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 	bq->q[bq->count++] = xdpf;
 }
 
-static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+static inline int __xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 				struct net_device *dev_rx,
 				struct bpf_prog *xdp_prog)
 {
-	struct xdp_frame *xdpf;
 	int err;
 
 	if (!dev->netdev_ops->ndo_xdp_xmit)
 		return -EOPNOTSUPP;
 
-	err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
+	err = xdp_ok_fwd_dev(dev, xdpf->len);
 	if (unlikely(err))
 		return err;
 
-	xdpf = xdp_convert_buff_to_frame(xdp);
-	if (unlikely(!xdpf))
-		return -EOVERFLOW;
-
 	bq_enqueue(dev, xdpf, dev_rx, xdp_prog);
 	return 0;
 }
@@ -521,27 +516,27 @@ static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_dtab_netdev
 	return act;
 }
 
-int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
+int dev_xdp_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx)
 {
-	return __xdp_enqueue(dev, xdp, dev_rx, NULL);
+	return __xdp_enqueue(dev, xdpf, dev_rx, NULL);
 }
 
-int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
+int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_frame *xdpf,
 		    struct net_device *dev_rx)
 {
 	struct net_device *dev = dst->dev;
 
-	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
+	return __xdp_enqueue(dev, xdpf, dev_rx, dst->xdp_prog);
 }
 
-static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp)
+static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_frame *xdpf)
 {
 	if (!obj ||
 	    !obj->dev->netdev_ops->ndo_xdp_xmit)
 		return false;
 
-	if (xdp_ok_fwd_dev(obj->dev, xdp->data_end - xdp->data))
+	if (xdp_ok_fwd_dev(obj->dev, xdpf->len))
 		return false;
 
 	return true;
@@ -587,14 +582,13 @@ static int get_upper_ifindexes(struct net_device *dev, int *indexes)
 	return n;
 }
 
-int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
+int dev_map_enqueue_multi(struct xdp_frame *xdpf, struct net_device *dev_rx,
 			  struct bpf_map *map, bool exclude_ingress)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
 	int excluded_devices[1+MAX_NEST_DEV];
 	struct hlist_head *head;
-	struct xdp_frame *xdpf;
 	int num_excluded = 0;
 	unsigned int i;
 	int err;
@@ -604,15 +598,11 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 		excluded_devices[num_excluded++] = dev_rx->ifindex;
 	}
 
-	xdpf = xdp_convert_buff_to_frame(xdp);
-	if (unlikely(!xdpf))
-		return -EOVERFLOW;
-
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = rcu_dereference_check(dtab->netdev_map[i],
 						    rcu_read_lock_bh_held());
-			if (!is_valid_dst(dst, xdp))
+			if (!is_valid_dst(dst, xdpf))
 				continue;
 
 			if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
@@ -635,7 +625,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_rcu(dst, head, index_hlist,
 						 lockdep_is_held(&dtab->index_lock)) {
-				if (!is_valid_dst(dst, xdp))
+				if (!is_valid_dst(dst, xdpf))
 					continue;
 
 				if (is_ifindex_excluded(excluded_devices, num_excluded,
diff --git a/net/core/filter.c b/net/core/filter.c
index 457d1a164ad5d..96441da61fca8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3994,12 +3994,24 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	struct xdp_frame *xdpf;
 	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
+	if (map_type == BPF_MAP_TYPE_XSKMAP) {
+		err = __xsk_map_redirect(fwd, xdp);
+		goto out;
+	}
+
+	xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!xdpf)) {
+		err = -EOVERFLOW;
+		goto err;
+	}
+
 	switch (map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
@@ -4007,17 +4019,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		map = READ_ONCE(ri->map);
 		if (unlikely(map)) {
 			WRITE_ONCE(ri->map, NULL);
-			err = dev_map_enqueue_multi(xdp, dev, map,
+			err = dev_map_enqueue_multi(xdpf, dev, map,
 						    ri->flags & BPF_F_EXCLUDE_INGRESS);
 		} else {
-			err = dev_map_enqueue(fwd, xdp, dev);
+			err = dev_map_enqueue(fwd, xdpf, dev);
 		}
 		break;
 	case BPF_MAP_TYPE_CPUMAP:
-		err = cpu_map_enqueue(fwd, xdp, dev);
-		break;
-	case BPF_MAP_TYPE_XSKMAP:
-		err = __xsk_map_redirect(fwd, xdp);
+		err = cpu_map_enqueue(fwd, xdpf, dev);
 		break;
 	case BPF_MAP_TYPE_UNSPEC:
 		if (map_id == INT_MAX) {
@@ -4026,7 +4035,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 				err = -EINVAL;
 				break;
 			}
-			err = dev_xdp_enqueue(fwd, xdp, dev);
+			err = dev_xdp_enqueue(fwd, xdpf, dev);
 			break;
 		}
 		fallthrough;
@@ -4034,6 +4043,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		err = -EBADRQC;
 	}
 
+out:
 	if (unlikely(err))
 		goto err;
 
-- 
2.43.0



