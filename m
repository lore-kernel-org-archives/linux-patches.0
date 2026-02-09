Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F509125B2;
	Mon,  9 Feb 2026 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647716; cv=none; b=TDDwKki+M6SyJ+dbfqMGlaJG7vpg1HoGLUKEN2J13YVxAEg3UbdiRn0mv3oSJWPXEhJcDhD8q3SEyFbOJLPA7jAzZ85h/NYuRhmFl1TM/bYdrPjBR1o/9ZFNt2IrgJ8puSJhCBri4gjDJAD2WGhv+9j7KxfVeSjg+HtQvITL/WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647716; c=relaxed/simple;
	bh=1ra2aTgjwkcNbI118Ailw8E9VypqjmcceTp5gx0fR/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6Lm59UCT6mXQVJWC2dvfBO9RoKuXGCxz8ovYagzGdhlVYBkyBWVAyiuGshsMXs0800Ndcnvn4900/ZuN38DGpB8/076VPxqn6COiJKbAHlwKp/HPNdqdw/ltLvIUOx558ZESHKh0ho4f253BpgS8Yn4azl1zYkte8i/nUd2ZFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJtm6JtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJtm6JtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168E9C16AAE;
	Mon,  9 Feb 2026 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647716;
	bh=1ra2aTgjwkcNbI118Ailw8E9VypqjmcceTp5gx0fR/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJtm6JtUN66y8HjAipktfOcIjbtYjIRABdSjauVyfPekw5UXL8SOLNKK4XvDZZsDs
	 sSyavdUZz0Aq5+z8LcOHZbAAZGkJHumAtM2dW4F3xsP2W8eq6knSzk3GR/LT+46hqY
	 jbQC7RoVhZTSEmrnDQcXkg5IBN7AmunX/9HOYFHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/175] firmware: cs_dsp: rate-limit log messages in KUnit builds
Date: Mon,  9 Feb 2026 15:23:52 +0100
Message-ID: <20260209142326.213043296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 10db9f6899dd3a2dfd26efd40afd308891dc44a8 ]

Use the dev_*_ratelimit() macros if the cs_dsp KUnit tests are enabled
in the build, and allow the KUnit tests to disable message output.

Some of the KUnit tests cause a very large number of log messages from
cs_dsp, because the tests perform many different test cases. This could
cause some lines to be dropped from the kernel log. Dropped lines can
prevent the KUnit wrappers from parsing the ktap output in the dmesg log.

The KUnit builds of cs_dsp export three bools that the KUnit tests can
use to entirely disable log output of err, warn and info messages. Some
tests have been updated to use this, replacing the previous fudge of a
usleep() in the exit handler of each test. We don't necessarily want to
disable all log messages if they aren't expected to be excessive,
so the rate-limiting allows leaving some logging enabled.

The rate-limited macros are not used in normal builds because it is not
appropriate to rate-limit every message. That could cause important
messages to be dropped, and there wouldn't be such a high rate of
messages in normal operation.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/linux-sound/af393f08-facb-4c44-a054-1f61254803ec@opensource.cirrus.com/T/#t
Fixes: cd8c058499b6 ("firmware: cs_dsp: Add KUnit testing of bin error cases")
Link: https://patch.msgid.link/20260130171256.863152-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c              | 37 +++++++++++++++++++
 drivers/firmware/cirrus/cs_dsp.h              | 18 +++++++++
 .../firmware/cirrus/test/cs_dsp_test_bin.c    | 22 ++++++++++-
 .../cirrus/test/cs_dsp_test_bin_error.c       | 24 +++++++++---
 .../firmware/cirrus/test/cs_dsp_test_wmfw.c   | 26 ++++++++++++-
 .../cirrus/test/cs_dsp_test_wmfw_error.c      | 24 +++++++++---
 drivers/firmware/cirrus/test/cs_dsp_tests.c   |  1 +
 7 files changed, 138 insertions(+), 14 deletions(-)
 create mode 100644 drivers/firmware/cirrus/cs_dsp.h

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 58e41751dbc19..7ca56777a1da5 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -9,6 +9,7 @@
  *                         Cirrus Logic International Semiconductor Ltd.
  */
 
+#include <kunit/visibility.h>
 #include <linux/cleanup.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
