Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962DB2C3745;
	Mon, 27 Oct 2025 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591684; cv=none; b=JJ+OlktGveOVeguPMP3duz7wXMDlEscJQA7QxMPRuRUudYiknFXBBsfzd5aqacDAANpiuXufqYJFnOWdsIo1ywgfskw2o6fGbGuJKUAvS7cwadWlEMH+OTUVoA+BiFU0GqI9xRphcenCB+/FQlut+r6SzyqTSKbM+g5FtPeOReg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591684; c=relaxed/simple;
	bh=UdUHLlbpcHzn8tvFcBqb9X3YamRusnm/K2uRxU7+LGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1Myx5dCBINe0lraXrVAVEl5hfoOo5sUeO/2M0b3Q+M0EWo056IdO2/++S/V2aGe3aNGmwQHrYK+zgcoUcsFQIpp3SILZhy7DcT+1+RpuCqlC1T++4AxDuhQQgAlRFQI97npCpPc07qFzWmYipTvkRre4SRJ0nJUtuVt8IiCsEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMVldEzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMVldEzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B17C4CEF1;
	Mon, 27 Oct 2025 19:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591684;
	bh=UdUHLlbpcHzn8tvFcBqb9X3YamRusnm/K2uRxU7+LGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMVldEzDmsfa8U0z7AyXeCUD6taw7PLNBZ7Rh9QEgNVZ1sihvUeaunMrY2Lx85TM+
	 9ZkbikHSON+sHM56Oeeildp4nRPr0RboZSnRwRWGayfekfSScaAAY+p0Il86cui/Jf
	 rQaKoU6CBVZocK0BTdifjbAranA5URg/0oVmmO3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/332] RISC-V: Dont print details of CPUs disabled in DT
Date: Mon, 27 Oct 2025 19:35:43 +0100
Message-ID: <20251027183532.513900812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit d2721bb165b3ee00dd23525885381af07fec852a ]

Early boot stages may disable CPU DT nodes for unavailable
CPUs based on SKU, pinstraps, eFuse, etc. Currently, the
riscv_early_of_processor_hartid() prints details of a CPU
if it is disabled in DT which has no value and gives a
false impression to the users that there some issue with
the CPU.

Fixes: e3d794d555cd ("riscv: treat cpu devicetree nodes without status as enabled")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20251014163009.182381-1-apatel@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
index 11d6d6cc61d51..39013aedbe0ab 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -27,10 +27,8 @@ int riscv_of_processor_hartid(struct device_node *node, unsigned long *hart)
 		return -ENODEV;
 	}
 
-	if (!of_device_is_available(node)) {
-		pr_info("CPU with hartid=%lu is not available\n", *hart);
+	if (!of_device_is_available(node))
 		return -ENODEV;
-	}
 
 	if (of_property_read_string(node, "riscv,isa", &isa)) {
 		pr_warn("CPU with hartid=%lu has no \"riscv,isa\" property\n", *hart);
-- 
2.51.0



