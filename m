Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB013A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4l7G6ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C21AC433C7;
	Wed, 15 Nov 2023 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077411;
	bh=9110WqqSkHZGwaBRh7j6YzQrlq1TvrXyj4pLNkdQQvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4l7G6evdLRvWQIHP0DgYrawmjLLJUd3nGQKmeSQp/SrUFXAMH6AGUqpKDIYFxQYu
	 3rX6xm2zRxqgaTxvgR/h6MigKYXTSBacGkreel48OsSQZsXTKh5R+j5Zk0QkDiE3QU
	 0lZG4tGrmtxNRLl8z5de7xZGit86p4uBA4ZXWkE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/603] arm64: dts: qcom: sc7280: drop incorrect EUD port on SoC side
Date: Wed, 15 Nov 2023 14:13:51 -0500
Message-ID: <20231115191633.177250824@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 39c8af78cbefb8c71a5ad1fa088e761ef418f0a0 ]

Qualcomm Embedded USB Debugger (EUD) second port should point to Type-C
USB connector.  Such connector was defined directly in root node of
sc7280.dtsi which is clearly wrong.  SC7280 is a chip, so physically it
does not have USB Type-C port.  The connector is usually accessible
through some USB switch or controller.

Doug Anderson said that he wasn't ever able to use EUD on Herobrine
boards, probably because of invalid or missing DTS description - DTS is
saying EUD is on usb_2 node, which is connected to a USB Hub, not to the
Type-C port.

Correct the EUD/USB connector topology by removing the top-level fake
USB connector and EUD port pointing to it, and disabling the incomplete
EUD device node.

This fixes also dtbs_check warnings:

  sc7280-herobrine-crd.dtb: connector: ports:port@0: 'reg' is a required property

Link: https://lore.kernel.org/all/CAD=FV=Xt26=rBf99mzkAuwwtb2f-jnKtnHaEhXnthz0a5zke4Q@mail.gmail.com/
Fixes: 9ee402ccfeb1 ("arm64: dts: qcom: sc7280: Fix EUD dt node syntax")
Cc: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230820075626.22600-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 20231d80c504b..91bb58c6b1a61 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -649,18 +649,6 @@ cpu7_opp_3014mhz: opp-3014400000 {
 		};
 	};
 
-	eud_typec: connector {
-		compatible = "usb-c-connector";
-
-		ports {
-			port@0 {
-				con_eud: endpoint {
-					remote-endpoint = <&eud_con>;
-				};
-			};
-		};
-	};
-
 	memory@80000000 {
 		device_type = "memory";
 		/* We expect the bootloader to fill in the size */
@@ -3625,6 +3613,8 @@ eud: eud@88e0000 {
 			      <0 0x88e2000 0 0x1000>;
 			interrupts-extended = <&pdc 11 IRQ_TYPE_LEVEL_HIGH>;
 
+			status = "disabled";
+
 			ports {
 				#address-cells = <1>;
 				#size-cells = <0>;
@@ -3635,13 +3625,6 @@ eud_ep: endpoint {
 						remote-endpoint = <&usb2_role_switch>;
 					};
 				};
-
-				port@1 {
-					reg = <1>;
-					eud_con: endpoint {
-						remote-endpoint = <&con_eud>;
-					};
-				};
 			};
 		};
 
-- 
2.42.0



