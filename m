Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EF91C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EB1C433EF;
	Wed, 28 Dec 2022 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244838;
	bh=eL3m/8xfE+bFpjCI8raGs3AKk6Wbbyt5gZi/AQeWkrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbFluIn5HgNnT8FiMXtTvJCq/7xP7lSYuycYqOdHgfYOrZ8j0G9hB4e8szc4MQ8Sx
	 +yUPHK/jnPKEeS6g0j99BkSyWw23swSUlm7KtCCWeW0WowtTLzf2AEUByiHkzYZCRs
	 kUhS6yXU75G8DuokeJkmQQYfqtRP9QiiU5sRkVNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0745/1146] usb: typec: wusb3801: fix fwnode refcount leak in wusb3801_probe()
Date: Wed, 28 Dec 2022 15:38:04 +0100
Message-Id: <20221228144350.383017033@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit dc18a4c7b3bd447cef2395deeb1f6ac16dfaca0e ]

I got the following report while doing fault injection test:

  OF: ERROR: memory leak, expected refcount 1 instead of 4,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/tcpc@60/connector

If wusb3801_hw_init() fails, fwnode_handle_put() needs be called to
avoid refcount leak.

Fixes: d016cbe4d7ac ("usb: typec: Support the WUSB3801 port controller")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221203071027.3808308-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/wusb3801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/wusb3801.c b/drivers/usb/typec/wusb3801.c
index 3cc7a15ecbd3..a43a18d4b02e 100644
--- a/drivers/usb/typec/wusb3801.c
+++ b/drivers/usb/typec/wusb3801.c
@@ -364,7 +364,7 @@ static int wusb3801_probe(struct i2c_client *client)
 	/* Initialize the hardware with the devicetree settings. */
 	ret = wusb3801_hw_init(wusb3801);
 	if (ret)
-		return ret;
+		goto err_put_connector;
 
 	wusb3801->cap.revision		= USB_TYPEC_REV_1_2;
 	wusb3801->cap.accessory[0]	= TYPEC_ACCESSORY_AUDIO;
-- 
2.35.1



