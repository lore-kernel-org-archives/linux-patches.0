Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E086411710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6209EC433C8;
	Mon, 11 Sep 2023 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445285;
	bh=wuuQxkqdlaKhAPeF6YfbdiFIk5/T3j6YxfhingqXH+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KPLsM2wZnCWjnjjgQ5n1hQgAGYO1skwTPoz5OdryM2M1zmyq5iUc/rdnehnL+S14
	 /FkRkWhDXQeezXdBBM1rCUoAVvg5KYNblhCLbQETAwVCUplfqgI5/u6+WUjWcFfgqh
	 9MPceUAF4vz+peRu66DixcKa7s4LyRjumX1Ms+8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/600] arm64: tegra: Fix HSUART for Jetson AGX Orin
Date: Mon, 11 Sep 2023 15:44:47 +0200
Message-ID: <20230911134641.100924136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 861dbb2b15b1049113887fb95e856f7123eea0cc ]

After commit 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
reset-names") was applied, the HSUART failed to probe and the following
error is seen:

 serial-tegra 3100000.serial: Couldn't get the reset
 serial-tegra: probe of 3100000.serial failed with error -2

Commit 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
reset-names") is correct because the "reset-names" property is not
needed for 8250 UARTs. However, the "reset-names" is required for the
HSUART and should have been populated as part of commit ff578db7b693
("arm64: tegra: Enable UART instance on 40-pin header") that
enabled the HSUART for Jetson AGX Orin. Fix this by populating the
"reset-names" property for the HSUART on Jetson AGX Orin.

Fixes: ff578db7b693 ("arm64: tegra: Enable UART instance on 40-pin header")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
index 57ab753288144..f094011be9ed9 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -2004,6 +2004,7 @@ interrupt-controller@2a40000 {
 
 		serial@3100000 {
 			compatible = "nvidia,tegra194-hsuart";
+			reset-names = "serial";
 			status = "okay";
 		};
 
-- 
2.40.1



