Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE88383C83;
	Sat, 12 Sep 2026 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241737; cv=none; b=TJKa42MBCIpiYwitsv2MIcdi8TH0xotamygnVgudMcLVVzW4oLxvt85XM/O9eh5LB6OdFepjMY+iYLC36m+29wyEHotk7RdGovHDp1euLb06FefU1Wq6fT5fn/iBLbkYFnnv7MfSmJawJptVDEUEoV4gWs+EB1taH/ztuIzQNp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241737; c=relaxed/simple;
	bh=iT9MQzOA2tjoLPxPzOH2J+SR18M50ksslRrSATPagEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILj6jBPhdVycWT+nD+kS2wQeFShc/6nd4yiRdARzwOJXQNcTPtAjAdzDCt2Xv3oRyaxZqCtlpVZsgjbHNHigRLrKUd0OADjLXOX5A7uIf+lT1wZPSik9xoZ6mvGP6ZUuyUZJCYJIR7Ha9NHT79Xy2ZPLnude45GOgpECtjegH34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRPG8J3g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRPG8J3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D421F000FF;
	Sat, 12 Sep 2026 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241736;
	bh=Lnm788FWxm4HWRc/cvIZ826iQv1AGRa8Ac8n4ZCnQIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRPG8J3gPaGzze8cB6ag31FBiGYjHfBN7FzIZvc7BLLscGbTI/ckz+yuZ7WvrTj6H
	 tMvOCOitZX/ks0Q0dam2u6W0vSlMco9YamJIxlqrem0l6PAflix49WtbJGWCgq7d8Y
	 s+3Ai+K8HJjE5lLLz7nujTdjouaz7tTnwlTfcI74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 154/798] xdp: fix zero-copy frame layout
Date: Sat, 12 Sep 2026 08:56:22 +0200
Message-ID: <20260912065520.539004129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 71283aaa6c65b3cec84caf1dc78560985737641f upstream.

xdp_convert_zc_to_xdp_frame() clones an XSK packet into an order-0 page
and advertises PAGE_SIZE as its frame size.  It allows the copied frame
to occupy the page tail needed by skb_shared_info and records zero
headroom even when metadata separates the frame header from packet data.
An AF_XDP zero-copy packet redirected through cpumap can therefore make
the skb overlap skb_shared_info or place it beyond the allocated page.

Limit the copied layout to SKB_WITH_OVERHEAD(PAGE_SIZE) and include the
metadata length in frame headroom.  Redirect callers already handle a
NULL conversion result.

BUG: KASAN: slab-out-of-bounds in skb_gro_receive
Write of size 4 at addr ffff88800cf37004 by task cpumap/1/map:1/146
Call Trace:
 skb_gro_receive (net/core/gro.c:174)
 udp_gro_receive (net/ipv4/udp_offload.c:812)
 inet_gro_receive (net/ipv4/af_inet.c:1539)
 dev_gro_receive (net/core/gro.c:515)
 gro_receive_skb (net/core/gro.c:633)
 cpu_map_kthread_run (kernel/bpf/cpumap.c:395)
 kthread (kernel/kthread.c:436)
 ret_from_fork (arch/x86/kernel/process.c:164)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
Kernel panic - not syncing: KASAN: panic_on_warn set ...

Fixes: b0d1beeff2a9 ("xdp: implement convert_to_xdp_frame for MEM_TYPE_ZERO_COPY")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260818154516.793517-1-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/xdp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -456,7 +456,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_
 		   xdp->data - xdp->data_meta;
 	totsize = xdp->data_end - xdp->data + metasize;
 
-	if (sizeof(*xdpf) + totsize > PAGE_SIZE)
+	if (sizeof(*xdpf) + totsize > SKB_WITH_OVERHEAD(PAGE_SIZE))
 		return NULL;
 
 	page = dev_alloc_page();
@@ -473,7 +473,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_
 
 	xdpf->data = addr + metasize;
 	xdpf->len = totsize - metasize;
-	xdpf->headroom = 0;
+	xdpf->headroom = metasize;
 	xdpf->metasize = metasize;
 	xdpf->frame_sz = PAGE_SIZE;
 	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;


