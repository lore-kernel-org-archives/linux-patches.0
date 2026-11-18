Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017858;
	b=rE1qsRQIVu9QpoVzi9wtX1Sb0fcJJgT84ot+6FW1tPgcnt7FNYuiRN68FXns8sNzouh8
	 t/+4BEzt83QGOnYtfAZStdKpwj7Yz/pIqBVePg4vDJsxoRBIfOJnCg2lUjCyWeVUB58Dl
	 m/wCmwg3kZ81NEQZyMBCJDKdPwgG5WBALfo6DWBnkVqR3q6YbWBdttC8tGX9cUDgSrczl
	 mBeapHUiSgo2lH2VakHoI3aijItN6U6M8zRxTjcii3EZMJLuSzu6cE3jvZ/k0GUuAMHL1
	 PE4sYRpOBrlpgwiMWn6HrLeotHtQAo91KmDHhNl9WuEeiOo6y9l4q3DQlAkxAHEFDBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxO/yJdDC23QuRy/pSIXav5U1y6kZctnmJyV8GPv08M=;
	b=okn3yxWnbd2FNVOnh08R7EdCAjqtI6fmR8Z1b+JKNxL7Zxdd5Ow5OhocEj1P0zopbaQI
	 Udj4b6BPlsL7GCbyEOPXvOYa9Ed/NRl9fHpjlgpnqzqm0glx/cWoijJhK6HTpJRdnVGp6
	 i4ZLgu0zF49KMmwmI4GjpPcGVyz67fQzjvi5R8+PsvvbnPA+jw7GauyHwlmqmLewfcS9Q
	 icq8klnSxTRaf+dv7LmfASAkqbX/gymy8GeUx8pY+iRsQ1zsspEDnfmdk2KQ1fMP352K4
	 wCvJ3s5SP7Tv29vcKSRuTCYi7wjbCe5frpH+Gh8wzHtN6Uw8mtUOUwgWMVsEO0EcSSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2DSCoAF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC120606A31C;
	Wed, 18 Nov 2026 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2DSCoAF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6451F000C4;
	Wed, 18 Nov 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017858;
	bh=dxO/yJdDC23QuRy/pSIXav5U1y6kZctnmJyV8GPv08M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2DSCoAFdcZiJu4W6XtLsh4dKKMWgy1oSGcruJSZ47+CHD2gHfbW5Di0tmrmEnnuS
	 6TbFMM+xdlAmThghFbqCySeWU8M2xwJB8tKD/yAv+TL0VU+/fM8NtXyg8jY0Xr4GUs
	 SCN970xVynQBG5Ze7l8T/aYiLeAcGohTY/RvCk3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1033/2651] clk: si5351: fail prepare when PLL reset times out
Date: Wed, 18 Nov 2026 15:37:53 +0100
Message-ID: <20261118150325.154281989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit b6685c30d15cd7f28c40b2daaeacc00f21b2f12a ]

The clock prepare path requests a PLL reset when the platform data
requires a deterministic output phase. The reset helper logs polling
errors but returns no status, so prepare still enables the output and
reports success when the reset did not complete.

Return the poll result to prepare, restore the output power-down bit on
failure, and leave the output disabled. XTAL and CLKIN inputs continue
to bypass PLL reset successfully.

The issue was found by our static-analysis tool.

Fixes: 5142cbcea324 ("clk: si5351: Wait for bit clear after PLL reset")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5351.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 20b0c3c48b863..70daba62305c5 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -907,7 +907,7 @@ static int _si5351_clkout_set_disable_state(
 	return 0;
 }
 
-static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num)
+static int _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num)
 {
 	u8 val = si5351_reg_read(drvdata, SI5351_CLK0_CTRL + num);
 	u8 mask = val & SI5351_CLK_PLL_SELECT ? SI5351_PLL_RESET_B :
@@ -918,7 +918,7 @@ static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num
 	switch (val & SI5351_CLK_INPUT_MASK) {
 	case SI5351_CLK_INPUT_XTAL:
 	case SI5351_CLK_INPUT_CLKIN:
-		return;  /* pll not used, no need to reset */
+		return 0;  /* pll not used, no need to reset */
 	}
 
 	si5351_reg_write(drvdata, SI5351_PLL_RESET, mask);
@@ -931,6 +931,8 @@ static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num
 	dev_dbg(&drvdata->client->dev, "%s - %s: pll = %d\n",
 		__func__, clk_hw_get_name(&drvdata->clkout[num].hw),
 		(val & SI5351_CLK_PLL_SELECT) ? 1 : 0);
+
+	return err;
 }
 
 static int si5351_clkout_prepare(struct clk_hw *hw)
@@ -947,8 +949,18 @@ static int si5351_clkout_prepare(struct clk_hw *hw)
 	 * Do a pll soft reset on the parent pll -- needed to get a
 	 * deterministic phase relationship between the output clocks.
 	 */
-	if (pdata->clkout[hwdata->num].pll_reset)
-		_si5351_clkout_reset_pll(hwdata->drvdata, hwdata->num);
+	if (pdata->clkout[hwdata->num].pll_reset) {
+		int ret;
+
+		ret = _si5351_clkout_reset_pll(hwdata->drvdata, hwdata->num);
+		if (ret) {
+			si5351_set_bits(hwdata->drvdata,
+					SI5351_CLK0_CTRL + hwdata->num,
+					SI5351_CLK_POWERDOWN,
+					SI5351_CLK_POWERDOWN);
+			return ret;
+		}
+	}
 
 	si5351_set_bits(hwdata->drvdata, SI5351_OUTPUT_ENABLE_CTRL,
 			(1 << hwdata->num), 0);
-- 
2.53.0



