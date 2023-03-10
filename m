Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8198821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B13C433D2;
	Fri, 10 Mar 2023 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460148;
	bh=EhWHElz6p0xnaf29qofh8FHWqBu6iEtQuEfAlqoIeyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/G/vrZwsWklidJ3YrPXSTF1b0aZMsv3VG7LZHP7VQOX17MYHVg9sDagKGR+sOMFn
	 nn4Y9lWpM0UT7DJuxhij3VKXAhXZj8iW52QXZpuzlm9osedzeO2eA+akDQtIiane46
	 VeIYNpG8DBc4JartYVrp+KMvdGoUJlvq396FWDQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/529] linux/kconfig.h: replace IF_ENABLED() with PTR_IF() in <linux/kernel.h>
Date: Fri, 10 Mar 2023 14:36:21 +0100
Message-Id: <20230310133816.015937030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 0ab1438bad43d95877f848b7df551bd431680270 ]

<linux/kconfig.h> is included from all the kernel-space source files,
including C, assembly, linker scripts. It is intended to contain a
minimal set of macros to evaluate CONFIG options.

IF_ENABLED() is an intruder here because (x ? y : z) is C code, which
should not be included from assembly files or linker scripts.

Also, <linux/kconfig.h> is no longer self-contained because NULL is
defined in <linux/stddef.h>.

Move IF_ENABLED() out to <linux/kernel.h> as PTR_IF(). PTF_IF()
takes the general boolean expression instead of a CONFIG option
so that it fits better in <linux/kernel.h>.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 18ab69c8ca56 ("Input: iqs269a - do not poll during suspend or resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ingenic.c | 3 +++
 include/linux/kernel.h            | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index e0df5ad6741dc..4d07c531371cd 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -11,6 +11,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -2826,6 +2827,8 @@ static int __init ingenic_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#define IF_ENABLED(cfg, ptr)	PTR_IF(IS_ENABLED(cfg), (ptr))
+
 static const struct of_device_id ingenic_pinctrl_of_match[] = {
 	{ .compatible = "ingenic,jz4740-pinctrl", .data = &jz4740_chip_info },
 	{ .compatible = "ingenic,jz4725b-pinctrl", .data = &jz4725b_chip_info },
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 394f10fc29aad..66948e1bf4fa6 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -47,6 +47,8 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+#define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
+
 #define u64_to_user_ptr(x) (		\
 {					\
 	typecheck(u64, (x));		\
-- 
2.39.2



