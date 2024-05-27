Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0475017727;
	Mon, 27 May 2024 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838445; cv=none; b=ZywE5zRbYmc+WIx2bpfVKhiGWFKSliJ+ceB0qpXYgWVxgZM2l8R9COQHo1hHAJVzadNERZiiUnOIBOj2oXfl+UQdgrI7FgNjNMwNqg00kZO8rX02TY+kxBNriiocYJFt32javlUfJ/zP1wuhXYe1yU5EzBfpeWSuVLqjQCCXdQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838445; c=relaxed/simple;
	bh=Br2lUifwvVvbQtTyl++gxiMbY6SCydbvuFV6swwBhRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYn6GqEHOWr9uIi/tlYKWY0rFuqiPj3z+2Q73PVEnQOSqJSMziZ5mqIO9MPhZIEdvMaAYubwMmtCmGznBy4kXsjZfT6z0o5Y4q6JYJ7b7xpVSR4ODVr2RPQZ9OJnC6O0GkwbzPXjzLEtFTmJNl1WMRtRjTndC1PkSFxMiEq4K/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6czHn5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6czHn5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA54C2BBFC;
	Mon, 27 May 2024 19:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838444;
	bh=Br2lUifwvVvbQtTyl++gxiMbY6SCydbvuFV6swwBhRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6czHn5GNESp+Zi7fFFnijrBdjON0Kka/LVbSJVbFL354QikZkLETHrklq2u9lXQ7
	 oRyiOwu/ZjQ2Oyr24QMeATrsDy6jTLp+DtIL5hgbdKZUfNPlToUHSKcE6ZlUutyqp2
	 dIKesMzsVaYHgCeR4a5oIZmT1SAhpWfrl7z5ByGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Xiubo Li <xiubli@redhat.com>,
	Chris Down <chris@chrisdown.name>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 356/493] dev_printk: Add and use dev_no_printk()
Date: Mon, 27 May 2024 20:55:58 +0200
Message-ID: <20240527185641.928718059@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c26ec799042a3888935d59b599f33e41efedf5f8 ]

When printk-indexing is enabled, each dev_printk() invocation emits a
pi_entry structure.  This is even true when the dev_printk() is
protected by an always-false check, as is typically the case for debug
messages: while the actual code to print the message is optimized out by
the compiler, the pi_entry structure is still emitted.

Avoid emitting pi_entry structures for unavailable dev_printk() kernel
messages by:
  1. Introducing a dev_no_printk() helper, mimicked after the existing
     no_printk() helper, which calls _dev_printk() instead of
     dev_printk(),
  2. Replacing all "if (0) dev_printk(...)" constructs by calls to the
     new helper.

This reduces the size of an arm64 defconfig kernel with
CONFIG_PRINTK_INDEX=y by 957 KiB.

Fixes: ad7d61f159db7397 ("printk: index: Add indexing support to dev_printk")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/8583d54f1687c801c6cda8edddf2cf0344c6e883.1709127473.git.geert+renesas@glider.be
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dev_printk.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 6bfe70decc9fb..ae80a303c216b 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -129,6 +129,16 @@ void _dev_info(const struct device *dev, const char *fmt, ...)
 		_dev_printk(level, dev, fmt, ##__VA_ARGS__);		\
 	})
 
+/*
+ * Dummy dev_printk for disabled debugging statements to use whilst maintaining
+ * gcc's format checking.
+ */
+#define dev_no_printk(level, dev, fmt, ...)				\
+	({								\
+		if (0)							\
+			_dev_printk(level, dev, fmt, ##__VA_ARGS__);	\
+	})
+
 /*
  * #defines for all the dev_<level> macros to prefix with whatever
  * possible use of #define dev_fmt(fmt) ...
@@ -158,10 +168,7 @@ void _dev_info(const struct device *dev, const char *fmt, ...)
 	dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__)
 #else
 #define dev_dbg(dev, fmt, ...)						\
-({									\
-	if (0)								\
-		dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
-})
+	dev_no_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 #ifdef CONFIG_PRINTK
@@ -247,20 +254,14 @@ do {									\
 } while (0)
 #else
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
-do {									\
-	if (0)								\
-		dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
-} while (0)
+	dev_no_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 #ifdef VERBOSE_DEBUG
 #define dev_vdbg	dev_dbg
 #else
 #define dev_vdbg(dev, fmt, ...)						\
-({									\
-	if (0)								\
-		dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
-})
+	dev_no_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 /*
-- 
2.43.0



