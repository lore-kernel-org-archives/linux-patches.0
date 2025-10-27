Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9116E31E0E1;
	Mon, 27 Oct 2025 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591984; cv=none; b=Fkc/+S1ve//EpnS282UB01TWM3bdppQrXH85Rs3kRNveQT1pyskz6Qn8q/zFv+57f7N3L0o6O/C+4ieXdcAtDFOvQT7cpPmRQqoh8vkjxkHE1bdhanALC9ZgRZ39mj+wAGtdzSNxpVCVsj9tD494f697+4b/f0p4pNIywqoJjMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591984; c=relaxed/simple;
	bh=QwltvsOR+arcQVwyFB5tsF9R74FsVdrIC2uekIbDafM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqzWwUlZhIFDt/M2pnfQNVrVZYGm/Bk2nuLm5fBWe8iKCx1BNMbBx+srK7dH1Qef0gMz8+MKRPxLNGygG+lkW4tcw9zlqScROUF7rQ+XJy6Qxn8XQlCmX/BJQmiHSPlNoClHehtktxv8GerCpGvMGqgjM+NCnD63IHMBj3zNVTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7OKSOK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7OKSOK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22377C4CEF1;
	Mon, 27 Oct 2025 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591984;
	bh=QwltvsOR+arcQVwyFB5tsF9R74FsVdrIC2uekIbDafM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7OKSOK+BJ+P/9UhXe+DWiaesd2QZTnsu83Mdn6JESqEe1XptPeehaTriPXZez66D
	 TcQ2yMoyN4t0UotSXntD8LzL5vWix80g/UcGrVZcpUbCME7Q+8248Yyx+NHCl1CPXE
	 fkz4FpzX2+DHVRN96I8gxNYtXlpNveX1J36M9JcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/123] RISC-V: Dont print details of CPUs disabled in DT
Date: Mon, 27 Oct 2025 19:35:54 +0100
Message-ID: <20251027183448.378204295@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



