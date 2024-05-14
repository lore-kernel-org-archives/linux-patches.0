Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A415A0FC;
	Tue, 14 May 2024 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686203; cv=none; b=Ymv+KMZeHdbjq9R35TSqxG4b2BkSFP8IeogkHciPkBO/T1PtYAvLe8fjn7VcD32pNIa83C/yTtLBaSyhfy7MGTqJE5aFex/q60WBO2U58VhQfm/EArydcEICL/BG0CgF5u98wbIp3eGjQGvSOXobS7bUvtHGOff+S4d6To2S/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686203; c=relaxed/simple;
	bh=+buPb/TuhtQTIaZL2rXG/9mAypLsJfSG94RH4HY+V2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFSf9eLCNfjFp+9baywxCXf/ZMHlugwQJwwdLvRvmq/ZyjvufGLozgLCyT/oZwAVG50b9Yvu9I7lz82rg9fj0qGpY6NihfbMIGEq5BLaEmkq+c6aP5Wk3fWNNFreAXysfKjaI6vl8PFLskyxiRmQEJwwZh1EO39k4dfy2YU7pH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyAPQroG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyAPQroG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AD9C2BD10;
	Tue, 14 May 2024 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686202;
	bh=+buPb/TuhtQTIaZL2rXG/9mAypLsJfSG94RH4HY+V2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyAPQroGgZiQNveHBY8+tAZK86f6mKpvXC4+tjInlcyOZDB14s0Q5sr5LOvnV6pMc
	 zhI95205T1I1HA2Y5r6najVTvox2DqBWkIbLtaMNMcLe9iD6cNFdsRd3b9X7FmELQF
	 VE6PqBU99WD1D/hp0kbEf15UsKmeQm2pTtkT5pAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Stanislav Fomichev <sdf@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+af9492708df9797198d6@syzkaller.appspotmail.com
Subject: [PATCH 6.1 057/236] xdp: use flags field to disambiguate broadcast redirect
Date: Tue, 14 May 2024 12:16:59 +0200
Message-ID: <20240514101022.519714150@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 5bcf0dcbf9066348058b88a510c57f70f384c92c ]

When redirecting a packet using XDP, the bpf_redirect_map() helper will set
up the redirect destination information in struct bpf_redirect_info (using
the __bpf_xdp_redirect_map() helper function), and the xdp_do_redirect()
function will read this information after the XDP program returns and pass
the frame on to the right redirect destination.

When using the BPF_F_BROADCAST flag to do multicast redirect to a whole
map, __bpf_xdp_redirect_map() sets the 'map' pointer in struct
bpf_redirect_info to point to the destination map to be broadcast. And
xdp_do_redirect() reacts to the value of this map pointer to decide whether
it's dealing with a broadcast or a single-value redirect. However, if the
destination map is being destroyed before xdp_do_redirect() is called, the
map pointer will be cleared out (by bpf_clear_redirect_map()) without
waiting for any XDP programs to stop running. This causes xdp_do_redirect()
to think that the redirect was to a single target, but the target pointer
is also NULL (since broadcast redirects don't have a single target), so
this causes a crash when a NULL pointer is passed to dev_map_enqueue().

To fix this, change xdp_do_redirect() to react directly to the presence of
the BPF_F_BROADCAST flag in the 'flags' value in struct bpf_redirect_info
to disambiguate between a single-target and a broadcast redirect. And only
read the 'map' pointer if the broadcast flag is set, aborting if that has
been cleared out in the meantime. This prevents the crash, while keeping
the atomic (cmpxchg-based) clearing of the map pointer itself, and without
adding any more checks in the non-broadcast fast path.

Fixes: e624d4ed4aa8 ("xdp: Extend xdp_redirect_map with broadcast support")
Reported-and-tested-by: syzbot+af9492708df9797198d6@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://lore.kernel.org/r/20240418071840.156411-1-toke@redhat.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index cb7c4651eaec8..1d8b271ef8cc2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4244,10 +4244,12 @@ static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	u32 flags = ri->flags;
 	struct bpf_map *map;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->flags = 0;
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
 	if (unlikely(!xdpf)) {
@@ -4259,11 +4261,20 @@ static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		map = READ_ONCE(ri->map);
-		if (unlikely(map)) {
+		if (unlikely(flags & BPF_F_BROADCAST)) {
+			map = READ_ONCE(ri->map);
+
+			/* The map pointer is cleared when the map is being torn
+			 * down by bpf_clear_redirect_map()
+			 */
+			if (unlikely(!map)) {
+				err = -ENOENT;
+				break;
+			}
+
 			WRITE_ONCE(ri->map, NULL);
 			err = dev_map_enqueue_multi(xdpf, dev, map,
-						    ri->flags & BPF_F_EXCLUDE_INGRESS);
+						    flags & BPF_F_EXCLUDE_INGRESS);
 		} else {
 			err = dev_map_enqueue(fwd, xdpf, dev);
 		}
@@ -4334,9 +4345,9 @@ EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
 static int xdp_do_generic_redirect_map(struct net_device *dev,
 				       struct sk_buff *skb,
 				       struct xdp_buff *xdp,
-				       struct bpf_prog *xdp_prog,
-				       void *fwd,
-				       enum bpf_map_type map_type, u32 map_id)
+				       struct bpf_prog *xdp_prog, void *fwd,
+				       enum bpf_map_type map_type, u32 map_id,
+				       u32 flags)
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	struct bpf_map *map;
@@ -4346,11 +4357,20 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
 	case BPF_MAP_TYPE_DEVMAP:
 		fallthrough;
 	case BPF_MAP_TYPE_DEVMAP_HASH:
-		map = READ_ONCE(ri->map);
-		if (unlikely(map)) {
+		if (unlikely(flags & BPF_F_BROADCAST)) {
+			map = READ_ONCE(ri->map);
+
+			/* The map pointer is cleared when the map is being torn
+			 * down by bpf_clear_redirect_map()
+			 */
+			if (unlikely(!map)) {
+				err = -ENOENT;
+				break;
+			}
+
 			WRITE_ONCE(ri->map, NULL);
 			err = dev_map_redirect_multi(dev, skb, xdp_prog, map,
-						     ri->flags & BPF_F_EXCLUDE_INGRESS);
+						     flags & BPF_F_EXCLUDE_INGRESS);
 		} else {
 			err = dev_map_generic_redirect(fwd, skb, xdp_prog);
 		}
@@ -4387,9 +4407,11 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	u32 flags = ri->flags;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->flags = 0;
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
 	if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
@@ -4409,7 +4431,7 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 		return 0;
 	}
 
-	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id);
+	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id, flags);
 err:
 	_trace_xdp_redirect_err(dev, xdp_prog, ri->tgt_index, err);
 	return err;
-- 
2.43.0



