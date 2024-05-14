Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685BD433BE;
	Tue, 14 May 2024 10:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682425; cv=none; b=BY9Le8TOFpgobYlH/n/rjdTXQeolfze1XI/oO1FdfSiStMcoS+5KB0qalzBkPwbYPUVXOFRulP1y9pMuSEExRMcA26elxMFcPv4MoPaDe+bkwcIArLUoCvnSr9VgI+DIWPxZpbHaDGDEQngAk6l6BuzJjtVOlo9+cxNDuC6+KTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682425; c=relaxed/simple;
	bh=Ga/kIGUXi1Vy4sdE26+NePyAjvGoomJszz0GX5BDyN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYvEUOdPtw+TTKvHYCYO5N7xKKmjLDdRM2bWMA2Ydks4ofjGyyJgTc0C58fjdNIAuJBnqNpYglZVkX/XRQg6ENON1MVAQq+Q8388FS4kaQ1jqH3bDvdkgXrB5EPGnbesh3ScpnIC4GliUOC6YT7bV4NbRkVf7Rqny4q9Wc1nUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahVF30lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahVF30lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15008C2BD10;
	Tue, 14 May 2024 10:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682425;
	bh=Ga/kIGUXi1Vy4sdE26+NePyAjvGoomJszz0GX5BDyN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahVF30lbauWCjQHSK8myHKzrrDcL2GbhNbgxr+o4MTy5uiDim8HjmpVmY7H9X1xpT
	 yYmYv4k3vfJF5UcqxgwpbqjYYT9oJ1w8m4dky1c1jMsY0eLOUpbWvUoiC+Z731BeFi
	 Db11iTtLXDQw+joMZ8VJ3omGqW7di+uBbb68pWfQ=
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
Subject: [PATCH 6.8 041/336] xdp: use flags field to disambiguate broadcast redirect
Date: Tue, 14 May 2024 12:14:05 +0200
Message-ID: <20240514101040.160185765@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index ef3e78b6a39c4..75cdaa16046bb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4360,10 +4360,12 @@ static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
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
@@ -4375,11 +4377,20 @@ static __always_inline int __xdp_do_redirect_frame(struct bpf_redirect_info *ri,
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
@@ -4442,9 +4453,9 @@ EXPORT_SYMBOL_GPL(xdp_do_redirect_frame);
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
@@ -4454,11 +4465,20 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
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
@@ -4495,9 +4515,11 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 	enum bpf_map_type map_type = ri->map_type;
 	void *fwd = ri->tgt_value;
 	u32 map_id = ri->map_id;
+	u32 flags = ri->flags;
 	int err;
 
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
+	ri->flags = 0;
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
 	if (map_type == BPF_MAP_TYPE_UNSPEC && map_id == INT_MAX) {
@@ -4517,7 +4539,7 @@ int xdp_do_generic_redirect(struct net_device *dev, struct sk_buff *skb,
 		return 0;
 	}
 
-	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id);
+	return xdp_do_generic_redirect_map(dev, skb, xdp, xdp_prog, fwd, map_type, map_id, flags);
 err:
 	_trace_xdp_redirect_err(dev, xdp_prog, ri->tgt_index, err);
 	return err;
-- 
2.43.0



