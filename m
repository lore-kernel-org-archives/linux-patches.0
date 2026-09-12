Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9E8348C75;
	Sat, 12 Sep 2026 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224930; cv=none; b=IvYu/FVYJUowJKn31Q7qP4516SmQn4xvP3w5GzpCQxzcqQ7Y+Hny3D1yEcgRMZEQxoExMo/G2QePXYz+RA5IJxWgf3KfQ3tyyAEAMHiN297p0ljAP/bKsCibGHfoD/ZioD1fVfWPbx0l+YQruZQtFpZgtsqUSJyTOWQkusGr02E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224930; c=relaxed/simple;
	bh=0iELchOtp85h2nVRmxTL2oo2ti8QEH0u/APXwLh5R44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBcDlfBiw0ZA40hbkEmribugPO57hMpJ0ObrrwOJs+Wbf02lE9iDvZzLOoecedIoARoDTkUyryVEQS1NV86y5C51I56skFTQOT6OPX6RQVGx0BQVgMzmgyKLCCP1IeQxfSED9p02vkTbFKMS3iwqFdYPj6meHgAB3vrqvBA9AZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ar65HuL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ar65HuL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6EA1F000FF;
	Sat, 12 Sep 2026 14:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224928;
	bh=a+TUETtsrx8z+53RFq3FfGLgnIRqpnMubs7sTnv2/Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar65HuL+q0N0S9xBBnsmd0l6H4r2JD7HP4XE7E5wy6my4M5FfskVgJCOTg8MHT6V/
	 a290tthOZ83ti7n82jTbPrKZiklNAmO5Zzt5c2x4Tm4gPspn8wGkSCiKPNRb4NuYaF
	 3fWnQSQzRtdBbJnwtvbkksqbY9K8TVHKTGCvQZ+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	David Rientjes <rientjes@google.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Itaru Kitayama <itaru.kitayama@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yang Shi <shy828301@gmail.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1052/1424] selftests/mm: support multi-size THP interface in thp_settings
Date: Sat, 12 Sep 2026 08:58:04 +0200
Message-ID: <20260912065630.864810874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 4f5070a5e40db2e9dbf5fff4ec678d6fbb338d5c ]

Save and restore the new per-size hugepage enabled setting, if available
on the running kernel.

Since the number of per-size directories is not fixed, solve this as
simply as possible by catering for a maximum number in the thp_settings
struct (20).  Each array index is the order.  The value of THP_NEVER is
changed to 0 so that all of these new settings default to THP_NEVER and
the user only needs to fill in the ones they want to enable.

Link: https://lkml.kernel.org/r/20231207161211.2374093-8-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 15828a150c58 ("selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   |  3 ++
 tools/testing/selftests/mm/thp_settings.c | 55 ++++++++++++++++++++++-
 tools/testing/selftests/mm/thp_settings.h | 11 ++++-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index b15e7fd701769..7bd3baa9d34b4 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1141,6 +1141,7 @@ static void parse_test_type(int argc, const char **argv)
 
 int main(int argc, const char **argv)
 {
+	int hpage_pmd_order;
 	struct thp_settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
@@ -1175,11 +1176,13 @@ int main(int argc, const char **argv)
 		exit(EXIT_FAILURE);
 	}
 	hpage_pmd_nr = hpage_pmd_size / page_size;
+	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
+	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
 
 	save_settings();
 	thp_push_settings(&default_settings);
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index 5e8ec792cac70..a4163438108ec 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -16,9 +16,10 @@ static struct thp_settings saved_settings;
 static char dev_queue_read_ahead_path[PATH_MAX];
 
 static const char * const thp_enabled_strings[] = {
+	"never",
 	"always",
+	"inherit",
 	"madvise",
-	"never",
 	NULL
 };
 
