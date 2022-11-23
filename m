Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0604F1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715DDC433D6;
	Wed, 23 Nov 2022 09:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195960;
	bh=lSh7dWGbiTy18SerLpyw2sdeqDmywC414TJRby9OZEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9v0Nw4ZJRBQr7dUEOrWNoGCYASgHnT+AFNN8UC5itOd9BUQ46shGRYvg3cQL0ii8
	 QJGOtZhlZFFIXCVDcgzh1WLRc7GeJlJ8vVmxv6OI72ts9ACE6Tr+0bgp767W5R7H2x
	 cKk0M5baVQJIOvndUzKRYCAj9zuPu0IYgOiU90Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/181] mISDN: fix possible memory leak in mISDN_dsp_element_register()
Date: Wed, 23 Nov 2022 09:50:43 +0100
Message-Id: <20221123084605.790261268@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index c3b2c99b5cd5..cfbcd9e973c2 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -77,6 +77,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	if (!entry)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&entry->list);
 	entry->elem = elem;
 
 	entry->dev.class = elements_class;
@@ -107,7 +108,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
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



