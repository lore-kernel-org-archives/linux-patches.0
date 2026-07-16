Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3417E426429;
	Thu, 16 Jul 2026 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211147; cv=none; b=KUTD4KT7cvj4T5mRYfXSS2SRPdwwX34g2hjkGr4UIm2Tmdh0HrGto1TXoFUuHNwt5tTorXi8OkchN9J54mbQDXS5T0HRrBoTZKA9HC0nFNG1csl4K97/2AOqplh+y5pSZH36TZ/rvx9WNCj0HOSIVnWcUydwnd/5AbDxJvDaCFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211147; c=relaxed/simple;
	bh=K5SqbKoKuhfjrfg8xE8eZznVM9ieUJY1bhZnse6mlDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jb0dJYOhDbCyvZQk+bxFbmDdMZcUZM5sA1bPV/ocabPnWnvC2UqayhVpaPAg7SCdGo4Kcaso86bVk+qzV5fmf11x9KNu60XOZhWG62KCtP0pQB20Z8cFARa0XZJ0Ibw4aO+8NBGheP8WP/fAX4kw85hm/iicqb7aA6DoLbaavnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n75bELXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n75bELXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A070D1F000E9;
	Thu, 16 Jul 2026 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211146;
	bh=/hXN8bhCOtyEGEG7JR6Ta3z+adW6NjHiqzPpsmtbtD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n75bELXgcgTKRIuVfjvIK93E8ixU8UakSoxWvT7VlAgHb2AoMDTEoO5HYEU6oCsXI
	 Lm8nmeHIOF/XPfYULNz15m9YRLb/HbyInABwFlIX5QNZqIa/Vbn67gTthj+o0YXO8A
	 k8LB2Nm/oJUhf5jkI6l77yew99/SMu6kgB6OdbaY=
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
Subject: [PATCH 6.18 280/480] bpf: Reject fragmented frames in devmap
Date: Thu, 16 Jul 2026 15:30:27 +0200
Message-ID: <20260716133050.884374580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -581,6 +581,10 @@ static int dev_map_enqueue_clone(struct
 {
 	struct xdp_frame *nxdpf;
 
+	/* Frags live outside the linear frame and cannot be cloned safely. */
+	if (unlikely(xdp_frame_has_frags(xdpf)))
+		return -EOPNOTSUPP;
+
 	nxdpf = xdpf_clone(xdpf);
 	if (!nxdpf)
 		return -ENOMEM;
@@ -726,6 +730,9 @@ static int dev_map_redirect_clone(struct
 	struct sk_buff *nskb;
 	int err;
 
+	if (unlikely(skb_is_nonlinear(skb)))
+		return -EOPNOTSUPP;
+
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb)
 		return -ENOMEM;


