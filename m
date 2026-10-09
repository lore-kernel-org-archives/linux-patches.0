Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57C42D8DC4;
	Fri,  9 Oct 2026 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555878; cv=none; b=kXaytaEmf3XJXMSQ67eRXoycXix3DZV86tHJey/GhH9jVmcNHP2xXhiA0UMIUe+WFFXkny221oXTxTIhyTowp47OcqnqEjz6UtFJt42RzoYgjhm/FP9SavGOqF48JnxwAeyBPF9Hzex0XFuE8sXBFBHN3mF5LT9YkSp3UyUGwQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555878; c=relaxed/simple;
	bh=ewKCY+VcMzW9bWKvWETIzjIMzYvZhlPF6PZSzmNHxg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKOVBqsQiI8qJoa5C5hK1L4tavzsleF3vad2UnuYMDjQNrBv13VifKKxZwiFXuOxU0qkR3s8mEahK3DhKJ86Quayfy8dSvgrUe7xoWFGTnSTMv2S/JCk9WwJzo4tHCugrgcgzg8HoLY14VBBQ84ZiJziTiUMuhVBGkeWeav08lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOlTKt9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOlTKt9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971991F000FF;
	Fri,  9 Oct 2026 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555877;
	bh=BuMe1wdLddaQthZXLtmfj6pVwXFNQ7TUOJQh81i4Lcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOlTKt9hNuj9xg/iSlfb4KY5tPOWSoj1nDB7DLV6Oy6pKSFBnjcS9lIGUflq9GPD0
	 TpUSiTM/9CohY8g5DrjAogp2hQkzndXCwTUe+gLLR1F0vAqOkWzaJxzld8bExX94+6
	 br/ZI6oek1jVbFN18csGLr6FmQMThjVZ48Ftws1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 084/428] rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak
Date: Fri,  9 Oct 2026 16:07:01 +0200
Message-ID: <20261009140948.023958999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit 0ee5c5d804d592a8328a425b9274487d393d3a05 ]

The struct rtc_wkalrm has padding holes after the 'pending' member.
When returned to userspace via the RTC_WKALRM_RD ioctl, uninitialized
kernel stack data residing in these holes may be leaked.

Zero-initialize the struct at declaration to eliminate this information
leak risk.

Fixes smatch warnings:
- drivers/rtc/dev.c:392 rtc_dev_ioctl() warn: check that 'alarm' doesn't
  leak information (struct has a hole after 'pending')

Fixes: 36e14f5fdfdf ("rtc: rename core files")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/B28B7DE18F3A9447+20260827015444.3314227-1-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/dev.c b/drivers/rtc/dev.c
index 8ba7c25d2565e..be173c9511fac 100644
--- a/drivers/rtc/dev.c
+++ b/drivers/rtc/dev.c
@@ -216,7 +216,7 @@ static long rtc_dev_ioctl(struct file *file,
 	struct rtc_device *rtc = file->private_data;
 	const struct rtc_class_ops *ops = rtc->ops;
 	struct rtc_time tm;
-	struct rtc_wkalrm alarm;
+	struct rtc_wkalrm alarm = { 0 };
 	struct rtc_param param;
 	void __user *uarg = (void __user *)arg;
 
-- 
2.53.0



