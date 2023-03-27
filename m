Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A0F79E4
	for <patches@lists.linux.dev>; Mon, 27 Mar 2023 22:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624DDC4339C;
	Mon, 27 Mar 2023 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679955721;
	bh=36NmJOfvymqOUa86Xso6Y3noQoP8kgcFeJ65vzin3Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A07LNRrkcsI2/KLWfm9DfgHmIVnCrLxs45YeWwY9JyI55diZsluhyqXJiofBBLI57
	 aktf1oFcKlpX3nR6zKUa7dsvuujFKsbc2am0m0bsuNynboAvz9A2uF5Pgx4fPnCqhQ
	 5vDfm78cXE3aFkVxSGDm0YuC2mx+L8HHQ2Rl2XYQ4KLK3UkFKBDQ0HHOprF6hZw+kT
	 8rifNS8tCdUr7/rYxOvcuVPUnmzh9+AEJLym5SDcnSCzBplVH5WPHsyqZ09WDwvynG
	 yoAPuEyjhkq9P1ZygfxcdTdTYWgDZG2M7Z4lqBsK+ICXLukiyXA83Pai+A4eLgSZab
	 xV2GiLqGaXTUA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	devicetree@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH v3 01/11] of: Add KUnit test to confirm DTB is loaded
Date: Mon, 27 Mar 2023 15:21:49 -0700
Message-Id: <20230327222159.3509818-2-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230327222159.3509818-1-sboyd@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple KUnit test that confirms a DTB has been loaded, i.e. there
is a root node.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/of/.kunitconfig |  3 +++
 drivers/of/Kconfig      |  9 +++++++++
 drivers/of/Makefile     |  2 ++
 drivers/of/of_test.c    | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+)
 create mode 100644 drivers/of/.kunitconfig
 create mode 100644 drivers/of/of_test.c

diff --git a/drivers/of/.kunitconfig b/drivers/of/.kunitconfig
new file mode 100644
index 000000000000..5a8fee11978c
--- /dev/null
+++ b/drivers/of/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_OF=y
+CONFIG_OF_KUNIT_TEST=y
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 194e090ceee8..1b995cecf5be 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -37,6 +37,15 @@ config OF_UNITTEST
 
 	  If unsure, say N here. This option is not safe to enable.
 
+config OF_KUNIT_TEST
+	tristate "Devicetree KUnit DTB Test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option builds KUnit unit tests for device tree infrastructure.
+
+	  If unsure, say N here, but this option is safe to enable.
+
 config OF_ALL_DTBS
 	bool "Build all Device Tree Blobs"
 	depends on COMPILE_TEST
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index cbae92c5ed02..b11a8adcb985 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -19,4 +19,6 @@ obj-y	+= kexec.o
 endif
 endif
 
+obj-$(CONFIG_OF_KUNIT_TEST) += of_test.o
+
 obj-$(CONFIG_OF_UNITTEST) += unittest-data/
diff --git a/drivers/of/of_test.c b/drivers/of/of_test.c
new file mode 100644
index 000000000000..08b670aee083
--- /dev/null
+++ b/drivers/of/of_test.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for OF APIs
+ */
+#include <linux/module.h>
+#include <linux/of.h>
+
+#include <kunit/test.h>
+
+/*
+ * Test that the root node / exists.
+ */
+static void dtb_root_node_exists(struct kunit *test)
+{
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, of_find_node_by_path("/"));
+}
+
+static struct kunit_case dtb_test_cases[] = {
+	KUNIT_CASE(dtb_root_node_exists),
+	{}
+};
+
+/*
+ * Test suite to confirm a live DTB is loaded.
+ */
+static struct kunit_suite dtb_suite = {
+	.name = "dtb",
+	.test_cases = dtb_test_cases,
+};
+
+kunit_test_suites(
+	&dtb_suite,
+);
+MODULE_LICENSE("GPL");
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

