Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4B531960F;
	Wed, 17 Sep 2025 12:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113934; cv=none; b=oVyMAXgk0mnHCoxTEbvsOPZdkA+hDBcPtrB0vQlyoCo/heg5eQqcDz2no4Mlia30JVJAbFSwGlG4dWYo6PzYKI+tSvX48bF+UVWM91a70IG9ehvamz5rSKbRxjzwJhRlMEqOO6XG8DV3mo/EXtzRldghjLEIebO2lAln9R4D+vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113934; c=relaxed/simple;
	bh=ANAz07hjRaNWzOtVTUj+yDWLu1IAmgXhCZoE2RszcYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnJn3L3XxTNQpIy6RyY8ECt5AjMvy3dU80QkdRW35enCPM1arHyKfcPFE/E5wfJbTGOVDMsl7rE1JV7EgiOvF8lBWin6hVSqmINCOO7gsOU/4L74r6g3gvooYzggechgKy9vjd1mu+IECy/8LiipjgCgPF0P7+Ne1GIyq4wpbc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB99JV3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB99JV3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37F9C4CEF0;
	Wed, 17 Sep 2025 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113934;
	bh=ANAz07hjRaNWzOtVTUj+yDWLu1IAmgXhCZoE2RszcYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB99JV3+EvaI45l/gtM2DWhczsNGVPT71C4u0TTvAHYTZNnxxRS8GNPme4MrR0MtK
	 zlVq80YzD3piy0NY9/+OVFarZoCu+xP2HvFVxPA7ALxseHltb0zq3ylKdeWiZFt+6r
	 7LuVQC+ZOnKP1FbYLcj0Yu7TaIrE5rAsHrtG8Tso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 097/101] phy: ti-pipe3: fix device leak at unbind
Date: Wed, 17 Sep 2025 14:35:20 +0200
Message-ID: <20250917123339.178088026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -703,6 +711,11 @@ static int ti_pipe3_get_sysctrl(struct t
 		}
 
 		phy->control_dev = &control_pdev->dev;
+
+		ret = devm_add_action_or_reset(dev, ti_pipe3_put_device,
+					       phy->control_dev);
+		if (ret)
+			return ret;
 	}
 
 	if (phy->mode == PIPE3_MODE_PCIE) {


