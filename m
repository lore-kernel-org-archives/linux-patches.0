Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395D82D97A6;
	Mon, 27 Oct 2025 19:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592676; cv=none; b=soEHQ8VMHG/iRnJSe/1h2aP0kUa96M6LbFNqqRa527KG/tU6W0RAigNFEHWnyP0YI9woDLR11E7CjvDjBUKQbR+5RoKp9kuBi9JMNGP74uknBBJjxss1/+SrqbX+d1HNDnhwYSKMHKO8bBAYfaN5cEmyoxz1DErXGVDNUFjEbhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592676; c=relaxed/simple;
	bh=yczRW7FwOW1WK1GyHIWGzYwX2r8aIQloNjGmtuSVKBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5SZVVfSN1uSZWrPKMuS9Ze52DORpaQJTcsYFTfY4wXhOqVx/V8oLaq8GGiti3dye3K3cS//agZ7I0czyNc5Yqu9/S3k3RxqJp7zJs8gvFz7fk7+DuNyZ52La1Z6SV+h9MLipM/9lUhceFDK+L0iyoxziUFOaXLFuUqa3TGRzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ku9ih05s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ku9ih05s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C088CC113D0;
	Mon, 27 Oct 2025 19:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592676;
	bh=yczRW7FwOW1WK1GyHIWGzYwX2r8aIQloNjGmtuSVKBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ku9ih05sNf6Tw7EbFDQg3xFETY00WA104XpKy3ncEkD/HsCdpVf5+mKuaizLxFnhY
	 EdB7HGmda4CFaqbiT+PeM26tTTSg8D64vc8La3ATNFx8pgNmkseLuDS6aPd88vkGoE
	 FlhoVWde00lQ4f9uIn45HYxtcuQCD2kkPxeKFAyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/84] RISC-V: Dont print details of CPUs disabled in DT
Date: Mon, 27 Oct 2025 19:36:42 +0100
Message-ID: <20251027183440.231773295@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 88732abecd023..93e794d0e5231 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -61,10 +61,8 @@ int __init riscv_early_of_processor_hartid(struct device_node *node, unsigned lo
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



