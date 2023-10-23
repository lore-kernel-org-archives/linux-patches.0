Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC46615EB1
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP+fCt+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C1DC433C8;
	Mon, 23 Oct 2023 11:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061787;
	bh=kjY1TbFtR/rWzvv8YeAGUQ0hjIbqKsQaWLraHKYHv8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP+fCt+gYpsYSIVMsc3bOjL8av0wymOGiRysqN2eVOlXU7cM6U23MPvsSEtFGiUNv
	 hkou79LFf763/p+bVMZqtfb2+isQhL8NdzjMjIPCcS5v1Xc1Owbk3LCIR3uTGIyaEA
	 Wp1ac6+LDRM1zcUuh0mAnbh1g0QDxwHagD3h/Ehs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/202] regulator/core: Revert "fix kobject release warning and memory leak in regulator_register()"
Date: Mon, 23 Oct 2023 12:57:52 +0200
Message-ID: <20231023104831.318805325@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit 6e800968f6a715c0661716d2ec5e1f56ed9f9c08 ]

This reverts commit 5f4b204b6b8153923d5be8002c5f7082985d153f.

Since rdev->dev now has a release() callback, the proper way of freeing
the initialized device can be restored.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Link: https://lore.kernel.org/r/d7f469f3f7b1f0e1d52f9a7ede3f3c5703382090.1695077303.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 52b75779dbb7e..51c4f604d3b24 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5483,15 +5483,11 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	mutex_lock(&regulator_list_mutex);
 	regulator_ena_gpio_free(rdev);
 	mutex_unlock(&regulator_list_mutex);
-	put_device(&rdev->dev);
-	rdev = NULL;
 clean:
 	if (dangling_of_gpiod)
 		gpiod_put(config->ena_gpiod);
-	if (rdev && rdev->dev.of_node)
-		of_node_put(rdev->dev.of_node);
-	kfree(rdev);
 	kfree(config);
+	put_device(&rdev->dev);
 rinse:
 	if (dangling_cfg_gpiod)
 		gpiod_put(cfg->ena_gpiod);
-- 
2.40.1



