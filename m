Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE03783BE;
	Thu, 17 Sep 2026 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665125; cv=none; b=Xo/oR0ICP87X2qwkYPUhmlrLTqDUT55yB44OxQUz7MR9AMBiftk1yyRIHb75+H8LXrdaCG9UftKJJRvJlxcj6Fp2mE1wgAksli/HCMcRbWJsCX28+zXYgSd3yQlsqHNaQYLOMYgZc6sg4kT4ZdFUQ7Hox1jEqj7qXXMUuECEKS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665125; c=relaxed/simple;
	bh=IXQT2ug6bJQLTATJv4MrFIsAnSVItx6vQ1iW332FEAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlC7tKagS5u8w/NG2kPdmFNKJYQSDQjjjPPG+N/Z2LBGb7BomoYd5jcv1VGv3w4SYMtyDQ3YP4bs8acZaZEzMyhI52vROkSwjcnDvkogloNSib69L5eHoARe/OO1Zj25Kc6TSuq+4PcQ8vbYv/DA9Q6ZDPo6VJR98RqcXQIzAY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iSKGfLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iSKGfLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2CE1F000FF;
	Thu, 17 Sep 2026 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665123;
	bh=ZNdYC3GckW908RgmpimUYCTkDSvPzHKTjB/loN7mazg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iSKGfLiPhRyooCIL3wiCl7YsxCZIbE56oYc6GiPBAEcP6FMNq7ZRk76sSGWjHz41
	 pxH2dCT7QIbaCZScJ8ztLTAnCxXufoKo3kbP/eI2P381ugf2r1Do/AgMpuy+9g8USE
	 YTMMyNEULMyHbyEHaz8OCEjbjl4jHg/GEh5EkuwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0598/1250] rtc: cmos: Use platform_get_irq_optional() in cmos_platform_probe()
Date: Thu, 17 Sep 2026 16:06:33 +0100
Message-ID: <20260917151608.089025032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit e9f850ba66cdf6b77fb4f005e46c4b605c4de434 ]

The rtc-cmos driver can live without an IRQ and returning an error
code from platform_get_irq() is not a problem for it in general, so
make it call platform_get_irq_optional() in cmos_platform_probe()
instead of platform_get_irq() to avoid a confusing error message
printed by the latter if an IRQ cannot be found for index 0, which
is possible on x86 platforms.

Additionally, on x86, if the IRQ is not defined and the system has
a legacy PIC, hardcode it to RTC_IRQ, which should be safe then (and
which is what the dropped PNP code did).

Fixes: d15f1c2e413e ("ACPI: PNP: Drop CMOS RTC PNP device support")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-acpi/20260303060752.GA2749263@ax162/
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12857714.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 7ac39c435f630..b537f40654b72 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1508,9 +1508,18 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	else
 		resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
+	irq = platform_get_irq_optional(pdev, 0);
+	if (irq < 0) {
 		irq = -1;
+#ifdef CONFIG_X86
+		/*
+		 * On some x86 systems, the IRQ is not defined, but it should
+		 * always be safe to hardcode it on systems with a legacy PIC.
+		 */
+		if (nr_legacy_irqs())
+			irq = RTC_IRQ;
+#endif
+	}
 
 	return cmos_do_probe(&pdev->dev, resource, irq);
 }
-- 
2.53.0



