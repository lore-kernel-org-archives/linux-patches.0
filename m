Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AEB335BA3;
	Mon, 18 Aug 2025 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525068; cv=none; b=vE+IkKNJqmg7kQ65eWmsBC71JOyA5oKpiL2JzeNhPB+weJydgiFEaf3Dy7EM1TFM6tL1JxPPGJpp9bAc/6Wnu593DWNYLYk8cjUAgYnorhiGfJ9ZVmC1Ft6X8IjamHY4duVJt1ww31cUkQQx5bq4d++n6R1d+oSZI4LLJ0nP684=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525068; c=relaxed/simple;
	bh=C9t7IeYQ/h6FR4CXqUhKuhWZdycLqBAsEEgxen+pwoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzvHAuYHvpPxEAG8iVWtgYqIIhZKO+OUe0mal0Yb6wl6cdbQIsP95OIa2Rk9L83SJ0dF75AFCQ591g4DpydAWI7GN0mYJE0zpRRJl1nt45RTPXoyQJrGj8l/66dSephhYSvT8t3LrdlhF/Ev6IcYBD+nuc9dq+91PeLIABCsGjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI2I7unR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI2I7unR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AE2C4CEEB;
	Mon, 18 Aug 2025 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525067;
	bh=C9t7IeYQ/h6FR4CXqUhKuhWZdycLqBAsEEgxen+pwoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tI2I7unRY3vKHSRuajkbbrc0nFrJkP64JoEFLLLRmReCUuIrECFWHcFCfbfLN1A5U
	 PC8ZPbEDRAWPlmB7c7kALtNOXqpo2SZO0jdCGANhEh7b55qFFA6/atKwI0U/3CAzqj
	 coDROP+YDkKq7WdkhDBzRW9Rm1b2MxF9Rz5JVNwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 149/570] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Mon, 18 Aug 2025 14:42:16 +0200
Message-ID: <20250818124511.555797194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d1aa6806b683..175de0c0b50e 100644
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



