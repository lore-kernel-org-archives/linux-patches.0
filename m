Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B99F47C111;
	Sat, 12 Sep 2026 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218874; cv=none; b=Tc8fR6c2yhbUAo6WX0Y3UFOgc7RMkwa9yzJDNintRryBltYbb5z4jI/ENkgynZ3Nq4GJsRFKU5PONqm29XHNiS0AgqLfG21UMrlXLGbZ1TZh4yNGDCLICqxL2BgTzCNB/EPrDoTd84nu/etvdZzjP4T4eVqLd9N/+xy8GM5EmqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218874; c=relaxed/simple;
	bh=q+IZ7NaCP9BtY5ayJHaGZQ51q9tLga0K6QZdleqibU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3optTcT4StVFtsYNTH83iJ1btetNb5RtOP3E3UTNDqwO6H98sU+Ifbk6muFn/fUs5zLdl8WTW0k5Ahd7n99MsSDIxR6jLB5b3k7m1hsAzyStD9TjqcEEk74RmBAi4S/AXJ/Qbv4ji3WGlCk+dWQqcJ+2fQ16NvRRELwTNQ2Wzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EuMlUl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EuMlUl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAC11F000FF;
	Sat, 12 Sep 2026 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218873;
	bh=IhTJQYXr+YYkM9ttYJ8bRImcxuxXv4xU6Io9dmGVp4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EuMlUl8IGXReVdsSRSuOsKvrGyJebuebm6q5dlF1iUAPOY3FXL2htBR61J1LkYzy
	 53M0iEkBQvJrgBjJHTGiNSurYqPgvH8kYipoW/a9r7EJ8s+CGcFcbD/W5WHgOnHMoR
	 KV+u6oP+8P1a+ZCXi7FOOjQ4mgQ9f8rXSuOy33e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michal Simek <michal.simek@amd.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1234/1376] rtc: zynqmp: Return optional clock lookup errors
Date: Sat, 12 Sep 2026 09:01:00 +0200
Message-ID: <20260912065635.048979457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f49af7d963fbd..e77fb1433401d 100644
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



