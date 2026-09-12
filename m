Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF05035F5F7;
	Sat, 12 Sep 2026 09:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204547; cv=none; b=jXICtx8SBpjh7vdKwCKGHj5qE/PjBhuWctAy6eFV6Su4Ornp847HLKr2bVIWadTWvGRlrninCF5QjlLRzcjYge76Gy57RVfnnfruC1QcEOlcpwAGZ57oUIQIxyjeuPhOuG0npVVOMGCiOKqxD5A623SPlMlEx9E2eYunpn9F0To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204547; c=relaxed/simple;
	bh=VIu3VaowAv8eOyfTxMLpJjHKBWnghhbTA/ll2Uu/3Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlAGrjOumkotpUE30lvMAmn9TcVaJSwylT2v1U5xa4bDOFlLgRP+u0MAtP3GWXQzBPBJJJefO0eYnCrMDdvFij8QSUx7+2TNPgHzORXxtJdX3Es8bv0Bp9PbttmCdbI2O/fWJUKaE+8WfsqkVax4KlrgKGUrT/c/TimdsIbKHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHtk/vlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHtk/vlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9291F000FF;
	Sat, 12 Sep 2026 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204545;
	bh=zjKRjnDtRazRQ46qPh+eWjSJ1Kh/1lu4VrELtdLb4W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHtk/vltlepdRBOuL3QLU5h9CXlV7+Qv5+9eHi4p8PtMJ5fY7ikDuVkYxY9vs7jN1
	 R2LZyw+diHa11dDsNH2MKC3r+ATaPc7woxVi+NoX3Z4uTPEtowHpNlPUWymKEh4ECz
	 lpvWBpSwbl3GRkR6CAbFMKvC3cOvzu9AGkaRldXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michal Simek <michal.simek@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1634/1815] rtc: zynqmp: Return optional clock lookup errors
Date: Sat, 12 Sep 2026 08:56:24 +0200
Message-ID: <20260912065727.349798298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5904c4109554582ce8ded6a4dcfede48b21dbe4d ]

devm_clk_get_optional() returns NULL when the optional clock is absent,
but returns an ERR_PTR when the clock provider lookup fails.  Probe
currently keeps the ERR_PTR and then passes it to clk_get_rate().

Return the lookup error instead.  A truly absent optional clock still
reaches the existing calibration fallback through clk_get_rate(NULL).

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Fixes: 07dcc6f9c762 ("rtc: zynqmp: Add calibration set and get support")
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260624055524.38522-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-zynqmp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-zynqmp.c b/drivers/rtc/rtc-zynqmp.c
index 2ae54804b87a4..5bcb7536e9734 100644
--- a/drivers/rtc/rtc-zynqmp.c
+++ b/drivers/rtc/rtc-zynqmp.c
@@ -334,10 +334,9 @@ static int xlnx_rtc_probe(struct platform_device *pdev)
 
 	/* Getting the rtc info */
 	xrtcdev->rtc_clk = devm_clk_get_optional(&pdev->dev, "rtc");
-	if (IS_ERR(xrtcdev->rtc_clk)) {
-		if (PTR_ERR(xrtcdev->rtc_clk) != -EPROBE_DEFER)
-			dev_warn(&pdev->dev, "Device clock not found.\n");
-	}
+	if (IS_ERR(xrtcdev->rtc_clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(xrtcdev->rtc_clk),
+				     "Failed to get rtc clock\n");
 	xrtcdev->freq = clk_get_rate(xrtcdev->rtc_clk);
 	if (!xrtcdev->freq) {
 		ret = of_property_read_u32(pdev->dev.of_node, "calibration",
-- 
2.53.0



