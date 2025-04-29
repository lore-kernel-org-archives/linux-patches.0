Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CAF2512D8;
	Tue, 29 Apr 2025 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947871; cv=none; b=d1ZUFfWe3ef5nw3jD8uKXu7oiDVajXeRhie44SNR7hNYA3D3MVsH6CK3yylJvszoPEfE27RO2Gb5Fg75nmKnXx0OTA4YWkI0L7tTg6xKWxH+Y0s1sjrIUux4v09yPKEHaQ0cHVtPU6FTPJZRXxCMSbiVTvQPume3FQJCKxxsmYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947871; c=relaxed/simple;
	bh=kdryNQu8EXf/xaRaGaLyF+NvCdgFeFz6xS2pPLrm5bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9JYR07sr5XMzsXEcZ+GEPrhDRoYFzbf0CQJxFiahqcaAfKXMgMU3MCEkzIuQrKEVJDz651BrXmgufV2CVeP4s7zdPiLg3FFlpN9nMD/MCIvdJsLZUZB00V7cRnwSBBs1/WnG9Ta/2MrSGAuGJ3fysRQkIIUrGT3Ui6xb446+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Db0qC4a0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Db0qC4a0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB85C4CEE3;
	Tue, 29 Apr 2025 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947871;
	bh=kdryNQu8EXf/xaRaGaLyF+NvCdgFeFz6xS2pPLrm5bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db0qC4a0SIb/f9GrGLFMZ79tUxYlegSUMg4e9rqXcHGxOFGf2qr1ifm6tStAULFLe
	 Ls9zTa55L0HctazIpUxAETDwRtwDox1uDozsrG89w4/61JS9DcDj+ik/0Ui6Kw0jwV
	 VlpQA5EoZBDvIYCkAgPTlmKYtV8KDOmaVh5LNV9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.12 128/280] misc: microchip: pci1xxxx: Fix incorrect IRQ status handling during ack
Date: Tue, 29 Apr 2025 18:41:09 +0200
Message-ID: <20250429161120.364713447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit e9d7748a7468581859d2b85b378135f9688a0aff upstream.

Under irq_ack, pci1xxxx_assign_bit reads the current interrupt status,
modifies and writes the entire value back. Since, the IRQ status bit
gets cleared on writing back, the better approach is to directly write
the bitmask to the register in order to preserve the value.

Fixes: 1f4d8ae231f4 ("misc: microchip: pci1xxxx: Add gpio irq handler and irq helper functions irq_ack, irq_mask, irq_unmask and irq_set_type of irq_chip.")
Cc: stable <stable@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20250313170856.20868-3-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
@@ -165,7 +165,7 @@ static void pci1xxxx_gpio_irq_ack(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	pci1xxx_assign_bit(priv->reg_base, INTR_STAT_OFFSET(gpio), (gpio % 32), true);
+	writel(BIT(gpio % 32), priv->reg_base + INTR_STAT_OFFSET(gpio));
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 


