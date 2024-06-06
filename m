Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418631AC254;
	Thu,  6 Jun 2024 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683313; cv=none; b=k9GoHWtgzzYboY4kR9TptOg1hcWaFvltuGiOvbZi7wWuD3+AsSk6rrkVLzgHkI8LPz7SQSdY4+ytAunyh7efnPaOQQCyTn923q2guYzEGfL4Z7Vxrn6YWpPXsGEIrHVkXZzTz6pyw6Ls9lRkBKWxLiZyPqdigQVAfb7TRw71cCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683313; c=relaxed/simple;
	bh=bQyye2PWkhatAonfwMVBjGdoB10MTR2gTsvIqUvonDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6oUwzsResuAq8dxxZ6XojpZ2O9NmGN0SU4EwXip3+5+qV4XgajrhV5ib9mfQtSTQ73YN0UXzdFPxFUEBr6bMLSjYZtyC3y6IcrOnyaGxDWAqrp6IXda36ySW5Ikx7RKXvxJuyou4dLTP1cdyDDKoTFMqtz0GnMQsAULZpCBnXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcEm5Vz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcEm5Vz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4EBC32781;
	Thu,  6 Jun 2024 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683313;
	bh=bQyye2PWkhatAonfwMVBjGdoB10MTR2gTsvIqUvonDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcEm5Vz4WOLuPN2sp7NQb5WrqUV/HI7B2hypWVcZp6xgSuiBsFZwWfYa5a+jX86Zj
	 9u7AXig2R/R5QXzZGF2rTRwcB7i/d9fVJ9KFshMhc8usJgmyj8imHCrguuRnRucl4d
	 5VuhSx4aYp7icQLBn20aJmu1hgj88UPQ73NUjUbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Davenport <ddavenport@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/473] drm/panel-samsung-atna33xc20: Use ktime_get_boottime for delays
Date: Thu,  6 Jun 2024 16:02:02 +0200
Message-ID: <20240606131706.329753821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Drew Davenport <ddavenport@chromium.org>

[ Upstream commit 62e43673ca84a68cc06dcaa9337a06df7f79fef9 ]

ktime_get_boottime continues while the device is suspended. This change
ensures that the resume path will not be delayed if the power off delay
has already been met while the device is suspended

Signed-off-by: Drew Davenport <ddavenport@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221117133655.2.Iebd9f79aba0a62015fd2383fe6986c2d6fe12cfd@changeid
Stable-dep-of: 5e842d55bad7 ("drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesn't assert")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-atna33xc20.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c b/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
index 5a8b978c64158..f4616f0367846 100644
--- a/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
+++ b/drivers/gpu/drm/panel/panel-samsung-atna33xc20.c
@@ -53,7 +53,7 @@ static void atana33xc20_wait(ktime_t start_ktime, unsigned int min_ms)
 	ktime_t now_ktime, min_ktime;
 
 	min_ktime = ktime_add(start_ktime, ms_to_ktime(min_ms));
-	now_ktime = ktime_get();
+	now_ktime = ktime_get_boottime();
 
 	if (ktime_before(now_ktime, min_ktime))
 		msleep(ktime_to_ms(ktime_sub(min_ktime, now_ktime)) + 1);
@@ -75,7 +75,7 @@ static int atana33xc20_suspend(struct device *dev)
 	ret = regulator_disable(p->supply);
 	if (ret)
 		return ret;
-	p->powered_off_time = ktime_get();
+	p->powered_off_time = ktime_get_boottime();
 	p->el3_was_on = false;
 
 	return 0;
@@ -93,7 +93,7 @@ static int atana33xc20_resume(struct device *dev)
 	ret = regulator_enable(p->supply);
 	if (ret)
 		return ret;
-	p->powered_on_time = ktime_get();
+	p->powered_on_time = ktime_get_boottime();
 
 	if (p->no_hpd) {
 		msleep(HPD_MAX_MS);
@@ -142,7 +142,7 @@ static int atana33xc20_disable(struct drm_panel *panel)
 		return 0;
 
 	gpiod_set_value_cansleep(p->el_on3_gpio, 0);
-	p->el_on3_off_time = ktime_get();
+	p->el_on3_off_time = ktime_get_boottime();
 	p->enabled = false;
 
 	/*
-- 
2.43.0



