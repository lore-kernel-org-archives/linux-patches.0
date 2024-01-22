Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9405F5683;
	Tue, 23 Jan 2024 00:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970670; cv=none; b=SBptl0VZy3seCMFKnzaP1D4p0p6yzg1QAhQw0fQ2+zJA8ts4ZbVledvCXWD3cxQp7cZWS1H1HL72TiSLTKhiphCDNRxNyRg0Un/HzHLe+pnYtg59xOt6SBQelA+QIY2ub8IWr4+8oBO5Xq4vN5GP5kCBV+bGTZNv4QQGIbTa1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970670; c=relaxed/simple;
	bh=wxlfXtpVz9muv1QtsTpd2d5DAJ6MUBfaDN0h2WnRQXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcnbB185cori9fbqRG+ITIP6zpz+Fac72jjHrg2ihRUkrD8Fg4mEGCKe6T3KeyDBjLfnAqt7CK9neoRpcCmiMLEVdhxOf8xJZmW3+NW8lT1P1KtXYflLqsQxCxrHqkvnjmdpx1O9lY8AwLEEaTKhHcL+BR/xIIgp5YeXt95WUDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVHqTGL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVHqTGL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D1DC433C7;
	Tue, 23 Jan 2024 00:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970670;
	bh=wxlfXtpVz9muv1QtsTpd2d5DAJ6MUBfaDN0h2WnRQXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVHqTGL3A7rmbHfp4D3fpJ/81kMraaMlfakfE26eiF9+ct+0hR0XRdPd77555m8TR
	 U8l2q6/9xfmRPLwBLnunQItixmB+f5aTzJtM5EE6y/2wDB7QCPBaQQBJoahJEFUGMo
	 GaGiwbJkunV6KaUnTC5Gl3PlEMIdwwe7XoZxx6Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/417] arm64: dts: qcom: sc7180: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:54:13 -0800
Message-ID: <20240122235754.645946547@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 7ac90b4cf107a3999b30844d7899e0331686b33b ]

On sc7180 when the watchdog timer fires your logs get filled with:
  watchdog0: pretimeout event
  watchdog0: pretimeout event
  watchdog0: pretimeout event
  ...
  watchdog0: pretimeout event

If you're using console-ramoops to debug crashes the above gets quite
annoying since it blows away any other log messages that might have
been there.

The issue is that the "bark" interrupt (AKA the "pretimeout"
interrupt) remains high until the watchdog is pet. Since we've got
things configured as "level" triggered we'll keep getting interrupted
over and over.

Let's switch to edge triggered. Now we'll get one interrupt when the
"bark" interrupt goes off and won't get another one until the "bark"
interrupt is cleared and asserts again.

This matches how many older Qualcomm SoCs have things configured.

Fixes: 28cc13e4060c ("arm64: dts: qcom: sc7180: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.1.Ic7577567baff921347d423b722de8b857602efb1@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 6f0ee4e13ef1..78e537f1d796 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3378,7 +3378,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc7180", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000{
-- 
2.43.0



