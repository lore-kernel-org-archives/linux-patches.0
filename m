Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E45936C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302341; cv=none; b=aOr+ERv8E5S+WxAIQPF0N2Ow1JD32WFo9FqARiLNEmyYhVaFj/6VB6R/NKS1otX2KTd1JNppaThrj10vX0JAXPRXNcGPuAEKeSJSz/9WVPs03DnXlWk3WpsLEkIYBoQjN12I6Wq4cHANNi4gEBtrXSQ55WGYYK3CSPSxJRa5nmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302341; c=relaxed/simple;
	bh=Bx/EA5z7QaIyPEa93LO26/t+6zf4H02FoyqWfxG2v/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHH8lJyZMwIzHhk0kRjISIBWv1uQXVsboyAEMkWW5ltgu9Nl47Dn1SwMhJScrSxdIG3W9g7kvYPr0d8ZMGoI2laSm4xpf/lIeIFKICLqcYHfTvztWjfUeDxUaQXKqhrwxAYKBmwIABfP0zfjxWUMi7DYgO9zj2ObCBMS93fKjzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B50n6dlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B50n6dlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E30C19423;
	Sat, 28 Feb 2026 18:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302340;
	bh=Bx/EA5z7QaIyPEa93LO26/t+6zf4H02FoyqWfxG2v/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B50n6dlwrJvse84fnSyKmcav01ACzfjKFyvhEV02neuLOzUaivA+H2tdZBymL8ar0
	 T8DWH9fIJGYe3lv0Yxibe5y6cYLSOkhf1wzzjhx3Z7uHruZYCaU2gMQOH2LbXfJCid
	 yvbELIZ10N4EvoGcU6b4JmW+1/ZOIQuJtAGov0V4+KEcE/U1Oq2lLL0jlytJj3DIv1
	 ulwm1eox0FwgZnLSElM1GoYHc5+Nj4YwN5FHp7AQRPGlzSnS/q4q+EQeI+YkXChdOC
	 eAwujKr4609B90/fUM8nZ+gXmCdXGKisrD2oduDw/OyNf5VtZzsffDi9F/CAQ4AIvL
	 TnI0ACGHRlr/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/232] soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
Date: Sat, 28 Feb 2026 13:08:36 -0500
Message-ID: <20260228181127.1592657-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6259094ee806fb813ca95894c65fb80e2ec98bf1 ]

In svs_enable_debug_write(), the buf allocated by memdup_user_nul()
is leaked if kstrtoint() fails.

Fix this by using __free(kfree) to automatically free buf, eliminating
the need for explicit kfree() calls and preventing leaks.

Fixes: 13f1bbcfb582 ("soc: mediatek: SVS: add debug commands")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
[Angelo: Added missing cleanup.h inclusion]
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 1ec6e631a7796..9897905a65baf 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -7,6 +7,7 @@
 #include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/debugfs.h>
@@ -709,7 +710,7 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 	struct svs_platform *svsp = dev_get_drvdata(svsb->dev);
 	unsigned long flags;
 	int enabled, ret;
-	char *buf = NULL;
+	char *buf __free(kfree) = NULL;
 
 	if (count >= PAGE_SIZE)
 		return -EINVAL;
@@ -735,8 +736,6 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 		svs_adjust_pm_opp_volts(svsb);
 	}
 
-	kfree(buf);
-
 	return count;
 }
 
-- 
2.51.0

