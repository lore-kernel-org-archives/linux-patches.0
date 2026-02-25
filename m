Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256A01E2834;
	Wed, 25 Feb 2026 01:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983461; cv=none; b=dlHM5KWov430uhtdDvWvwyJTeX19u5fZlDY8gsuhyK57Vm22Nri3xXgB72NRB9pkTKt8kGkxQC1hU9iGGP5IAwZspTyfmlxl+Cs9VsUd9BbHq16zF76nEPuxJ7JdNEATHL3kHcQq5wJWXtqx7MP8bySNbnDtQnV40AMr3PWnrUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983461; c=relaxed/simple;
	bh=xYsYkBfelF0Zqg9zk2OS5jougb0Mr8FD6JXOumxLMTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUVKywh4uRC2Fe4N9oAKZn/cL/vry0jQyyMHAIwBW3wHExLPzNRXmIjvcyqz2KC94qKDqgId/YrDSbSJRtIbk9aRJAG7ylBlgZnl8UEDTUELThU7bKgQ3XbRupdvc6fUCmuDfYa/hREL+q0uiMsPyLQOOovFRuxDV076Mn4KfnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/BR8VzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/BR8VzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7041C116D0;
	Wed, 25 Feb 2026 01:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983460;
	bh=xYsYkBfelF0Zqg9zk2OS5jougb0Mr8FD6JXOumxLMTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/BR8VzAbvLklm20jKYBqY5xDuSNqCHd6NmRTZFNVg+pjRJcV/0Ck2/NJ7m26QnxU
	 Gdhop6i8+oeNoh53TdY+c8HOIjN4pqIYEpBk+R0gWhD8wYZ8xblTQvdGQFGi5fqQTk
	 +I/22eLtnmSbaZ5r057JPHccTUxJgH1isnqyhZ9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 533/781] clk: Move clk_{save,restore}_context() to COMMON_CLK section
Date: Tue, 24 Feb 2026 17:20:42 -0800
Message-ID: <20260225012412.873249157@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b607482ca77e9..64ff118ffb1a1 100644
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
@@ -933,23 +957,6 @@ struct clk *clk_get_parent(struct clk *clk);
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
@@ -1129,13 +1136,6 @@ static inline struct clk *clk_get_sys(const char *dev_id, const char *con_id)
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



