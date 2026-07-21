Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802833689F;
	Tue, 21 Jul 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654021; cv=none; b=ghMXcuDGswYOd/8p5I+ZykR1onU5SKBn1sPknamBYQ07PBSJ2E8+YaTafUe1PwXz0M8/07+GI0o7jn7tgsNBgEg6SOE8wb7B+jOCQGEpSBzfV6Z4yNzD3smI9bfV30BZ9+dCJNPdeO2GMgZu3OFNyX1lxeFVO+E7LxAWIHna/Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654021; c=relaxed/simple;
	bh=y/eMUqPjrwjJcvC2v8nMbY48K/JvQQJUxV+t8RF2rKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsmI+AUSczlARvPAbuNi8Jat4vwU1uhpqHJd29VUoBc6W5R/Ym3/6E4RGmNqnq2mmOeKK0Wz6f46ExHO7VQ443a0uKBdmS4aG5J0g9pwiBFl3Ltzm06vYrjfI54DsVlEHYX6XDL7u3yTisodSMx/GvXuKud8FQ+yLIS5pKBy3qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMw1QB3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMw1QB3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FD71F000E9;
	Tue, 21 Jul 2026 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654020;
	bh=lQe/+5U7EHkhlbNnzgMKUbJU8FpGazY7wvbEYRZT8hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMw1QB3nz+jZwBtW7mWfXVDfqtkTZ2f6p2qir1lZzY0Uc2RXTJIktKgfmpzQ44Jw6
	 c7cuk8Q2r1kR3NRF3UfKMqcFBsUXmWPsWpJFXJob3VQaLIj13a34j2A5U4QVAlzs3o
	 DX4Hfj7LRSH58a/aXDDRjSFO6hGPRuqckwd4FIdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>,
	Yanfei Xu <yanfei.xu@bytedance.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 1547/2077] LoongArch: KVM: Validate irqchip index in irqfd routing
Date: Tue, 21 Jul 2026 17:20:20 +0200
Message-ID: <20260721152629.264912300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanfei Xu <yanfei.xu@bytedance.com>

commit 3474037904c20ff915e3ebab0ab5c1e41bbe549e upstream.

Sashiko reported that the irqchip index is not validated for LoongArch.
Add validation and reject out-of-range irqchip indexes to avoid indexing
past the routing table's chip array.

Cc: stable@vger.kernel.org
Fixes: 1928254c5ccb ("LoongArch: KVM: Add irqfd support")
Closes: https://lore.kernel.org/kvm/20260525051714.485D51F000E9@smtp.kernel.org/
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Yanfei Xu <yanfei.xu@bytedance.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/irqfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/irqfd.c
+++ b/arch/loongarch/kvm/irqfd.c
@@ -51,7 +51,8 @@ int kvm_set_routing_entry(struct kvm *kv
 		e->irqchip.irqchip = ue->u.irqchip.irqchip;
 		e->irqchip.pin = ue->u.irqchip.pin;
 
-		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS)
+		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS ||
+		    e->irqchip.irqchip >= KVM_NR_IRQCHIPS)
 			return -EINVAL;
 
 		return 0;


