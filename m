Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E91A735
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZiTE6FC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0E7C433C7;
	Mon,  9 Oct 2023 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859468;
	bh=Wd0S+7u5IxVsEIbsxw4BbrPj33sR3VNQJGrC6ojyBjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZiTE6FCIJwDJ130m1cFUcBSJI6Vq1mxoI9XzW+ty3iIsq0TE4IrzD3QCHPPaRW4Z
	 YtqZHuvTL25+JH+Y9ytVGKf65/hYHD9cIK+/n4KP2bKbhJ3IjqJRpMt6XusE0O89fa
	 2O39Y7RqCr5QW1eql46WqZ3cCrOrzmfuTSmu5eV4=
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
Subject: [PATCH 4.19 30/91] ARM: dts: ti: omap: motorola-mapphone: Fix abe_clkctrl warning on boot
Date: Mon,  9 Oct 2023 15:06:02 +0200
Message-ID: <20231009130112.570522225@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit ac08bda1569b06b7a62c7b4dd00d4c3b28ceaaec ]

Commit 0840242e8875 ("ARM: dts: Configure clock parent for pwm vibra")
attempted to fix the PWM settings but ended up causin an additional clock
reparenting error:

clk: failed to reparent abe-clkctrl:0060:24 to sys_clkin_ck: -22

Only timer9 is in the PER domain and can use the sys_clkin_ck clock source.
For timer8, the there is no sys_clkin_ck available as it's in the ABE
domain, instead it should use syc_clk_div_ck. However, for power
management, we want to use the always on sys_32k_ck instead.

Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Fixes: 0840242e8875 ("ARM: dts: Configure clock parent for pwm vibra")
Depends-on: 61978617e905 ("ARM: dts: Add minimal support for Droid Bionic xt875")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4-droid4-xt894.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-droid4-xt894.dts b/arch/arm/boot/dts/omap4-droid4-xt894.dts
index 67d77eee9433c..459720f5f5586 100644
--- a/arch/arm/boot/dts/omap4-droid4-xt894.dts
+++ b/arch/arm/boot/dts/omap4-droid4-xt894.dts
@@ -647,12 +647,12 @@
 /* Configure pwm clock source for timers 8 & 9 */
 &timer8 {
 	assigned-clocks = <&abe_clkctrl OMAP4_TIMER8_CLKCTRL 24>;
-	assigned-clock-parents = <&sys_clkin_ck>;
+	assigned-clock-parents = <&sys_32k_ck>;
 };
 
 &timer9 {
 	assigned-clocks = <&l4_per_clkctrl OMAP4_TIMER9_CLKCTRL 24>;
-	assigned-clock-parents = <&sys_clkin_ck>;
+	assigned-clock-parents = <&sys_32k_ck>;
 };
 
 /*
-- 
2.40.1



