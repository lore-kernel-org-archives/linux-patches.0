Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28D305040;
	Tue, 30 Sep 2025 14:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244150; cv=none; b=RlKsZMLJI/K/F7HsY23+yUHrBNkVCpgMlVIrslVVmDuwgXsIdLNj0e2ZYiSPZLytXGDV7T3dxBa5KT1Um/fRiwVVb6aGJj7JwH6bpx5DDBAu/zKr00Wlz6o+OmnnQpiuzVhN4+9znSWnlhMNCb5RJRi02d5+gNWQTO1ue+yCN+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244150; c=relaxed/simple;
	bh=tFgwx+sLWOITMJN3VS1v0D8hVTsTQq689hjWtBXm4+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVa/KrncD97kYGjsEXVy8w8ndNN7dhf+5BQptXM/EszqCCcVTEaQv8ob/c9bM18PxNw1HS6C2P0E9XDhe3T+Fu3PTHVNs4cHcubpNyvwyiD8pO0tCK4nRAD1QlzJ7NS+TCA1rSHsuCE+QQFCWdP4DjR/mAejov7qsMu0IBktrOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NXiNhWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NXiNhWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4473CC4CEF0;
	Tue, 30 Sep 2025 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244150;
	bh=tFgwx+sLWOITMJN3VS1v0D8hVTsTQq689hjWtBXm4+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NXiNhWNoLyJmWKn40fuex7m2nF4mJXYaFCNfvvMevh0eyl4ZdJe+wLBYg1qlTb7k
	 Wg6VfyJCgwJ06n09z3+kRDZIFMiFfltxBXz6mVcHxwtziJoWOeNHyV6uRtcn+Xaac7
	 RLJwjTe+7G2fQaAIuuzzS1Wb7eUMpMyqG9lT2gJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 042/122] phy: ti-pipe3: fix device leak at unbind
Date: Tue, 30 Sep 2025 16:46:13 +0200
Message-ID: <20250930143824.721733861@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


