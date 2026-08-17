Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFA23BB687;
	Mon, 17 Aug 2026 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975457; cv=none; b=bjPuGNTvARPVstoCxbiybsZNffsE6POTWPJzrYWKwwn9VkLYsGX71a7NbPt7Gb9pA1j+l/J3poDfnyuU/0KB8h8cl42irIsGH17yOvCfAHwb2aHdIOi1F6TMZ353RaNaTyyMqfUzmSzY7unDqZI5Sohof73EhoaWCgLzPzFvELU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975457; c=relaxed/simple;
	bh=UWs+/P1orw79cSiEMi10xLGgaAQsXsAN3APsto68SXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hw10GJb8rYv+ARanzvp1NgmgYbWyc6YrRZohTiA7bi1TWTW1BwAi6ashC2EDmQ01zjVt4/vvLyVLEpeVwi96wC4AxBdGwf39N4UJS56l/WkowP5JbB9vbpd6FyyJLpLWkivGZTbEa62WPmjpTTQNpW3RrXJpxvzD12SXYIRfdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pICG0jts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pICG0jts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A650B1F000E9;
	Mon, 17 Aug 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975456;
	bh=SLKtGRLs+qg83/Cs9viJX1kHKMqTc9EwEiZ90F3sUmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pICG0jtsgDVvrt9auZqASzAS34A1IM3geQIPm8W0xhI7UI+fqpsA2RvAuHxQvk3Ap
	 UjL7XsbqdlgQmBJeDMBWb6Bn+Kubrbk8ZzdB0apg89bB/6sPtYIs4HTD/a0vJINuQn
	 YlDra7QXDd8xzMNSaxU5/YSe1oNGwtTD1Wz/2Zk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/389] ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts
Date: Mon, 17 Aug 2026 15:27:54 +0200
Message-ID: <20260817132540.338535730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 66c4e310ad71f41e41736d33dd8a1fb5eaaec7f3 ]

clear_interrupt_bit() ignores the bit argument and performs a
read-write-back of the entire INTPR register.  If INTPR uses standard
Write-1-to-Clear semantics, this clears every pending interrupt bit,
not just the intended one.  Coalesced interrupts (e.g. DMAT + NEWFP)
would be cleared together, silently losing the second event.

Write only the specific bit to clear so that other pending interrupts
are preserved.

Fixes: 62936009f35a ("[libata] Add 460EX on-chip SATA driver, sata_dwc_460ex")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index e9383db1b13a98..6a7e9aac4814e6 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -443,8 +443,7 @@ static void clear_serror(struct ata_port *ap)
 
 static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
 {
-	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr,
-			sata_dwc_readl(&hsdev->sata_dwc_regs->intpr));
+	sata_dwc_writel(&hsdev->sata_dwc_regs->intpr, bit);
 }
 
 static u32 qcmd_tag_to_mask(u8 tag)
-- 
2.53.0



