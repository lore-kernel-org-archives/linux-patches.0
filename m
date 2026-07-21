Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF633A9FC;
	Tue, 21 Jul 2026 20:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666766; cv=none; b=OCiL53fsKYQblhcNBYsxePJp0Xj1PwN7nAey59OBsElFgL1Ne8k/cfoTYzAkFeuAJdP7dUJvmxoDV32PO51KA6ZVAheAj8Xe1U7CKkaf1gvXVDgukDCmXYwzXj6lwlMkIyUexHNYFb7e8gBi/bqHtUzJEKFAcvsH00V44BKANmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666766; c=relaxed/simple;
	bh=tRgjYnNJYL49EOvwgg2oWyEO/Jr0UW0MZeOTxyCP5i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYmtknAoAIJc08hjHoE8YdVl1wEYg9HpuvvFPJ5s/79Os52LY6aQqBpqN6SOhlCjH9h72Chd1P9J2CnmSqOoqEd9c2u6psbNm6Vqnt9ZfvhAOgBjWDNTSrq6eLoqdSA//VeI4DPnle+7MZ8/gq6DrjCrQEK9nTGIgltMmO/TeyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMVFvyRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMVFvyRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257281F000E9;
	Tue, 21 Jul 2026 20:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666765;
	bh=yKHgxtZt1T/0tZVB5BxIBbs9eIAzdFsxVRQXvh0CV5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMVFvyRhKpvUr9ax8GJBZ4t3QqwXQvzEe+nAiKO9ih2anqQw77U+2eaBj+v4rCdii
	 MhjQDDfYGWqJtPsWmfWAsN/zYFBpHLUBMIqFtLpZQAPdvyjSOzRM9eusG8ESqm/oaK
	 EgE8F3CZ+a9lzqGfO8cjxEzYs+DHOnD6JcJ2iWks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0807/1266] MIPS: DEC: Ensure RTC platform device deregistration upon failure
Date: Tue, 21 Jul 2026 17:20:44 +0200
Message-ID: <20260721152459.919131339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



