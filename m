Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DC92D23A8;
	Thu,  3 Jul 2025 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554857; cv=none; b=aM40W2KgcPWOMtTDsJrC4AehugAtQUrHUGOHTUB4FlOBCAaimwkYZkF1EmNAujpAdhUmockfRXMjQmbiYYvvnO98z97G7X7xJsvPCV3H91yBqNtfIkravJU1pGt+4PfYPdGyaT+yyTudZPY+gz3XnLqVERhZC4vYylfeC/aRRJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554857; c=relaxed/simple;
	bh=YjzPEUbMpdojk3Fs3U4vKGBnNby4HmXGVH+6R1FRzbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUy0jgYm1poIufRFaGp+b/PIQvlatlwPr8bDISsuUo80wdqc1Ah+cBT1xWmTDbgTD0tUIL7VLrtrUjx8agl3ezOVG3Y3qUV8RXelo9xa1QQwy6g3zTdKz1+hezId35MReACMfTjS+eAS4HwWUe2F8dcWPTaEEw0XGS0qQTpJkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sfw8pNHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfw8pNHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6765C4CEE3;
	Thu,  3 Jul 2025 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554857;
	bh=YjzPEUbMpdojk3Fs3U4vKGBnNby4HmXGVH+6R1FRzbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sfw8pNHZ6isd7m3okEDgtbdyWkBZ2QV4Z83UD7E5aZGmqNVEskoIJw3+EpvNw7F7P
	 ZY9C+1LKvupEZhV2DXovrgxIjSVLIEo2KODmshtRV6lmeN20TNdac2msagJPKv2ruJ
	 WRbWyq4GCHSESlxCfJRjKvH0PEjJ9Gg14G9fLEUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 101/263] LoongArch: KVM: Avoid overflow with array index
Date: Thu,  3 Jul 2025 16:40:21 +0200
Message-ID: <20250703144008.357558739@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 080e8d2ecdfde588897aa8a87a8884061f4dbbbb upstream.

The variable index is modified and reused as array index when modify
register EIOINTC_ENABLE. There will be array index overflow problem.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index f39929d7bf8a..9c47456b805c 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -436,17 +436,16 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 		break;
 	case EIOINTC_ENABLE_START ... EIOINTC_ENABLE_END:
 		index = (offset - EIOINTC_ENABLE_START) >> 1;
-		old_data = s->enable.reg_u32[index];
+		old_data = s->enable.reg_u16[index];
 		s->enable.reg_u16[index] = data;
 		/*
 		 * 1: enable irq.
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u16[index] & ~old_data & s->isr.reg_u16[index];
-		index = index << 1;
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+			eiointc_enable_irq(vcpu, s, index * 2 + i, mask, 1);
 		}
 		/*
 		 * 0: disable irq.
@@ -455,7 +454,7 @@ static int loongarch_eiointc_writew(struct kvm_vcpu *vcpu,
 		data = ~s->enable.reg_u16[index] & old_data & s->isr.reg_u16[index];
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index, mask, 0);
+			eiointc_enable_irq(vcpu, s, index * 2 + i, mask, 0);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
@@ -529,10 +528,9 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u32[index] & ~old_data & s->isr.reg_u32[index];
-		index = index << 2;
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+			eiointc_enable_irq(vcpu, s, index * 4 + i, mask, 1);
 		}
 		/*
 		 * 0: disable irq.
@@ -541,7 +539,7 @@ static int loongarch_eiointc_writel(struct kvm_vcpu *vcpu,
 		data = ~s->enable.reg_u32[index] & old_data & s->isr.reg_u32[index];
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index, mask, 0);
+			eiointc_enable_irq(vcpu, s, index * 4 + i, mask, 0);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
@@ -615,10 +613,9 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		 * update irq when isr is set.
 		 */
 		data = s->enable.reg_u64[index] & ~old_data & s->isr.reg_u64[index];
-		index = index << 3;
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index + i, mask, 1);
+			eiointc_enable_irq(vcpu, s, index * 8 + i, mask, 1);
 		}
 		/*
 		 * 0: disable irq.
@@ -627,7 +624,7 @@ static int loongarch_eiointc_writeq(struct kvm_vcpu *vcpu,
 		data = ~s->enable.reg_u64[index] & old_data & s->isr.reg_u64[index];
 		for (i = 0; i < sizeof(data); i++) {
 			u8 mask = (data >> (i * 8)) & 0xff;
-			eiointc_enable_irq(vcpu, s, index, mask, 0);
+			eiointc_enable_irq(vcpu, s, index * 8 + i, mask, 0);
 		}
 		break;
 	case EIOINTC_BOUNCE_START ... EIOINTC_BOUNCE_END:
-- 
2.50.0



