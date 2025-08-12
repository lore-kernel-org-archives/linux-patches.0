Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8412EF652;
	Tue, 12 Aug 2025 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023352; cv=none; b=gnd6iBLuLHFByA3NUWFCb6KnlcfkNhPQrmui0OwjOwBjUN8X9ewsfEd44kT2nQgbt97HUWwuU3g78/+CA/xyd2ee+OPEDQlew2gCDRkDJDj5uNm0qJIY4f4AZsaJk7hpKR4jyOlhGoRHWevO+mSXONLvR1u92M/fmBpFbacCDB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023352; c=relaxed/simple;
	bh=a3xQDm0Yq8FwMG4aA4LLPiVhVqwX4vW4wX3zB11AC80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNeQ+DgBmbjBEKYKDUICTy0sNLGznWiuoosOHZdaaiGhEUkYjJYIJfkmmK+Bp1zB/veT/7+WAUBk9596sZOpwaCq82KVR/s4chAnfcj60B9etGN9jlNOED4Y7W/DwT8HUyAd1vsk8DvSjq/TX0vbenzWlpac1/TEZu2kipZcpw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwdYdQJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwdYdQJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB8BC4CEF6;
	Tue, 12 Aug 2025 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023352;
	bh=a3xQDm0Yq8FwMG4aA4LLPiVhVqwX4vW4wX3zB11AC80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwdYdQJpGjmksrAk4sJHO7BhSXTvVFqrNS01nLrYPzcuP6YRcgpLucYTi0cyS4U5R
	 d3Bpt7Az2GAOSylazoTRc5jVGBqwh5bMvwiDYB3Gy8jxYRdIoxam5W5ETjgfOp1TeV
	 MRMoEG0ejlPKWuCD94lQJLFTN3n6jlB1M874jNGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 053/627] arm64: dts: rockchip: fix endpoint dtc warning for PX30 ISP
Date: Tue, 12 Aug 2025 19:25:48 +0200
Message-ID: <20250812173421.347090072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit 5ddb2d46852997a28f8d77153e225611a8268b74 ]

dtc complains with the following message for DTSes which use the ISP:

arch/arm64/boot/dts/rockchip/px30.dtsi:1272.19-1276.6: Warning (graph_child_address): /isp@ff4a0000/ports/port@0: graph node has single child node 'endpoint@0', #address-cells/#size-cells are not necessary

Typically, it is expected from the device DTS(I) to update the SoC DTSI
nodes if they have more than one endpoint, so let's assume there's only
one endpoint in port@0 by default, instead of forcing board DTS(I)s to
/delete-property/ address-cells and size-cells to make dtc happy.

Because PX30 PP1516/EVB's endpoint@0 is the only endpoint and
considering its parent node now has no address-cells property, dtc
complains (same messages for PX30 EVB):

arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi:447.29-451.6: Warning (avoid_default_addr_size): /isp@ff4a0000/ports/port@0/endpoint@0: Relying on default #address-cells value
arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi:447.29-451.6: Warning (avoid_default_addr_size): /isp@ff4a0000/ports/port@0/endpoint@0: Relying on default #size-cells value
arch/arm64/boot/dts/rockchip/px30-pp1516-ltk050h3146w-a2.dtb: Warning (avoid_unnecessary_addr_size): Failed prerequisite 'avoid_default_addr_size'
arch/arm64/boot/dts/rockchip/px30-pp1516-ltk050h3146w-a2.dtb: Warning (unique_unit_address_if_enabled): Failed prerequisite 'avoid_default_addr_size'
arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi:447.29-451.6: Warning (graph_endpoint): /isp@ff4a0000/ports/port@0/endpoint@0: graph node '#address-cells' is -1, must be 1
arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi:447.29-451.6: Warning (graph_endpoint): /isp@ff4a0000/ports/port@0/endpoint@0: graph node '#size-cells' is -1, must be 0
arch/arm64/boot/dts/rockchip/px30-pp1516-ltk050h3146w-a2.dtb: Warning (graph_child_address): Failed prerequisite 'graph_endpoint'

so we fix that by removing the reg property. dtc still complains (same
messages for PX30 EVB):

arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi:447.29-450.6: Warning (unit_address_vs_reg): /isp@ff4a0000/ports/port@0/endpoint@0: node has a unit name, but no reg or ranges property

so we also remove the @0 suffix off the node name.

Fixes: 8df7b4537dfb ("arm64: dts: rockchip: add isp node for px30")
Fixes: 474a77395be2 ("arm64: dts: rockchip: hook up camera on px30-evb")
Fixes: 56198acdbf0d ("arm64: dts: rockchip: add px30-pp1516 base dtsi and board variants")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20250610-ringneck-haikou-video-demo-cam-v2-1-de1bf87e0732@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-evb.dts     | 3 +--
 arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi | 3 +--
 arch/arm64/boot/dts/rockchip/px30.dtsi        | 2 --
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-evb.dts b/arch/arm64/boot/dts/rockchip/px30-evb.dts
index d93aaac7a42f..bfd724b73c9a 100644
--- a/arch/arm64/boot/dts/rockchip/px30-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-evb.dts
@@ -483,8 +483,7 @@ &isp {
 
 	ports {
 		port@0 {
-			mipi_in_ucam: endpoint@0 {
-				reg = <0>;
+			mipi_in_ucam: endpoint {
 				data-lanes = <1 2>;
 				remote-endpoint = <&ucam_out>;
 			};
diff --git a/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi b/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
index 3f9a133d7373..b4bd4e34747c 100644
--- a/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi
@@ -444,8 +444,7 @@ &isp {
 
 	ports {
 		port@0 {
-			mipi_in_ucam: endpoint@0 {
-				reg = <0>;
+			mipi_in_ucam: endpoint {
 				data-lanes = <1 2>;
 				remote-endpoint = <&ucam_out>;
 			};
diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index feabdadfa440..8220c875415f 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -1271,8 +1271,6 @@ ports {
 
 			port@0 {
 				reg = <0>;
-				#address-cells = <1>;
-				#size-cells = <0>;
 			};
 		};
 	};
-- 
2.39.5



