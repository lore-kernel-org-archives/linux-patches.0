Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B8935A928;
	Wed,  3 Dec 2025 16:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778909; cv=none; b=DCHrgQtq3DL0WE7T6bbEsN8L0Q5qDVqNPKhNXJxvZzHiaUzJQ7roSB8koCnxAOWEheyDgnb7utpwqPZ9Czv4J4xDYCizGLWF7fO02mnA+slL0Zzx/SCfsviw4YL5RJAoLiLd1HmjPlAu9gNhDQ8JCEpe8b1oqtCE9yekBxn7ikQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778909; c=relaxed/simple;
	bh=hOchLcpuh3XTKuIDjFZLxgowaM0l2CVTTH4jMcbOrmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl+4f9aRgZddl0Z9XHzC2LvPo0irHYUEPobUhLNi15gKUoRU+VcR+Omg2j9jnoKKCooTh5LCgz4UGNvz/DfCwF8BKjjvD30qj3JEMI5MDC3oZH9ExtF02suYChHQVAeIYqoVhU/mfIPLOX3/9FAYzBfVz/YrXeZtsNrfdO6+TTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/CPm7yZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/CPm7yZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD79C4CEF5;
	Wed,  3 Dec 2025 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778908;
	bh=hOchLcpuh3XTKuIDjFZLxgowaM0l2CVTTH4jMcbOrmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/CPm7yZGKdvJYgS9cBCfZIWIqtxGqW+Wg1TlVUKC2loi5WlBq1jisf9PozEt/Lmu
	 Oc3R7jDp1wJbzb7iqw33wG00qWesl9d+3CKTBtEZq2jkpnvdqZgOzby5bvJCcTyyrz
	 rRVTEkGXhWCmppZI2mIDNrUNgmAanh8cvAWTnPLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Pierre Gondois <pierre.gondois@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 069/568] ACPI: PPTT: Update acpi_find_last_cache_level() to acpi_get_cache_info()
Date: Wed,  3 Dec 2025 16:21:11 +0100
Message-ID: <20251203152443.234443926@linuxfoundation.org>
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

[ Upstream commit bd500361a937c03a3da57178287ce543c8f3681b ]

acpi_find_last_cache_level() allows to find the last level of cache
for a given CPU. The function is only called on arm64 ACPI based
platforms to check for cache information that would be missing in
the CLIDR_EL1 register.
To allow populating (struct cpu_cacheinfo).num_leaves by only parsing
a PPTT, update acpi_find_last_cache_level() to get the 'split_levels',
i.e. the number of cache levels being split in data/instruction
caches.

It is assumed that there will not be data/instruction caches above a
unified cache.
If a split level consist of one data cache and no instruction cache
(or opposite), then the missing cache will still be populated
by default with minimal cache information, and maximal cpumask
(all non-existing caches have the same fw_token).

Suggested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Rafael J. Wysocki  <rafael.j.wysocki@intel.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20230104183033.755668-6-pierre.gondois@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cacheinfo.c |   11 +++---
 drivers/acpi/pptt.c           |   76 +++++++++++++++++++++++++++---------------
 include/linux/cacheinfo.h     |    9 +++-
 3 files changed, 63 insertions(+), 33 deletions(-)

