Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC971F7076;
	Tue, 21 Jan 2025 18:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482411; cv=none; b=P1jBa1oNcM8CxiBo+ZlV7nEp2pdf6VyVdYnwaI3W3W2/W78aL1FNlslvFvj5OCImYv8+xBN4+qQgyKlFviWZP00Q3Jy9N9fW8yre9DXvMUyi+WctzLyEZwISSC57dYV1IYErCJx9mHuyv9KSAHzdrGjNJ6IbPV/4EOg3baJZiA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482411; c=relaxed/simple;
	bh=1RlGcdRK0G/dC5OHtUpLyFiGaPzuqFAVV8Fws9lIS8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qulFwwFwb+vdxK4h4gD0NaLOfOBXHfEWroDQs0Pbu4AeoZkFwmYHoVvxZY3By1gkKwi+1n+EUqr/OCmHStuXpiOOaNweiSP2tClsdzc94ag07SSmo7yqOerTqtSfuVYZg/EH0sm2oyiKKuHco+UCKjNw+68kNydMfPUNhQ3q004=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+ozXKKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+ozXKKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFA5C4CEDF;
	Tue, 21 Jan 2025 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482411;
	bh=1RlGcdRK0G/dC5OHtUpLyFiGaPzuqFAVV8Fws9lIS8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+ozXKKzDAr47CfpwxCgMIuzM6oU+XdVGKDqtaKU12AkfOP/ccInNSzfTHJJkN6qC
	 Oc8iq7owShmIu+pF+8UnS9mr/hNYOnkonFZgJhHMhAzTo7WUTWQa+uvgtHSSlkmzYY
	 7Db9PSxxg6bXDP5L7+k/c6IroXMuLXiwy+erE36I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/122] reset: rzg2l-usbphy-ctrl: Assign proper of node to the allocated device
Date: Tue, 21 Jan 2025 18:51:25 +0100
Message-ID: <20250121174534.416934507@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 1f8af9712413f456849fdf3f3a782cbe099476d7 ]

The platform device named "rzg2l-usb-vbus-regulator", allocated by
the rzg2l-usbphy-ctrl driver, is used to instantiate a regulator driver.
This regulator driver is associated with a device tree (DT) node, which
is a child of the rzg2l-usbphy-ctrl DT node. The regulator's DT node allows
consumer nodes to reference the regulator and configure the regulator as
needed.

Starting with commit cd7a38c40b23 ("regulator: core: do not silently ignore
provided init_data") the struct regulator_dev::dev::of_node is no longer
populated using of_node_get(config->of_node) if the regulator does not
provide init_data. Since the rzg2l-usb-vbus-regulator does not provide
init_data, this behaviour causes the of_find_regulator_by_node() function
to fails, resulting in errors when attempting to request the regulator.

To fix this issue, call device_set_of_node_from_dev() for the
"rzg2l-usb-vbus-regulator" platform device.

Fixes: 84fbd6198766 ("regulator: Add Renesas RZ/G2L USB VBUS regulator driver")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20241119085554.1035881-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-rzg2l-usbphy-ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/reset-rzg2l-usbphy-ctrl.c b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
index 1cd157f4f03b4..4e2ac1f0060c0 100644
--- a/drivers/reset/reset-rzg2l-usbphy-ctrl.c
+++ b/drivers/reset/reset-rzg2l-usbphy-ctrl.c
@@ -176,6 +176,7 @@ static int rzg2l_usbphy_ctrl_probe(struct platform_device *pdev)
 	vdev->dev.parent = dev;
 	priv->vdev = vdev;
 
+	device_set_of_node_from_dev(&vdev->dev, dev);
 	error = platform_device_add(vdev);
 	if (error)
 		goto err_device_put;
-- 
2.39.5



