Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B72BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF1DC43443;
	Tue,  7 Mar 2023 18:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215517;
	bh=njnxhRjfOVICpAVtvVAbPv+JVpVnYBv9PRiXxTeZpJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBEcZ+R11m9hRSED8UwDsDmyCqYqXVbc2Bo1hZRzWXXt7fNtG8G3Q+b80q932F+//
	 5QWvpskHJGVC3pemUDzP0QwlgU5f7r44sw0TnfRX8kKkdss+EJrdYdscT9cG+Z66al
	 LUXubqkmDjck02fo54AC46Yircns3nod2/gfXjHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/567] leds: led-core: Fix refcount leak in of_led_get()
Date: Tue,  7 Mar 2023 17:59:56 +0100
Message-Id: <20230307165917.187085648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit da1afe8e6099980fe1e2fd7436dca284af9d3f29 ]

class_find_device_by_of_node() calls class_find_device(), it will take
the reference, use the put_device() to drop the reference when not need
anymore.

Fixes: 699a8c7c4bd3 ("leds: Add of_led_get() and led_put()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221220121807.1543790-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 6e88df4c87fa8..1024b1562aafc 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -235,6 +235,7 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
 	led_dev = class_find_device_by_of_node(leds_class, led_node);
 	of_node_put(led_node);
+	put_device(led_dev);
 
 	if (!led_dev)
 		return ERR_PTR(-EPROBE_DEFER);
-- 
2.39.2



