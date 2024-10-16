Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0CB13B298;
	Wed, 16 Oct 2024 21:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113618; cv=none; b=CQoeuq9BLE/TdrH+zPqM88Zr7mqeMcF1bGhbuPRndcmCJ7/Fq/uIwUJ3Kf83AsBB3KjNBnOVDPbjywUZAwtnPTr6t6zrl8ZhC3QTisQ1pilvOFFTSwnraL/RPAHTvF+ZlLdkFInj4qphFv4N1/jQiWNKdOuXuEhIGmREQc68hkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113618; c=relaxed/simple;
	bh=pvI7NWjIsxacW6JnIO272A6in4jx/EkKzXEIVWUeS3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O/JlpjIq33fyioOquGpleJybJFdZDP8IuVCQHUaCGtHaGvnX3gG7uuXoHqwhYYCmNXpWxDCKHR35+oGT6R+Kftq61sMDmYmif6N5dN8IF13YU2CRd3ts9hqM8E8Wc9diKUXjSAGdwYplTq9Djc7do+a33gNwBV5ijqN0NCE1O+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqMT46D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqMT46D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14E3C4CEC5;
	Wed, 16 Oct 2024 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729113618;
	bh=pvI7NWjIsxacW6JnIO272A6in4jx/EkKzXEIVWUeS3Q=;
	h=From:To:Cc:Subject:Date:From;
	b=rqMT46D+EbA5csYjrloYEHCdekOAy00Z+ubmhAuoVfOkJ72tPNCo1JqVMeNbLNTUX
	 q4IbQovpgl50roNZLNYGL0TepgStjXevU9A2JjKj9qXcx6NlNlpWW0qtrFPNTNzppS
	 2XD6Q9OJ3Wc0xYAO6/rzOiAPgNrmlNdDnR1XzBD6C4kpK7ebNkeuKjg+ojho9IARm4
	 gE6LxcpBGBL++28I+yit2NOpz/DBMxfl89cehxf2a5bzvOb/Wsy1g7PAbPxRCf2LRP
	 Cso5xry9KA6z61YPoAuJKzLe6K3ilDn9YxOlMmmqVLM7GcUnaoydcyIJU5iqWiLIXr
	 w8fO2i0fCTTiQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	kunit-dev@googlegroups.com
Subject: [PATCH] of: Allow overlay kunit tests to run CONFIG_OF_OVERLAY=n
Date: Wed, 16 Oct 2024 14:20:15 -0700
Message-ID: <20241016212016.887552-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some configurations want to enable CONFIG_KUNIT without enabling
CONFIG_OF_OVERLAY. The kunit overlay code already skips if
CONFIG_OF_OVERLAY isn't enabled, so this select here isn't really doing
anything besides making it easier to run the tests without them
skipping. Remove the select and move the config setting to the
drivers/of/.kunitconfig file so that the overlay tests can be run with
or without CONFIG_OF_OVERLAY set to test either behavior.

Fixes: 5c9dd72d8385 ("of: Add a KUnit test for overlays and test managed APIs")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/of/.kunitconfig   | 1 +
 drivers/of/Kconfig        | 1 -
 drivers/of/overlay_test.c | 2 ++
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/.kunitconfig b/drivers/of/.kunitconfig
index 4c53d2c7a275..7d570cb922a1 100644
--- a/drivers/of/.kunitconfig
+++ b/drivers/of/.kunitconfig
@@ -1,4 +1,5 @@
 CONFIG_KUNIT=y
 CONFIG_OF=y
 CONFIG_OF_KUNIT_TEST=y
+CONFIG_OF_OVERLAY=y
 CONFIG_OF_OVERLAY_KUNIT_TEST=y
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 0e2d608c3e20..0efa2d1b687a 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -111,7 +111,6 @@ config OF_OVERLAY_KUNIT_TEST
 	tristate "Device Tree overlay KUnit tests" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select OF_OVERLAY
 	help
 	  This option builds KUnit unit tests for the device tree overlay code.
 
diff --git a/drivers/of/overlay_test.c b/drivers/of/overlay_test.c
index 1f76d50fb16a..c787524c5a88 100644
--- a/drivers/of/overlay_test.c
+++ b/drivers/of/overlay_test.c
@@ -65,6 +65,8 @@ static void of_overlay_apply_kunit_cleanup(struct kunit *test)
 	struct device_node *np;
 
 	of_root_kunit_skip(test);
+	if (!IS_ENABLED(CONFIG_OF_OVERLAY))
+		kunit_skip(test, "requires CONFIG_OF_OVERLAY to apply overlay");
 	if (!IS_ENABLED(CONFIG_OF_EARLY_FLATTREE))
 		kunit_skip(test, "requires CONFIG_OF_EARLY_FLATTREE for root node");
 

base-commit: 6e0391e48cf9fb8b1b5e27c0cbbaf2e4639f2c33
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

