Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620750;
	b=JY8SaH2V1SucnMJDG+DrZ3PNYkIDIbWdJIl2OAwDPhLBWnOQFvcERzMh1yi/B/iIIgej
	 PMm2vDAeqDCP7a9mi7BUOqWUl3QP2eqx5f3NbYAGsFNkCqiTamwvfOouoCch3YC9oFuvc
	 c51Fo1R6+AqHpfNEII0AU0LFGXPOk0IagQn2zMmVumXZXW6Non/fpKL21FKLbMT8LEZy/
	 m1p6jecjOKLB0je5O4A0OuzndbrwBVfckNIxs2V7uu5Om6iIqwu5jj3PWNjs3xkSCg6hL
	 dHm/5qlgEiIZI4BUIb9ztvTN5KXT8XnqngPBpHexnAmt1AIfhfZwLiOBehX5jsypL/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PtPo2LJPs6OyISE9puB4EcCHxCoXU0DdHwGAZs4ANQ0=;
	b=L5FzP0zNhRyhibFHUbvAbxatm/aMP8ICQKZxx/8ZRkKIV/pPGXYvLAhrScdYVmk6ksC9
	 MCdhdQqUFuBjk3bO6K1JCDtrZy4lOjMMsyvUyMgdM/IkFHLzGPFt0D9Ib/qZYDX4dWPY4
	 bhZdR7MWmXHkqDtKwgI3qdB8QEsl2VR5SSRz1rapm87nVeYVK454dPVOPFiZQxUj2n478
	 ZhwksClWmR+j60dzlh5YKGiZvShdb6hNqoBXGEwC+lckpGfv8Is/J0jfbYQIVUjYnWM5o
	 ic7ehy7oiC7P0emu1gcGTKdW1jkD9fQPP6BfLhjYJjPkn2uQdmeiTpwtziV4aDZShkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dllc5I6O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE31606A327;
	Wed, 25 Nov 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dllc5I6O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F04F1F000E1;
	Wed, 25 Nov 2026 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620750;
	bh=PtPo2LJPs6OyISE9puB4EcCHxCoXU0DdHwGAZs4ANQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dllc5I6OhznTbDKA3BOTXngozkUo0DA7iMcuvLPJ86urh1AMNlgpjI4kAhf8qf9Tr
	 L2gwNyqgcnSf1XpO/OJ3bnyNzV5Gv64bytMQCg0EAfgGZSip6xI45VwTZQtiXuQTym
	 PwAE65yfFwkmWi//iUf9YyBsxAAOyhtD38HYdVXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/990] irqchip/sifive-plic: Avoid signed shift in interrupt enable mask
Date: Wed, 25 Nov 2026 15:22:51 +0100
Message-ID: <20261125143822.186436650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Context adjusted because __plic_toggle() here takes an enable_base pointer rather than a handler; the single 1 << (hwirq % 32) to BIT(hwirq % 32) change is otherwise identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index ca70641982ed6..0995e1fdd5b47 100644
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



