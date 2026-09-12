Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBB3299920;
	Sat, 12 Sep 2026 11:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211795; cv=none; b=kCH24DLsMlGyErUSAtpqhM9M9wqYi/wKfBbKb4TFFgNJVwWBqnEjNqKIYNGKaJr5RP8YOgE1KczjZsmaAIakueaft7+nStovTdF2yYZoFhIFioXdLHpeacSe2RxZozPdla27CFjnwVNxfeiKyTzKO4DfJOv9B28lE/CedneJiXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211795; c=relaxed/simple;
	bh=7qcT2WPyZqvgydS7wi64L97PBeagHVSjsMfRjAsG0ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO9vkARXj+ekVAricf82iePHFQLr9YuymW7bME+xkCNpfVflDJHCl2OwMRbhW9SKwAZFR8uCVrSrFMV0Mvu17LHx2A8fXYFdTn8o/LhDLMJ0huQDgYy7RAZA4oNyokdXveKHfiiiE1BM7XMPmnRgVMhoH718LqPmxfW2K2m6biI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNE0mY/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNE0mY/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DC61F000FF;
	Sat, 12 Sep 2026 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211794;
	bh=D4yvvIb4821jOnPtwZGdFBamHCYW7RkveXK/9GTnmkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNE0mY/Os+ybt7kCcGfH0awxAY8OVsAPH4Fc9PfdsfSAmy5gPCheT5yEVYkcK+2yR
	 ir2fjA8h1pfwoxS91BSs61ren5XlgOVk6Fp0DvFlr3YM5O9QjNTuDyP6W/rmSxz0+K
	 YfagGOqQwszaJ0DEe3tyuNcUkmsYNh4lOacJzUB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michal Simek <michal.simek@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1304/1518] rtc: zynqmp: Return optional clock lookup errors
Date: Sat, 12 Sep 2026 08:57:53 +0200
Message-ID: <20260912065653.022010218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 856bc1678e7d3..bf2ecd0dfe238 100644
--- a/drivers/rtc/rtc-zynqmp.c
+++ b/drivers/rtc/rtc-zynqmp.c
@@ -335,10 +335,9 @@ static int xlnx_rtc_probe(struct platform_device *pdev)
 
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



