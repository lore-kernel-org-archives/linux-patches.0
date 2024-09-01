Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB11183CA3;
	Sun,  1 Sep 2024 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209289; cv=none; b=hkZ+2WU+JH3BudCrgn/Z03+zqrIrbGmqkYwOOjB6IMNDqCL4Jc9SwYhVhRt6/Uh4sQWGcRGkV4k+vYXbHAnGoH9C1FWbMusRVQVRp9CEY3UfWsuHDrQvzB+aOupVPA5mXqWSfxJMD1hTNpnPhWQMoqGxjJrIWTmCxeGtW9FxdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209289; c=relaxed/simple;
	bh=4Pp1Mfz+F3wy2fN+cADGXOTICwYdR8YgJ3IsPS2zjlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfDU/9F9pf8wt+x6wlRBrcRhrLl1bCILphHY9YLIYiPtgB9IOdyR20+regF1ZXU37CHvYi8hmqLLUd8jmgDCjAs2uWyFyodCOpj/lA8dZETK72WDRlJ97Nrv5fBoLwtMBXS/7tcUhydEVLLcVow6PTQVzIvDzrq0b5tLmXDn808=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HReqMcGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HReqMcGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43864C4CEC3;
	Sun,  1 Sep 2024 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209289;
	bh=4Pp1Mfz+F3wy2fN+cADGXOTICwYdR8YgJ3IsPS2zjlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HReqMcGVU8qc714neLXif/WgzbxIvpvTQrtwaCjQjbCIRYaomzp94Z12YlgsZZ12s
	 DwZZ4ot5A1RfMSeEWY+eXPZCNvLiR3wkvAmDFGdx/+RIjNZgdWBuNJNhPQHKsqSuHI
	 5s04lsndi7VZWpppTtUaSWcLdlIhATEQZggDzG+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>
Subject: [PATCH 6.1 61/71] usb: dwc3: st: fix probed platform device ref count on probe error path
Date: Sun,  1 Sep 2024 18:18:06 +0200
Message-ID: <20240901160804.189844707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ddfcfeba891064b88bb844208b43bef2ef970f0c upstream.

The probe function never performs any paltform device allocation, thus
error path "undo_platform_dev_alloc" is entirely bogus.  It drops the
reference count from the platform device being probed.  If error path is
triggered, this will lead to unbalanced device reference counts and
premature release of device resources, thus possible use-after-free when
releasing remaining devm-managed resources.

Fixes: f83fca0707c6 ("usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://lore.kernel.org/r/20240814093957.37940-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-st.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -219,10 +219,8 @@ static int st_dwc3_probe(struct platform
 	dwc3_data->regmap = regmap;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "syscfg-reg");
-	if (!res) {
-		ret = -ENXIO;
-		goto undo_platform_dev_alloc;
-	}
+	if (!res)
+		return -ENXIO;
 
 	dwc3_data->syscfg_reg_off = res->start;
 
@@ -233,8 +231,7 @@ static int st_dwc3_probe(struct platform
 		devm_reset_control_get_exclusive(dev, "powerdown");
 	if (IS_ERR(dwc3_data->rstc_pwrdn)) {
 		dev_err(&pdev->dev, "could not get power controller\n");
-		ret = PTR_ERR(dwc3_data->rstc_pwrdn);
-		goto undo_platform_dev_alloc;
+		return PTR_ERR(dwc3_data->rstc_pwrdn);
 	}
 
 	/* Manage PowerDown */
@@ -300,8 +297,6 @@ undo_softreset:
 	reset_control_assert(dwc3_data->rstc_rst);
 undo_powerdown:
 	reset_control_assert(dwc3_data->rstc_pwrdn);
-undo_platform_dev_alloc:
-	platform_device_put(pdev);
 	return ret;
 }
 


