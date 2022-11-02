Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1EE633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6624FC433D7;
	Wed,  2 Nov 2022 03:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360606;
	bh=JwT+7bwk9JgAssKlCYn5OLD/kgs6EmC1adm9l1dXOdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sW7TWF0ynaOOlYSD2x6AtuW/ILCbVWkBzKu/v4BcQK3Ds6kblgF7kmdVi6YsF3Ps
	 K/m5mCjORiqJ04UIjpe7dI+ftOenAhg9Jn0na/iTOUMZmOsrUzBTDZDhjfYuJaeq8j
	 iqhYZ8Xw6DQqjrPslvLkFoqTNVZe7cY9cjC5DOWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 59/60] net: ehea: fix possible memory leak in ehea_register_port()
Date: Wed,  2 Nov 2022 03:35:20 +0100
Message-Id: <20221102022053.030532741@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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

[ Upstream commit 0e7ce23a917a9cc83ca3c779fbba836bca3bcf1e ]

If of_device_register() returns error, the of node and the
name allocated in dev_set_name() is leaked, call put_device()
to give up the reference that was set in device_initialize(),
so that of node is put in logical_port_release() and the name
is freed in kobject_cleanup().

Fixes: 1acf2318dd13 ("ehea: dynamic add / remove port")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221025130011.1071357-1-yangyingliang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index a754e2ce7730..c3606e8b1192 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2928,6 +2928,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
 	ret = of_device_register(&port->ofdev);
 	if (ret) {
 		pr_err("failed to register device. ret=%d\n", ret);
+		put_device(&port->ofdev.dev);
 		goto out;
 	}
 
-- 
2.35.1



