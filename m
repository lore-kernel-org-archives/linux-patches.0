Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061991C07F6;
	Tue, 15 Oct 2024 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997194; cv=none; b=hKT/2corFXd+v59qlxmEuk7G/xdF1hKrePDbDlpMG+4nqmC84qyrCjJP9ZNFX1fwIHmYmpJjGc8eOLvT+FYJMuE/rfsbI91f/jEls/kv1DtyzH3H5naicOeVXfyLJ8F16KqGcj/sflmhxnJJ3G9Fkj7ElqKa9UEalnWY8qQlWXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997194; c=relaxed/simple;
	bh=xHbsyrhtw8OK6+3EUpsxkwwlG3RhpWjT9V4GTzMNeho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eg16ysLYWEznhn9M0xs4xfhhbOsbHXv+nj+F475i+qZV2BQcHqb+7s9khT9slC4T5DH/iOSuEtuIRiCXnOBcyih6keCe0lqlflXB6A1hNskWYi4lWlAU4O4p5aK+5il3NW8aGwPBXqWw6LiWv/0gwon7SVUycuyT0JTsHr+bAHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgxt0vLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgxt0vLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A541C4CEC6;
	Tue, 15 Oct 2024 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997193;
	bh=xHbsyrhtw8OK6+3EUpsxkwwlG3RhpWjT9V4GTzMNeho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgxt0vLrKwFDdwbWeGDU34OKEj2jm+ANPzVmhwXt9vI6LsvcCA52Tt2wwpvkyyz/e
	 W/1qShBL7J2FN3Lv2qngCVSeSzvUgwlKTy/tS0lXmLh0owU+8VZ0Bc2BE0eUJS4b9H
	 Fc2tQuPgwoKEPGRJOb5B6x2CMOZb4Np9WoiwLzUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/518] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Tue, 15 Oct 2024 14:40:18 +0200
Message-ID: <20241015123921.398984639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 411103f013e25..08c50e68cfca6 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -195,12 +195,14 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
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