--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -46,7 +46,7 @@ static void ci_leaf_init(struct cacheinf
 int init_cache_level(unsigned int cpu)
 {
 	unsigned int ctype, level, leaves;
-	int fw_level;
+	int fw_level, ret;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 
 	for (level = 1, leaves = 0; level <= MAX_CACHE_LEVEL; level++) {
@@ -59,10 +59,13 @@ int init_cache_level(unsigned int cpu)
 		leaves += (ctype == CACHE_TYPE_SEPARATE) ? 2 : 1;
 	}
 
-	if (acpi_disabled)
+	if (acpi_disabled) {
 		fw_level = of_find_last_cache_level(cpu);
-	else
-		fw_level = acpi_find_last_cache_level(cpu);
+	} else {
+		ret = acpi_get_cache_info(cpu, &fw_level, NULL);
+		if (ret < 0)
+			return ret;
+	}
 
 	if (fw_level < 0)
 		return fw_level;
--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -81,6 +81,7 @@ static inline bool acpi_pptt_match_type(
  * acpi_pptt_walk_cache() - Attempt to find the requested acpi_pptt_cache
  * @table_hdr: Pointer to the head of the PPTT table
  * @local_level: passed res reflects this cache level
+ * @split_levels: Number of split cache levels (data/instruction).
  * @res: cache resource in the PPTT we want to walk
  * @found: returns a pointer to the requested level if found
  * @level: the requested cache level
@@ -100,6 +101,7 @@ static inline bool acpi_pptt_match_type(
  */
 static unsigned int acpi_pptt_walk_cache(struct acpi_table_header *table_hdr,
 					 unsigned int local_level,
+					 unsigned int *split_levels,
 					 struct acpi_subtable_header *res,
 					 struct acpi_pptt_cache **found,
 					 unsigned int level, int type)
@@ -113,8 +115,17 @@ static unsigned int acpi_pptt_walk_cache
 	while (cache) {
 		local_level++;
 
+		if (!(cache->flags & ACPI_PPTT_CACHE_TYPE_VALID)) {
+			cache = fetch_pptt_cache(table_hdr, cache->next_level_of_cache);
+			continue;
+		}
+
+		if (split_levels &&
+		    (acpi_pptt_match_type(cache->attributes, ACPI_PPTT_CACHE_TYPE_DATA) ||
+		     acpi_pptt_match_type(cache->attributes, ACPI_PPTT_CACHE_TYPE_INSTR)))
+			*split_levels = local_level;
+
 		if (local_level == level &&
-		    cache->flags & ACPI_PPTT_CACHE_TYPE_VALID &&
 		    acpi_pptt_match_type(cache->attributes, type)) {
 			if (*found != NULL && cache != *found)
 				pr_warn("Found duplicate cache level/type unable to determine uniqueness\n");
@@ -135,8 +146,8 @@ static unsigned int acpi_pptt_walk_cache
 static struct acpi_pptt_cache *
 acpi_find_cache_level(struct acpi_table_header *table_hdr,
 		      struct acpi_pptt_processor *cpu_node,
-		      unsigned int *starting_level, unsigned int level,
-		      int type)
+		      unsigned int *starting_level, unsigned int *split_levels,
+		      unsigned int level, int type)
 {
 	struct acpi_subtable_header *res;
 	unsigned int number_of_levels = *starting_level;
@@ -149,7 +160,8 @@ acpi_find_cache_level(struct acpi_table_
 		resource++;
 
 		local_level = acpi_pptt_walk_cache(table_hdr, *starting_level,
-						   res, &ret, level, type);
+						   split_levels, res, &ret,
+						   level, type);
 		/*
 		 * we are looking for the max depth. Since its potentially
 		 * possible for a given node to have resources with differing
@@ -165,29 +177,29 @@ acpi_find_cache_level(struct acpi_table_
 }
 
 /**
- * acpi_count_levels() - Given a PPTT table, and a CPU node, count the caches
+ * acpi_count_levels() - Given a PPTT table, and a CPU node, count the cache
+ * levels and split cache levels (data/instruction).
  * @table_hdr: Pointer to the head of the PPTT table
  * @cpu_node: processor node we wish to count caches for
+ * @levels: Number of levels if success.
+ * @split_levels:	Number of split cache levels (data/instruction) if
+ *			success. Can by NULL.
  *
  * Given a processor node containing a processing unit, walk into it and count
  * how many levels exist solely for it, and then walk up each level until we hit
  * the root node (ignore the package level because it may be possible to have
- * caches that exist across packages). Count the number of cache levels that
- * exist at each level on the way up.
- *
- * Return: Total number of levels found.
+ * caches that exist across packages). Count the number of cache levels and
+ * split cache levels (data/instruction) that exist at each level on the way
+ * up.
  */
-static int acpi_count_levels(struct acpi_table_header *table_hdr,
-			     struct acpi_pptt_processor *cpu_node)
+static void acpi_count_levels(struct acpi_table_header *table_hdr,
+			      struct acpi_pptt_processor *cpu_node,
+			      unsigned int *levels, unsigned int *split_levels)
 {
-	int total_levels = 0;
-
 	do {
-		acpi_find_cache_level(table_hdr, cpu_node, &total_levels, 0, 0);
+		acpi_find_cache_level(table_hdr, cpu_node, levels, split_levels, 0, 0);
 		cpu_node = fetch_pptt_node(table_hdr, cpu_node->parent);
 	} while (cpu_node);
-
-	return total_levels;
 }
 
 /**
@@ -326,7 +338,7 @@ static struct acpi_pptt_cache *acpi_find
 
 	while (cpu_node && !found) {
 		found = acpi_find_cache_level(table_hdr, cpu_node,
-					      &total_levels, level, acpi_type);
+					      &total_levels, NULL, level, acpi_type);
 		*node = cpu_node;
 		cpu_node = fetch_pptt_node(table_hdr, cpu_node->parent);
 	}
@@ -597,36 +609,48 @@ static int check_acpi_cpu_flag(unsigned
 }
 
 /**
- * acpi_find_last_cache_level() - Determines the number of cache levels for a PE
+ * acpi_get_cache_info() - Determine the number of cache levels and
+ * split cache levels (data/instruction) and for a PE.
  * @cpu: Kernel logical CPU number
+ * @levels: Number of levels if success.
+ * @split_levels:	Number of levels being split (i.e. data/instruction)
+ *			if success. Can by NULL.
  *
  * Given a logical CPU number, returns the number of levels of cache represented
  * in the PPTT. Errors caused by lack of a PPTT table, or otherwise, return 0
  * indicating we didn't find any cache levels.
  *
- * Return: Cache levels visible to this core.
+ * Return: -ENOENT if no PPTT table or no PPTT processor struct found.
+ *	   0 on success.
  */
-int acpi_find_last_cache_level(unsigned int cpu)
+int acpi_get_cache_info(unsigned int cpu, unsigned int *levels,
+			unsigned int *split_levels)
 {
 	struct acpi_pptt_processor *cpu_node;
 	struct acpi_table_header *table;
-	int number_of_levels = 0;
 	u32 acpi_cpu_id;
 
+	*levels = 0;
+	if (split_levels)
+		*split_levels = 0;
+
 	table = acpi_get_pptt();
 	if (!table)
 		return -ENOENT;
 
-	pr_debug("Cache Setup find last level CPU=%d\n", cpu);
+	pr_debug("Cache Setup: find cache levels for CPU=%d\n", cpu);
 
 	acpi_cpu_id = get_acpi_id_for_cpu(cpu);
 	cpu_node = acpi_find_processor_node(table, acpi_cpu_id);
-	if (cpu_node)
-		number_of_levels = acpi_count_levels(table, cpu_node);
+	if (!cpu_node)
+		return -ENOENT;
+
+	acpi_count_levels(table, cpu_node, levels, split_levels);
 
-	pr_debug("Cache Setup find last level level=%d\n", number_of_levels);
+	pr_debug("Cache Setup: last_level=%d split_levels=%d\n",
+		 *levels, split_levels ? *split_levels : -1);
 
-	return number_of_levels;
+	return 0;
 }
 
 /**
--- a/include/linux/cacheinfo.h
+++ b/include/linux/cacheinfo.h
@@ -88,19 +88,22 @@ bool last_level_cache_is_shared(unsigned
 int detect_cache_attributes(unsigned int cpu);
 #ifndef CONFIG_ACPI_PPTT
 /*
- * acpi_find_last_cache_level is only called on ACPI enabled
+ * acpi_get_cache_info() is only called on ACPI enabled
  * platforms using the PPTT for topology. This means that if
  * the platform supports other firmware configuration methods
  * we need to stub out the call when ACPI is disabled.
  * ACPI enabled platforms not using PPTT won't be making calls
  * to this function so we need not worry about them.
  */
-static inline int acpi_find_last_cache_level(unsigned int cpu)
+static inline
+int acpi_get_cache_info(unsigned int cpu,
+			unsigned int *levels, unsigned int *split_levels)
 {
 	return 0;
 }
 #else
-int acpi_find_last_cache_level(unsigned int cpu);
+int acpi_get_cache_info(unsigned int cpu,
+			unsigned int *levels, unsigned int *split_levels);
 #endif
 
 const struct attribute_group *cache_get_priv_group(struct cacheinfo *this_leaf);


