Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF79E1AAE1D;
	Mon, 14 Oct 2024 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917682; cv=none; b=TBhe2Dgam6y3LDjFrDHZI/FzJxtgNxyox1WwfT+4FwFXkc4EJ6vma1DGjRQNs/oHNy5uXwnCnef0uEOhvkK+Sr3fIj9i16FyIUHm8foyU7m6Dy+AFGH4s7kTSaKME6GlBop93gS253Hm7/4VP1eRcZaa0KEn4oUyoGUoYBx8Wao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917682; c=relaxed/simple;
	bh=PqLOQXsrWkYbe9rKVFg9EKIl8IIHrDaN/eanTmJknvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dnj7gxrXli5vpvHY4EwN4ZR+hLRyhwdS4EDWsY9/qJsprFJzI8Oh7gHqzRHu9YdUtBUGGqNdCc68sJk5ZaYr32tHW+IYNDXtMLegAsw+eJIkxEkJK30p/jLvajQPALyZy/dx3hTBBgYd9vn4B4l+JshtW9Pd49lwx105b6Vz+l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPKzAp/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPKzAp/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21965C4CEC3;
	Mon, 14 Oct 2024 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917681;
	bh=PqLOQXsrWkYbe9rKVFg9EKIl8IIHrDaN/eanTmJknvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPKzAp/b7MYDFZvrdEjYizdpEmwVqa99EQTSXPsdm3254zcncQi0D7odexVvdNW5D
	 HYwWzg8xtYYFSicEu5nlK3ayElbf6YGb4SUPIoE1nqVONbctxTmaOLZxntfH6w9Byo
	 aXYwtyK+5Nm7nXxmmq/I9Mvuuy/GVR+eOPs3JsEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/798] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Mon, 14 Oct 2024 16:10:57 +0200
Message-ID: <20241014141221.976429239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a09a85ac9d69..77b1b10456f52 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -201,12 +201,14 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto err_put;
+		goto err_unload;
 
 	drm_fbdev_generic_setup(ddev, 16);
 
 	return 0;
 
+err_unload:
+	drv_unload(ddev);
 err_put:
 	drm_dev_put(ddev);
 
-- 
2.43.0



