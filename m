Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528E635207B;
	Tue, 26 Aug 2025 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216279; cv=none; b=qy/w4cJLqSH/qlxgVTadCWy2ElzU9k2/4o5MfKs1q1pyTegty06TR39sl0onFsubUDOGT8yUwz4UwoGle8Q2KTM7ehm7zwYtVr+wnvF2Ku8GRG5rZHtfVT0mMdtFgwvwnxkV1+U0JwYJH/VG3FCd8C2em0a8GUdIjKIz4NOj/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216279; c=relaxed/simple;
	bh=8IaX/BrJdnBokqVvQrdYZIFFPNUWwFSpRmjvpgNrO7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOt9MN5LIorxaFJO8hX2blvjNHuhpBT129FrY8zkAMfoOwWhX+AYETsh8y6JBPjbJtsTAx3DAWDXoLC7AiRUoFDmhmQvHqyFO//kngdie8GLX+ovXhGn3nVuk1w3MJrdRlpBvlxm9GLWrgJ3ws1jeYsuHEyC69hMR7IVS0Ewys0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZE+zJvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZE+zJvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1407C113CF;
	Tue, 26 Aug 2025 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216279;
	bh=8IaX/BrJdnBokqVvQrdYZIFFPNUWwFSpRmjvpgNrO7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZE+zJvlmST5vUIaWbA7uXUDYZeT2nySbodmEHOjf03E5z5I90wEcgk/IibTXV2d6
	 fU6gr+sYisjEFVyj51THU3lqnDYZelJ1VRzVbbzBgq1fG+qrfmwCqDtdG0vOdguDNr
	 Nk6z8lp0VHOaiKnbZlWQTJCH1zfnPq6274bZImrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/644] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Tue, 26 Aug 2025 13:06:36 +0200
Message-ID: <20250826110953.942553536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



