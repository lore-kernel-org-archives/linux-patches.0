Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C6375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301712; cv=none; b=Zhmu96q26rBrkKHKt4GSMlLzNHGp/NaKsQ3gIN53wFsN7agVFVOWDgJghgwfd/wdmpiOvPIs9UmNlvSh8Z2fWPqESHosRESCgfeS72XsJ22bZzC9xmyE1ccdY+u0hVyWJOTWGxuDBDjpE3pgbBAGskPQ3pELci2uPb9MrbE8frA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301712; c=relaxed/simple;
	bh=j+mswgq77NEhCfOH5nuXFJ7mXyfghs+gyXb5NUCtBF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awsSjwimKHkNM3d5s+mjqspm1f1d5Ax6KD9g/G7w8/RiKSsTDstauPmZR3wZoArDnNO5XzDWbrYSd6TAyuMEUnhQFoRCwFtRHoPIlEy92BMuEQY8mxl00SBR78q3qrTV0FmxsoF8v5yl+mxppwDe9uP38DzyztsI3isfemD41YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abGJ0fji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abGJ0fji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD015C116D0;
	Sat, 28 Feb 2026 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301712;
	bh=j+mswgq77NEhCfOH5nuXFJ7mXyfghs+gyXb5NUCtBF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abGJ0fjiUWcVntZlD+Kkqe78na3W5SWn3jLGoXoCZaFULOGEOfJSXCt8OmMjccSoz
	 XaYa4HX6VeloNurVRxHuBBNpDLptFClh1U4+wlabH77xzhYKt2Z5jHcrY/9SHKqJKc
	 gzgwAyma/y6SNvkaSzLmpVbGPRISkwdsopCINolDVhCGdCszfIDM6YYb6h0ds5Yu6e
	 iQs8v4NpUDCmMrM2nGACkPCSBJyi5Y6NCvogs1T1C33mC5Cd2HChO3N0MsF7vcFnAB
	 niReFCqvu0apyiaw6K86B0B059YeUX5mam0frs11flKufeZGptL18d7RmRr8uR71zE
	 1zAoxfxe898HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/385] soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
Date: Sat, 28 Feb 2026 12:55:29 -0500
Message-ID: <20260228180011.1568201-107-sashal@kernel.org>
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
index 4cb8169aec6b5..07ab261e1269d 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -9,6 +9,7 @@
 #include <linux/bits.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/cleanup.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
 #include <linux/debugfs.h>
@@ -789,7 +790,7 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 	struct svs_bank *svsb = file_inode(filp)->i_private;
 	struct svs_platform *svsp = dev_get_drvdata(svsb->dev);
 	int enabled, ret;
-	char *buf = NULL;
+	char *buf __free(kfree) = NULL;
 
 	if (count >= PAGE_SIZE)
 		return -EINVAL;
@@ -807,8 +808,6 @@ static ssize_t svs_enable_debug_write(struct file *filp,
 		svsb->mode_support = SVSB_MODE_ALL_DISABLE;
 	}
 
-	kfree(buf);
-
 	return count;
 }
 
-- 
2.51.0

