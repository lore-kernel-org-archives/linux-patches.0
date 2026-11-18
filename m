Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020825;
	b=135kImsg2EgHC+W3IGGjhtWFxwTaE97iTDIzd2O5CyZa0O0A/BRkz3ohGKd/mN9TLhA6
	 BHH0Th4G5bJcjQpd9xC2asy4MMORZ3fkkv18VAVwjE/hDF9T1TjQosSwKDs5LIbAMFBMA
	 hfvwUSix0ZJJuDCGu+qBG/ZHnudyENsN7NwplJo9w7WXJr+avYApAAFIb1NyuchTWMX+c
	 jpAkH1VhlmnN64BB4aSzYMw+hqcOXE/d0EIpNAIa5hkP4uytyhA3wqhUhQ8PI6lxaPFnA
	 vkrejqcyiH7Aw9qn1FO4oCIlbUpH8YbUqyrB5GjY+gQFlk52e1ygHFwENlqOgwt9yog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iQ/Np7NEqCHPl29N63jepgeWQhfWRoFn3eijSWY5wPs=;
	b=LqxbZcJ4H7J0Th77jUrKNPF866t8QaK4zdCBMg/t9nPPkfyQ6XDMyEn8epMYhJmYADSr
	 sHEKgxeW0j9VBAKsxp62wx/hQQO1ZSXh4YtDFhMS3tst6fU0B29FyE5m6FQFP7TNpkOiR
	 uyGzN3TIIVUTEDLeGVt/yxTWMnawPKmbsqSViCwrJvPnsYhak9VM3dwn7Dv5BW+3YqxKX
	 tFzTvLbNlnTN6KZ/GEuGM9Uctne2Q2x3Vhe9zASVpDmPfGsrMk3VkUP+5JLLWLOc1ya+K
	 Sp3j7seDsWs2Hvnbe2GXAatTuRB34Cvv+DgYx6NgTkFCdqRt2gc7r+Eb4JQcwSuRLgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mqTuo3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F73606A337;
	Wed, 18 Nov 2026 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mqTuo3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91E51F000C4;
	Wed, 18 Nov 2026 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020825;
	bh=iQ/Np7NEqCHPl29N63jepgeWQhfWRoFn3eijSWY5wPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mqTuo3XahlpSUhNvy9DTdbEDNF1Jo6UI3yZT1U1lPgapyyctYXcNvaO00+0TNP+e
	 oP+qI1pRrKRTiZc6hZ9ydGg214qdwbbXt9NW3aWiky9gQOu7KbsaYJ+0M1Io4qy8sb
	 MNTdjNmgHtT8x+Yu5/giaMN8QwRATKhNITyONnNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2088/2651] bpf: Use the frame mem type in devmap egress XDP
Date: Wed, 18 Nov 2026 15:55:28 +0100
Message-ID: <20261118150401.192815516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index dc7b859e8bbfd..1b8f0d7f84552 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -350,6 +350,7 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 
 		xdp_convert_frame_to_buff(xdpf, &xdp);
 		xdp.txq = &txq;
+		rxq.mem.type = xdpf->mem_type;
 		xdp.rxq = &rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
-- 
2.53.0



