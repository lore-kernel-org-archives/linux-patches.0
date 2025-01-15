Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B32248BD0;
	Wed, 15 Jan 2025 10:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938652; cv=none; b=STvz98eKEKt6IJObl3tdZq3fYzpE09xUbD1b1bwGZb6QPm4Ie41vqVf/OVqFgqHaTplZJGXtouMhFq4/DUAEecpEFNfuHm0ASnGz0UGMvNagvjUSsJZeaZKmqyP/FPWHbTHpdHrtgizRgh6f0b3OUnqNf9zPcCNwcO+DXrXG6Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938652; c=relaxed/simple;
	bh=B6C8qtpAXKV4gopT33aBMnnpmQSME3MWwh8CpwOTl6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArFguOV9ry3EzBKv8/tacx5ly6Yfzm47H02HPbqZrLJbkvFPdVQOhsMaESFHZwBmAQ2Yf1fca92Vp1a3fI2REKcRH9rr7eqA0rai/lrodyOHBW1mo/JkTOreRbDaioSADvwyJ7FXhNNlPqGa/88Ihv/vajUErPbjAGHRnYOm/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8J1fbDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8J1fbDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DB9C4CEDF;
	Wed, 15 Jan 2025 10:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938652;
	bh=B6C8qtpAXKV4gopT33aBMnnpmQSME3MWwh8CpwOTl6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8J1fbDFbiwyFEWZeZ6rYTL/MZnVSyHS12+IAN8wfIvya9Uz1I2TigzVEk0yNpSvw
	 9ypYe+Q6ZpZPucEiZB/o+oKkypYAnihoOxcAWEnzBIS/2m91My19GmK+GD6K30sbMx
	 1jVcU3LSj5i3En9LYhqVQFKbREBSGmMm8vYnjTXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/129] cpuidle: riscv-sbi: fix device node release in early exit of for_each_possible_cpu
Date: Wed, 15 Jan 2025 11:37:11 +0100
Message-ID: <20250115103556.600482343@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0fe92409175..71d433bb0ce6 100644
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -534,12 +534,12 @@ static int sbi_cpuidle_probe(struct platform_device *pdev)
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
 		    of_property_present(np, "power-domains") &&
 		    of_property_present(np, "power-domain-names")) {
-- 
2.39.5



