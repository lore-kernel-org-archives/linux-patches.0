Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6CB383C73
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302087; cv=none; b=WZK20DR5lKmtNmoUSZRUt7GBXvq93mYm3fcCvCAW07dtrsb2a1i0lgCeJhwnlDmOouj88eQE4aF8HEtXTI9jBemqzhJje8n6qzmDQnXTv9np2WRz7ablvJ0fk6j3GfU1GWfN3KGExkN21uYiiSXCLzgLrsaYY6I00OqeD1WDIgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302087; c=relaxed/simple;
	bh=yo2+6IiFFueBZh/rrxeyS/LoylybzgvjFndYoOlvHmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoN0M8IFLSOrloGIo0oBoWUYd59P6RztSETmqXWbUYm/inVGNw+H9tBKz1ocCqpmE9hgZ1ImL7k0JLdKBqr7fSZXgsTKCjnpyWb5kh3WFSypDu04vl9EV896JmY6vUX+l7DeKfhqikAB+eOaCDSP45dVHviwvd4P/hqPS3On0oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpnS6TD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpnS6TD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E91C116D0;
	Sat, 28 Feb 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302087;
	bh=yo2+6IiFFueBZh/rrxeyS/LoylybzgvjFndYoOlvHmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpnS6TD6J7mWOPQw2FWnRZoYWt2wP/hlgFcVt9dYMW/Ll0So8yn+GX2gUzpYNuLpz
	 HMHttBT7xJgK3iBrUF9G5UmdhXjMsNJW4WSauTWgYGqOlmKJgQ9y//Sb834Hl/xZqp
	 HQmSU/f2AK8qj/5Xm6ywXU0BSRa/S7WPSLrsXM9bif5vcFsYxCyfkkYfQbaPCel2Jv
	 IrG0KLEjFJKYSpW01M1cw7IRopjq/fHhtcskfyNR8U4iwcEeeLBYGHgJdnNqFCMQK7
	 h6mb/mnY1/DyWH53C55U9U8ldzPyZfYd+U5ekOEP0u4VdDP81bBT4rQBKqldHkLEs3
	 YaYcYHB7FBBrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/283] soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
Date: Sat, 28 Feb 2026 13:03:32 -0500
Message-ID: <20260228180709.1583486-70-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 3a2f97cd52720..37d21e3de6942 100644
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
@@ -717,7 +718,7 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 	struct svs_bank *svsb = file_inode(filp)->i_private;
 	struct svs_platform *svsp = dev_get_drvdata(svsb->dev);
 	int enabled, ret;
-	char *buf = NULL;
+	char *buf __free(kfree) = NULL;
 
 	if (count >= PAGE_SIZE)
 		return -EINVAL;
@@ -735,8 +736,6 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 		svsb->mode_support = SVSB_MODE_ALL_DISABLE;
 	}
 
-	kfree(buf);
-
 	return count;
 }
 
-- 
2.51.0

