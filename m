Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C23638757B;
	Tue, 21 Jul 2026 18:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658382; cv=none; b=Q0CoJiasTbyVecNxxZ7Auucld6BaK0eZCpOJX6prUOXxHFQUghcFhl2IQ9knXU11Za9HZuA6rTLlxY6qT94pGSYA7NevfBcaJ1x3qGwFdYzUzogrDVsOmMWX2uUbEdN21Gr2nW4iihzgNlpotGGkRrIjYGTUOH8Y6ozo1CWXA1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658382; c=relaxed/simple;
	bh=NR0E5beWoRKtT4KuGUCeRLctfJNr9/QlUQXhohBaIVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl4H43K6DWartMTusnLfdji1iVXuiHW6qlyI+cUAWJDEtJT+WRCRkrJUxQdGiNYsNVJCcHG5EbhNgYKYwplEynPATu9gcgd1hEm4N/pmCCoc7ULF4gGCPnPsr4y5fDUOhpEApqEEpZ78i6zYcrtlp5ql5+Sk11HOHnrxdKC6q58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJmd24k3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJmd24k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AAE1F000E9;
	Tue, 21 Jul 2026 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658380;
	bh=KemlQW1Iy7fVWCm7tv4OPdNsPmy8XaXb0uj7Tz9+JTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJmd24k3Dj7z5KOF6lQFLLiYd0i7/5ZVZnwicA1nq/OCn3/hJweJA//mR60C3FQsR
	 ePxcgEDqyvtyk+H0gEhrqHjnyH2qrQ0vGHjZZkdPMHf9ZnPOuTzD3YXpM6+gj+OJ2l
	 ECQuIt36C3BaQQw8KAwpdwYN2QodoTeGWKXavZkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>,
	Yanfei Xu <yanfei.xu@bytedance.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1123/1611] LoongArch: KVM: Validate irqchip index in irqfd routing
Date: Tue, 21 Jul 2026 17:20:39 +0200
Message-ID: <20260721152540.679571689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,7 +53,8 @@ int kvm_set_routing_entry(struct kvm *kv
 		e->irqchip.irqchip = ue->u.irqchip.irqchip;
 		e->irqchip.pin = ue->u.irqchip.pin;
 
-		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS)
+		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS ||
+		    e->irqchip.irqchip >= KVM_NR_IRQCHIPS)
 			return -EINVAL;
 
 		return 0;


