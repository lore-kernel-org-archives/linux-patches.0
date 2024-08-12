Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53564184527;
	Mon, 12 Aug 2024 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479385; cv=none; b=L7FC+aTq96WyF67pDZY/HePPAqbJRoLahYPy6e+sb2fcba5qbN+lu6mLW58yMqd0lxUG7IUeLdmB//qRs1TZfDPHy4ZuxUxlP+f14Fu3G7TDeuiQzMEeo0BRsjSkxORh8w/FJJp6nINpIWxAXzTmXmncejt+zNXv0QsW2WAcjr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479385; c=relaxed/simple;
	bh=UFNucJrD7yoheXamSArJRS8TeAJGTc9W8ByPuWq/bac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs4Ai5B/SY0HC4on/kCYATN84OUgTq3F/HqMmKZKRRe5PigBTz67tAopGFeqQNau8TtlB2jp9DLsXUzW9BUhAthLf6jOBpUU13PQ0HnsfVtSqsf8x1cXE/K4msyNlA6CT5vqmvKJEB4JZgyrDX2d7fTRale05HR4/PggDEy0zTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFDUC1y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFDUC1y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE01C4AF09;
	Mon, 12 Aug 2024 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479385;
	bh=UFNucJrD7yoheXamSArJRS8TeAJGTc9W8ByPuWq/bac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFDUC1y4tptDTBIjq4QnBVwssFBpBFmrsnVwXdhBoQCyyhCeltcIAuaiOrr3fiB6Y
	 ZyPNKzFYCEsyHtgIIVWkG75RxM8FqXRskxg/3s7m/2LjtVD1KYUzmbAoMhi4767BNr
	 y19TuTaT/nCOfJ6/RhAO2cUH+SBv0VGhsugjNE4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Wang <shankerwangmiao@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 6.6 071/189] irqchip/loongarch-cpu: Fix return value of lpic_gsi_to_irq()
Date: Mon, 12 Aug 2024 18:02:07 +0200
Message-ID: <20240812160134.877167022@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/irqchip/irq-loongarch-cpu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