@@ -23,6 +24,41 @@
 #include <linux/firmware/cirrus/cs_dsp.h>
 #include <linux/firmware/cirrus/wmfw.h>
 
+#include "cs_dsp.h"
+
+/*
+ * When the KUnit test is running the error-case tests will cause a lot
+ * of messages. Rate-limit to prevent overflowing the kernel log buffer
+ * during KUnit test runs.
+ */
+#if IS_ENABLED(CONFIG_FW_CS_DSP_KUNIT_TEST)
+bool cs_dsp_suppress_err_messages;
+EXPORT_SYMBOL_IF_KUNIT(cs_dsp_suppress_err_messages);
+
+bool cs_dsp_suppress_warn_messages;
+EXPORT_SYMBOL_IF_KUNIT(cs_dsp_suppress_warn_messages);
+
+bool cs_dsp_suppress_info_messages;
+EXPORT_SYMBOL_IF_KUNIT(cs_dsp_suppress_info_messages);
+
+#define cs_dsp_err(_dsp, fmt, ...) \
+	do { \
+		if (!cs_dsp_suppress_err_messages) \
+			dev_err_ratelimited(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__); \
+	} while (false)
+#define cs_dsp_warn(_dsp, fmt, ...) \
+	do { \
+		if (!cs_dsp_suppress_warn_messages) \
+			dev_warn_ratelimited(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__); \
+	} while (false)
+#define cs_dsp_info(_dsp, fmt, ...) \
+	do { \
+		if (!cs_dsp_suppress_info_messages) \
+			dev_info_ratelimited(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__); \
+	} while (false)
+#define cs_dsp_dbg(_dsp, fmt, ...) \
+	dev_dbg_ratelimited(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__)
+#else
 #define cs_dsp_err(_dsp, fmt, ...) \
 	dev_err(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__)
 #define cs_dsp_warn(_dsp, fmt, ...) \
@@ -31,6 +67,7 @@
 	dev_info(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__)
 #define cs_dsp_dbg(_dsp, fmt, ...) \
 	dev_dbg(_dsp->dev, "%s: " fmt, _dsp->name, ##__VA_ARGS__)
+#endif
 
 #define ADSP1_CONTROL_1                   0x00
 #define ADSP1_CONTROL_2                   0x02
diff --git a/drivers/firmware/cirrus/cs_dsp.h b/drivers/firmware/cirrus/cs_dsp.h
new file mode 100644
index 0000000000000..adf543004aea3
--- /dev/null
+++ b/drivers/firmware/cirrus/cs_dsp.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * cs_dsp.h  --  Private header for cs_dsp driver.
+ *
+ * Copyright (C) 2026 Cirrus Logic, Inc. and
+ *                    Cirrus Logic International Semiconductor Ltd.
+ */
+
+#ifndef FW_CS_DSP_H
+#define FW_CS_DSP_H
+
+#if IS_ENABLED(CONFIG_KUNIT)
+extern bool cs_dsp_suppress_err_messages;
+extern bool cs_dsp_suppress_warn_messages;
+extern bool cs_dsp_suppress_info_messages;
+#endif
+
+#endif /* ifndef FW_CS_DSP_H */
diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_bin.c b/drivers/firmware/cirrus/test/cs_dsp_test_bin.c
index 163b7faecff46..2c6486fa95758 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_bin.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_bin.c
@@ -17,6 +17,8 @@
 #include <linux/random.h>
 #include <linux/regmap.h>
 
+#include "../cs_dsp.h"
+
 /*
  * Test method is:
  *
@@ -2224,7 +2226,22 @@ static int cs_dsp_bin_test_common_init(struct kunit *test, struct cs_dsp *dsp)
 		return ret;
 
 	/* Automatically call cs_dsp_remove() when test case ends */
-	return kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	ret = kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	if (ret)
+		return ret;
+
+	/*
+	 * The large number of test cases will cause an unusually large amount
+	 * of dev_info() messages from cs_dsp, so suppress these.
+	 */
+	cs_dsp_suppress_info_messages = true;
+
+	return 0;
+}
+
+static void cs_dsp_bin_test_exit(struct kunit *test)
+{
+	cs_dsp_suppress_info_messages = false;
 }
 
 static int cs_dsp_bin_test_halo_init(struct kunit *test)
