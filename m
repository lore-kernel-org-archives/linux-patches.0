Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99142248BB3;
	Wed, 15 Jan 2025 10:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938076; cv=none; b=krt/uccg6eGGeifE7djE8wgYgg2ibaMDCD4PQKnbrBfVYXWo2wUR1TAFI1NUfd5OkVVjKBK6TpwJd0mQZZm3tmRMGuL6yCUcxZdEn4gwA7HZ39RIRcHMHFTvQgzQzhQcMeox+Z/ukdCPHgQiMromRXuEjSq3V+Z9wd+/pGtOYJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938076; c=relaxed/simple;
	bh=VB25GU4WhXi+S6HESnARe9e/HoHN5VwHVCpzSM/PGAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtw9UpQdMxJ7MMBrNCzZJ+vjC29QAwHHplIbRgnsTbdxnS+sTdnWTFooL1fIqWtNtnFoxUAN+tgPnTB/W08+XDBj2owtT4uzO/TjXicp4iLl8eZ0OgK44064XHyAZpiL7zgmRN37BRVkFo+jkIyr589aIzqP2IgdghDE5QmItf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJhE0Edn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJhE0Edn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E351CC4CEDF;
	Wed, 15 Jan 2025 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938076;
	bh=VB25GU4WhXi+S6HESnARe9e/HoHN5VwHVCpzSM/PGAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJhE0EdnhAUvBTQ1Mexci8nMpYenrmcGnOrQVc40RATm4vlozZU13eJfe5zxCgVEh
	 vwYEf6veJMXk9cosZufNqQm6UkGDf8O20ZeklTIr38MLqMbgYv8EtbXo1An8F0P9DB
	 dJayoM/gaou1xROTE9VwzsvP3wnJTaOE+lr7964U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/189] cpuidle: riscv-sbi: fix device node release in early exit of for_each_possible_cpu
Date: Wed, 15 Jan 2025 11:36:12 +0100
Message-ID: <20250115103609.381007340@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index d228b4d18d56..77a1fc668ae2 100644
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -500,12 +500,12 @@ static int sbi_cpuidle_probe(struct platform_device *pdev)
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



