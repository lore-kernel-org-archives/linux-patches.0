Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623905;
	b=T1QH6FAsHVqvdK/2I/yix4EEspXmcJ9Tfpi0BaAfy6pz+Y3enYt3f5JsHYqLQ7DrCydB
	 kDgzQz/cwvD8Vny0ZLlO1Co47Tmbt8Ly5B9J5xvmme3PE0lcRilXKREx6sGGrbMyUAUFZ
	 MjJdZ+ojvg7bP5eZVXpMj+n8Cm1yJODqjWpKKjCfX6KWAGq5IS1TSCzU+00C8qv1EQBSH
	 yQV34c914AJN96WJ76oNB622ALjBYRVy2xL+ImFeGitNBQ5wRXTpcRlQf0rq/31KOEPX/
	 099WBURglT0S5O7OFKU0NJWSeje1MsoB2EpaPw9kPP71OXPkJa7sFM8iU+xCP3E7t8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K+Oxfu5iJpKRphqStyMUVb12k0X1kYiJwjqi/uE4J7Y=;
	b=bFbdRPfLOzF6iPqGXggj6+PgOMeT/2/XDreTE03c3YPM0L8qZFs6dmafRUOJmWqopo69
	 olBWzrym4FOfQCq9T6IqR1QyekA2dT1gYy3yva9j9V8k5L3pJVdPp/5a4Kj6HXS+j2P80
	 FUgsXp7ludW4mkKOwfSxKcngQGV6Wf9lVktWN+hbG0lpoIsulBcPclnF6RlRZeTtxWn6o
	 t9UjUn38g2HiBjKo3z5jFbsItRl9RnqhGTV5FK96mw2E2KavP5VedBeOvShS2ZTNgvqcZ
	 VDEZ6fD0z7yQi0B7HZqK4pY9NCewPE9VQe8clni71Q1Mt/CoWrdLblsiAa1Wg7Zz3wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LoCr/2fy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F6A606A31E;
	Wed, 25 Nov 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoCr/2fy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2161F000C4;
	Wed, 25 Nov 2026 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623904;
	bh=K+Oxfu5iJpKRphqStyMUVb12k0X1kYiJwjqi/uE4J7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoCr/2fy3f3iAQQSxENRZhQp3UIhHTfwyhqGfjKIAAv/B6uurZNdugNdNPfjSqhtr
	 /w3PskdQc8dxXfLtXoSlGsTyRDlUAw0nNK59QL03LT5gknu5UD7DiFAYdZP9ymai20
	 D3rdrurjF2iJgQ2LumO+UVLy2Zdzg35jubCyLPZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/816] irqchip/sifive-plic: Avoid signed shift in interrupt enable mask
Date: Wed, 25 Nov 2026 15:25:53 +0100
Message-ID: <20261125143849.340712271@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 0f214e5bbee59d5952d3c061fd65ed9a1e175981 ]

__plic_toggle() builds a 32-bit interrupt enable mask using a signed
integer literal. A valid interrupt selecting bit 31 evaluates 1 << 31,
which shifts a signed int into its sign bit.

Use BIT(), matching the equivalent mask construction in plic_irq_eoi().
The resulting mask remains representable in u32 on both RV32 and RV64.

The issue was found by our static-analysis tool.

Fixes: 8237f8bc4f6e ("irqchip: add a SiFive PLIC driver")
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: gpt 5
Link: https://patch.msgid.link/caplitmus-rv.v2.plic.87a8fc444de44e109889ba28703c76f3@163.com
[ sashal: Context lines were rebased onto this tree's older __plic_toggle() (direct read-modify-write via reg), and only the 1 << (hwirq % 32) to BIT(hwirq % 32) change was applied. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index d57e9b25d0b4d..b061062f47c58 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -97,7 +97,7 @@ static int plic_irq_set_type(struct irq_data *d, unsigned int type);
 static void __plic_toggle(void __iomem *enable_base, int hwirq, int enable)
 {
 	u32 __iomem *reg = enable_base + (hwirq / 32) * sizeof(u32);
-	u32 hwirq_mask = 1 << (hwirq % 32);
+	u32 hwirq_mask = BIT(hwirq % 32);
 
 	if (enable)
 		writel(readl(reg) | hwirq_mask, reg);
-- 
2.53.0



