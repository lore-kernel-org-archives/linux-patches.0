Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC803451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301885; cv=none; b=oyy0NeIEcjk8YqN5spLVfPleamPDhgJRteJU5yABL6FnLvI3YN2f6KWbr0ZDl4co6l1kiMQc+E03zyd4Mi8LLSO4kA3T2ltFeOCWFDPuXp41sgylk7Dn3xN3GgsFMtpt5m5MdpWYY6hPo7iZm+/NLG+qp7UndqENSxeiE9RpWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301885; c=relaxed/simple;
	bh=y71R+/tYJyD9Nz+i0gPmEEa3UdmKkjBTSOWVKxPx0uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av8xCMSEUfe962rI5IE0H+WMJYY+9UIMyiow/+jJoqFOeN3F8Sg6xMO9urY/P7egwT8ujiMDroqtj4R7ei/8SeTeG2N/hI7Pyqw2rOuR20Cfmd5aIrzH/zUt0Zn09y+aOCmPXHu/sIWPb3xKUedI0J75CJqtOATWAqsF4C7fP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blCtn09l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blCtn09l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9DEC116D0;
	Sat, 28 Feb 2026 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301885;
	bh=y71R+/tYJyD9Nz+i0gPmEEa3UdmKkjBTSOWVKxPx0uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blCtn09lyBE3PPX2N1eI/ziiNRGEUal8D8FB+lS6wSdo9dLul2x0tqEDbbibQo32L
	 HVlNp9kjF/Tjn8glb5+BLI5/Jw8nWtqu/IMpxA2pk9POc9nZ2L9WlJ0mQ6vnyMFvFM
	 93l5iloPUNmLcez6ruivMbKC7sjYiaoUxPzeyfkOfOhlouN8lg3fkf7xyJNSbcIIk3
	 Cibf7e6u7yb74hnElGg1azLPLFQCe6e11Oq+CPgXiLjvjATKI8VmugtRWhM3gWmcVq
	 ki5qoXuT87TVEGZRVVIekJ6srlQrEUJoKCWyJtORJTr8Vzd5HZDWOs1vZnh/zZUL9Y
	 ncRrztQenTNDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/385] clk: Move clk_{save,restore}_context() to COMMON_CLK section
Date: Sat, 28 Feb 2026 12:58:53 -0500
Message-ID: <20260228180011.1568201-311-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit f47c1b77d0a2a9c0d49ec14302e74f933398d1a3 ]

The clk_save_context() and clk_restore_context() helpers are only
implemented by the Common Clock Framework.  They are not available when
using legacy clock frameworks.  Dummy implementations are provided, but
only if no clock support is available at all.

Hence when CONFIG_HAVE_CLK=y, but CONFIG_COMMON_CLK is not enabled:

    m68k-linux-gnu-ld: drivers/net/phy/air_en8811h.o: in function `en8811h_resume':
    air_en8811h.c:(.text+0x83e): undefined reference to `clk_restore_context'
    m68k-linux-gnu-ld: drivers/net/phy/air_en8811h.o: in function `en8811h_suspend':
    air_en8811h.c:(.text+0x856): undefined reference to `clk_save_context'

Fix this by moving forward declarations and dummy implementions from the
HAVE_CLK to the COMMON_CLK section.

Fixes: 8b95d1ce3300c411 ("clk: Add functions to save/restore clock context en-masse")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511301553.eaEz1nEW-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/clk.h | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 851a0f2cf42c8..9488c58d8e6af 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -228,6 +228,23 @@ int devm_clk_rate_exclusive_get(struct device *dev, struct clk *clk);
  */
 void clk_rate_exclusive_put(struct clk *clk);
 
+/**
+ * clk_save_context - save clock context for poweroff
+ *
+ * Saves the context of the clock register for powerstates in which the
+ * contents of the registers will be lost. Occurs deep within the suspend
+ * code so locking is not necessary.
+ */
+int clk_save_context(void);
+
+/**
+ * clk_restore_context - restore clock context after poweroff
+ *
+ * This occurs with all clocks enabled. Occurs deep within the resume code
+ * so locking is not necessary.
+ */
+void clk_restore_context(void);
+
 #else
 
 static inline int clk_notifier_register(struct clk *clk,
@@ -293,6 +310,13 @@ static inline int devm_clk_rate_exclusive_get(struct device *dev, struct clk *cl
 
 static inline void clk_rate_exclusive_put(struct clk *clk) {}
 
+static inline int clk_save_context(void)
+{
+	return 0;
+}
+
+static inline void clk_restore_context(void) {}
+
 #endif
 
 #ifdef CONFIG_HAVE_CLK_PREPARE
@@ -931,23 +955,6 @@ struct clk *clk_get_parent(struct clk *clk);
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
-/**
- * clk_save_context - save clock context for poweroff
- *
- * Saves the context of the clock register for powerstates in which the
- * contents of the registers will be lost. Occurs deep within the suspend
- * code so locking is not necessary.
- */
-int clk_save_context(void);
-
-/**
- * clk_restore_context - restore clock context after poweroff
- *
- * This occurs with all clocks enabled. Occurs deep within the resume code
- * so locking is not necessary.
- */
-void clk_restore_context(void);
-
 #else /* !CONFIG_HAVE_CLK */
 
 static inline struct clk *clk_get(struct device *dev, const char *id)
@@ -1127,13 +1134,6 @@ static inline struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 	return NULL;
 }
 
-static inline int clk_save_context(void)
-{
-	return 0;
-}
-
-static inline void clk_restore_context(void) {}
-
 #endif
 
 /* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
-- 
2.51.0

