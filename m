Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625411;
	b=t6I6oF7pxZQK+3SJgES8dIg788cKgvO7m4b8aTKTfg+5dwoFg0ERaCb5Lfiah9NbllDm
	 a+Opc5qYj6OlcVtT1MHvA1qnE6teG5xMSKTHBr7M8ZIUALeAGtBNe9LdCStCAU1ybQGt+
	 mJjMQYh0BXKgIF2z3VgvhhDtEXR5ZfF0LT56hhpaVS29k46xFBKIU8dWSAW+h0J48QSPu
	 2ad4G0a9StZBTP7EuKzq+oLYB6PBIKZCrO8BGPc41uy0JzP9l3b2BjB5Mr3N+6ELeRqpd
	 ZBXiIxl1D1ZlYu6ytUvQvzEPNVLqWNyK2D766f2WecU4b1U6lca7ZrBN6RGQDePajqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JZX0ukB7tgpdHVR/gjjMRf3n2aJl6cbLeRzzV8LG2Mk=;
	b=IkviDz/kYcd6khcsw9DNGXeiXhBhKQ215UhKxw63uvoU+aDsCDndMf2ADmZprL7a3fJU
	 rJwjU5neXEzESsy20bLXJKauFIcnVjbM7lrsE6NUc7oOGeB2S32EZe7ezY2Fx9DVOlnwP
	 /lpCgFrdn+7qbu0FgXg4a/aa8TF2CB93aJSteErWjAk9yerVvzgWTjmHHst2SQt14Jfx7
	 pVwwA5TzmWs6xnP8Hrxsv+ZRPOcWkh0Oib6hVDHBW2CWXUMIo0l4b7vnoqA3VnWLZEmw0
	 WHyqdUIqGSZJ1nXGFoiHGYUcoVVlE/zKllihIZKC40isauVuYCspvbYQSUy/a5eWxnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1xs9cTc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCDF606A31E;
	Wed, 25 Nov 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1xs9cTc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E871F000C0;
	Wed, 25 Nov 2026 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625410;
	bh=JZX0ukB7tgpdHVR/gjjMRf3n2aJl6cbLeRzzV8LG2Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1xs9cTcWybs7eKHHkMwfZ0TKDDaQLeqE3dYrnH226RHE2jvydhQ9Ol1XmVPcTEfZ
	 okbAzgq5tX3tMpVRrgX0CSf5c3nkfB2gPmsvzOvi0AGsIKqtcoTE0OXUY0Jhi5vlXV
	 FpYq+d86pHthGNi5JseeuvdkzYK8k9FR3DnpeKnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 505/816] bpf: Use the frame mem type in devmap egress XDP
Date: Wed, 25 Nov 2026 15:34:13 +0100
Message-ID: <20261125143900.876865156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit b3ca872947ef322c475ceaa7a76a9ebb3356152e ]

A devmap egress program that removes a whole fragment of a redirected
xdp_frame with bpf_xdp_adjust_tail() or bpf_xdp_pull_data() frees it
with page_frag_free() whatever the frame's memory type is. For a
MEM_TYPE_PAGE_POOL frame from a page_pool based driver this drops the
page reference owned by the pool while the pool still accounts the
fragment ("page_pool leak" bad page, leaked pp reference).

kernel/bpf/devmap.c:dev_map_bpf_prog_run() points xdp.rxq at an
on-stack

    struct xdp_rxq_info rxq = { .dev = rx_dev };

whose mem.type is 0, i.e. MEM_TYPE_PAGE_SHARED, and
net/core/filter.c:bpf_xdp_shrink_data() releases frags according to
rxq->mem.type. cpumap, which runs programs on xdp_frames the same way,
already copies xdpf->mem_type into its private rxq for each frame.

With 9000 byte frames from virtio_net and an egress program that cuts the
fragments off:

  BUG: Bad page state in process swapper/3  pfn:10660b
  page dumped because: page_pool leak
   bad_page+0xbd/0x190
   __free_frozen_pages+0x5c7/0x900
   bpf_xdp_adjust_tail+0x3be/0x480
   bpf_prog_dad43f894a3faff7_egress+0x15c/0x1cd
   dev_map_bpf_prog_run+0x288/0x610

The pool waits for these pages for ever when its device is gone. That is
the harmless case. A page of the pool can hold more than one fragment
while its refcount is 1: the first page_frag_free() frees it under the
fragment which is still in use, and the second one runs into

  page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
  kernel BUG at include/linux/mm.h:1846!

veth is not affected. It takes references of its own on the pages and
redirects the frame as MEM_TYPE_PAGE_SHARED.

Fix by setting rxq.mem.type from each frame before running the devmap
program, as cpu_map_bpf_prog_run_xdp() does.

Fixes: ca9984c5f0ab ("bpf: devmap: provide rxq after redirect")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-2-alexei.starovoitov@gmail.com
[ sashal: Changed rxq.mem.type = xdpf->mem_type; to rxq.mem = xdpf->mem; because this tree's xdp_frame has a struct xdp_mem_info mem member instead of a flat mem_type field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 1c64c4cff41ec..368c9d50aa8bb 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -348,6 +348,7 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 
 		xdp_convert_frame_to_buff(xdpf, &xdp);
 		xdp.txq = &txq;
+		rxq.mem = xdpf->mem;
 		xdp.rxq = &rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
-- 
2.53.0



