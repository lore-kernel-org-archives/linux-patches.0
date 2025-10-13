Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7321F22257E;
	Mon, 13 Oct 2025 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368234; cv=none; b=RIFtxz6iROUItDRApNdzRyULDabYhJFnm1PA3D9UroSZq1VGoxlki8C67A2S5URwjSILIotkQSbjuEzHPjdjfW8id6KHhaJVCXcei71DsPz5kjpS0+yF1qcR43YPePbLQv/6OPCjZYuvD0akDwRs3lVjIGYYAbcsx+BCtfDkr1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368234; c=relaxed/simple;
	bh=in/3Luai7Cw9+zlj25Es7gqJBcuEmx+0NLl1oEBNOTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/VmipOUIYKAsLfWdVwAUIZufclTP8HhX18kS1krH0BepZXWINTEhFPKYzr9giZC7/r7qUXx3mCHkNau09z81aaOMLHVq8AxY26Zfmqiivb1zQmgEHqfIvrGiTl8PEnpeoxSs9ZTEfa0asvek1ol9EFvz9z1q+mbXt6u+AFTB28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=za2byTeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="za2byTeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019EBC113D0;
	Mon, 13 Oct 2025 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368234;
	bh=in/3Luai7Cw9+zlj25Es7gqJBcuEmx+0NLl1oEBNOTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=za2byTeoi/eW8jJDuJR7HP1y0YQRqTlqKK18DqxJKOGZ5NKt2Exr3TIlEEVI7tS08
	 7TyUW7lsPxSK+UjhO1gCJPeEJkhkUvogqPFbCxKyMugrvlSTh3loMd6y+zRS4J21mO
	 T3QDO7AZ5BCIZBTENrh+mu5g9aLxCcn/BG+uJkFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/262] drm/panel: novatek-nt35560: Fix invalid return value
Date: Mon, 13 Oct 2025 16:43:52 +0200
Message-ID: <20251013144329.370966199@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Brigham Campbell <me@brighamcampbell.com>

[ Upstream commit 125459e19ec654924e472f3ff5aeea40358dbebf ]

Fix bug in nt35560_set_brightness() which causes the function to
erroneously report an error. mipi_dsi_dcs_write() returns either a
negative value when an error occurred or a positive number of bytes
written when no error occurred. The buggy code reports an error under
either condition.

Fixes: 8152c2bfd780 ("drm/panel: Add driver for Sony ACX424AKP panel")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Brigham Campbell <me@brighamcampbell.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250731032343.1258366-2-me@brighamcampbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35560.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35560.c b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
index 5bbea734123bc..ee04c55175bb8 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35560.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
@@ -161,7 +161,7 @@ static int nt35560_set_brightness(struct backlight_device *bl)
 		par = 0x00;
 		ret = mipi_dsi_dcs_write(dsi, MIPI_DCS_WRITE_CONTROL_DISPLAY,
 					 &par, 1);
-		if (ret) {
+		if (ret < 0) {
 			dev_err(nt->dev, "failed to disable display backlight (%d)\n", ret);
 			return ret;
 		}
-- 
2.51.0



