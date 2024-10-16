Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B10F13B298;
	Wed, 16 Oct 2024 21:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729114060; cv=none; b=o1CGhtk4maf8momyuK8DYgGOPdVnAM6b3d5Y6yQdQHk4JUcxyBRmnoHQYXYhZ0D4xs6ETUGCAsfdATRKgSSpTlelxksEm2M0zJF7HDy/yRfPYLG+Rv4UjxWBRPBJdE3817p4g0F8sEyoWved7opFQKQUatLvqdsJlGhHM4nkKeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729114060; c=relaxed/simple;
	bh=X6QgoSZZJwiZ7FyB/Q/sbjO7mW4zKkNXk6i4bp9s/UI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iPcSHUcQ7OYdsUUWT//rAP+L7moqNWBybf2TwoEi/VvnySHb8wlyVQK04Wh/wTTaiN5zjft5L1nqm/LYklDUbQOl3JDyfaSehc0ugrtN0FNJpB3uELgAfxzI2bExDBxvPjB31q9i/EqVQd65Ae8ndhvNG7xpxlCyXXh9f/Rf6Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBgmZUeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBgmZUeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB8EC4CEC5;
	Wed, 16 Oct 2024 21:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729114059;
	bh=X6QgoSZZJwiZ7FyB/Q/sbjO7mW4zKkNXk6i4bp9s/UI=;
	h=From:To:Cc:Subject:Date:From;
	b=iBgmZUeKzZ7yfDM2XjJBtDoEt7R1jZ23lE+DnonRgX9kEt/EhxsfIhO2QBqsaDElk
	 9e1G15hDI6l2XCWQVV3lWP3SAWr1sOwEEoYxCCETUvD4yvy7z31GN1jLt2OmE9D/4n
	 v4+AcZ+tFlqEUvKanLjFQtq2+0XRdft/VBqe1zM4n4RjZ+TYXyXmdqV8Yg049TA9Wk
	 6DZuM/nwnHmDmhBHwuOzWtgH/e9jOyq64AVHElxJCDsqWld8cpQTg1zKKLVr3GszMk
	 VC4x6bOX8FZ+7D1xPpukjGJRQk4gV/Q4xJSfdGnoP5wFBIFfSqWUNtKHIEOd5mLfDE
	 S4c/q+PJzyKJg==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	kunit-dev@googlegroups.com
Subject: [PATCH] clk: Allow kunit tests to run without OF_OVERLAY enabled
Date: Wed, 16 Oct 2024 14:27:37 -0700
Message-ID: <20241016212738.897691-1-sboyd@kernel.org>
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
CONFIG_OF_OVERLAY isn't enabled, so these selects here aren't really
doing anything besides making it easier to run the tests without them
skipping. Remove the select and move the config setting to the
drivers/clk/.kunitconfig file so that the clk tests can be run with or
without CONFIG_OF_OVERLAY set to test either behavior.

Fixes: 5776526beb95 ("clk: Add KUnit tests for clk fixed rate basic type")
Fixes: 274aff8711b2 ("clk: Add KUnit tests for clks registered with struct clk_parent_data")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/.kunitconfig | 1 +
 drivers/clk/Kconfig      | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/.kunitconfig b/drivers/clk/.kunitconfig
index 54ece9207055..08e26137f3d9 100644
--- a/drivers/clk/.kunitconfig
+++ b/drivers/clk/.kunitconfig
@@ -1,5 +1,6 @@
 CONFIG_KUNIT=y
 CONFIG_OF=y
+CONFIG_OF_OVERLAY=y
 CONFIG_COMMON_CLK=y
 CONFIG_CLK_KUNIT_TEST=y
 CONFIG_CLK_FIXED_RATE_KUNIT_TEST=y
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 299bc678ed1b..0fe07a594b4e 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -517,7 +517,6 @@ config CLK_KUNIT_TEST
 	tristate "Basic Clock Framework Kunit Tests" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select OF_OVERLAY if OF
 	select DTC
 	help
 	  Kunit tests for the common clock framework.
@@ -526,7 +525,6 @@ config CLK_FIXED_RATE_KUNIT_TEST
 	tristate "Basic fixed rate clk type KUnit test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select OF_OVERLAY if OF
 	select DTC
 	help
 	  KUnit tests for the basic fixed rate clk type.

base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

