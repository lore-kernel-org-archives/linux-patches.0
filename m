Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E873A1ABEB9;
	Thu, 15 Aug 2024 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731297; cv=none; b=fED4TW5QtdQFj5PiD1c7YOqWwyh+WhRZjKFg1g/lcn42zjmHBf/bW5FbIYvPshjR1kp7YUZkG6+pwT+GhjlxPw+7qqUu6Xev4EoC4lekfQK0Et8pnmNl6UJ1Olxs7Yen7A6szSffeH8FaiHgJGVg2JG7hjN/7XEZWikvXyBRvtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731297; c=relaxed/simple;
	bh=xi+v/aZRbiBjI3pcjBlRJGD8oE+UXM0WuXY3/jkZ9Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wt8KMq/OLHh9VPnBNp3ENXjAyrX/NHBV2Xwbfqn28w6Em3LntY9aUP8UqrAp3d9wKvIFi8C2Dk9KsKRhmoviARHDTYzRVQbno0LW5v0E/EUdDjCwLcfytwI2HAWD4mGsJ7j5rn0U4NvLW7eLHKzPhZo+U+0Q+X9oMnaIZdgFKf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLFNoZAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLFNoZAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC39C32786;
	Thu, 15 Aug 2024 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731296;
	bh=xi+v/aZRbiBjI3pcjBlRJGD8oE+UXM0WuXY3/jkZ9Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLFNoZAM4NU978dzeaJbIrXD1rO7zaZ9buxXlNsTSX/8KBSI5eoQiK2FsAhZYOwUg
	 U2OZVP3hwEVay35W98o3zmIdhPnpxi/iYU9fCe2/es/SQmu4EkAgQqlCbA04ylNLvG
	 5qnzkGAAMzWUUBZNPK0ct+1GyhWBOeo3AFsVSUOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/259] pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails
Date: Thu, 15 Aug 2024 15:23:37 +0200
Message-ID: <20240815131906.044878398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9b401f4a7170125365160c9af267a41ff6b39001 ]

This driver calls pinctrl_register_and_init() which is not
devm_ managed, it will leads memory leak if pinctrl_enable()
fails. Replace it with devm_pinctrl_register_and_init().
And add missing of_node_put() in the error path.

Fixes: 5038a66dad01 ("pinctrl: core: delete incorrect free in pinctrl_enable()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240606023704.3931561-4-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index b597504ae6a46..e75c641c24455 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -881,7 +881,7 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 	iod->desc.name = dev_name(dev);
 	iod->desc.owner = THIS_MODULE;
 
-	ret = pinctrl_register_and_init(&iod->desc, dev, iod, &iod->pctl);
+	ret = devm_pinctrl_register_and_init(dev, &iod->desc, iod, &iod->pctl);
 	if (ret) {
 		dev_err(dev, "Failed to register pinctrl\n");
 		goto exit_out;
@@ -889,7 +889,11 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, iod);
 
-	return pinctrl_enable(iod->pctl);
+	ret = pinctrl_enable(iod->pctl);
+	if (ret)
+		goto exit_out;
+
+	return 0;
 
 exit_out:
 	of_node_put(np);
@@ -906,9 +910,6 @@ static int ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
-	if (iod->pctl)
-		pinctrl_unregister(iod->pctl);
-
 	ti_iodelay_pinconf_deinit_dev(iod);
 
 	/* Expect other allocations to be freed by devm */
-- 
2.43.0



