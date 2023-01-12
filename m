Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073C5749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D41EC43392;
	Thu, 12 Jan 2023 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533037;
	bh=JGAHG/j3hDivJrky7QwS/FoSMWJ5zss7zKCFQLJqsPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/JUmmGZDGZgsa2NK5nz2M1/cvVMgbyNYlD/VVpuizTymKfByj2gS1IlMTG1db0XU
	 BpvGBmW7K/NtodfL4N8eBGVC2FHPSbR3MqNEoKQU3AjrZLpAnx93cPgE4sDfXdbUTG
	 fFImuOQz1gNBVOPLXjPV/f9cpHfEr3DofVhNBQYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/783] usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()
Date: Thu, 12 Jan 2023 14:51:06 +0100
Message-Id: <20230112135540.545834005@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 0384e87e3fec735e47f1c133c796f32ef7a72a9b ]

I got the following report while doing device(mt6370-tcpc) load
test with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:

  OF: ERROR: memory leak, expected refcount 1 instead of 2,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/pmic@34/tcpc/connector

The 'fwnode' set in tcpci_parse_config() which is called
in tcpci_register_port(), its node refcount is increased
in device_get_named_child_node(). It needs be put while
exiting, so call fwnode_handle_put() in the error path of
tcpci_register_port() and in tcpci_unregister_port() to
avoid leak.

Fixes: 5e85a04c8c0d ("usb: typec: add fwnode to tcpc")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221121062416.1026192-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 49420e28a1f7..069affa5cb1e 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -649,8 +649,10 @@ struct tcpci *tcpci_register_port(struct device *dev, struct tcpci_data *data)
 		return ERR_PTR(err);
 
 	tcpci->port = tcpm_register_port(tcpci->dev, &tcpci->tcpc);
-	if (IS_ERR(tcpci->port))
+	if (IS_ERR(tcpci->port)) {
+		fwnode_handle_put(tcpci->tcpc.fwnode);
 		return ERR_CAST(tcpci->port);
+	}
 
 	return tcpci;
 }
@@ -659,6 +661,7 @@ EXPORT_SYMBOL_GPL(tcpci_register_port);
 void tcpci_unregister_port(struct tcpci *tcpci)
 {
 	tcpm_unregister_port(tcpci->port);
+	fwnode_handle_put(tcpci->tcpc.fwnode);
 }
 EXPORT_SYMBOL_GPL(tcpci_unregister_port);
 
-- 
2.35.1



