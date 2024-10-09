Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E0B199FB8;
	Wed,  9 Oct 2024 20:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728506497; cv=none; b=mMEcJe0KZn8O7wJ9qcZhuZcoICRda7ltvsHgKfnIYb/OAEekZJHk6Y9biTKOqA9XgN1ze6XdkVGhaV8SoT0zsOL3LuY2E/xZ01wQfH+t35EmbGXbz0JdNi50LidbxvUwXedsIuUKrCVGXlJpa1unWaA/aII1b8lzqI3Xu39HMA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728506497; c=relaxed/simple;
	bh=yza4YUbv4ZDOEyFxjvWcvVnI7e/+TRmYuEUahLq5Ssg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jffhZBSXSSYUjgfnkdiiBoSJz9alWpfCKGdYdiC6SSwWAiKU7gqblPIOqMncI2KpMvhjZfUDxxslpPkOZE9t3Ciaho7BDpDlStiqDZAhKHpWfIUBZfztTZnxnFX9cafWKjBdHGQ84O545EJBRzmwWdhTGyEXio7CAUVkDgIsJOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8JLrtGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8JLrtGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8CEC4CEC3;
	Wed,  9 Oct 2024 20:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728506494;
	bh=yza4YUbv4ZDOEyFxjvWcvVnI7e/+TRmYuEUahLq5Ssg=;
	h=From:To:Cc:Subject:Date:From;
	b=p8JLrtGuhuocV0VijNTrh7LhsLYeElAZiICXJ7v4CNiFV6vlWbye7fcB++dqV5UmP
	 NDE/3T7TpyyeF59ZwiIb1VMJfB1j//awGZLqqyJl47MvDNqvIefWQm1vq2N7xthsVI
	 KgAt4maTd/WbnYI8XYzG5kV8JQpuGPHhQnuZFUeOTGJul3EHRj8ebgzwDQl62/YaV2
	 icVFK9DNWk23PchNvBHnBjUF9EkKRpOBPIqSLdsZWM6hl8038ch+LWz8uWwkItwCox
	 DfoYsGYgif9u5/57tXeeW3Sds+T6tWoUpUpBxf9PrnqwWFe/flF40kNh9XaimSCd8X
	 2YEk0hR0qrrig==
From: Stephen Boyd <sboyd@kernel.org>
To: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	devicetree@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] of: Skip kunit tests when arm64+ACPI doesn't populate root node
Date: Wed,  9 Oct 2024 13:41:31 -0700
Message-ID: <20241009204133.1169931-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A root node is required to apply DT overlays. A root node is usually
present after commit 7b937cc243e5 ("of: Create of_root if no dtb
provided by firmware"), except for on arm64 systems booted with ACPI
tables. In that case, the root node is intentionally not populated
because it would "allow DT devices to be instantiated atop an ACPI base
system"[1].

Introduce an OF function that skips the kunit test if the root node
isn't populated. Limit the test to when both CONFIG_ARM64 and
CONFIG_ACPI are set, because otherwise the lack of a root node is a bug.
Make the function private and take a kunit test parameter so that it
can't be abused to test for the presence of the root node in non-test
code.

Use this function to skip tests that require the root node. Currently
that's the DT tests and any tests that apply overlays.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/r/6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net
Link: https://lore.kernel.org/r/Zd4dQpHO7em1ji67@FVFF77S0Q05N.cambridge.arm.com [1]
Fixes: 893ecc6d2d61 ("of: Add KUnit test to confirm DTB is loaded")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/of/of_kunit_helpers.c | 15 +++++++++++++++
 drivers/of/of_private.h       |  3 +++
 drivers/of/of_test.c          |  3 +++
 drivers/of/overlay_test.c     |  3 +++
 4 files changed, 24 insertions(+)

diff --git a/drivers/of/of_kunit_helpers.c b/drivers/of/of_kunit_helpers.c
index 287d6c91bb37..7b3ed5a382aa 100644
--- a/drivers/of/of_kunit_helpers.c
+++ b/drivers/of/of_kunit_helpers.c
@@ -10,6 +10,19 @@
 #include <kunit/test.h>
 #include <kunit/resource.h>
 
+#include "of_private.h"
+
+/**
+ * of_root_kunit_skip() - Skip test if the root node isn't populated
+ * @test: test to skip if the root node isn't populated
+ */
+void of_root_kunit_skip(struct kunit *test)
+{
+	if (IS_ENABLED(CONFIG_ARM64) && IS_ENABLED(CONFIG_ACPI) && !of_root)
+		kunit_skip(test, "arm64+acpi doesn't populate a root node");
+}
+EXPORT_SYMBOL_GPL(of_root_kunit_skip);
+
 #if defined(CONFIG_OF_OVERLAY) && defined(CONFIG_OF_EARLY_FLATTREE)
 
 static void of_overlay_fdt_apply_kunit_exit(void *ovcs_id)
@@ -36,6 +49,8 @@ int of_overlay_fdt_apply_kunit(struct kunit *test, void *overlay_fdt,
 	int ret;
 	int *copy_id;
 
+	of_root_kunit_skip(test);
+
 	copy_id = kunit_kmalloc(test, sizeof(*copy_id), GFP_KERNEL);
 	if (!copy_id)
 		return -ENOMEM;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 04aa2a91f851..c235d6c909a1 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -42,6 +42,9 @@ extern raw_spinlock_t devtree_lock;
 extern struct list_head aliases_lookup;
 extern struct kset *of_kset;
 
+struct kunit;
+extern void of_root_kunit_skip(struct kunit *test);
+
 #if defined(CONFIG_OF_DYNAMIC)
 extern int of_property_notify(int action, struct device_node *np,
 			      struct property *prop, struct property *old_prop);
diff --git a/drivers/of/of_test.c b/drivers/of/of_test.c
index c85a258bc6ae..b0557ded838f 100644
--- a/drivers/of/of_test.c
+++ b/drivers/of/of_test.c
@@ -7,6 +7,8 @@
 
 #include <kunit/test.h>
 
+#include "of_private.h"
+
 /*
  * Test that the root node "/" can be found by path.
  */
@@ -36,6 +38,7 @@ static struct kunit_case of_dtb_test_cases[] = {
 
 static int of_dtb_test_init(struct kunit *test)
 {
+	of_root_kunit_skip(test);
 	if (!IS_ENABLED(CONFIG_OF_EARLY_FLATTREE))
 		kunit_skip(test, "requires CONFIG_OF_EARLY_FLATTREE");
 
diff --git a/drivers/of/overlay_test.c b/drivers/of/overlay_test.c
index 19a292cdeee3..7cbf9a472111 100644
--- a/drivers/of/overlay_test.c
+++ b/drivers/of/overlay_test.c
@@ -11,6 +11,8 @@
 #include <kunit/of.h>
 #include <kunit/test.h>
 
+#include "of_private.h"
+
 static const char * const kunit_node_name = "kunit-test";
 static const char * const kunit_compatible = "test,empty";
 
@@ -62,6 +64,7 @@ static void of_overlay_apply_kunit_cleanup(struct kunit *test)
 	struct device *dev;
 	struct device_node *np;
 
+	of_root_kunit_skip(test);
 	if (!IS_ENABLED(CONFIG_OF_EARLY_FLATTREE))
 		kunit_skip(test, "requires CONFIG_OF_EARLY_FLATTREE for root node");
 

base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

