Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE33386C21;
	Sat, 12 Sep 2026 09:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204635; cv=none; b=CTZbIi+1AibQHxUis1B1Uvs1s7a8VdhDKEeSU498svEnYnNG6XlvPql4oogrVgFKAKoH6KV2Piv192Z+ip40mM0oKoiS0zQ07aO9aoIRSBGCLlBLFwtaQdME0FJCpG2RFYGnQLpWB8xd+UnSS+uzJALV6aLIJfs8R+Z2QC0FjRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204635; c=relaxed/simple;
	bh=3FycrMuOh9u1MATrflvlEixBH7UZKPo01BKORWtIDcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lnx8U5ZJTrB0vCj3CbVe6+rXBNsZxmppitVBfxSjZlmHnwm3BUvO1YHWXe5hYSQp4XqpX0NS+NEw0Hfr3hHw+u8gzAkUavovfyuHlGluw+58hjvOO4kcd+w3A0ouDwFITeb0zKA/A6b5vitC+lAWxYb5WFMLyDfewR0JbT8UaWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm6pPt05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm6pPt05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC2C1F000FF;
	Sat, 12 Sep 2026 09:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204633;
	bh=KbMakFDNQ7DXcsM5boz6xNk3J0pdkxb7qOSchOKIZpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm6pPt054ckPohn7MbWXtueJOSv+/e0FUCWhXZw+Ueoy6pY/WM+tPqH+C4xfJ2YYD
	 iqKbc0FEKu2coVPIwLEI3enXG5RAnVtTm14KMT1hv0actv1iY9H0n62ejAgUij9tLe
	 wNKt2PlxQ+/2rGlkSob2uZrPBjzBgPkf5JA0G7Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1646/1815] irqchip/gic-v5: Check get_logical_index() return value in MADT IAFFID parsing
Date: Sat, 12 Sep 2026 08:56:36 +0200
Message-ID: <20260912065727.634979906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit 328affc639ce9873a7a0a3fd6b8339f19767529b ]

In gic_acpi_parse_iaffid() a given MADT GICC entry might not correspond
to a logical cpu recognized by the kernel, resulting in the cpu variable
initialization to an error value.

Currently, the get_logical_index() return value is not checked for failure,
which might result in out-of-bounds memory corruption while trying to
index a per_cpu variable array.

Add a check to evaluate get_logical_index() return value.

Fixes: 35866efa52fe ("irqchip/gic-v5: Add ACPI IRS probing")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-1-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index 3028a8bbbf68b..0bd9ae9ae12ef 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -874,6 +874,8 @@ static int __init gic_acpi_parse_iaffid(union acpi_subtable_headers *header,
 		return 0;
 
 	cpu = get_logical_index(gicc->arm_mpidr);
+	if (cpu < 0)
+		return 0;
 
 	if (gicc->iaffid & ~GENMASK(current_iaffid_bits - 1, 0)) {
 		pr_warn("CPU %d iaffid 0x%x exceeds IRS iaffid bits\n", cpu, gicc->iaffid);
-- 
2.53.0



