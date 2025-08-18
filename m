Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA60D3218D1;
	Mon, 18 Aug 2025 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521848; cv=none; b=NNn5nZKyuTayaL0g+/XCgrvSRcS75a//A+bybEKj3AA8vZ0Ffnxxf0PGiB8Bj1Js7cNM6HxaDZJ2f15mWkI9T2tlU7YcYKDfI0QVJnMxEZMrsBOTyTmVAjGBgp+BEk9iAfbytc2afeEGt5XwrOSV4oSRwFD5E4fPIrli3q9lpuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521848; c=relaxed/simple;
	bh=LuWrDhlOJzNhXAKuhLyAiCK+s6uG9fT4mWSl/4L4Hgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+qsVc2UZzGjBXPaHRUmVH8B+K/79NY0zLUX5zvGz4d9Sa3px6JkgMBLielOgFlqXgPnxHY6RURD5hpiPyUkUVFp0pvsSezws/IqrSNfJV3ydQrsOccyQJoFoHBfbQQEaLWFXQpXSSV3IUE5yIokwttqN/AAkf4ovTF7yadCJ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcIffwjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcIffwjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3DC4CEEB;
	Mon, 18 Aug 2025 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521848;
	bh=LuWrDhlOJzNhXAKuhLyAiCK+s6uG9fT4mWSl/4L4Hgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcIffwjZ1Dr0WPxBnyj+Z+ZPU5RtxJ2LWD5Ez5kx7Grsec67hYPs/iyH6Rxe/jUlz
	 v2qErm0aotAauIYAr/ObuKgh7uObydVPgaem4B72XADHeoT00Az46fjpb8ZhwnQdYH
	 7bshpvFHf/J39XogVcwRew2A5tfYeaT5ufVPYmo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/444] PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()
Date: Mon, 18 Aug 2025 14:42:19 +0200
Message-ID: <20250818124453.167067654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



