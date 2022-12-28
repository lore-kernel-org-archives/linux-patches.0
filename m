Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C8B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF24C433F0;
	Wed, 28 Dec 2022 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241106;
	bh=o9YxICuFMvvYQ/GvolBsBBnSKS84R61gGbQ6MfyMcM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbGjpYi/Tfj4Pk7TEuRifKkZScFYDinH6RW0kSWhKADcQZo5a1AtrUWePhfXic3zd
	 DU6h4bQMHtQvxjcoA73PnKnX/jfRCRZnXx5WMcOZN7bgqa7eUmhG3IUKZkJJSS564g
	 6TM2WtrKkg5iTqDrlEubirNU054/JaMskSQhKe/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/731] drivers: dio: fix possible memory leak in dio_init()
Date: Wed, 28 Dec 2022 15:39:05 +0100
Message-Id: <20221228144309.256690473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e63e99397b2613d50a5f4f02ed07307e67a190f1 ]

If device_register() returns error, the 'dev' and name needs be
freed. Add a release function, and then call put_device() in the
error path, so the name is freed in kobject_cleanup() and to the
'dev' is freed in release function.

Fixes: 2e4c77bea3d8 ("m68k: dio - Kill warn_unused_result warnings")
Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109064036.1835346-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dio/dio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 4c06c93c93d3..c7f7134adc21 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -110,6 +110,12 @@ static char dio_no_name[] = { 0 };
 
 #endif /* CONFIG_DIO_CONSTANTS */
 
+static void dio_dev_release(struct device *dev)
+{
+	struct dio_dev *ddev = container_of(dev, typeof(struct dio_dev), dev);
+	kfree(ddev);
+}
+
 int __init dio_find(int deviceid)
 {
 	/* Called to find a DIO device before the full bus scan has run.
@@ -224,6 +230,7 @@ static int __init dio_init(void)
 		dev->bus = &dio_bus;
 		dev->dev.parent = &dio_bus.dev;
 		dev->dev.bus = &dio_bus_type;
+		dev->dev.release = dio_dev_release;
 		dev->scode = scode;
 		dev->resource.start = pa;
 		dev->resource.end = pa + DIO_SIZE(scode, va);
@@ -251,6 +258,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
-- 
2.35.1



