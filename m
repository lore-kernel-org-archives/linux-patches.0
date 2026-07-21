Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C73442FD8;
	Tue, 21 Jul 2026 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668403; cv=none; b=Iq8DtFjS4LZt7FArAiZHc87BKFwgZykUmRT2eZTnDRZh6Yo7z/j3Irm23IM9g1QZc68ozen1VKNhDXmUS7AyE31QM5xNdUcW5A/He8rOnOpuM6EHV10GzZHYsKyP5nkHyLDf5je1YsqMAn1tQu3VhQrcFChFeOVv892lvcjKePA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668403; c=relaxed/simple;
	bh=flVsfTdbc8jPkjsKu9tpp8IPvrhuPyEaY8L32dNpjx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ku0aseZIIf16MMOWQgkblMK3Zj5GEC1BwSNtTFQ2IEL0xOCfvfoLqfRMqV7qfZ0wSmg1u6Y/zACyEIWqDQtMDMr/8W/NnDES8pjDjIuj8kzNVFGHC9lI/Igk/XVj0RFPqVZ8UKWV6lVcBen243BIdg+pxDqRBCT5WaQnQHjJ1Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymCV83dP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymCV83dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7611F00A3A;
	Tue, 21 Jul 2026 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668401;
	bh=5DygzXW4lZUEydJy+JtqLxa0rVIeHFEO4c16kPE+ZKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymCV83dPiFbrIp9cONaOoMUIRmDX3D3Bd5CjegWHoculKWopIN76j98F4gDrwL/q2
	 ChBW/oRsSPrNxzu2KYvoCDPgDLbq2Ik8+lA3O11TYLKv5CTwYcT+he2ahjcUlZQ709
	 yQ37/cXjLcwY036alngGF/dUk6D6ZMCgzHFCqEzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhao Zhang <zzhan461@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.1 0163/1067] bpf: Reject fragmented frames in devmap
Date: Tue, 21 Jul 2026 17:12:44 +0200
Message-ID: <20260721152428.236138708@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Zhang <zzhan461@ucr.edu>

commit aa496720618f1a6054f1c870bf10b4f6c99bf656 upstream.

Devmap broadcast redirects clone the packet for all but the last
destination.

For native XDP, that clone path copies only the linear xdp_frame data,
while fragmented frames keep skb_shared_info in tailroom outside the
linear area. Cloning such a frame leaves XDP_FLAGS_HAS_FRAGS set but
without valid frag metadata, and the later free path can interpret
uninitialized tail data as skb_shared_info, leading to an out-of-bounds
access during frame return.

Reject fragmented native XDP frames in dev_map_enqueue_clone().

Add the same restriction to the generic XDP clone path in
dev_map_redirect_clone(). Generic XDP represents fragmented packets as
nonlinear skbs, and rejecting them here keeps clone-based broadcast
support aligned between native and generic XDP.

Fixes: e624d4ed4aa8 ("xdp: Extend xdp_redirect_map with broadcast support")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/21c2d153dd25603d359069a02bf06779b51f6423.1780385378.git.zzhan461@ucr.edu
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -552,6 +552,10 @@ static int dev_map_enqueue_clone(struct
 {
 	struct xdp_frame *nxdpf;
 
+	/* Frags live outside the linear frame and cannot be cloned safely. */
+	if (unlikely(xdp_frame_has_frags(xdpf)))
+		return -EOPNOTSUPP;
+
 	nxdpf = xdpf_clone(xdpf);
 	if (!nxdpf)
 		return -ENOMEM;
@@ -697,6 +701,9 @@ static int dev_map_redirect_clone(struct
 	struct sk_buff *nskb;
 	int err;
 
+	if (unlikely(skb_is_nonlinear(skb)))
+		return -EOPNOTSUPP;
+
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return -ENOMEM;


