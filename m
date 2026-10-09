Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887C246AA8C;
	Fri,  9 Oct 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555523; cv=none; b=Gd2/Y3w/iH2a/Kwgahd31xo6VfB8n3DWiG8n6b/MAidORIL543BSrjMwcUEp9NY1uYJHDI6VZ/RVoNZjs7v0WAN7eEdna8eNrJHAURGlwMvTR60bdj2vbr+/M9J/GjD4FWVVuGpbAs6m61jMLuN2Erce/TWs9A+yiP2QLfyjp1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555523; c=relaxed/simple;
	bh=e/WeX7RMS1C2M+gVUu5ESEGmVkd4uFxNGtidyvXiaRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gia9ktQn7iewImXBW+CUw3CIRLKEegSiwLIFHV1Szj1gNHQ6PomVQQhxH/koqtiunOAA9quVeHA9CL57B43lTvZUM6Dbqj+yia9TKV7pSk/LnLIGMq//CGmCqKmM48r/7nco7Ua3jU7wtLDzLvmje8FdgnXhHRsjIT+WtsdfEQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZwVSfXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZwVSfXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C421F00898;
	Fri,  9 Oct 2026 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555522;
	bh=+jsVsgctpObGFSo5I95fMcnjwK6CJ7/0etAudwTWLwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZwVSfXen5K4PU1DUWXQRYBrqXOrhRbrQTTHwplkCXHA4/vpeM/jmgbcqDVyEiuL6
	 66bgusin2qUu/mUyTrWEj2vmxX3PvjDv+DV8c+XjUQpRV0vekhgH9xsh7J8pv2IT3w
	 Nsepu6yIM4PGn/N2jVexTEffFQzTVLBvYOkAJ8Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/403] rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak
Date: Fri,  9 Oct 2026 16:07:14 +0200
Message-ID: <20261009140953.803911629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index baf1a8ca8b2b1..f699de159b143 100644
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



