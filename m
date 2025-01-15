Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08063248BC8;
	Wed, 15 Jan 2025 10:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937625; cv=none; b=QHZDzOYEBm7FNpX9ocUSOe1Nl/5ysYyfmajYP+kGN4WzYmMAbGLHC/Hd0BKy+YruHGeC2S9HvvIgqkShzBY2w3tOTmMogeNEm1o0t08fmcxUkL+t7WonK12qaiNOBuLRrcJsda0dVY5zlIkNa8O/4AGpcPU6i9W+PtWbc/6KUvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937625; c=relaxed/simple;
	bh=Q7+Y0gAmOuUjAAqO1f+yCMYXco5aI1ntLbuZR7u3Qjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as5Xf+p+0MAv27Aatnvqu2WabT/r3Tkqn202A4WmZK0XfEnbwBLh3dycP8vbzCHEIwx1LqoNEc0OELl9PdyGQDIvy5weW63bCnqI3fpo1Z/ZtZJkTV2bDPXuAHKLITha49yy0k14hXM92/nwNoUkoOo0uWqmYJsULdNOLtApcC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfYUkuOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfYUkuOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514F8C4CEE1;
	Wed, 15 Jan 2025 10:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937624;
	bh=Q7+Y0gAmOuUjAAqO1f+yCMYXco5aI1ntLbuZR7u3Qjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfYUkuOxngXJ9T+LBADBjNwj6qOBaapywUBFEZ+sbxta14cxTlxarhyD6o8DAVch8
	 CfOHi6ICQu3g/3qk1VKdvGiLtrX3zHeR89Pj/4fz0xkamQPaQt0GtDiNo28PsvDJ3m
	 iDnNl30rnvIofDRLSZW9/liD0rGiCVpeDvOTp4ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/92] cpuidle: riscv-sbi: fix device node release in early exit of for_each_possible_cpu
Date: Wed, 15 Jan 2025 11:36:53 +0100
Message-ID: <20250115103548.929890559@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 7e25044b804581b9c029d5a28d8800aebde18043 ]

The 'np' device_node is initialized via of_cpu_device_node_get(), which
requires explicit calls to of_node_put() when it is no longer required
to avoid leaking the resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'np' by means of the __free()
macro, which automatically calls of_node_put() when the variable goes
out of scope. Given that 'np' is only used within the
for_each_possible_cpu(), reduce its scope to release the nood after
every iteration of the loop.

Fixes: 6abf32f1d9c5 ("cpuidle: Add RISC-V SBI CPU idle driver")
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241116-cpuidle-riscv-sbi-cleanup-v3-1-a3a46372ce08@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-riscv-sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-riscv-sbi.c b/drivers/cpuidle/cpuidle-riscv-sbi.c
index af7320a768d2..963d5f171ef7 100644
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -540,12 +540,12 @@ static int sbi_cpuidle_probe(struct platform_device *pdev)
 	int cpu, ret;
 	struct cpuidle_driver *drv;
 	struct cpuidle_device *dev;
-	struct device_node *np, *pds_node;
+	struct device_node *pds_node;
 
 	/* Detect OSI support based on CPU DT nodes */
 	sbi_cpuidle_use_osi = true;
 	for_each_possible_cpu(cpu) {
-		np = of_cpu_device_node_get(cpu);
+		struct device_node *np __free(device_node) = of_cpu_device_node_get(cpu);
 		if (np &&
 		    of_find_property(np, "power-domains", NULL) &&
 		    of_find_property(np, "power-domain-names", NULL)) {
-- 
2.39.5



