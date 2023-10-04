Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5061D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9B3C433C8;
	Wed,  4 Oct 2023 18:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442838;
	bh=qCNm2q5eHQE4ezJ5e8cxh1FH5nKysZXujVBMaGYB5U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrT/sXa7iT+I+m+cQVAT8LxEmlajP5T0Is/vWHU+eJsK0ceKVznVoLeVxZNO3AilZ
	 TARLztoXNxg2rT2Digj3qdt/DUlYi55YFrBau6wStAi5vy3PM790rPljCx6KXUfcSg
	 GazNp58DcOYVL0M3MLXQ3NPgXYK0NW1QaYcMkpeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Carl Philipp Klemm <philipp@uvos.xyz>,
	Merlijn Wajer <merlijn@wizzup.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/183] ARM: dts: ti: omap: Fix bandgap thermal cells addressing for omap3/4
Date: Wed,  4 Oct 2023 19:55:29 +0200
Message-ID: <20231004175207.986791298@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 6469b2feade8fd82d224dd3734e146536f3e9f0e ]

Fix "thermal_sys: cpu_thermal: Failed to read thermal-sensors cells: -2"
error on boot for omap3/4. This is caused by wrong addressing in the dts
for bandgap sensor for single sensor instances.

Note that omap4-cpu-thermal.dtsi is shared across omap4/5 and dra7, so
we can't just change the addressing in omap4-cpu-thermal.dtsi.

Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Fixes: a761d517bbb1 ("ARM: dts: omap3: Add cpu_thermal zone")
Fixes: 0bbf6c54d100 ("arm: dts: add omap4 CPU thermal data")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-cpu-thermal.dtsi | 3 +--
 arch/arm/boot/dts/omap4-cpu-thermal.dtsi | 5 ++++-
 arch/arm/boot/dts/omap443x.dtsi          | 1 +
 arch/arm/boot/dts/omap4460.dtsi          | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-cpu-thermal.dtsi b/arch/arm/boot/dts/omap3-cpu-thermal.dtsi
index 1ba79932a79fc..4d2684e4ae06e 100644
--- a/arch/arm/boot/dts/omap3-cpu-thermal.dtsi
+++ b/arch/arm/boot/dts/omap3-cpu-thermal.dtsi
@@ -12,8 +12,7 @@ cpu_thermal: cpu_thermal {
 	polling-delay = <1000>; /* milliseconds */
 	coefficients = <0 20000>;
 
-			/* sensor       ID */
-	thermal-sensors = <&bandgap     0>;
+	thermal-sensors = <&bandgap>;
 
 	cpu_trips: trips {
 		cpu_alert0: cpu_alert {
diff --git a/arch/arm/boot/dts/omap4-cpu-thermal.dtsi b/arch/arm/boot/dts/omap4-cpu-thermal.dtsi
index 801b4f10350c1..d484ec1e4fd86 100644
--- a/arch/arm/boot/dts/omap4-cpu-thermal.dtsi
+++ b/arch/arm/boot/dts/omap4-cpu-thermal.dtsi
@@ -12,7 +12,10 @@ cpu_thermal: cpu_thermal {
 	polling-delay-passive = <250>; /* milliseconds */
 	polling-delay = <1000>; /* milliseconds */
 
-			/* sensor       ID */
+	/*
+	 * See 44xx files for single sensor addressing, omap5 and dra7 need
+	 * also sensor ID for addressing.
+	 */
 	thermal-sensors = <&bandgap     0>;
 
 	cpu_trips: trips {
diff --git a/arch/arm/boot/dts/omap443x.dtsi b/arch/arm/boot/dts/omap443x.dtsi
index 238aceb799f89..2104170fe2cd7 100644
--- a/arch/arm/boot/dts/omap443x.dtsi
+++ b/arch/arm/boot/dts/omap443x.dtsi
@@ -69,6 +69,7 @@
 };
 
 &cpu_thermal {
+	thermal-sensors = <&bandgap>;
 	coefficients = <0 20000>;
 };
 
diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index 1b27a862ae810..a6764750d4476 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -79,6 +79,7 @@
 };
 
 &cpu_thermal {
+	thermal-sensors = <&bandgap>;
 	coefficients = <348 (-9301)>;
 };
 
-- 
2.40.1



