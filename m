Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5261863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F31C433D2;
	Wed, 28 Dec 2022 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242546;
	bh=N5CI8jTzBIEOejPNB8urGoQ412XHK+6YJj8C6cwehy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HckayjqI61KLR4PZh5P9NfcKH1gQHeM2+B9+8KaSb4CJy0VknHityZTxLx0kTcmPR
	 yV/gMXlMNYSbkjE+Wvfe5r7uh4aCiiYSznCAhcW7OvKBRV0pMRuQ1QC1mkJjo4KSZB
	 TjMdIjD5xQ0ZqbdRutgYemsLbYHaPFOv1g+abV6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0356/1146] media: platform: exynos4-is: Fix error handling in fimc_md_init()
Date: Wed, 28 Dec 2022 15:31:35 +0100
Message-Id: <20221228144339.831570525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit b434422c45282a0573d8123239abc41fa72665d4 ]

A problem about modprobe s5p_fimc failed is triggered with the
following log given:

 [  272.075275] Error: Driver 'exynos4-fimc' is already registered, aborting...
 modprobe: ERROR: could not insert 's5p_fimc': Device or resource busy

The reason is that fimc_md_init() returns platform_driver_register()
directly without checking its return value, if platform_driver_register()
failed, it returns without unregister fimc_driver, resulting the
s5p_fimc can never be installed later.
A simple call graph is shown as below:

 fimc_md_init()
   fimc_register_driver() # register fimc_driver
   platform_driver_register()
     platform_driver_register()
       driver_register()
         bus_add_driver()
           dev = kzalloc(...) # OOM happened
   # return without unregister fimc_driver

Fix by unregister fimc_driver when platform_driver_register() returns
error.

Fixes: d3953223b090 ("[media] s5p-fimc: Add the media device driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/fimc-core.c | 2 +-
 drivers/media/platform/samsung/exynos4-is/media-dev.c | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-core.c b/drivers/media/platform/samsung/exynos4-is/fimc-core.c
index 91cc8d58a663..1791100b6935 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-core.c
@@ -1173,7 +1173,7 @@ int __init fimc_register_driver(void)
 	return platform_driver_register(&fimc_driver);
 }
 
-void __exit fimc_unregister_driver(void)
+void fimc_unregister_driver(void)
 {
 	platform_driver_unregister(&fimc_driver);
 }
diff --git a/drivers/media/platform/samsung/exynos4-is/media-dev.c b/drivers/media/platform/samsung/exynos4-is/media-dev.c
index 383a1e0ab912..2f3071acb9c9 100644
--- a/drivers/media/platform/samsung/exynos4-is/media-dev.c
+++ b/drivers/media/platform/samsung/exynos4-is/media-dev.c
@@ -1584,7 +1584,11 @@ static int __init fimc_md_init(void)
 	if (ret)
 		return ret;
 
-	return platform_driver_register(&fimc_md_driver);
+	ret = platform_driver_register(&fimc_md_driver);
+	if (ret)
+		fimc_unregister_driver();
+
+	return ret;
 }
 
 static void __exit fimc_md_exit(void)
-- 
2.35.1



