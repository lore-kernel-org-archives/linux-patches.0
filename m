Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3063E27A455;
	Tue, 26 Aug 2025 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214276; cv=none; b=FqjlQr9l1xSurmBCgVu7gj30wzQEkrmLIOgmqN3zCYsc2sbRiGemMEinaLqlQCV/KlB+AC2+BFmiykyAoBJb/gM1QjrG7OA3D6ckRw3DjL+KCjJ87JdOwfCGcBJ5kTdmYvFRkUyzQX5UuLSrSLnX4hItP2IV1Pgs8FJosyYwRvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214276; c=relaxed/simple;
	bh=nfiTlDjqOzAxJxQyXg1E9s3KHmTsY2ZOIY8Us72Es/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjQ5JwfDn0P25AFemzq32bMLSss9WXUfgYqBxmkTO6croaMi8tjiyJArwXiSLD7vTyN20qfyNeBLpy8hPDOLygZaw1VmDFgTnl7m4ooPDkLQs1uok2WW+WBZiLIElM30AF41eGGVtfIAF61Nelhp2SBuAPu17P77RNGSYsYwBSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJQOscsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJQOscsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E7EC4CEF1;
	Tue, 26 Aug 2025 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214276;
	bh=nfiTlDjqOzAxJxQyXg1E9s3KHmTsY2ZOIY8Us72Es/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJQOscskUWWf2sgZp/Xbp+F0KturnjsnJ1+dULeL1hTtnOIP3TW0D9xqKY2Dgbb+c
	 SyNCF1a8FDArVNA802UdIjmn8Vq2Qy3pwHSdSduj+Kinpu8WdrO7/YGsMA4SPFofWt
	 xQb7kwLxLcyIRvfSGdJVUSwIwXu3WE+gV5i26PFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/482] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Tue, 26 Aug 2025 13:05:29 +0200
Message-ID: <20250826110932.711970126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



