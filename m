Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393362D23A8;
	Thu,  3 Jul 2025 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554870; cv=none; b=QJEcszqybztMbe8t02GHWHW3omP9F8Msp7GdeLZpd+PyS6wF+mmKJzbjOfj1UC9RdcVh4Sq8SK6PBQ+kn7l1L+c+awvpSKD3MCSxjBQHfKKUYfGJCP9eN36AY8CqsFwg9YRV46V947zNl4FlKeK7Lvae/Z+/9CZlfJedXE9tbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554870; c=relaxed/simple;
	bh=XQkK+5wVVywTw5gBLdp87ubGOZQ6mHI6w8ELsgD+UmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhhEE9P9bg3gfp5hLgmFocxRtN6ebxxxd7lSqBjw4G7Ozk3uLvC3bpHwYCkE6I8VcWPNxLpwkzJDQ9/8PSnsw+M01ocO1gE0kE2hB/bDDDXndujrF7Bogu2G0y193DtXMpgjoo883wEtiOWAwMtpaMuMhq7RRxG1zhPCNPRNIqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q95q6s7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q95q6s7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FC9C4CEED;
	Thu,  3 Jul 2025 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554870;
	bh=XQkK+5wVVywTw5gBLdp87ubGOZQ6mHI6w8ELsgD+UmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q95q6s7WVmPkzg8T7Al6tCI8nSOGK83zvrL08Zju0MAX10aBKyLqf381KaBFUhAkN
	 3C/3QD6oKQUNsfdxwdZ5pvKtBwAwBbqOyPW2C6+vhWDnwcu2fzl3P8HwEEKkoyzeQj
	 ZEe1EbPjlJ71W//bPR1u00N03tnlTcPiEV/GxNEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 105/263] LoongArch: KVM: Fix interrupt route update with EIOINTC
Date: Thu,  3 Jul 2025 16:40:25 +0200
Message-ID: <20250703144008.524469050@linuxfoundation.org>
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

commit c34bbc2c990700ba07b271fc7c8113b0bc3e4093 upstream.

With function eiointc_update_sw_coremap(), there is forced assignment
like val = *(u64 *)pvalue. Parameter pvalue may be pointer to char type
or others, there is problem with forced assignment with u64 type.

Here the detailed value is passed rather address pointer.

Cc: stable@vger.kernel.org
Fixes: 3956a52bc05b ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -66,10 +66,9 @@ static void eiointc_update_irq(struct lo
 }
 
 static inline void eiointc_update_sw_coremap(struct loongarch_eiointc *s,
-					int irq, void *pvalue, u32 len, bool notify)
+					int irq, u64 val, u32 len, bool notify)
 {
 	int i, cpu;
-	u64 val = *(u64 *)pvalue;
 
 	for (i = 0; i < len; i++) {
 		cpu = val & 0xff;
@@ -403,7 +402,7 @@ static int loongarch_eiointc_writeb(stru
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq;
 		s->coremap.reg_u8[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -488,7 +487,7 @@ static int loongarch_eiointc_writew(stru
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq >> 1;
 		s->coremap.reg_u16[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -573,7 +572,7 @@ static int loongarch_eiointc_writel(stru
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq >> 2;
 		s->coremap.reg_u32[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -658,7 +657,7 @@ static int loongarch_eiointc_writeq(stru
 		irq = offset - EIOINTC_COREMAP_START;
 		index = irq >> 3;
 		s->coremap.reg_u64[index] = data;
-		eiointc_update_sw_coremap(s, irq, (void *)&data, sizeof(data), true);
+		eiointc_update_sw_coremap(s, irq, data, sizeof(data), true);
 		break;
 	default:
 		ret = -EINVAL;
@@ -822,7 +821,7 @@ static int kvm_eiointc_ctrl_access(struc
 		for (i = 0; i < (EIOINTC_IRQS / 4); i++) {
 			start_irq = i * 4;
 			eiointc_update_sw_coremap(s, start_irq,
-					(void *)&s->coremap.reg_u32[i], sizeof(u32), false);
+					s->coremap.reg_u32[i], sizeof(u32), false);
 		}
 		break;
 	default:


