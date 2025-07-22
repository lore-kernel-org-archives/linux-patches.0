Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10B02ECE84;
	Tue, 22 Jul 2025 14:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193705; cv=none; b=ibrj9Btkdt8ag0gKwzNnlt5SNWscPMnVRK6wzOyu2QCT1x/ZcDjq/VWIqfBJBoLpFgtqnr4BCBzsQTLG8AgAa3/tSZGI1X+9Ee2Vb5VMxT2J5xr33m9g9R4Wgh0v/D8j3VlRnIWnaL622bMnhc+ilWGoT1jUUzDJKXqiBslfmos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193705; c=relaxed/simple;
	bh=BpnFifv29Ps8uIB92xO32gxc6+1u4vcbguuXdemkh88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7NRwz+Swwq0kD6TooXfs40hxk0u6IECczCLCUep62luaBUxvK0syj1hzGwgSHgRnqD6bw2sdIID5Yw9zLDW/cDXLeba9SSIoJMboc6hIpuCCROzyGMm6xoD/LuwPPwh8ESDVMm86xpC1LNLxHqjmIxz2QfgVB2HS05RZpYyn94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+uplHq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+uplHq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9F9C4CEEB;
	Tue, 22 Jul 2025 14:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193705;
	bh=BpnFifv29Ps8uIB92xO32gxc6+1u4vcbguuXdemkh88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+uplHq5VJpBk22FGuNRf7yiTBxOTeJCIKydiXNZif+T6ItdPYMyxrY1QhUj6fc/w
	 k+WKz6CXx2/JSA9e28/Npu1HCQpMWY83towRDfscpl9O5MwNc6kJerCJ3Vapc2ZtSN
	 +9fhl6ckqXlKDlNgbtCQDrf3fn0mV8G/7aZZdHyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 171/187] usb: dwc3: qcom: Dont leave BCR asserted
Date: Tue, 22 Jul 2025 15:45:41 +0200
Message-ID: <20250722134352.142656957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

commit ef8abc0ba49ce717e6bc4124e88e59982671f3b5 upstream.

Leaving the USB BCR asserted prevents the associated GDSC to turn on. This
blocks any subsequent attempts of probing the device, e.g. after a probe
deferral, with the following showing in the log:

[    1.332226] usb30_prim_gdsc status stuck at 'off'

Leave the BCR deasserted when exiting the driver to avoid this issue.

Cc: stable <stable@kernel.org>
Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250709132900.3408752-1-krishna.kurapati@oss.qualcomm.com
[ adapted to individual clock management instead of bulk clock operations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -763,13 +763,13 @@ static int dwc3_qcom_probe(struct platfo
 	ret = reset_control_deassert(qcom->resets);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to deassert resets, err=%d\n", ret);
-		goto reset_assert;
+		return ret;
 	}
 
 	ret = dwc3_qcom_clk_init(qcom, of_clk_get_parent_count(np));
 	if (ret) {
 		dev_err_probe(dev, ret, "failed to get clocks\n");
-		goto reset_assert;
+		return ret;
 	}
 
 	qcom->qscratch_base = devm_platform_ioremap_resource(pdev, 0);
@@ -835,8 +835,6 @@ clk_disable:
 		clk_disable_unprepare(qcom->clks[i]);
 		clk_put(qcom->clks[i]);
 	}
-reset_assert:
-	reset_control_assert(qcom->resets);
 
 	return ret;
 }
@@ -857,8 +855,6 @@ static void dwc3_qcom_remove(struct plat
 	qcom->num_clocks = 0;
 
 	dwc3_qcom_interconnect_exit(qcom);
-	reset_control_assert(qcom->resets);
-
 	pm_runtime_allow(dev);
 	pm_runtime_disable(dev);
 }


