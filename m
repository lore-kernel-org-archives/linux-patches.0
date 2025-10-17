Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88F63370FB;
	Fri, 17 Oct 2025 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714780; cv=none; b=gnYvAvTLzPYDTb/SlXGk3EJFVrNocD5kFakpBs9gSaR4V2LyOBoj9bjfNkFxyc+qTHxwVPpTWf5oVXjdUl/9gAu832pCxtCSt8Zs3fagX7GqvTBbakQUuY5XUIcPBM1ZmotUV9fBQGKOV48XEjeAmOvzVCFRP9eNzx4cCcdQ/ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714780; c=relaxed/simple;
	bh=xzkJh9Uv+sZJiuE2iPc1fKxX77O69ml8U5wmLqSYyO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uggOy76Bn4L9HsNIxSFlCGPa7kjrYhGeNv6sHOwefQEPFyBH5KQDVeMSB3yI/9g+h/cEL6/xpNPNBGK5p2KmXBGspdrzAyNACAhwwJZiJkhVFwGUIkCPlYmN59Tu+1D7kAq54FzkGcBc2LAORVu6+8VYRUJ7PIJyXukWhdNHf6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjP1NJKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjP1NJKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D436C4CEE7;
	Fri, 17 Oct 2025 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714779;
	bh=xzkJh9Uv+sZJiuE2iPc1fKxX77O69ml8U5wmLqSYyO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjP1NJKqFogcpud3NXiiYDgJr+zRtULf06e+fz2BcRzD5Md5vNNwrupEHY+bDzMw4
	 NH7tgB7e53mrO0YGtOrQRXPcWxIiMVcrkVWNdurVV778z6irNcfKCY4+HKf3Elzclk
	 j35pnPQLSPQLlYoozGGItk4611DvBVr9Rl7pVzAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/277] irqchip/sifive-plic: Make use of __assign_bit()
Date: Fri, 17 Oct 2025 16:54:30 +0200
Message-ID: <20251017145156.765346792@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 40d7af5375a4e27d8576d9d11954ac213d06f09e ]

Replace the open coded

if (foo)
        __set_bit(n, bar);
    else
        __clear_bit(n, bar);

with __assign_bit(). No functional change intended.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/all/20240902130824.2878644-1-lihongbo22@huawei.com
Stable-dep-of: f75e07bf5226 ("irqchip/sifive-plic: Avoid interrupt ID 0 handling during suspend/resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 36dbcf2d728a5..bf69a4802b71e 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -252,11 +252,10 @@ static int plic_irq_suspend(void)
 
 	priv = per_cpu_ptr(&plic_handlers, smp_processor_id())->priv;
 
-	for (i = 0; i < priv->nr_irqs; i++)
-		if (readl(priv->regs + PRIORITY_BASE + i * PRIORITY_PER_ID))
-			__set_bit(i, priv->prio_save);
-		else
-			__clear_bit(i, priv->prio_save);
+	for (i = 0; i < priv->nr_irqs; i++) {
+		__assign_bit(i, priv->prio_save,
+			     readl(priv->regs + PRIORITY_BASE + i * PRIORITY_PER_ID));
+	}
 
 	for_each_cpu(cpu, cpu_present_mask) {
 		struct plic_handler *handler = per_cpu_ptr(&plic_handlers, cpu);
-- 
2.51.0