@@ -2536,18 +2553,21 @@ static struct kunit_case cs_dsp_bin_test_cases_adsp2[] = {
 static struct kunit_suite cs_dsp_bin_test_halo = {
 	.name = "cs_dsp_bin_halo",
 	.init = cs_dsp_bin_test_halo_init,
+	.exit = cs_dsp_bin_test_exit,
 	.test_cases = cs_dsp_bin_test_cases_halo,
 };
 
 static struct kunit_suite cs_dsp_bin_test_adsp2_32bit = {
 	.name = "cs_dsp_bin_adsp2_32bit",
 	.init = cs_dsp_bin_test_adsp2_32bit_init,
+	.exit = cs_dsp_bin_test_exit,
 	.test_cases = cs_dsp_bin_test_cases_adsp2,
 };
 
 static struct kunit_suite cs_dsp_bin_test_adsp2_16bit = {
 	.name = "cs_dsp_bin_adsp2_16bit",
 	.init = cs_dsp_bin_test_adsp2_16bit_init,
+	.exit = cs_dsp_bin_test_exit,
 	.test_cases = cs_dsp_bin_test_cases_adsp2,
 };
 
diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_bin_error.c b/drivers/firmware/cirrus/test/cs_dsp_test_bin_error.c
index a7ec956d27249..631b9cb9eb250 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_bin_error.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_bin_error.c
@@ -18,6 +18,8 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
+#include "../cs_dsp.h"
+
 KUNIT_DEFINE_ACTION_WRAPPER(_put_device_wrapper, put_device, struct device *);
 KUNIT_DEFINE_ACTION_WRAPPER(_cs_dsp_remove_wrapper, cs_dsp_remove, struct cs_dsp *);
 
@@ -380,11 +382,9 @@ static void bin_block_payload_len_garbage(struct kunit *test)
 
 static void cs_dsp_bin_err_test_exit(struct kunit *test)
 {
-	/*
-	 * Testing error conditions can produce a lot of log output
-	 * from cs_dsp error messages, so rate limit the test cases.
-	 */
-	usleep_range(200, 500);
+	cs_dsp_suppress_err_messages = false;
+	cs_dsp_suppress_warn_messages = false;
+	cs_dsp_suppress_info_messages = false;
 }
 
 static int cs_dsp_bin_err_test_common_init(struct kunit *test, struct cs_dsp *dsp,
@@ -474,7 +474,19 @@ static int cs_dsp_bin_err_test_common_init(struct kunit *test, struct cs_dsp *ds
 		return ret;
 
 	/* Automatically call cs_dsp_remove() when test case ends */
-	return kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	ret = kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	if (ret)
+		return ret;
+
+	/*
+	 * Testing error conditions can produce a lot of log output
+	 * from cs_dsp error messages, so suppress messages.
+	 */
+	cs_dsp_suppress_err_messages = true;
+	cs_dsp_suppress_warn_messages = true;
+	cs_dsp_suppress_info_messages = true;
+
+	return 0;
 }
 
 static int cs_dsp_bin_err_test_halo_init(struct kunit *test)
diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw.c b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw.c
index 9e997c4ee2d67..f02cb6cf76386 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw.c
@@ -18,6 +18,8 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
+#include "../cs_dsp.h"
+
 /*
  * Test method is:
  *
@@ -1853,7 +1855,22 @@ static int cs_dsp_wmfw_test_common_init(struct kunit *test, struct cs_dsp *dsp,
 		return ret;
 
 	/* Automatically call cs_dsp_remove() when test case ends */
-	return kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	ret = kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	if (ret)
+		return ret;
+
+	/*
+	 * The large number of test cases will cause an unusually large amount
+	 * of dev_info() messages from cs_dsp, so suppress these.
+	 */
+	cs_dsp_suppress_info_messages = true;
+
+	return 0;
+}
+
+static void cs_dsp_wmfw_test_exit(struct kunit *test)
+{
+	cs_dsp_suppress_info_messages = false;
 }
 
 static int cs_dsp_wmfw_test_halo_init(struct kunit *test)
@@ -2163,42 +2180,49 @@ static struct kunit_case cs_dsp_wmfw_test_cases_adsp2[] = {
 static struct kunit_suite cs_dsp_wmfw_test_halo = {
 	.name = "cs_dsp_wmfwV3_halo",
 	.init = cs_dsp_wmfw_test_halo_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_halo,
 };
 
 static struct kunit_suite cs_dsp_wmfw_test_adsp2_32bit_wmfw0 = {
 	.name = "cs_dsp_wmfwV0_adsp2_32bit",
 	.init = cs_dsp_wmfw_test_adsp2_32bit_wmfw0_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_adsp2,
 };
 
 static struct kunit_suite cs_dsp_wmfw_test_adsp2_32bit_wmfw1 = {
 	.name = "cs_dsp_wmfwV1_adsp2_32bit",
 	.init = cs_dsp_wmfw_test_adsp2_32bit_wmfw1_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_adsp2,
 };
 
 static struct kunit_suite cs_dsp_wmfw_test_adsp2_32bit_wmfw2 = {
 	.name = "cs_dsp_wmfwV2_adsp2_32bit",
 	.init = cs_dsp_wmfw_test_adsp2_32bit_wmfw2_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_adsp2,
 };
 
 static struct kunit_suite cs_dsp_wmfw_test_adsp2_16bit_wmfw0 = {
 	.name = "cs_dsp_wmfwV0_adsp2_16bit",
 	.init = cs_dsp_wmfw_test_adsp2_16bit_wmfw0_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_adsp2,
 };
 
 static struct kunit_suite cs_dsp_wmfw_test_adsp2_16bit_wmfw1 = {
 	.name = "cs_dsp_wmfwV1_adsp2_16bit",
 	.init = cs_dsp_wmfw_test_adsp2_16bit_wmfw1_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_adsp2,
 };
 
 static struct kunit_suite cs_dsp_wmfw_test_adsp2_16bit_wmfw2 = {
 	.name = "cs_dsp_wmfwV2_adsp2_16bit",
 	.init = cs_dsp_wmfw_test_adsp2_16bit_wmfw2_init,
+	.exit = cs_dsp_wmfw_test_exit,
 	.test_cases = cs_dsp_wmfw_test_cases_adsp2,
 };
 
diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
index c309843261d72..37162d12e2fa7 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_wmfw_error.c
@@ -18,6 +18,8 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
+#include "../cs_dsp.h"
+
 KUNIT_DEFINE_ACTION_WRAPPER(_put_device_wrapper, put_device, struct device *);
 KUNIT_DEFINE_ACTION_WRAPPER(_cs_dsp_remove_wrapper, cs_dsp_remove, struct cs_dsp *);
 
@@ -989,11 +991,9 @@ static void wmfw_v2_coeff_description_exceeds_block(struct kunit *test)
 
 static void cs_dsp_wmfw_err_test_exit(struct kunit *test)
 {
-	/*
-	 * Testing error conditions can produce a lot of log output
-	 * from cs_dsp error messages, so rate limit the test cases.
-	 */
-	usleep_range(200, 500);
+	cs_dsp_suppress_err_messages = false;
+	cs_dsp_suppress_warn_messages = false;
+	cs_dsp_suppress_info_messages = false;
 }
 
 static int cs_dsp_wmfw_err_test_common_init(struct kunit *test, struct cs_dsp *dsp,
@@ -1072,7 +1072,19 @@ static int cs_dsp_wmfw_err_test_common_init(struct kunit *test, struct cs_dsp *d
 		return ret;
 
 	/* Automatically call cs_dsp_remove() when test case ends */
-	return kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	ret = kunit_add_action_or_reset(priv->test, _cs_dsp_remove_wrapper, dsp);
+	if (ret)
+		return ret;
+
+	/*
+	 * Testing error conditions can produce a lot of log output
+	 * from cs_dsp error messages, so suppress messages.
+	 */
+	cs_dsp_suppress_err_messages = true;
+	cs_dsp_suppress_warn_messages = true;
+	cs_dsp_suppress_info_messages = true;
+
+	return 0;
 }
 
 static int cs_dsp_wmfw_err_test_halo_init(struct kunit *test)
diff --git a/drivers/firmware/cirrus/test/cs_dsp_tests.c b/drivers/firmware/cirrus/test/cs_dsp_tests.c
index 7b829a03ca529..288675fdbdc53 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_tests.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_tests.c
@@ -12,3 +12,4 @@ MODULE_AUTHOR("Richard Fitzgerald <rf@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS("FW_CS_DSP");
 MODULE_IMPORT_NS("FW_CS_DSP_KUNIT_TEST_UTILS");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
-- 
2.51.0



