Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9E3AFCF4;
	Sat, 17 Oct 2026 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256320; cv=none; b=g+9gCCHeevSXMU3ETFBiRHHBIeCq9XR3cLx9Gijtop198hhdCxq7sUoZTR7yxhTFJC4FOHVhHvFpvkah4XHpDaXJs+dHE+iYHlZ5YHIi2i34LyPoSPxyEZ7bccXDp2CeaMvHuhNuxNivqCc59xWwCfqdczRvWl1VrUUIMLpfDWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256320; c=relaxed/simple;
	bh=FOqb1N5d8gYUHSW1f7ayilHpkbZnZiyterKtlerK/KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jyiySuMg6wm0zWFwO8eVLY1gYuDjhwA2inHczaHBoThfzWXTmngtHD+zI1UNwD5onJTlvGQWz5aaCsB75bsqvCsFlOPPP1JU5uWjqV+Xw+tYkOPXGEAzqUonCHLn4F9v5Br3guM+5NcYul3dhTWSNpQBF8+E7SI2AOGH4OOnoRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwuEWRvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwuEWRvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705AB1F000C4;
	Sat, 17 Oct 2026 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256319;
	bh=rH1Bj0UbFNFVoO/d/aHemo8czVLgRONih3qr2S6AGdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwuEWRvfaBYOdGdB+uLIJz7khd5pacr967aRZk6SMDfV1gdZjcv0YoSX0eM0RBxO3
	 Qxkxz1zgXzjptzSQQ1YzjItFMigq0aL8jWKsXu4YDwXcXGaXX5/ZRofKV0reU4LV/v
	 emACgHmIXC770zoeKjd4QuNS4hNxpFQIPUwVPrE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0196/1674] rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak
Date: Sat, 17 Oct 2026 17:41:08 +0200
Message-ID: <20261017160436.183564293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4aad9bb998683..8ff910017b105 100644
--- a/drivers/rtc/dev.c
+++ b/drivers/rtc/dev.c
@@ -207,7 +207,7 @@ static long rtc_dev_ioctl(struct file *file,
 	struct rtc_device *rtc = file->private_data;
 	const struct rtc_class_ops *ops = rtc->ops;
 	struct rtc_time tm;
-	struct rtc_wkalrm alarm;
+	struct rtc_wkalrm alarm = { 0 };
 	struct rtc_param param;
 	void __user *uarg = (void __user *)arg;
 
-- 
2.53.0



