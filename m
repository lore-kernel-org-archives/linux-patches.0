Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72D635E1D5;
	Sat, 12 Sep 2026 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231792; cv=none; b=UU+cbOtu6VPoAMRJ1lodzYaUaTTddXvt0V2ROsAuvdcPdknLX1n9EdCgj5VY+KvAZVSbkFThIIOBf4cLprMnwkRN/zuEN2Eif2olOHPj3hpl9dDC6+ziylx/A1ARNMdqdqLqHpR7w/wNKUy+VRejZN8pq0c+FK3mv62thqwc2G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231792; c=relaxed/simple;
	bh=39UoZ57tJoJH863OxPjoOKYiXODFcMHVRrdzUReDOw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/l+afmg4N5P1xnsnRYw0JP4FEP3NOtMRll0uNwyR4X8maa861bGZWwIG1YSShai1vp+NFJVkM3E9eZLFX1lkG3sLySfUAEc8ZTC67UtzidqRXYcamDevK3NUcRo0SZXghbSwyWQ+SfNuUWBEjLeV5vPBIWw5aKhFlBbV5/HV0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iv4Uyhhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iv4Uyhhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C7C1F000FF;
	Sat, 12 Sep 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231790;
	bh=mAk+8xGy9nMyr+7V6baOkDgGIDEAzVv7kEMMYy2/5YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iv4UyhhvihCNfxyFtdD+xELXBauMN8IenHTgmhCF87pphjOJ4PoG3BJPNyrU4hHVr
	 7tzbNCcf3tzq0rhSGBl1LtV4ntZiVz2l6X6Cw+1JLHD6ul7+bL44WC1wk8NLJOFaL6
	 GLUTHTeIJrMui7lMzMQovCKCvWxPLiNBi6Xc+kAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michal Simek <michal.simek@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1072/1191] rtc: zynqmp: Return optional clock lookup errors
Date: Sat, 12 Sep 2026 09:03:20 +0200
Message-ID: <20260912065612.250057079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d87f2f527b977..a6c7f32f60484 100644
--- a/drivers/rtc/rtc-zynqmp.c
+++ b/drivers/rtc/rtc-zynqmp.c
@@ -320,10 +320,9 @@ static int xlnx_rtc_probe(struct platform_device *pdev)
 
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



