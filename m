Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CD128EA72;
	Tue, 26 Aug 2025 12:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212773; cv=none; b=eMKCorwdF4QyXh/MLdkx821JaysvXMs97/rK1RLVUKgux8FqXlOtUW0E/4vW6a2O9dIZulUd52EYgGYOiOnl05TTWJC08Wg5iEXM2obJ++tqyW6GTT9knRvCEEqlU4hkTIHDeiLDanCAuDRcuREB+WoYFESVOT2wnQqOa4E5r+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212773; c=relaxed/simple;
	bh=dY1j3Qc8Uq4Ut1wMCymVWL0w0/gh6n8L1+LZ5MPvRUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSaiRJyfVia5+4jObFFxDACEwRmOe31unoCsu902H4RpoNNyVBqHV3ndV1coToqTzNP4o7gZpsNsbFD4Dg0FZMYMohHumMF942u/WF3hZOxP+vXMDXJEso3xRWaes4HNfAp3krEaRkB9tJ6Z/LL9EhdQdzkomGAiYKFb2EoC6jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mS5RpWDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mS5RpWDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D60C4CEF4;
	Tue, 26 Aug 2025 12:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212772;
	bh=dY1j3Qc8Uq4Ut1wMCymVWL0w0/gh6n8L1+LZ5MPvRUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mS5RpWDUbEhjPyIvhjGUCU01haaYkC+Ip/tAhPKWXsPUiB06DkDGZAPEe6txA+s5U
	 dZqemh+RbBRyeqBMm2OetgmVj1EngKhq2S/YXj9M1Wln3k/+vWdu2v0d6v/xMmKw3f
	 eYsk+CiVfR2ut6StEfR45Gsbu0zjMh8lOpHvy32w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/587] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Tue, 26 Aug 2025 13:04:06 +0200
Message-ID: <20250826110955.410885099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d69672ccacc4..8d057cea09d5 100644
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
@@ -39,10 +40,13 @@ static ssize_t set_freq_store(struct device *dev, struct device_attribute *attr,
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



