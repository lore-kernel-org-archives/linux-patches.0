Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B17B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AF0C433D7;
	Wed, 23 Nov 2022 08:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193710;
	bh=2+lgQz+aViiWigOWhhtGoXwEEgqQVI0YSc5X9fCSB2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1dRhfXUyclDaV1JNvwN9iJ1f0YnG1qzkjW6afXZpfHwKtMk70zZGdtoYGXsmd9Li
	 eTpPu0Yc8aTCDBxp0cyWcVO1Z/sJv7JmK3qt6gNXAFNmnIcU8pOpq+QkV7F/5TssIY
	 ZszqbvE6qMK0dzDOUAciofeLxIECzmovONCfmPOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 40/76] mISDN: fix possible memory leak in mISDN_dsp_element_register()
Date: Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084548.051063600@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

[ Upstream commit 98a2ac1ca8fd6eca6867726fe238d06e75eb1acd ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
use put_device() to give up the reference, so that the name can be
freed in kobject_cleanup() when the refcount is 0.

The 'entry' is going to be freed in mISDN_dsp_dev_release(), so the
kfree() is removed. list_del() is called in mISDN_dsp_dev_release(),
so it need be initialized.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221109132832.3270119-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/dsp_pipeline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index e72b4e73cd61..796cae691560 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -97,6 +97,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	if (!entry)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&entry->list);
 	entry->elem = elem;
 
 	entry->dev.class = elements_class;
@@ -131,7 +132,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	device_unregister(&entry->dev);
 	return ret;
 err1:
-	kfree(entry);
+	put_device(&entry->dev);
 	return ret;
 }
 EXPORT_SYMBOL(mISDN_dsp_element_register);
-- 
2.35.1