@@ -198,6 +199,10 @@ void thp_write_num(const char *name, unsigned long num)
 
 void thp_read_settings(struct thp_settings *settings)
 {
+	unsigned long orders = thp_supported_orders();
+	char path[PATH_MAX];
+	int i;
+
 	*settings = (struct thp_settings) {
 		.thp_enabled = thp_read_string("enabled", thp_enabled_strings),
 		.thp_defrag = thp_read_string("defrag", thp_defrag_strings),
@@ -218,11 +223,26 @@ void thp_read_settings(struct thp_settings *settings)
 	};
 	if (dev_queue_read_ahead_path[0])
 		settings->read_ahead_kb = read_num(dev_queue_read_ahead_path);
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & orders)) {
+			settings->hugepages[i].enabled = THP_NEVER;
+			continue;
+		}
+		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		settings->hugepages[i].enabled =
+			thp_read_string(path, thp_enabled_strings);
+	}
 }
 
 void thp_write_settings(struct thp_settings *settings)
 {
 	struct khugepaged_settings *khugepaged = &settings->khugepaged;
+	unsigned long orders = thp_supported_orders();
+	char path[PATH_MAX];
+	int enabled;
+	int i;
 
 	thp_write_string("enabled", thp_enabled_strings[settings->thp_enabled]);
 	thp_write_string("defrag", thp_defrag_strings[settings->thp_defrag]);
@@ -242,6 +262,15 @@ void thp_write_settings(struct thp_settings *settings)
 
 	if (dev_queue_read_ahead_path[0])
 		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		if (!((1 << i) & orders))
+			continue;
+		snprintf(path, PATH_MAX, "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		enabled = settings->hugepages[i].enabled;
+		thp_write_string(path, thp_enabled_strings[enabled]);
+	}
 }
 
 struct thp_settings *thp_current_settings(void)
@@ -294,3 +323,27 @@ void thp_set_read_ahead_path(char *path)
 		sizeof(dev_queue_read_ahead_path));
 	dev_queue_read_ahead_path[sizeof(dev_queue_read_ahead_path) - 1] = '\0';
 }
+
+unsigned long thp_supported_orders(void)
+{
+	unsigned long orders = 0;
+	char path[PATH_MAX];
+	char buf[256];
+	int ret;
+	int i;
+
+	for (i = 0; i < NR_ORDERS; i++) {
+		ret = snprintf(path, PATH_MAX, THP_SYSFS "hugepages-%ukB/enabled",
+			(getpagesize() >> 10) << i);
+		if (ret >= PATH_MAX) {
+			printf("%s: Pathname is too long\n", __func__);
+			exit(EXIT_FAILURE);
+		}
+
+		ret = read_file(path, buf, sizeof(buf));
+		if (ret)
+			orders |= 1UL << i;
+	}
+
+	return orders;
+}
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
index ff3d98c30617b..71cbff05f4c7f 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/thp_settings.h
@@ -7,9 +7,10 @@
 #include <stdint.h>
 
 enum thp_enabled {
+	THP_NEVER,
 	THP_ALWAYS,
+	THP_INHERIT,
 	THP_MADVISE,
-	THP_NEVER,
 };
 
 enum thp_defrag {
@@ -29,6 +30,12 @@ enum shmem_enabled {
 	SHMEM_FORCE,
 };
 
+#define NR_ORDERS 20
+
+struct hugepages_settings {
+	enum thp_enabled enabled;
+};
+
 struct khugepaged_settings {
 	bool defrag;
 	unsigned int alloc_sleep_millisecs;
@@ -46,6 +53,7 @@ struct thp_settings {
 	bool use_zero_page;
 	struct khugepaged_settings khugepaged;
 	unsigned long read_ahead_kb;
+	struct hugepages_settings hugepages[NR_ORDERS];
 };
 
 int read_file(const char *path, char *buf, size_t buflen);
@@ -67,5 +75,6 @@ void thp_restore_settings(void);
 void thp_save_settings(void);
 
 void thp_set_read_ahead_path(char *path);
+unsigned long thp_supported_orders(void);
 
 #endif /* __THP_SETTINGS_H__ */
-- 
2.53.0



