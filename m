Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A008C468D
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C065C340EE;
	Fri, 25 Mar 2022 01:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170781;
	bh=paBVmYOT32iNH/+OtobHjIYpn5sqthR9XqBVKDVTDpI=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=w48HRkdqxvgxoBaI+i4oPOgcKG4Tn8hc2YYWywdKwNySoHovtoTW4rBCEcxnKdMcn
	 B/RUff1lcYZ0F7JicKej4ayyKdhv36NRazOTXuqrz9caGbze5PbG3PbVA2Cw5hSKt+
	 mecTQxawY7DoWlVhXHo1ApND9HJV3zKvZ7PdcGHM=
Date: Thu, 24 Mar 2022 18:13:00 -0700
To: ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 089/114] kasan: rename kasan_access_info to kasan_report_info
Message-Id: <20220325011301.6C065C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: rename kasan_access_info to kasan_report_info

Rename kasan_access_info to kasan_report_info, as the latter name better
reflects the struct's purpose.

Link: https://lkml.kernel.org/r/158a4219a5d356901d017352558c989533a0782c.1646237226.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h          |    4 ++--
 mm/kasan/report.c         |    8 ++++----
 mm/kasan/report_generic.c |    6 +++---
 mm/kasan/report_tags.c    |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/mm/kasan/kasan.h~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/kasan.h
@@ -132,7 +132,7 @@ enum kasan_report_type {
 	KASAN_REPORT_INVALID_FREE,
 };
 
-struct kasan_access_info {
+struct kasan_report_info {
 	enum kasan_report_type type;
 	void *access_addr;
 	void *first_bad_addr;
@@ -276,7 +276,7 @@ static inline void kasan_print_tags(u8 a
 #endif
 
 void *kasan_find_first_bad_addr(void *addr, size_t size);
-const char *kasan_get_bug_type(struct kasan_access_info *info);
+const char *kasan_get_bug_type(struct kasan_report_info *info);
 void kasan_metadata_fetch_row(char *buffer, void *row);
 
 #if defined(CONFIG_KASAN_STACK)
--- a/mm/kasan/report.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report.c
@@ -84,7 +84,7 @@ static int __init kasan_set_multi_shot(c
 }
 __setup("kasan_multi_shot", kasan_set_multi_shot);
 
-static void print_error_description(struct kasan_access_info *info)
+static void print_error_description(struct kasan_report_info *info)
 {
 	if (info->type == KASAN_REPORT_INVALID_FREE) {
 		pr_err("BUG: KASAN: double-free or invalid-free in %pS\n",
@@ -392,7 +392,7 @@ static bool report_enabled(void)
 	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
 }
 
-static void print_report(struct kasan_access_info *info)
+static void print_report(struct kasan_report_info *info)
 {
 	void *tagged_addr = info->access_addr;
 	void *untagged_addr = kasan_reset_tag(tagged_addr);
@@ -414,7 +414,7 @@ static void print_report(struct kasan_ac
 void kasan_report_invalid_free(void *ptr, unsigned long ip)
 {
 	unsigned long flags;
-	struct kasan_access_info info;
+	struct kasan_report_info info;
 
 	start_report(&flags, true);
 
@@ -437,7 +437,7 @@ bool kasan_report(unsigned long addr, si
 	void *ptr = (void *)addr;
 	unsigned long ua_flags = user_access_save();
 	unsigned long irq_flags;
-	struct kasan_access_info info;
+	struct kasan_report_info info;
 
 	if (unlikely(!report_enabled())) {
 		ret = false;
--- a/mm/kasan/report_generic.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report_generic.c
@@ -43,7 +43,7 @@ void *kasan_find_first_bad_addr(void *ad
 	return p;
 }
 
-static const char *get_shadow_bug_type(struct kasan_access_info *info)
+static const char *get_shadow_bug_type(struct kasan_report_info *info)
 {
 	const char *bug_type = "unknown-crash";
 	u8 *shadow_addr;
@@ -95,7 +95,7 @@ static const char *get_shadow_bug_type(s
 	return bug_type;
 }
 
-static const char *get_wild_bug_type(struct kasan_access_info *info)
+static const char *get_wild_bug_type(struct kasan_report_info *info)
 {
 	const char *bug_type = "unknown-crash";
 
@@ -109,7 +109,7 @@ static const char *get_wild_bug_type(str
 	return bug_type;
 }
 
-const char *kasan_get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
 	/*
 	 * If access_size is a negative number, then it has reason to be
--- a/mm/kasan/report_tags.c~kasan-rename-kasan_access_info-to-kasan_report_info
+++ a/mm/kasan/report_tags.c
@@ -7,7 +7,7 @@
 #include "kasan.h"
 #include "../slab.h"
 
-const char *kasan_get_bug_type(struct kasan_access_info *info)
+const char *kasan_get_bug_type(struct kasan_report_info *info)
 {
 #ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
_
