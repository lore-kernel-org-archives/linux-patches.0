Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B37A2D5A14;
	Mon, 27 Oct 2025 19:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592387; cv=none; b=dNvO19krrffLQWVDp5jwi+aNrEIqoY/b4ixukIKlDK5Gs9uR7Z0jrzKMnS/RVc2W0BdNye96Bfs4rAtfnA4YOOpfTZxRypwNH0cLQhLsWDBAHiqS01wc2d4kThLYHxPPa/NS28LzkcLkGsjCzxAajdsC0eAW7VrJW9hFAHKmQUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592387; c=relaxed/simple;
	bh=OGpFUnvureqSSH/yURz9qggxKB6Fgwn0sCYOHDuHo2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuisPfn9tbAc7udnAZGTJIFarDFT0godhc9RqvsWr9wtIbl21MOjs9T3cke+WWP6eHPajXH/3iufoHQin/Rt7bn9PQWapOFjYwPT2JAAo0C3RpeUzenMb15Hm8LNeWNvNCz52GQSQBw6RoDvDHlPnCXlgRUDoM99GPy7E2rGqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZdPVg0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZdPVg0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DF0C4CEF1;
	Mon, 27 Oct 2025 19:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592387;
	bh=OGpFUnvureqSSH/yURz9qggxKB6Fgwn0sCYOHDuHo2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZdPVg0OzuYzifDzAlPfQUFIPc6p98iuNRM3neucY6SAqaiq98vIGM3Tqv3X7iHdm
	 9+U3L8IAvg4Fi74GhsvYQOkfFx7BmZ1e5KxKS8Pp4U0ZRUMaByBm78sRzLbIXfM71f
	 wN3z9rPDjuF9zzLcD7SDrJ5BcsC3TQY3TKJPOI+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/157] RISC-V: Dont print details of CPUs disabled in DT
Date: Mon, 27 Oct 2025 19:36:02 +0100
Message-ID: <20251027183503.970945883@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f76181dc634d..e642b3dc42d27 100644
--- a/arch/riscv/kernel/cpu.c
+++ b/arch/riscv/kernel/cpu.c
@@ -32,10 +32,8 @@ int riscv_of_processor_hartid(struct device_node *node, unsigned long *hart)
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



