Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BE51D319B;
	Wed,  2 Oct 2024 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879492; cv=none; b=sGFvRiZ7ZzNMYP15CAsA3d5X+1nVq0lPVM7w0snX6qE71NF5TalO0KPfq8DHHMk0uxT4GR7bEFCuY03WDOmC3RvNtAI2w3GfkJWHFDLnKimUWhLTFzRkViD7YXWsfoTugC1xbJYdT7ki8uB+tnjLS8TbU+W6nj3BXPQpMLWi2g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879492; c=relaxed/simple;
	bh=lpeeOhN4u54p7wQdyyS9CIseET9+0JSlDcF9C4Oiyvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA6hbSo6tFMKdmd00IMv5zLy4ZEhsTGKgDN61/1iZxGPy4nFXldefz6CIG8fWTtgenFpqGY5dvZY8FBg1tKSlmXAK9NxmM4EAeuoTqp2d7VILnNkbBK4ZWZTNsw+7pYi9vOpf5FWC3lS9g51XYWGcxpmzct2gWXTe9X7KTbmNbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEWhgYv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEWhgYv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689E7C4CEC2;
	Wed,  2 Oct 2024 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879491;
	bh=lpeeOhN4u54p7wQdyyS9CIseET9+0JSlDcF9C4Oiyvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEWhgYv4ki9khcEWR95Lr/+rKXM6Dq5ECMDI2Vcyj7y6pf6/9zHjqvmSXctXjB3gu
	 X35NcgYbAKKKaAccRNj2UtacB1fnkQueHRHEXOeE5BQ3WL5TXXhhg4Y3D0de7Qa/VJ
	 jFayJTEgFIzpGl4B2BgvIyIp2AbzvQEyfFLhDj7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/538] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Wed,  2 Oct 2024 14:56:17 +0200
Message-ID: <20241002125757.689139012@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ce7c90bfda2656418c69ba0dd8f8a7536b8928d4 ]

If drm_dev_register() fails, a call to drv_load() must be undone, as
already done in the remove function.

Fixes: b759012c5fa7 ("drm/stm: Add STM32 LTDC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20fff7f853f20a48a96db8ff186124470ec4d976.1704560028.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/stm/drv.c b/drivers/gpu/drm/stm/drv.c
index e8523abef27a5..4d2db079ad4ff 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -203,12 +203,14 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto err_put;
+		goto err_unload;
 
 	drm_fbdev_dma_setup(ddev, 16);
 
 	return 0;
 
+err_unload:
+	drv_unload(ddev);
 err_put:
 	drm_dev_put(ddev);
 
-- 
2.43.0



