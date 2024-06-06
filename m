Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8B198824;
	Thu,  6 Jun 2024 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683334; cv=none; b=CrJRHtYE77cxuVsMWxdw1X0MSoYx8Ypr4cbIA+4i7Rf/LmNS6t3TfHlE8Tm75+aSFXtOPMugypocIJKUkkXgUc82p86fyQp14vknZVcOrfxJv0z/yN7kmDR87bWyvkp7CplsaxwyM4tASSdSPtEiC2BG86RA5q3bO5nYQPz4pKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683334; c=relaxed/simple;
	bh=rFOAfs6MZcoQJSXLbN9/UudXQGDFBRK83v5xHi1EjMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPEcOZRyQ/rGio4yaDMBmWOXhEC+2ynkYyoZs+y86sOjYhcv9AmSHdFpuwkqjHMmSe9Ft62slKqx2bnOBZoPLJqRQo6VDgxzf+agS+DaT3HgT9YIc/RGBjuoT9pUhAHRjFmRC7SnhYnVAGL0PUwCL9MYuCVYm7mXHjc/42figM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xvu2wVlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xvu2wVlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8970C2BD10;
	Thu,  6 Jun 2024 14:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683333;
	bh=rFOAfs6MZcoQJSXLbN9/UudXQGDFBRK83v5xHi1EjMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xvu2wVlorEaeKF6+hhsCEoEB1oMgdobUEtSOXk+xvtBNuUv0heXNpbAbxrJvfU5gM
	 vc2zZR1VHv6G5JEmcXp9nKpUjD6CoCKVtFSCKOtPSxVZWpArqlZ1MlJZ28u77Roikq
	 joo0RHd2MsOCyW/o0J1mU2eoKP929v/bwHwEOzTE=
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
Subject: [PATCH 6.6 275/744] dev_printk: Add and use dev_no_printk()
Date: Thu,  6 Jun 2024 15:59:07 +0200
Message-ID: <20240606131741.206799175@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



