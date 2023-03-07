Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80850BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA671C4339B;
	Tue,  7 Mar 2023 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213061;
	bh=XZ1ZD3poNPKE0K7+mKw1eMs8JEvPYVrU9O5NuJuBZ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdacro6tWI11wbx8I7PmiLpWv3W7OKvJlRpxI6Vm5pGkrqdWWVQ37I74gIgip5vI1
	 0ehofVcBkfiGqpzctaXPSbg518dXtm+gjA+UY1s5pKlI9PrREvdGH1EKyXeXOnlxvB
	 v3RsjBlZcGu8UVpXsX/yPYdcWfK3SXkeE+SJ1aJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/885] leds: led-core: Fix refcount leak in of_led_get()
Date: Tue,  7 Mar 2023 17:55:20 +0100
Message-Id: <20230307170019.117931322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 7391d2cf1370a..aa39b2a48fdff 100644
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



