Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643D3188CC0;
	Mon, 12 Aug 2024 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478983; cv=none; b=W15kXej6VmNyAFbIa8Pa9etfATeRTHj5N/KOeCizPZ12GLYe78e+0uZf/+MfNf3J5pS7ZFt1Ywyt6Bmmgg31NPXMcvAuCcuMSdrnKo1gBNvzkpyhcRzIKtXxfsH5IPUSQj6fVE3j9gNnN/2a4iGuhbeIBBC/wir5SFd+xUrCniY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478983; c=relaxed/simple;
	bh=S1nBEsnyDzky0xi1WwK9ijP0AKn4PQWk7xDzCrz6IhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igxXg191PeUq0sP8hQydeCeUx1MWI4OjlUZNTeZNrfgWMPWKqec+DftbYG5p6dQw97uZw1KW0xOr8fhuvyLabGST/MBzkG2egghvMyuaAUtOMkzdmsesoqYQm4VAm5oXyV9T/iT/26HAcn2Dpfut0j3VLNSsqz2fjIs5agpyWxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phoUpDIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phoUpDIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E83C4AF0F;
	Mon, 12 Aug 2024 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478983;
	bh=S1nBEsnyDzky0xi1WwK9ijP0AKn4PQWk7xDzCrz6IhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phoUpDIZMDXWMVIbDc6Stv23SXAHx9E3rrUnX4EvC59an3VIxdIfUNGZdphlsA2lu
	 0uStUGlpsD2NWVe1Lp1Yx+RPdk49hUxTsgYm9wHujOJ0ecY6VovHsqLIrueYhIUdE4
	 Wnlmv9ljCMvFFF6LzHQQrtEPN43/YS2jKZoyyezk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Wang <shankerwangmiao@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 6.1 055/150] irqchip/loongarch-cpu: Fix return value of lpic_gsi_to_irq()
Date: Mon, 12 Aug 2024 18:02:16 +0200
Message-ID: <20240812160127.294706626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 81a91abab1307d7725fa4620952c0767beae7753 upstream.

lpic_gsi_to_irq() should return a valid Linux interrupt number if
acpi_register_gsi() succeeds, and return 0 otherwise. But lpic_gsi_to_irq()
converts a negative return value of acpi_register_gsi() to a positive value
silently.

Convert the return value explicitly.

Fixes: e8bba72b396c ("irqchip / ACPI: Introduce ACPI_IRQ_MODEL_LPIC for LoongArch")
Reported-by: Miao Wang <shankerwangmiao@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240723064508.35560-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongarch-cpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-loongarch-cpu.c b/drivers/irqchip/irq-loongarch-cpu.c
index 9d8f2c406043..b35903a06902 100644
--- a/drivers/irqchip/irq-loongarch-cpu.c
+++ b/drivers/irqchip/irq-loongarch-cpu.c
@@ -18,11 +18,13 @@ struct fwnode_handle *cpuintc_handle;
 
 static u32 lpic_gsi_to_irq(u32 gsi)
 {
+	int irq = 0;
+
 	/* Only pch irqdomain transferring is required for LoongArch. */
 	if (gsi >= GSI_MIN_PCH_IRQ && gsi <= GSI_MAX_PCH_IRQ)
-		return acpi_register_gsi(NULL, gsi, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_HIGH);
+		irq = acpi_register_gsi(NULL, gsi, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_HIGH);
 
-	return 0;
+	return (irq > 0) ? irq : 0;
 }
 
 static struct fwnode_handle *lpic_get_gsi_domain_id(u32 gsi)
-- 
2.46.0



