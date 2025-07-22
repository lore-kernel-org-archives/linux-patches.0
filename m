Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9749A238D57;
	Tue, 22 Jul 2025 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192209; cv=none; b=fh9b2HDudOaeUl7onuZlMxlLvJufAf38kDqU7vmwdOYXjZWuoe12YbAxkNW6P4CC27bv9jdOKlg6DjPIfKWRmF/ifi1Y2IpsprhgrJ15pFLFbLE1oE2QR/w82Xh44sZ7HNh44ZoJ7/2HnLwgA0EAm3EZfbVt5/4QyVSGUNchDRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192209; c=relaxed/simple;
	bh=q/FevrszHJPIyszp3lrz01w5Vd+UhUbV3M74DYkrqrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5MOwozp9CFpA3HDGuM+q4fsmmo2Xn0VMx4qdyKMGaPgt0qjW2VRsQlCax6oJVI3E6VvdyCFLwCQ7tqFy9aPiLSg/gwvTbU9DV+wZBAKBnwiMFIrVuJiNxhpzcX+0YsSumK1lh3eu3bs9oKhBYuz58KNMeltfwe8AOr72ComKjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhLYmXlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhLYmXlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FD0C4CEEB;
	Tue, 22 Jul 2025 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192209;
	bh=q/FevrszHJPIyszp3lrz01w5Vd+UhUbV3M74DYkrqrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhLYmXlXzNIMluMGprch0csX0iddek8Pa4kwG9eDCwbBnTO9V5X/vUvLRuAksbdAp
	 uBjsghOccsOKeGjebV/pEBYr8v5xDuaJncqKgUrHSTD/XXu5gtdFR/lxdb8yGnK8Eb
	 SFFD5b6jyfaZwZojwEZm4V+GcNIOhX5wIKyNd9sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 75/79] usb: dwc3: qcom: Dont leave BCR asserted
Date: Tue, 22 Jul 2025 15:45:11 +0200
Message-ID: <20250722134331.152836195@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted to individual clock management API instead of bulk clock operations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -856,13 +856,13 @@ static int dwc3_qcom_probe(struct platfo
 	ret = reset_control_deassert(qcom->resets);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to deassert resets, err=%d\n", ret);
-		goto reset_assert;
+		return ret;
 	}
 
 	ret = dwc3_qcom_clk_init(qcom, of_clk_get_parent_count(np));
 	if (ret) {
 		dev_err(dev, "failed to get clocks\n");
-		goto reset_assert;
+		return ret;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -966,8 +966,6 @@ clk_disable:
 		clk_disable_unprepare(qcom->clks[i]);
 		clk_put(qcom->clks[i]);
 	}
-reset_assert:
-	reset_control_assert(qcom->resets);
 
 	return ret;
 }
@@ -997,7 +995,6 @@ static int dwc3_qcom_remove(struct platf
 	qcom->num_clocks = 0;
 
 	dwc3_qcom_interconnect_exit(qcom);
-	reset_control_assert(qcom->resets);
 
 	pm_runtime_allow(dev);
 	pm_runtime_disable(dev);


