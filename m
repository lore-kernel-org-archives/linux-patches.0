Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3918859B;
	Wed,  4 Feb 2026 15:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218964; cv=none; b=tx17vmVEhF7fnc4QC2YV6X6S++vR8u1wn3LB+VZ4HUH8kNG0H13uBm9Huw4QF6YsWQ0xeRakzV+RbL+te0wdgoG6R7nRKRoXJ50KUYYxKHgMYyJ7QsqgtfV5VemN1hQ+IBmQTFDZEmhMMJiJpt0hWleUaHcFqTv/Ij/gSbhV9UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218964; c=relaxed/simple;
	bh=K5qv9jUFbjIcEMIhOX7CfdUpR7qCTEWCZhakmhHY+kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwbGBTeGGqIUnCUAP0vMcUfdjec9V/JtT1b3UwcG/51Ua2ux/BTdNlU/Bbf9By6IZgAfUwgajwMoysJiq1NLTS0ggZbgPPg4xGWqmnuq1aHQDtmqfxF6IPnOyI4kP3hpFOYtIJaEhq8zSgFkRQ9s2CmiUqdP+stWk9fQCax8iuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYlub55C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYlub55C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75DCC4CEF7;
	Wed,  4 Feb 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218964;
	bh=K5qv9jUFbjIcEMIhOX7CfdUpR7qCTEWCZhakmhHY+kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYlub55C1LSzZB/pibe0nzoZzc4u8ONzoNAiMqXOr47OO0FxNSBr4yD+C04XxAVSn
	 YyBvoiTAzNBNgXwIz/8hHCMx0tMnx994hAE7sxevF8gyEogSBEEkS3+Mgl6T5OiKnC
	 ZxpeN8sspTwYEyfvI9K45559AIk+Uf11II9TmZ+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/122] net: bcmasp: fix early exit leak with fixed phy
Date: Wed,  4 Feb 2026 15:39:50 +0100
Message-ID: <20260204143852.164798957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 6de4436bf369e1444606445e4cd5df5bcfc74b48 ]

We are not deregistering the fixed phy link when hitting the early
exit condition. Add the correct early exit sequence.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260122194001.1098859-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index b9973956c4809..ceb6c11431dd9 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1261,7 +1261,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 		netdev_err(intf->ndev, "invalid PHY mode: %s for port %d\n",
 			   phy_modes(intf->phy_interface), intf->port);
 		ret = -EINVAL;
-		goto err_free_netdev;
+		goto err_deregister_fixed_link;
 	}
 
 	ret = of_get_ethdev_address(ndev_dn, ndev);
@@ -1286,6 +1286,9 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 
 	return intf;
 
+err_deregister_fixed_link:
+	if (of_phy_is_fixed_link(ndev_dn))
+		of_phy_deregister_fixed_link(ndev_dn);
 err_free_netdev:
 	free_netdev(ndev);
 err:
-- 
2.51.0



