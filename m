Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D64423A76;
	Tue, 31 Mar 2026 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974956; cv=none; b=ndPKhSRTx1MEtzls7EjMPON94IwHplEEpzOBrLfMlxJiPGeLcxYb1cdbmoWyatIuP7GIvkymtxaWQO6QbqotcKywqQYoa5Cd9D/iyLtQxSb6fBa9fVTn7OOVedv+xF0eW64/YzTtyOfVz3fyhI2pstJlrxxct3edvogI3uGl0dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974956; c=relaxed/simple;
	bh=r9RxtsVizRmLe9dE1Xzc8nUJB0C/vnlGiiwFvUqU2vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyl3E/3R0PJy/5Uc+urpWFMVRKCBuoi9ljSFLWqOxCOa92pA/mj+V7/5mPMNVtyBHtcVA+FRH9eYDF8XhwQNku2Jyvrs1GCtMsrK2KgibWv8cEbpXg8aW3kKIARyP/zaqe/COlFpTX72T+hZTtIFEiYIcBI7s1L4GL80x9mksMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7J/mKuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7J/mKuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF46FC19423;
	Tue, 31 Mar 2026 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974956;
	bh=r9RxtsVizRmLe9dE1Xzc8nUJB0C/vnlGiiwFvUqU2vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7J/mKuWgkorb5zF4wIS6Jcke26AmxaeuiN8QN8wk9NdvQEYVqhBgNSRJ5D5vM7Qb
	 mt5LKALyQUH5D0G3IR+v9ITwYf60OXSkLbFnK4vS31bKIMxQkwyMZzF8fEeeilcWpO
	 eYxUHps5eR/7sUJ7aEh6wH8P5IFSO+q1fj8UVSy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 108/342] net: bcmasp: streamline early exit in probe
Date: Tue, 31 Mar 2026 18:19:01 +0200
Message-ID: <20260331161802.988639079@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 1fd1281250c38408d793863c8dcaa43c7de8932c ]

Streamline the bcmasp_probe early exit. As support for other
functionality is added(i.e. ptp), it is easier to keep track of early
exit cleanup when it is all in one place.

Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260122194949.1145107-3-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbfa5be2bf64 ("net: bcmasp: fix double free of WoL irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 27 +++++++++++----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index 014340f33345a..de5f540f78049 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1322,6 +1322,8 @@ static int bcmasp_probe(struct platform_device *pdev)
 
 	bcmasp_core_init_filters(priv);
 
+	bcmasp_init_wol(priv);
+
 	ports_node = of_find_node_by_name(dev->of_node, "ethernet-ports");
 	if (!ports_node) {
 		dev_warn(dev, "No ports found\n");
@@ -1333,16 +1335,14 @@ static int bcmasp_probe(struct platform_device *pdev)
 		intf = bcmasp_interface_create(priv, intf_node, i);
 		if (!intf) {
 			dev_err(dev, "Cannot create eth interface %d\n", i);
-			bcmasp_remove_intfs(priv);
-			ret = -ENOMEM;
-			goto of_put_exit;
+			of_node_put(ports_node);
+			ret = -EINVAL;
+			goto err_cleanup;
 		}
 		list_add_tail(&intf->list, &priv->intfs);
 		i++;
 	}
-
-	/* Check and enable WoL */
-	bcmasp_init_wol(priv);
+	of_node_put(ports_node);
 
 	/* Drop the clock reference count now and let ndo_open()/ndo_close()
 	 * manage it for us from now on.
@@ -1357,19 +1357,20 @@ static int bcmasp_probe(struct platform_device *pdev)
 	list_for_each_entry(intf, &priv->intfs, list) {
 		ret = register_netdev(intf->ndev);
 		if (ret) {
-			netdev_err(intf->ndev,
-				   "failed to register net_device: %d\n", ret);
-			bcmasp_wol_irq_destroy(priv);
-			bcmasp_remove_intfs(priv);
-			goto of_put_exit;
+			dev_err(dev, "failed to register net_device: %d\n", ret);
+			goto err_cleanup;
 		}
 		count++;
 	}
 
 	dev_info(dev, "Initialized %d port(s)\n", count);
 
-of_put_exit:
-	of_node_put(ports_node);
+	return ret;
+
+err_cleanup:
+	bcmasp_wol_irq_destroy(priv);
+	bcmasp_remove_intfs(priv);
+
 	return ret;
 }
 
-- 
2.51.0



