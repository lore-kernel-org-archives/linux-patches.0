Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58DE4FDA47;
	Tue, 13 Oct 2026 12:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894796; cv=none; b=h1UdfWuvvuAJKfQSRIoHBn80zX3lM5Y58id0QBmdh5JZ0sPPewKxVadr5llN8N6LXHe0M9TGAJe+PyH4RDfvTNoeenMGWWITkT/ct0Rzf9bV8RoR4Iwtn0mXr61IcP1kVCC5ftU49IxmFOyUp1+6zVlVpzi4vNwp8ZLh7RgWDwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894796; c=relaxed/simple;
	bh=LxyWB/k5xjGTs8v24CFiqXj4XJn+te1lJmbjUCOEPkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7kzL4Jch31Bcp628OZMwNG/EM0i2HNuSoz4WySw6eAOzg3Bfn7kPhNoP+vc3C8Vzkk0ZZsDNh6wmmSKv49ZtDNzWRWx3M3vzRk0/OO8nm6Vqj6cbdyTSjcVXJRiPcfN3ofSBV00St+Wsrn+dxEN+c6aJDntnomV2ubtPHpfKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn0qXrB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn0qXrB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5981F000FF;
	Tue, 13 Oct 2026 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894795;
	bh=ARnbMLvKL7EvzNl7p1pBsAMMFdXhcQK49B+V9H6/TDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kn0qXrB+/V6eCNukAoG2npIJ7EN8t0iOQGeywcw9Lpc5jMQeMrC4kCZcC0f5s9OGo
	 VdnEtKZlp/pybOqq3OUoKAbHEVF2q3rBhA4pd3uqsDWjHkDeo8djpyYwfkEV7AMDCg
	 zbBl6mQBeXKAl3c2QJVCe+sY11KWuM5eLlJK5VXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/497] rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak
Date: Tue, 13 Oct 2026 13:33:46 +0200
Message-ID: <20261013112909.287920611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index c4a3ab53dcd4b..747408244424a 100644
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



