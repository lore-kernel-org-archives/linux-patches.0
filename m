Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7037DA78;
	Thu, 15 Aug 2024 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728621; cv=none; b=PBhIOAHzbXqVgZtlj86bkGrKKrWshr0FS+dXupNZ0zZEMSORsZ6KjiX37gYqG0o2e/llyK+NiF7M00ZBpcGyN1uH0bIACWkJL8dEzY5yb94gEaL9fnCmYvx3qOVZM/rAqADi+cJNG5hd9tex0bkMe3xOu/rUKWUwMyrJfBkUmNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728621; c=relaxed/simple;
	bh=mzoDpbZUQxVCuuBAZRYXs1QGmW1V4tXRd40KqccMzbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXBHQliFoMPVDUn4v6HGImlfIxUZePGaRBC8JQ/FNEXKor4YvAtpBc8XUOwGgazszoFXVw2EKe3p0GwfUnWkUyjLcnIs0FG6mBgLHrt1I1BRJYX4DTOmaELoNvRpoIi+0ATpTA/MzaxIQqGE+VGn08YDnPqz0oka2CJ2lHutrEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ly45wLt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ly45wLt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB9FC32786;
	Thu, 15 Aug 2024 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728621;
	bh=mzoDpbZUQxVCuuBAZRYXs1QGmW1V4tXRd40KqccMzbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ly45wLt3LZcKQJ0qw8/j33hWAweNhBAEwg1Pqgc2i8BpKCv7St/P4F8jr02dDja8a
	 dhO73GKo3bW11+SMBbkkyxjOftFj1oiZ7MhHoujNjAaPKyGySAUGKz4mQw5nVczVqy
	 QFvAtkH0vQ26dhBtcjBGQv6s+TYAjX9BFtY4frGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/196] pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails
Date: Thu, 15 Aug 2024 15:22:55 +0200
Message-ID: <20240815131854.297483291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 1c4196f40e8d6..e86b765141a63 100644
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



