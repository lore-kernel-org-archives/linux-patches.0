Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7711B395F;
	Mon, 10 Mar 2025 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630962; cv=none; b=NTaL6vboLNd5fH8+QCJwo7IbdaRnNyPdbYB1NpukZydwp0n1wR1hzr876oYey9wvGOCOkedgKbOkCA4Gbefy5fpFZghC9obw89On4svoYovOU7TTfCtgzsdY2tL/UQoHnhRA2jk/lOLstNM3Fbtxlz03VPM9xJ1+BMP9ws5qFoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630962; c=relaxed/simple;
	bh=WNJh4wEsFvHAw4iyyqdwpqy/bT/p0Py8oxdG2NAOnTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtUOWobMm/n9FDs+vH/lb+miaPSbOYYPb8h7cvjMkMvz1tSAYdi0UdBNv4bgrxaHYDPDO1IgtNwXQ3afqsOyprCI+oZlHQjadnyzkimhcLQ9lR1jiFuolq2alopX7KjcbT0g7EzpEwqKtYX9yGquYyeo0FpmWXX6KoGsphPzM7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0et5EaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0et5EaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6CFC4CEEC;
	Mon, 10 Mar 2025 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630962;
	bh=WNJh4wEsFvHAw4iyyqdwpqy/bT/p0Py8oxdG2NAOnTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0et5EaLjLw2iWNlzmx2flSta5uutI8hl6vXnSQOwU8Xtxl86pdvWUjAtQfsrwu8R
	 33xoZhycMwYMXrBpkRQO0oGBswM/vebzd+SMWq7SbUI3mUoT5/t58dG7M8T5NTUIA5
	 4SJ1MC0BZihsO3WGRC8JFwraxglMiYVieAxW80OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghuo Chen <xinghuo.chen@foxmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 563/620] hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
Date: Mon, 10 Mar 2025 18:06:49 +0100
Message-ID: <20250310170607.767906481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinghuo Chen <xinghuo.chen@foxmail.com>

[ Upstream commit 10fce7ebe888fa8c97eee7e317a47e7603e5e78d ]

The devm_memremap() function returns error pointers on error,
it doesn't return NULL.

Fixes: c7cefce03e69 ("hwmon: (xgene) access mailbox as RAM")
Signed-off-by: Xinghuo Chen <xinghuo.chen@foxmail.com>
Link: https://lore.kernel.org/r/tencent_9AD8E7683EC29CAC97496B44F3F865BA070A@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index a64f768bf1818..60a8ff56c38e9 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -719,7 +719,7 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 			goto out;
 		}
 
-		if (!ctx->pcc_comm_addr) {
+		if (IS_ERR_OR_NULL(ctx->pcc_comm_addr)) {
 			dev_err(&pdev->dev,
 				"Failed to ioremap PCC comm region\n");
 			rc = -ENOMEM;
-- 
2.39.5



