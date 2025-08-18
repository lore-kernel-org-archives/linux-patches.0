Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292F343D6E;
	Mon, 18 Aug 2025 13:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523325; cv=none; b=sAXG9+7Wvd72ZDTjjzk1kDOoi9BI0oGbTwaB5bGLJzHAse8tMauzDHfXD6umpRsskUB90OSKIwIptr2lFDleJFyWV6VqV3v079cX1jRj/kZYYD1+TFQ3m0rtga3GlaRdwV6ycXwqea8FdcS52Urx7xnUTk3FqRk3utiKRd6TXk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523325; c=relaxed/simple;
	bh=PylZh9dX5NAU3QH+ATgTIb0ISaMAPcO2wTFjZ7+8IJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFDzk8273yEDjnBF9KQxUqLfdrNuNs12vzCJbgvbMKZG80/8CyhnNeTflAphFtjFcz0UJT5zvlGiiNTo3hYyV7ZoL06mPn7q9vd0bPKNBf48Le0DFzubpNl0iBkv3gsYXuM+tw49PGX336h+NnqaJFU3LlWRMT1fbBmq+rdTe88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9GrkVRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9GrkVRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B38C4CEEB;
	Mon, 18 Aug 2025 13:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523324;
	bh=PylZh9dX5NAU3QH+ATgTIb0ISaMAPcO2wTFjZ7+8IJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9GrkVRI1OApoYAv4Fw00ecAMCOGNV4Vnmo9DR+1WEWcjtyhcghzxTOOpqlrvoI4M
	 C/ZGUEelg+7TPGoX8AF9N0TPR0lYaZfrNEnUM07EQKfFT96OlA6SrbltAB9PW+31A9
	 77A8/kFscZ4rhJZByn6Mhze0w39KY8V/YZI6nTkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/515] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Mon, 18 Aug 2025 14:42:02 +0200
Message-ID: <20250818124503.628206779@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



