Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D617926B2B8;
	Tue, 25 Mar 2025 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906282; cv=none; b=l5TROLuByo7O77qdU+eYvFcNRxTAPPsyFglvRCxTKFRxyf8rk/xxRdriqg6fcau5uADV64ArHvlhhzB6/iEuak2yy08Uho85QtdPTyZgqXsXssctv/Rwaw97W6pKbPzlzgGESQ138rYZ8auGg0laMnZJzJW++blNCyrvgheDZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906282; c=relaxed/simple;
	bh=v3ehHMb8XhLDxt8bCukdHv6g3GLaqZnjfnRCLyaEZFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p50Wk7XrZsI3uAYSSRvnqe/hKlfaWAVxQfD3IFjGcXqvihRaBs8E6a/HWi1dwSfF6II8V9/jsAIO8HhXdHSfP+v6qMMHXL8sH1fmzYDwWl5iIY3hAF8sfrCGWslYIoKgCawg+r5I0niqoLYwfX3GrY8ouOuTLy6RVR31JqvYdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqmLeR9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqmLeR9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897E1C4CEE4;
	Tue, 25 Mar 2025 12:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906282;
	bh=v3ehHMb8XhLDxt8bCukdHv6g3GLaqZnjfnRCLyaEZFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqmLeR9VxRNVKPwImEcXHM6wWgO6crZFnhYaRj7uHjQNNAbT/F5HDRSpcIh0++XM4
	 rlHIn2ysU+QU0HWezQV3HHzJZ7onSHNth2KuW2cx59Y9acl1q11WzraVLTAtUp2own
	 vCtq9b8mcBrQZQsR+0CzT1MAtv7f7wKBY1i/jRZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/116] xfrm: fix tunnel mode TX datapath in packet offload mode
Date: Tue, 25 Mar 2025 08:21:33 -0400
Message-ID: <20250325122149.373341236@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit 5eddd76ec2fd1988f0a3450fde9730b10dd22992 ]

Packets that match the output xfrm policy are delivered to the netstack.
In IPsec packet mode for tunnel mode, the HW is responsible for building
the hard header and outer IP header. In such a situation, the inner
header may refer to a network that is not directly reachable by the host,
resulting in a failed neighbor resolution. The packet is then dropped.
xfrm policy defines the netdevice to use for xmit so we can send packets
directly to it.

Makes direct xmit exclusive to tunnel mode, since some rules may apply
in transport mode.

Fixes: f8a70afafc17 ("xfrm: add TX datapath support for IPsec packet offload mode")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index e5722c95b8bb3..9160a5e09041d 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -610,6 +610,40 @@ int xfrm_output_resume(struct sock *sk, struct sk_buff *skb, int err)
 }
 EXPORT_SYMBOL_GPL(xfrm_output_resume);
 
+static int xfrm_dev_direct_output(struct sock *sk, struct xfrm_state *x,
+				  struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct net *net = xs_net(x);
+	int err;
+
+	dst = skb_dst_pop(skb);
+	if (!dst) {
+		XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+		kfree_skb(skb);
+		return -EHOSTUNREACH;
+	}
+	skb_dst_set(skb, dst);
+	nf_reset_ct(skb);
+
+	err = skb_dst(skb)->ops->local_out(net, sk, skb);
+	if (unlikely(err != 1)) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	/* In transport mode, network destination is
+	 * directly reachable, while in tunnel mode,
+	 * inner packet network may not be. In packet
+	 * offload type, HW is responsible for hard
+	 * header packet mangling so directly xmit skb
+	 * to netdevice.
+	 */
+	skb->dev = x->xso.dev;
+	__skb_push(skb, skb->dev->hard_header_len);
+	return dev_queue_xmit(skb);
+}
+
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	return xfrm_output_resume(sk, skb, 1);
@@ -729,6 +763,13 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 			return -EHOSTUNREACH;
 		}
 
+		/* Exclusive direct xmit for tunnel mode, as
+		 * some filtering or matching rules may apply
+		 * in transport mode.
+		 */
+		if (x->props.mode == XFRM_MODE_TUNNEL)
+			return xfrm_dev_direct_output(sk, x, skb);
+
 		return xfrm_output_resume(sk, skb, 0);
 	}
 
-- 
2.39.5



