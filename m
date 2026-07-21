Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1144946AA80;
	Tue, 21 Jul 2026 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648303; cv=none; b=GUz9SxsxrAG00jFb0kCzmMYSKdIiwNtSmMLPSqW3MLTtlGZS57QHUwGS2MrLqm6UxPQ4lQNj60fA8C20Je4leokeFBhF+gSS/2e2QMgSWDUQaQe/ZI944sLQBX/CG9iNN1W/+W1wQTMSK/s8BjTY4Y0w0yHszibBF1XQL8YTxQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648303; c=relaxed/simple;
	bh=8GHy+FoPy7/hJ0CzDFD+APq/VOHRS9gPn2q736IeKGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nm85LBzKwG3aPsxEPcFP2s9Hd/mwNtVhXQi5dqjuOxFihPzLtqbtnyRujdasYdl0YW5332cxJjCmKZwsWnAafYMdViXtxLkmmJ4UKh8pj6SYP41XquW2zMqf+zAEMS26vugc7gEcNTFYTBe6Srmpr17xGMmTzhC75sQba2L9YqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wkur2/OV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wkur2/OV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A1E1F00A3A;
	Tue, 21 Jul 2026 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648302;
	bh=ngEtBjEnICjKo0JXFve7zFVIRcGFWkyXATpSrsqiH/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wkur2/OVqdOlbxJVMeGsLPVmeHxWhcZ/hYAZNYXb7ax1TwQftU5VqBzt7r/Ho9x1c
	 OQTowv25Mu4lOGDZrgYoiXZgtG5Tv31iDYIyfnw0DLpnFsTHAdUltW6LQRU0osBNz0
	 kT2Iq7rHNeg0AWQ+7HNZJd8jtfGoPoDzqehRVDg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0148/2077] ARM: dts: rockchip: Add #{address,size}-cells to Chromium-based /firmware
Date: Tue, 21 Jul 2026 16:57:01 +0200
Message-ID: <20260721152556.175480246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 98461edf564a35ee00a97a64f5463eaece586546 ]

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
Reviewed-by: Douglas Anderson <dianders@chromium.org>
[On RK288-based Chromebooks there is no real other way than to load the
 DTB  together with its kernel when running a mainline kernel and as the
 whole line is EOL, there also won't be any updates to the bootloader that
 could fix that issue there.]
Link: https://patch.msgid.link/20260428200712.2660635-3-briannorris@chromium.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi b/arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi
index 2d6cf08d00f906..ca8e8e73507819 100644
--- a/arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi
@@ -18,6 +18,11 @@ chosen {
 		stdout-path = "serial2:115200n8";
 	};
 
+	firmware {
+		#address-cells = <1>;
+		#size-cells = <1>;
+	};
+
 	/*
 	 * The default coreboot on veyron devices ignores memory@0 nodes
 	 * and would instead create another memory node.
-- 
2.53.0



