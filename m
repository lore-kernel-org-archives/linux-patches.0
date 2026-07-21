Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECCC3D3337;
	Tue, 21 Jul 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653423; cv=none; b=OnSTFnQFWL1thZycpvsAto6AwWN0f7baIXsGxxHxD5EZYmTHQKGo8YdogUt9jYgsLQExoBB7h+z6tDktLF3iT9o/sFjnY7bjfjLUUnRqMOuVuTJExabT6r/37ucPwB/LF/AXDecS4sGza6PM+RM/3vxLYYAdNerkUpu87mQgsxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653423; c=relaxed/simple;
	bh=WpztctrwtWduhZYv332bi5m7QX0pych9qGFNO2HfuJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWWcsaaZRYSb/ibDa+uZ+WnDD7KjPYuGc1f32knOQvXPIjr1tR1pVCHiGQaMjfLyuzvbK/luiWHJzor2D9ivNK/tyolApprtWhbWR01FzRr3ZGrSk5lwrLKd2qZNH9KbseUJkOv58Ggwp1eVKq7puwAI+8FJ0Hk8GxXpS+yTZEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXOc9hW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXOc9hW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102E01F000E9;
	Tue, 21 Jul 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653422;
	bh=Fhgdv9WWuh3JRUZqOmXuHMgNrouJfLxTYkqe9AO8jDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXOc9hW5hS8uPm0kkFXd7uICvr3a36HV2J/J0EmqUWEdcP3SJt4dk0o3SCFQX5I7F
	 dU8ghF3K9xWXXsOiZhYdomg7Z/0wV3/nQIucGaGuIoXz+i2xVDm07j3T5a3eRRl3ty
	 bIRrW14vRMAjifkWbEUhm7wE60FDZhKkQdsmqggg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1320/2077] MIPS: DEC: Ensure RTC platform device deregistration upon failure
Date: Tue, 21 Jul 2026 17:16:33 +0200
Message-ID: <20260721152623.953455350@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit eacaf5ae747f7dead6cc268de17a7382d79031fc ]

Switch RTC platform device registration from platform_device_register()
to platform_add_devices() so as to make sure any failure will result in
automatic device unregistration.

Fixes: fae67ad43114 ("arch/mips/dec: switch DECstation systems to rtc-cmos")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/dec/platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/mips/dec/platform.c b/arch/mips/dec/platform.c
index 723ce16cbfc0cc..a005246a0ac5d2 100644
--- a/arch/mips/dec/platform.c
+++ b/arch/mips/dec/platform.c
@@ -38,6 +38,10 @@ static struct platform_device dec_rtc_device = {
 	.num_resources = ARRAY_SIZE(dec_rtc_resources),
 };
 
+static struct platform_device *dec_rtc_devices[] __initdata = {
+	&dec_rtc_device,
+};
+
 static struct resource dec_dz_resources[] = {
 	{ .name = "dz", .flags = IORESOURCE_MEM, },
 	{ .name = "dz", .flags = IORESOURCE_IRQ, },
@@ -137,7 +141,7 @@ static int __init dec_add_devices(void)
 	}
 	num_zs = i;
 
-	ret1 = platform_device_register(&dec_rtc_device);
+	ret1 = platform_add_devices(dec_rtc_devices, 1);
 	ret2 = IS_ENABLED(CONFIG_32BIT) ?
 	       platform_add_devices(dec_dz_devices, num_dz) : 0;
 	ret3 = platform_add_devices(dec_zs_devices, num_zs);
-- 
2.53.0



