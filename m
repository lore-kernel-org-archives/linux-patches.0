Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DB12EAE5;
	Thu, 12 Dec 2024 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015971; cv=none; b=q2QQXATMNiZpZN53BFFO3+6mgv8OAzRqMJmpJCD94+MdqmyKctXdfNwFdeq8khDgGzezx+tmmtzARPqnCe8RaTk9O4sS1pvoJIucKAGUec7N/2ffcDkoQF+SD42Nl+BDkSIH8z1LF+S5hkp40D1tdklFFRUqGJHnpf7s414ShGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015971; c=relaxed/simple;
	bh=78loKXQ4MK8DZIFsj5Vj5Fi7sG91GkpGKZ/czPmmejc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoN8FuIN5UMzrHibk8Bzaw7J4Z8fcWTlnrQZbzjYoCCdj0uVH1Wars0C/up/RUV3NsxjhVvEKUUUj0tfvcmYg5JmU8BSW3bLuq4cRPa7DuaiuDpF/kJUUtAJYu3T/1AVbmNdN1jODsVZG5XX/r8wVNVlCt8L1/lsIN70YiyKts4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ue38lrMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ue38lrMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29ACC4CECE;
	Thu, 12 Dec 2024 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015971;
	bh=78loKXQ4MK8DZIFsj5Vj5Fi7sG91GkpGKZ/czPmmejc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ue38lrMxeonUe2F9Ndb53QJT4vkVGcn51H8lpzP1WVyzCvH5OQvwgzKRy031H/JTD
	 3HtkKbFwYJ9D3dIcX74Ojkwivfa/RPOh05S36QvEg0Xvs5lPTYOreTCRfMK01XvuON
	 9IMNRqbAXC5k5STSRt9V/7Xdxt3yYAUSoAj1TbPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/466] mmc: mtk-sd: fix devm_clk_get_optional usage
Date: Thu, 12 Dec 2024 15:53:54 +0100
Message-ID: <20241212144309.386283710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ed299eda8fbb37cb0e05c7001ab6a6b2627ec087 ]

This already returns NULL when not found. However, it can return
EPROBE_DEFER and should thus return here.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20240930224919.355359-4-rosenp@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 2508925fb346 ("mmc: mtk-sd: Fix MMC_CAP2_CRYPTO flag setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 73f97f985daf4..83e7291481861 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2773,9 +2773,8 @@ static int msdc_drv_probe(struct platform_device *pdev)
 	if (!(mmc->caps2 & MMC_CAP2_NO_MMC)) {
 		host->crypto_clk = devm_clk_get_optional(&pdev->dev, "crypto");
 		if (IS_ERR(host->crypto_clk))
-			host->crypto_clk = NULL;
-		else
-			mmc->caps2 |= MMC_CAP2_CRYPTO;
+			return PTR_ERR(host->crypto_clk);
+		mmc->caps2 |= MMC_CAP2_CRYPTO;
 	}
 
 	host->irq = platform_get_irq(pdev, 0);
-- 
2.43.0



