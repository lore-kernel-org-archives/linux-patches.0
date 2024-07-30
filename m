Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2214831F;
	Tue, 30 Jul 2024 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358142; cv=none; b=fPUMronJGQQuvdDSmwR5wjo1e7xiH0t+9XlJ7sCNX2dF6Cj8oOXyXRGV/RfMoYEZrhMr+pZ4zYOsaq5GmasxN4yU9vdPdAz6OVIDNz8bNzHESyusmImo5UtZ3YZBZJdpvDXg48To+Sr8dwUJZvUDKej+jx7ULqX0oCQHEFVIVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358142; c=relaxed/simple;
	bh=798deU0TpUVTuU3CdlNG+39REZq1aBnDvwDtvSxeqA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLo1XnVHjEwr+Entajj2G3ILZL3N+BwgWNPuoO4vsnv4AVgxd2iQ/LeBXZrxXGB8kpeHnx4dotW86CJekEmNI8a96CQ5zf5/W2bdubke+rg45Hig8W055/w7ZmSuTTz2M2d1zGXmeWzkpliQjIgbZbI0+QSrQozww8cTJQND+xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZO8tLFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZO8tLFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4D9C32782;
	Tue, 30 Jul 2024 16:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358141;
	bh=798deU0TpUVTuU3CdlNG+39REZq1aBnDvwDtvSxeqA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZO8tLFbItyZWsK/nJG4AvxBen1DyR2lcZf+xRCWhYNSltJU971ZNrwgJ3Rxw3rgl
	 wiSa0Jqi+ab/mVVmB1suR5Gt7fFiegIouG5vu4C9qG1YcpYehUkWMsWg9dGj6gGhcl
	 xcKeEMyf28RKsuT0WG/iXn06ZIQBNN4RhIq/x0g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/568] pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:47:16 +0200
Message-ID: <20240730151652.732310365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index f3a2735620955..5370bbdf2e1a1 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -878,7 +878,7 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 	iod->desc.name = dev_name(dev);
 	iod->desc.owner = THIS_MODULE;
 
-	ret = pinctrl_register_and_init(&iod->desc, dev, iod, &iod->pctl);
+	ret = devm_pinctrl_register_and_init(dev, &iod->desc, iod, &iod->pctl);
 	if (ret) {
 		dev_err(dev, "Failed to register pinctrl\n");
 		goto exit_out;
@@ -886,7 +886,11 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, iod);
 
-	return pinctrl_enable(iod->pctl);
+	ret = pinctrl_enable(iod->pctl);
+	if (ret)
+		goto exit_out;
+
+	return 0;
 
 exit_out:
 	of_node_put(np);
@@ -903,9 +907,6 @@ static int ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
-	if (iod->pctl)
-		pinctrl_unregister(iod->pctl);
-
 	ti_iodelay_pinconf_deinit_dev(iod);
 
 	/* Expect other allocations to be freed by devm */
-- 
2.43.0



