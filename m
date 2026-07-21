Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE9646D2B3;
	Tue, 21 Jul 2026 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655703; cv=none; b=CvAZiU82+lv+pop/PqJpgqkhVlbHGlSAUSKbg4BbLECoqPPO85ghuV/dpIIy8RKrxdQM98afioyDXSVgBx6dYi4mcRMDM9tePejKX+9blCiRupXMVnqRVXGcPZ3/LJ82R6XFLIWryjsAj46A75mzY4Ms4bb9IX+q5cHHY80F5YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655703; c=relaxed/simple;
	bh=wZogdN2SWww0cx7ax2ff/VDsQIQJdncAVWF4zdbtau8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKo9oXkIwf5ru7Thcsh99paCbsMx83WX2Hp1T+20zWG5N1tzs0aK0cq3En/XBC0kpnxECYpniSW/QGMRqOyCGoEJDEx83Yhd8z/otPdBkFHisENzqaUPekN0+/wmo1IrWejC432dx4N8YY5aXFec08om0xN8H9jX1aSYgEfT9Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtQliLJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtQliLJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E5D1F000E9;
	Tue, 21 Jul 2026 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655702;
	bh=Tqq7weOOAQhBQgBr0GxljrRxnW1/MdGBMTnhGqSmOAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtQliLJ1RBjASx2rSkb3mkirE9z+5Wa8XZ9Kr+tm/axz0XEbHISh9vuINXf6LXMti
	 JfoDYPoHHc3lwJ8DtMK2ndSOuErgZhH5psJDDTo5acgdTii9X74uC7jRpXknNHzOjK
	 +eXI/pNoFBAuYNEBeGsTBMgr4thxruRU8RClFX6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0110/1611] ARM: dts: rockchip: Add #{address,size}-cells to Chromium-based /firmware
Date: Tue, 21 Jul 2026 17:03:46 +0200
Message-ID: <20260721152517.325695541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 260d6c92cfd11d..ce846b9bd23fbf 100644
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



