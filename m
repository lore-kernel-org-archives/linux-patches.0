Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA7F356911;
	Tue, 26 Aug 2025 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217674; cv=none; b=rVSCs617GqE72fyUFBtghp4LVKQTByHME53ZTInyCyg9N2jOwJ2G/N026KPLblZp/CfpFuq4fayYvyJB+ATLQnuvCbh4ogooXNS/c9/oKiTHXVzThVyrNnGBPzzgb5Bs1xwJsmHGBO/5TCoHtOw8MSKzl+jx5x00otg24d8qUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217674; c=relaxed/simple;
	bh=eOPFfA5c8i7ojUMN2sLP4HJPgZvN9bGXRDcL8wTAEPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW1O2kUOGaW8wEZIyNQdBajCz9VTn45q2YFPmQngQwodYv54gxb+nu7jdkKDfrjUjj9FO+ZEFQA2+kDLnswHfY7pMiTpmYRa03h4V4t6YS0y6QKihplG+16Eqi7Wmy9707+KizN7t+50ILiYBkaaZj81l/QG7wpk4LIpLXcqQpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjyLk1nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjyLk1nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A5DC4CEF1;
	Tue, 26 Aug 2025 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217674;
	bh=eOPFfA5c8i7ojUMN2sLP4HJPgZvN9bGXRDcL8wTAEPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjyLk1nYo/kod+O0zbR2Jy3o4Hzbghu5BKpZ8OlrGlkDXCRhjV1QQ0b/kgnR7kjal
	 HgkyHmQexj0cRdO3qlKJaUY/0IlggRXow0AavIL9YVJygElZDdBmGuh0V9qRell98N
	 rnlZ7AVjV0JDnfIKX5T9Ks1sDCz4+6cL1hqX+/1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 231/523] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Tue, 26 Aug 2025 13:07:21 +0200
Message-ID: <20250826110930.151519420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 914cc799b28f17d369d5b4db3b941957d18157e8 ]

Replace sscanf() with kstrtoul() in set_freq_store() and check the result
to avoid invalid input.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://lore.kernel.org/lkml/20250421030020.3108405-2-zhenglifeng1@huawei.com/
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/governor_userspace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index 8a9cf8220808..82c60dedcffd 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/devfreq.h>
+#include <linux/kstrtox.h>
 #include <linux/pm.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -39,10 +40,13 @@ static ssize_t store_freq(struct device *dev, struct device_attribute *attr,
 	unsigned long wanted;
 	int err = 0;
 
+	err = kstrtoul(buf, 0, &wanted);
+	if (err)
+		return err;
+
 	mutex_lock(&devfreq->lock);
 	data = devfreq->governor_data;
 
-	sscanf(buf, "%lu", &wanted);
 	data->user_frequency = wanted;
 	data->valid = true;
 	err = update_devfreq(devfreq);
-- 
2.39.5



