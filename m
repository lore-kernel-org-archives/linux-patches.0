Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A59F2FD1DD;
	Tue, 30 Sep 2025 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245182; cv=none; b=uuOHyLMCwcxuUAYIXzPUjJjv1/v0GZdsjP+bGsdG0nASbAMgXy+fmQBPbmEI/wxCgM9newtL62lkvMQFfJqToe6anQbjASmmt2EbWqeQamEog5rhv01gu6cMnfD3s+K3hhNQOICPdn8De8kgPtbfO70ugT5k0qm3K/Dp7myCy2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245182; c=relaxed/simple;
	bh=C8Gts0J4sGQgYD7T+gvInGeRe8P6yNYGA8ulGCvBRAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qK/wDsR2H4UrKMPvYupguIifqt7MRgeM9xbinAmh0yCrLwzrMxFH4QC4zDtOuXFjAoEsEKHXobiAXSMxFXoDugRV+X+TfRSypivtY5nskAIap2gh+i1XBD7RVes+OpS04aDqZeW5/VfjwgILWEtjtPriMKznfaBPJIbk5cbJeRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBin3OIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBin3OIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6D5C4CEF0;
	Tue, 30 Sep 2025 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245182;
	bh=C8Gts0J4sGQgYD7T+gvInGeRe8P6yNYGA8ulGCvBRAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBin3OIem8JCyqX4PQitfPZcN7cAvxJaPMjQAFqobR606LAcJ4O+AGrvazd86sZGN
	 71jkaqbfypwqvUHRQUeTs4ko93xPZf3VSGqsantwtIyrVbpVtpJzdvyQ6OWNp1GtCb
	 0j1WnEJec2Z14mILHpsfr2xzbc/2lIM0qF7hmqNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 059/151] phy: ti-pipe3: fix device leak at unbind
Date: Tue, 30 Sep 2025 16:46:29 +0200
Message-ID: <20250930143829.952805198@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e19bcea99749ce8e8f1d359f68ae03210694ad56 upstream.

Make sure to drop the reference to the control device taken by
of_find_device_by_node() during probe when the driver is unbound.

Fixes: 918ee0d21ba4 ("usb: phy: omap-usb3: Don't use omap_get_control_dev()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724131206.2211-4-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-ti-pipe3.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/phy/ti/phy-ti-pipe3.c
+++ b/drivers/phy/ti/phy-ti-pipe3.c
@@ -666,12 +666,20 @@ static int ti_pipe3_get_clk(struct ti_pi
 	return 0;
 }
 
+static void ti_pipe3_put_device(void *_dev)
+{
+	struct device *dev = _dev;
+
+	put_device(dev);
+}
+
 static int ti_pipe3_get_sysctrl(struct ti_pipe3 *phy)
 {
 	struct device *dev = phy->dev;
 	struct device_node *node = dev->of_node;
 	struct device_node *control_node;
 	struct platform_device *control_pdev;
+	int ret;
 
 	phy->phy_power_syscon = syscon_regmap_lookup_by_phandle(node,
 							"syscon-phy-power");
@@ -702,6 +710,11 @@ static int ti_pipe3_get_sysctrl(struct t
 		}
 
 		phy->control_dev = &control_pdev->dev;
+
+		ret = devm_add_action_or_reset(dev, ti_pipe3_put_device,
+					       phy->control_dev);
+		if (ret)
+			return ret;
 	}
 
 	if (phy->mode == PIPE3_MODE_PCIE) {


