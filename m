Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F226771B32;
	Mon, 15 Apr 2024 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191071; cv=none; b=i6FOtevLxzivuHhw2xfnGbLmHrMvhSSuO19IuokKuFdn+W4U6YyHJtL+2iWuZtxwCqPK91GbFMTqGmDRjDLiYIn+lDxeFNbtvepew+fbiPJm52cco/zEYFK5GN4hoPfB9V1jpg88hqdmqC++PKDQvSvS/6eCD7muPYOOYBzFQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191071; c=relaxed/simple;
	bh=qj5UAW64L7gwLCwPrnRK6KJXVA+XLk/xlAnn4fe8fOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAT78ak9ToJcS00cJrwLUzlmpyZ9u1B6q/y0kfRMVxrfnRBkckCvRPM6bh5wmncDzR3fAjlOUO/qrJV5kwJKvVnX7c1g7ITbpEAmHC6cY9T0yQNHja8j7doRv28UrcytxRghVDPxfL4EJOxcF+tP9/PCHZ870GH2lHERue9XM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f5jC0mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f5jC0mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E559C113CC;
	Mon, 15 Apr 2024 14:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191070;
	bh=qj5UAW64L7gwLCwPrnRK6KJXVA+XLk/xlAnn4fe8fOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f5jC0mG1vTuz7nyfzJWZPSxoCuoZoYb7Ud6rj9VvUNnHjKkYvEUVJxepymJ/JFaY
	 AKP8TxiL+f20lXGz53kgvrealsQc17w0fIhFkSHLl696eU52MkZpuEopJP24gQlnha
	 kHL2fxiNu50T03cGu5W4i2jCvIP8udv9uS0J+Zvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 023/172] mmc: omap: fix deferred probe
Date: Mon, 15 Apr 2024 16:18:42 +0200
Message-ID: <20240415142001.055940090@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit f6862c7f156d04f81c38467e1c304b7e9517e810 ]

After a deferred probe, GPIO descriptor lookup will fail with EBUSY. Fix by
using managed descriptors.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-5-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index aa40e1a9dc29e..50408771ae01c 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1259,18 +1259,18 @@ static int mmc_omap_new_slot(struct mmc_omap_host *host, int id)
 	slot->pdata = &host->pdata->slots[id];
 
 	/* Check for some optional GPIO controls */
-	slot->vsd = gpiod_get_index_optional(host->dev, "vsd",
-					     id, GPIOD_OUT_LOW);
+	slot->vsd = devm_gpiod_get_index_optional(host->dev, "vsd",
+						  id, GPIOD_OUT_LOW);
 	if (IS_ERR(slot->vsd))
 		return dev_err_probe(host->dev, PTR_ERR(slot->vsd),
 				     "error looking up VSD GPIO\n");
-	slot->vio = gpiod_get_index_optional(host->dev, "vio",
-					     id, GPIOD_OUT_LOW);
+	slot->vio = devm_gpiod_get_index_optional(host->dev, "vio",
+						  id, GPIOD_OUT_LOW);
 	if (IS_ERR(slot->vio))
 		return dev_err_probe(host->dev, PTR_ERR(slot->vio),
 				     "error looking up VIO GPIO\n");
-	slot->cover = gpiod_get_index_optional(host->dev, "cover",
-						id, GPIOD_IN);
+	slot->cover = devm_gpiod_get_index_optional(host->dev, "cover",
+						    id, GPIOD_IN);
 	if (IS_ERR(slot->cover))
 		return dev_err_probe(host->dev, PTR_ERR(slot->cover),
 				     "error looking up cover switch GPIO\n");
@@ -1402,8 +1402,8 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
 
-	host->slot_switch = gpiod_get_optional(host->dev, "switch",
-					       GPIOD_OUT_LOW);
+	host->slot_switch = devm_gpiod_get_optional(host->dev, "switch",
+						    GPIOD_OUT_LOW);
 	if (IS_ERR(host->slot_switch))
 		return dev_err_probe(host->dev, PTR_ERR(host->slot_switch),
 				     "error looking up slot switch GPIO\n");
-- 
2.43.0



