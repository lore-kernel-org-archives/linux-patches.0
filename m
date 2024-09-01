Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415761C68C;
	Sun,  1 Sep 2024 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208679; cv=none; b=rrxhUMnN+gf/zoWqZ1mqf+7aO8KOWvH+aAGOE2GnVEc3s3X/upw3TgdBQslkbHkOkB2dOVXmoQEgmoc5Quj91IGsb5OjeMxamvMljvAY2HDbtUToxviPaeyhnpo1iLrnAA2XGuxSvtiWSfiltZ9uhCTVMT3WO+UwMCq98WhuTSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208679; c=relaxed/simple;
	bh=nxNRSvIqenktZygj/5uBU34d3IZtYrrRLIMgB/sSEJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9JPDUNQDL2y9Z2QF3RQn6+gIpb/2svENYB+1xqKQpIUeTO34ihMuEEeTAMbJ0M1L4MwHhKixntTmDLpytBZpBm99qdzYZU/hiV7ytrrsuHMEvZgceKBUdi9wK5+e4yCjloZppPRVQ+e+8TxCYVX8WE5gqPoO2x0NzmhGpBQJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAA9QNOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAA9QNOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83A4C4CEC3;
	Sun,  1 Sep 2024 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208679;
	bh=nxNRSvIqenktZygj/5uBU34d3IZtYrrRLIMgB/sSEJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAA9QNOG2+hbjXYkWvsS5aMBsa1a4bz3W1RO9jrBcHTXrHPbo7u7tO09z1vGIoXU3
	 DWC6J4Jzwap4GS+VgMwXqTCSuKVk4UmyBhxpVVcTHW43cSxO5z4/n0sX3vYcdJ7muF
	 hEhwRHRBzCQhahNyo+/M6nG+er2wmuL3z8QPOyBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.10 131/149] usb: dwc3: xilinx: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:17:22 +0200
Message-ID: <20240901160822.379947024@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 16f2a21d9d7e48e1af02654fe3d926c0ce6cb3e5 upstream.

Depopulate device in probe error paths to fix leak of children
resources.

Fixes: 53b5ff83d893 ("usb: dwc3: xilinx: improve error handling for PM APIs")
Cc: stable@vger.kernel.org
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240816075409.23080-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -298,9 +298,14 @@ static int dwc3_xlnx_probe(struct platfo
 		goto err_pm_set_suspended;
 
 	pm_suspend_ignore_children(dev, false);
-	return pm_runtime_resume_and_get(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		goto err_pm_set_suspended;
+
+	return 0;
 
 err_pm_set_suspended:
+	of_platform_depopulate(dev);
 	pm_runtime_set_suspended(dev);
 
 err_clk_put:


