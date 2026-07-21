Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5289B46D0A8;
	Tue, 21 Jul 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657957; cv=none; b=doJhAMBZPMGbm+l99/7Y49psB0cNQr7b/U7U6VFB80FNVWMonMxyPJe+5L4E4H1LU/4aEYJJk7jJnA+r/7P2aIu4FbmknL22+ZSfnaTU9h5UN6Y7QaGOw+Zf3PsFfanq1/n0bcu4KyLTcqucb49eG4u1jqQxVBq5Z83mYgetgCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657957; c=relaxed/simple;
	bh=epQgUY7PjfROyUiJtyN/Z8dIZvGprO3PsI4bYFkLbqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KT7gWnRDE5bD4V3ZGQivsxTgJW1PaSTNIy25ocZJBXDE+xNsN+qR+oUhu9DVA7cMJYeyU7cTVHseHBwvwm0ZUM/3GEOTiPSacXQYjpXqvOOvV4wlOWwwNclpzxgGBm1WFnG1hvll3sxPeqLQcuam6/6EXL+pO1KTfzrmDPykR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3h51s7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3h51s7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B899B1F000E9;
	Tue, 21 Jul 2026 18:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657955;
	bh=evsQ38rut8orANT/jDFDjP5R6h8E+QdONXRp3U2jyW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D3h51s7Gn6Brunq8pEceW4hMYJoj8EMF3RiA9wXUfqgn6qq9a7r08c7uvCnxW6pqg
	 Q1ycOa0u0svJ7jO+CWHiFBAiHbGFYhwAMDjDhM3pu9q32tR11KPUpcSMEGIeRUxex0
	 +7sCSbVV2nBDjk7XYZAHrMblZveQM6vlfZ5Aj7uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0960/1611] MIPS: DEC: Ensure RTC platform device deregistration upon failure
Date: Tue, 21 Jul 2026 17:17:56 +0200
Message-ID: <20260721152536.988415839@linuxfoundation.org>
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



