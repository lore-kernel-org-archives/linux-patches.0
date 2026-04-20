Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D203D4A33F8;
	Mon, 20 Apr 2026 13:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691966; cv=none; b=mrHrbVt/JVXZ5y6Ln33NWYq3S9uS783slx66lH4EDUThSFSykdxpKL5714SPTWQ//3atlcTfneVxqeuV+OW4iQ51MKOIi6U7/DGzSc4xiiNR/+xVNmVx/51Ky/QsV7EYl7W8oOYMJ0brWjJQKC8Uy2cVdiazsR7QdprGs15RTZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691966; c=relaxed/simple;
	bh=DIGKo2zsA17VauZZiZ1xLrJA3DEHB2BiyBYge1MHuEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALeaIh8sgATRL39YDfIansLZ3IMykCx571DglxQnaVBAPyWwmYj0+C+FvINYX1bTN90RJ8J7Bo0UYA8eQlMuZ2AYD7z1vlTrzN/MT+zcdZSOB6rZucZcV1sthyAyuTcV5MepYzELHoCJCrzt3FV+5ff1OiZT8QOfaZ/WCmijHWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPmNAD7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPmNAD7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5D1C2BCB8;
	Mon, 20 Apr 2026 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691966;
	bh=DIGKo2zsA17VauZZiZ1xLrJA3DEHB2BiyBYge1MHuEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPmNAD7Tkl1tRvmu9fzY98Fea2atYmuiAIqTrOEcozAgJN6ZuLsQCt50LUG2VH61Z
	 b4h2PscPhnbvQ4JPrZ1wVsBkIqWSOi/yWSkAOG5Zb1Eo+wMyeu/Qi+6nPTLBG2QPzs
	 1u7D+diuPfMWoV4Em2bn7EZvVZv+iOZoakgsbu8z6WOHLDyeDsj4fjYpN5yzTkYB0V
	 1WOD8BFrF9aCtf9HB96Kmo3DRoPB3WGXonPGA9cwcK6Ep5eGwHCHdxPxkWq2Qh9RMV
	 fd64xsc5/cYW/BQTXOe1cXj6yCsBsGRmy/zYB/uF/jndjXIzgiwY2DVB2ohtsY+omb
	 vTitmzFwMz4YQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jon Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	thierry.reding@kernel.org,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] dt-bindings: net: Fix Tegra234 MGBE PTP clock
Date: Mon, 20 Apr 2026 09:21:29 -0400
Message-ID: <20260420132314.1023554-295-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit fb22b1fc5bca3c0aad95388933497ceb30f1fb26 ]

The PTP clock for the Tegra234 MGBE device is incorrectly named
'ptp-ref' and should be 'ptp_ref'. This is causing the following
warning to be observed on Tegra234 platforms that use this device:

 ERR KERN tegra-mgbe 6800000.ethernet eth0: Invalid PTP clock rate
 WARNING KERN tegra-mgbe 6800000.ethernet eth0: PTP init failed

Although this constitutes an ABI breakage in the binding for this
device, PTP support has clearly never worked and so fix this now
so we can correct the device-tree for this device. Note that the
MGBE driver still supports the legacy 'ptp-ref' clock name and so
older/existing device-trees will still work, but given that this
is not the correct name, there is no point to advertise this in the
binding.

Fixes: 189c2e5c7669 ("dt-bindings: net: Add Tegra234 MGBE")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260401102941.17466-3-jonathanh@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 .../devicetree/bindings/net/nvidia,tegra234-mgbe.yaml         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
index 2bd3efff2485e..215f14d1897d2 100644
--- a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
+++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
@@ -42,7 +42,7 @@ properties:
       - const: mgbe
       - const: mac
       - const: mac-divider
-      - const: ptp-ref
+      - const: ptp_ref
       - const: rx-input-m
       - const: rx-input
       - const: tx
@@ -133,7 +133,7 @@ examples:
                  <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
                  <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
                  <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
-        clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+        clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
                       "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
                       "rx-pcs", "tx-pcs";
         resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
-- 
2.53.0

