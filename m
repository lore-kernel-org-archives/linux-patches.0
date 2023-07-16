Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3BB8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FB5C433C7;
	Sun, 16 Jul 2023 20:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538066;
	bh=B1naQgSahwWWgmZEuznMPDHjuX/lQ8siFyUav+WJBtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNi6oqcswv6NszJqNbzsa+KrUHFWZRP4yXOB2Na+u8idb3sNz9Zc5U0OuBhcyNGq5
	 gowFDHHSIBHFpNnyjbjNVz55dy+/qr/KksZX8vxtXqNo8yAPjTFPCrSRGq+dr4LwTH
	 FLXSn35lWntguJzujnN/IXfjsvhtvgrNCuLEe8JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 319/800] arm64: dts: qcom: apq8016-sbc: Fix 1.8V power rail on LS expansion
Date: Sun, 16 Jul 2023 21:42:52 +0200
Message-ID: <20230716194956.481626683@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 5500f823db38db073d30557af159b77fb1f2bf26 ]

The 96Boards specification expects a 1.8V power rail on the low-speed
expansion connector that is able to provide at least 0.18W / 100 mA.
According to the DB410c hardware user manual this is done by connecting
both L15 and L16 in parallel with up to 55mA each (for 110 mA total) [1].

Unfortunately the current regulator setup in the DB410c device tree
does not implement the specification correctly and only provides 5 mA:

  - Only L15 is marked always-on, so L16 is never enabled.
  - Without specifying a load the regulator is put into LPM where
    it can only provide 5 mA.

Fix this by:

  - Adding proper voltage constraints for L16.
  - Making L16 always-on.
  - Adding regulator-system-load for both L15 and L16. 100 mA should be
    available in total, so specify 50 mA for each. (The regulator
    hardware can only be in normal (55 mA) or low-power mode (5 mA) so
    this will actually result in the expected 110 mA total...)

[1]: https://www.96boards.org/documentation/consumer/dragonboard/dragonboard410c/hardware-docs/hardware-user-manual.md.html#power-supplies

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 828dd5d66f0f ("arm64: dts: apq8016-sbc: make 1.8v available on LS expansion")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230510-msm8916-regulators-v1-2-54d4960a05fc@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dts | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
index 14cb217a13c1e..3ec449f5cab78 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
@@ -526,19 +526,27 @@ l14 {
 		regulator-max-microvolt = <3300000>;
 	};
 
-	/**
-	 * 1.8v required on LS expansion
-	 * for mezzanine boards
+	/*
+	 * The 96Boards specification expects a 1.8V power rail on the low-speed
+	 * expansion connector that is able to provide at least 0.18W / 100 mA.
+	 * L15/L16 are connected in parallel to provide 55 mA each. A minimum load
+	 * must be specified to ensure the regulators are not put in LPM where they
+	 * would only provide 5 mA.
 	 */
 	l15 {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
+		regulator-system-load = <50000>;
+		regulator-allow-set-load;
 		regulator-always-on;
 	};
 
 	l16 {
 		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <3300000>;
+		regulator-max-microvolt = <1800000>;
+		regulator-system-load = <50000>;
+		regulator-allow-set-load;
+		regulator-always-on;
 	};
 
 	l17 {
-- 
2.39.2



