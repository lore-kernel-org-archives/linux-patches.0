Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6F32143D;
	Mon, 27 Oct 2025 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592966; cv=none; b=RbIdyjzMi0mu+l0W0mu4fIBHvzyww8sdU/tcJVdI9pFPeLkfusDk0M5W7+Q/iZpx5cFwwfhvRM2FDNlZhoTOilkGuh83z/cPApwFIpMAAyoU6YHSS8JPmKF+dfHuUHV0QGEpdjsCEb58ewAIoUnwNFXcO6JmSqgAVS3hcohh1dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592966; c=relaxed/simple;
	bh=ejFlTbyRsr7w/BBrsJwNZjFnSOOtfcFe/8VKWJK1G/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxia/rMtD6x1RwhpEHrfog2lAJ1MsHO+waVATZ17rwJzrIHFACOrskItEN8R43g/VitSlCRhYJ0GOoj4zogAqlrfr+1eqmaBEJchAEQqfYD9rwb+X8y7Gcp5A+hqm9/gEv9sWMCmhRYe75NIalwFWK0gzNc6mJbZXf+iUXsRck4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ys6181wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ys6181wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA6BC4CEF1;
	Mon, 27 Oct 2025 19:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592965;
	bh=ejFlTbyRsr7w/BBrsJwNZjFnSOOtfcFe/8VKWJK1G/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys6181wgnv7l9iOF9lu1qUKGB/ccGB+1RULJDlZw5o2Ao3bU3+JzN7AtjrklASf4w
	 TJyxqFBwkQ1FDFK+QTxu26WQS/Kd3CU1BPh9F/VYTQQFMOx2gaihzS84DNN91gu50V
	 7YQUrTii8ArHOnfBwxyKv+ctBbIu1Ap0w78FCdiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/117] RISC-V: Dont print details of CPUs disabled in DT
Date: Mon, 27 Oct 2025 19:36:47 +0100
Message-ID: <20251027183456.217068212@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
index f6b13e9f5e6cb..3dbc8cc557dd1 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -62,10 +62,8 @@ int __init riscv_early_of_processor_hartid(struct device_node *node, unsigned lo
 		return -ENODEV;
 	}
 
-	if (!of_device_is_available(node)) {
-		pr_info("CPU with hartid=%lu is not available\n", *hart);
+	if (!of_device_is_available(node))
 		return -ENODEV;
-	}
 
 	if (of_property_read_string(node, "riscv,isa-base", &isa))
 		goto old_interface;
-- 
2.51.0



