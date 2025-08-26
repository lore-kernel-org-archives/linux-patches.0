Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1742535AAA0;
	Tue, 26 Aug 2025 14:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218547; cv=none; b=TPyzr/BHhoKr45nBUxno2hdzwnqNTC5qJYbngTRVJYL0DnD+8gdhvCMu4ecsTT0u/nEOZRt6NMAX9AHCT67inJiJHecGVsebDlHnfuxa0vbJ7XVkQs3cTR4esi7QLoHKEZ9ghvB/v8JVqqk/UQM+ocQcKC9f2r1UDdMnHNL++qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218547; c=relaxed/simple;
	bh=exjGq1/LYSZsA07whiENH5a/OVHcOQFoJaUat3TNRi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG6+BiqazkLIs418j9fBYgxKgZwP9ZEBLr7Kwb1rcl1tsFRe2OI9nPMUWdtH0OgWptQnZb3hHQeHAd3z7wvPdAGGKjp4VOy54l2Atoa9d/qJboUTqd4ulifTTp6cGgABJZOuP3ORiVwgC2jcqanyOY2hXXwZFmEjRpFOTH25xkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKu1FMCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKu1FMCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B07CC4CEF1;
	Tue, 26 Aug 2025 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218546;
	bh=exjGq1/LYSZsA07whiENH5a/OVHcOQFoJaUat3TNRi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKu1FMCF/UtwrL2NS4wN3N1m5Ob+xpy3KEEV0dq4YN/75PWPmR26ZC8Fn/dUi6TG6
	 UGfFT0TKFbg8RFmtBB8Gbb8yyKWtaHkYNEf7M9SrZyh6Cak53bjM2vgQnGP/8O6sl7
	 yYKBjPMOx8VW+sGv2d/jbEYSeJ/E/f0w4LPOrS7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/403] usb: dwc3: qcom: Dont leave BCR asserted
Date: Tue, 26 Aug 2025 13:06:07 +0200
Message-ID: <20250826110906.952744251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/dwc3/dwc3-qcom.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -615,13 +615,13 @@ static int dwc3_qcom_probe(struct platfo
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
@@ -700,8 +700,6 @@ clk_disable:
 		clk_disable_unprepare(qcom->clks[i]);
 		clk_put(qcom->clks[i]);
 	}
-reset_assert:
-	reset_control_assert(qcom->resets);
 
 	return ret;
 }
@@ -725,8 +723,6 @@ static int dwc3_qcom_remove(struct platf
 	}
 	qcom->num_clocks = 0;
 
-	reset_control_assert(qcom->resets);
-
 	pm_runtime_allow(dev);
 	pm_runtime_disable(dev);
 


