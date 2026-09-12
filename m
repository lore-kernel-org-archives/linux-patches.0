Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF6537C0E2;
	Sat, 12 Sep 2026 07:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197819; cv=none; b=C9ZaquE66N3dGBBw6CwrY0rjTk6nVD+s/GhnDCXfflZtb9ye0DzPcgFjA83eDgTNkO8now2AvMSsUeP7S/9bVfXx3wDAYOvFU4Gy198gy9KeNKD+Fa9LQjMVGTIIEOOoPKzaGEePY3K1lL2HH0bkcChtXxj6CXqK59Ul7GXxA50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197819; c=relaxed/simple;
	bh=ZVKIrVphr4/yxWSPanIp5DrxmEQ2UbbJ2QQPXbBqTSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfIkP2WkpAj+S23B+GpZUmHISOkhtW1+AxK3raoW6yMYNB4ofd7kzMzsl63pdKYX0fX+w78gUElFGH/cvIcQQtVuM0isedEJDdotf15Xb6zLgA714PQys0bXYi01lpdO8krSCb/FLrNTevaEsLvmu6rUclHVW0746oqhe78DAog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvisCAje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvisCAje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5441F000FF;
	Sat, 12 Sep 2026 07:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197818;
	bh=QJX+3lN3vweXPDaFFYcbCs8iYb74F7njoEKiBb2mrUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvisCAjeW32H53ySAz/ofHE5A1PId2L64Bs/LNolWoIg1tF8BDYqzEf9byGLh/lhH
	 DYnqzYc2tD4857BemmVySirPFiPlUXiuUoRJevxhso6qSnr5XkIjyZuhx2hNsVZwEA
	 hVYQuZt4sxMZAIQEFArQZuvV3qLAF8pz1OZkS4R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0253/1815] arm64: dts: qcom: Add #{address,size}-cells to Chromium-based /firmware
Date: Sat, 12 Sep 2026 08:33:23 +0200
Message-ID: <20260912065654.920562121@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 2a906f0b4f037b3fe5f790a48f88549a86288fdf ]

Chromium/Depthcharge bootloaders may dynamically add a few device nodes
to a system's DTB under a /firmware node. A typical DT looks something
like the following:

/ {
        firmware {
                ranges;

                coreboot {
                        compatible = "coreboot";
                        reg = <...>;
                        ...;
                };
        };
};

Notably, the /firmware node has an empty 'ranges', but does not have
address/size-cells.

Commit 6e5773d52f4a ("of/address: Fix WARN when attempting translating
non-translatable addresses") started requiring #address-cells for a
device's parent if we want to use the reg resource in a device node.
This leads to errors like the following:

[    7.763870] coreboot_table firmware:coreboot: probe with driver coreboot_table failed with error -22

Add appropriate #{address,size}-cells to work around the problem.

Note that Google has also patched the Depthcharge bootloader source to
add {address,size}-cells [1], but bootloader updates are typically
delivered only via Google OS updates. Not all users install Google
software updates, and even if they do, Google may not produce updated
binaries for all/older devices.

[1] https://lore.kernel.org/all/20241209092809.GA3246424@google.com/
    https://crrev.com/c/6051580 ("coreboot: Insert #address-cells and
    #size-cells for firmware node")

Closes: https://lore.kernel.org/all/aeKlYzTiL0OB1y3g@google.com/
Fixes: 6e5773d52f4a ("of/address: Fix WARN when attempting translating non-translatable addresses")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20260428200712.2660635-8-briannorris@chromium.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi   | 5 +++++
 arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index b398f69917f0e..cd4a0e281cf8f 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -99,6 +99,11 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
+	firmware {
+		#address-cells = <2>;
+		#size-cells = <2>;
+	};
+
 	/* FIXED REGULATORS - parents above children */
 
 	/* This is the top level supply and variable voltage */
diff --git a/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi b/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
index 5c5e4f1dd2217..58ea0532c0fbb 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-herobrine.dtsi
@@ -25,6 +25,11 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
+	firmware {
+		#address-cells = <2>;
+		#size-cells = <2>;
+	};
+
 	/*
 	 * FIXED REGULATORS
 	 *
-- 
2.53.0



