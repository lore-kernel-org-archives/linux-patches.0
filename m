Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138D114535A;
	Thu, 11 Apr 2024 10:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831642; cv=none; b=dDfQaSX1YtgDvGwZmGlLyOJV0XWzf0zaSVBne/t1VcWTLkY+6jb6e0tcU4v1J55i/vw4FtLYzfxeWyksNM/Gwl+P2eljZ7ki0tbiJQMJBeo/O3T9GXwxKaXjTnEds6yj4oMfxAB8eJ5s44WaV6zSDxEfRpRN+QMA9KFwOGG32NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831642; c=relaxed/simple;
	bh=F1ISf2TpEwZra2cCMq3cbHysA1SbibIfTYcmKDct1Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oey47GaAPVgOOYGUrlt+iKTJEe2Y1l0uJ4nm0bXI5IfjV6u0IKSv6Op1zH10lh4vta/4JvY+8bVHAxZEWWpy1WaOQIeo9DsU8oqh8r6O+750Vz+JvHyM24bynm5uqH3ctrXt6cV/ZJr90HOp+8TNiQcFa5JDOHT4qk02c3Ha5ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gro4SZre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gro4SZre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87203C433C7;
	Thu, 11 Apr 2024 10:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831641;
	bh=F1ISf2TpEwZra2cCMq3cbHysA1SbibIfTYcmKDct1Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gro4SZre9wj2QtMVqLF0KV6wAlYUNuYeCWL4eHXQSPsp5EjU9AbwkAyODj4N6d34K
	 P/pOvQM88+o4iyDTh3BxC6YI7jX9lyHlcZS+nfe3CdvMX6o0HgKqwKY+N/rsl8HCNX
	 fruo9/pqo4HScd6hQqHmrAneKv57S18dqipZM2uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/294] usb: gadget: tegra-xudc: Use dev_err_probe()
Date: Thu, 11 Apr 2024 11:54:01 +0200
Message-ID: <20240411095438.035972708@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 77b57218ac2f37da4e8b72e78f002944b9f85091 ]

Rather than testing if the error code is -EPROBE_DEFER before printing
an error message, use dev_err_probe() instead to simplify the code.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20210519163553.212682-2-jonathanh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 84fa943d93c3 ("usb: gadget: tegra-xudc: Fix USB3 PHY retrieval logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index c5f0fbb8ffe47..23e31eec442dc 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3508,10 +3508,8 @@ static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 		xudc->utmi_phy[i] = devm_phy_optional_get(xudc->dev, phy_name);
 		if (IS_ERR(xudc->utmi_phy[i])) {
 			err = PTR_ERR(xudc->utmi_phy[i]);
-			if (err != -EPROBE_DEFER)
-				dev_err(xudc->dev, "failed to get usb2-%d PHY: %d\n",
-					i, err);
-
+			dev_err_probe(xudc->dev, err,
+				      "failed to get usb2-%d PHY\n", i);
 			goto clean_up;
 		} else if (xudc->utmi_phy[i]) {
 			/* Get usb-phy, if utmi phy is available */
@@ -3538,10 +3536,8 @@ static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 		xudc->usb3_phy[i] = devm_phy_optional_get(xudc->dev, phy_name);
 		if (IS_ERR(xudc->usb3_phy[i])) {
 			err = PTR_ERR(xudc->usb3_phy[i]);
-			if (err != -EPROBE_DEFER)
-				dev_err(xudc->dev, "failed to get usb3-%d PHY: %d\n",
-					usb3, err);
-
+			dev_err_probe(xudc->dev, err,
+				      "failed to get usb3-%d PHY\n", usb3);
 			goto clean_up;
 		} else if (xudc->usb3_phy[i])
 			dev_dbg(xudc->dev, "usb3-%d PHY registered", usb3);
@@ -3781,9 +3777,7 @@ static int tegra_xudc_probe(struct platform_device *pdev)
 
 	err = devm_clk_bulk_get(&pdev->dev, xudc->soc->num_clks, xudc->clks);
 	if (err) {
-		if (err != -EPROBE_DEFER)
-			dev_err(xudc->dev, "failed to request clocks: %d\n", err);
-
+		dev_err_probe(xudc->dev, err, "failed to request clocks\n");
 		return err;
 	}
 
@@ -3798,9 +3792,7 @@ static int tegra_xudc_probe(struct platform_device *pdev)
 	err = devm_regulator_bulk_get(&pdev->dev, xudc->soc->num_supplies,
 				      xudc->supplies);
 	if (err) {
-		if (err != -EPROBE_DEFER)
-			dev_err(xudc->dev, "failed to request regulators: %d\n", err);
-
+		dev_err_probe(xudc->dev, err, "failed to request regulators\n");
 		return err;
 	}
 
-- 
2.43.0



