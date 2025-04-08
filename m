Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFA6268690;
	Tue,  8 Apr 2025 11:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111015; cv=none; b=kbqoHqwBmecCFDKS/JG6EGoxGeAQHJIeRHTEaGkYTDWsI3jd3Ma7fAP+qc5d3Ouby/SxchFLvBik+69fmCzVXT+M0NRHS1pQdkqLBuzUG8xXmJ8SrQwLIVFByzCMvT5EHKwc8e+2fyy7b/AjDUibrqp+QTXC2Q/sZq297E01/Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111015; c=relaxed/simple;
	bh=CLxMgQxkFOW7FLmZfjdqEz1Kzjd4mLLPKo0EZfSTZe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JO95+nyuV+EbW1Vx8ahv1nqiJNMGf9VBJmQANViAKSsJWgV4nFnqOT+WIzM+teutlszCUhicTNU/sAXbnV/1MnKNYDPeFu8d3GeL6Pmf/givwMW0w4w3LxYsKmFEsO1dwkgFmCMBtQdNX0KgwRML6mYna1thxhRHjRZcC9LyLcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZSCuQNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZSCuQNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243BDC4CEE5;
	Tue,  8 Apr 2025 11:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111015;
	bh=CLxMgQxkFOW7FLmZfjdqEz1Kzjd4mLLPKo0EZfSTZe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZSCuQNPW77ZLzaI99gEPGNJCZrqaoczbpNgWAAUlFedXuzbmATwnxpUJZKxcvplP
	 iFigdNO9BlqNWSE6fTviJF1DppQjd4c7hO72VdQDZGuikYaZjO9NHzBecgjOY5GIMz
	 GMhFFhkDsDLyLwGoeprdvd4/AzECIEYjXGQayq4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Thomas Zimmermann <tzimmremann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 278/731] drm/vkms: Fix use after free and double free on init error
Date: Tue,  8 Apr 2025 12:42:55 +0200
Message-ID: <20250408104920.745243041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ed15511a773df86205bda66c37193569575ae828 ]

If the driver initialization fails, the vkms_exit() function might
access an uninitialized or freed default_config pointer and it might
double free it.

Fix both possible errors by initializing default_config only when the
driver initialization succeeded.

Reported-by: Louis Chauvet <louis.chauvet@bootlin.com>
Closes: https://lore.kernel.org/all/Z5uDHcCmAwiTsGte@louis-chauvet-laptop/
Fixes: 2df7af93fdad ("drm/vkms: Add vkms_config type")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmremann@suse.de>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250212084912.3196-1-jose.exposito89@gmail.com
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_drv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index e0409aba93496..7fefef690ab6b 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -244,17 +244,19 @@ static int __init vkms_init(void)
 	if (!config)
 		return -ENOMEM;
 
-	default_config = config;
-
 	config->cursor = enable_cursor;
 	config->writeback = enable_writeback;
 	config->overlay = enable_overlay;
 
 	ret = vkms_create(config);
-	if (ret)
+	if (ret) {
 		kfree(config);
+		return ret;
+	}
 
-	return ret;
+	default_config = config;
+
+	return 0;
 }
 
 static void vkms_destroy(struct vkms_config *config)
@@ -278,9 +280,10 @@ static void vkms_destroy(struct vkms_config *config)
 
 static void __exit vkms_exit(void)
 {
-	if (default_config->dev)
-		vkms_destroy(default_config);
+	if (!default_config)
+		return;
 
+	vkms_destroy(default_config);
 	kfree(default_config);
 }
 
-- 
2.39.5



