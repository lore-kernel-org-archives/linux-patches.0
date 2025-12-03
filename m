Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9985F34FF77;
	Wed,  3 Dec 2025 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778810; cv=none; b=niVN9vfW+egnjd0LZcpPfUnYBN380dCiuMZibFQngzROLm7DOfAp57H5udSl+mix9aSUlbxHTq7kHenTADMIaKqB1g5UhGrCn8FHmfwgYkX+N1+QUHLn/oOOw7pRBPmI1i7FAKOLSQJC+y53fo3ZfCZLyq9Em2KvqVpwQY8H9Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778810; c=relaxed/simple;
	bh=W3tYUGV7WSW5j/bfS+m+4Z6KcT6efi1C4VuvoE1J/dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpTkgasxu6QPsJYa1ZEDaKR1xEuIQ+0AszRaI+E0yuJ9vDxQ4d8GAimwaqVVgzUL39tN4+bijt06wvu5/1FWvK94QAkTNjaS/g/1GDTJP3YfaNj9YTW/i+1CeiYsDm1qEcvymcdiEASroRUuV2JRdHOb92C2Vz/eMqFped7g+8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/GT5SLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/GT5SLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9B6C4CEF5;
	Wed,  3 Dec 2025 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778810;
	bh=W3tYUGV7WSW5j/bfS+m+4Z6KcT6efi1C4VuvoE1J/dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/GT5SLvA32qOjFDxanVERVY3DBMmXJs3CB73wgyqRsIFK02UiJALMc/eabAP7ib4
	 g9yd6wgZZnjNTn12dv5nySw4HoJdMm3uxcdc42pZNFzEo/TqXT+xkvGDHtMwf8sQC9
	 yFXw6sJ63y76QPp5FA5wu20LUO6eSYdWPl7RLfp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 065/568] cacheinfo: Use RISC-Vs init_cache_level() as generic OF implementation
Date: Wed,  3 Dec 2025 16:21:07 +0100
Message-ID: <20251203152443.085396796@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit c3719bd9eeb2edf84bd263d662e36ca0ba262a23 ]

RISC-V's implementation of init_of_cache_level() is following
the Devicetree Specification v0.3 regarding caches, cf.:
- s3.7.3 'Internal (L1) Cache Properties'
- s3.8 'Multi-level and Shared Cache Nodes'

Allow reusing the implementation by moving it.

Also make 'levels', 'leaves' and 'level' unsigned int.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20230104183033.755668-2-pierre.gondois@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cacheinfo.c |   39 -------------------------------------
 drivers/base/cacheinfo.c      |   44 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/cacheinfo.h     |    1 
 3 files changed, 46 insertions(+), 38 deletions(-)

--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -115,44 +115,7 @@ static void fill_cacheinfo(struct cachei
 
 int init_cache_level(unsigned int cpu)
 {
-	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
-	struct device_node *np = of_cpu_device_node_get(cpu);
-	struct device_node *prev = NULL;
-	int levels = 0, leaves = 0, level;
-
-	if (of_property_read_bool(np, "cache-size"))
-		++leaves;
-	if (of_property_read_bool(np, "i-cache-size"))
-		++leaves;
-	if (of_property_read_bool(np, "d-cache-size"))
-		++leaves;
-	if (leaves > 0)
-		levels = 1;
-
-	prev = np;
-	while ((np = of_find_next_cache_node(np))) {
-		of_node_put(prev);
-		prev = np;
-		if (!of_device_is_compatible(np, "cache"))
-			break;
-		if (of_property_read_u32(np, "cache-level", &level))
-			break;
-		if (level <= levels)
-			break;
-		if (of_property_read_bool(np, "cache-size"))
-			++leaves;
-		if (of_property_read_bool(np, "i-cache-size"))
-			++leaves;
-		if (of_property_read_bool(np, "d-cache-size"))
-			++leaves;
-		levels = level;
-	}
-
-	of_node_put(np);
-	this_cpu_ci->num_levels = levels;
-	this_cpu_ci->num_leaves = leaves;
-
-	return 0;
+	return init_of_cache_level(cpu);
 }
 
 int populate_cache_leaves(unsigned int cpu)
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -223,8 +223,52 @@ static int cache_setup_of_node(unsigned
 
 	return 0;
 }
+
+int init_of_cache_level(unsigned int cpu)
+{
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
+	struct device_node *np = of_cpu_device_node_get(cpu);
+	struct device_node *prev = NULL;
+	unsigned int levels = 0, leaves = 0, level;
+
+	if (of_property_read_bool(np, "cache-size"))
+		++leaves;
+	if (of_property_read_bool(np, "i-cache-size"))
+		++leaves;
+	if (of_property_read_bool(np, "d-cache-size"))
+		++leaves;
+	if (leaves > 0)
+		levels = 1;
+
+	prev = np;
+	while ((np = of_find_next_cache_node(np))) {
+		of_node_put(prev);
+		prev = np;
+		if (!of_device_is_compatible(np, "cache"))
+			break;
+		if (of_property_read_u32(np, "cache-level", &level))
+			break;
+		if (level <= levels)
+			break;
+		if (of_property_read_bool(np, "cache-size"))
+			++leaves;
+		if (of_property_read_bool(np, "i-cache-size"))
+			++leaves;
+		if (of_property_read_bool(np, "d-cache-size"))
+			++leaves;
+		levels = level;
+	}
+
+	of_node_put(np);
+	this_cpu_ci->num_levels = levels;
+	this_cpu_ci->num_leaves = leaves;
+
+	return 0;
+}
+
 #else
 static inline int cache_setup_of_node(unsigned int cpu) { return 0; }
+int init_of_cache_level(unsigned int cpu) { return 0; }
 #endif
 
 int __weak cache_setup_acpi(unsigned int cpu)
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -80,6 +80,7 @@ struct cpu_cacheinfo {
 
 struct cpu_cacheinfo *get_cpu_cacheinfo(unsigned int cpu);
 int init_cache_level(unsigned int cpu);
+int init_of_cache_level(unsigned int cpu);
 int populate_cache_leaves(unsigned int cpu);
 int cache_setup_acpi(unsigned int cpu);
 bool last_level_cache_is_valid(unsigned int cpu);


