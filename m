Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58DD23D2AD;
	Mon, 19 May 2025 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689795; cv=none; b=HHRTpGfG0aSUsQoHe5lb51zoLUk7JgMZiHC5ahLYpvW79F7n6WYf6zrF+7e9XHw1aVzBjFJ1SRBmfEAFDqBOC9naJBUh6JL10yaZq/fC8Dn9LY63ziIoSKJ34X1f6V9DkhyutDEWHCZhz96JSEhCf5hadrQnVnmOmqXGUUXV8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689795; c=relaxed/simple;
	bh=3JZ+J2Vm8ML3pFJKhoXIlMdHqBp8i4FGSQqaiIZu1Uw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CkAWo9kig9NUYlSZq1ZF+9Q7nFUQ9KLQETsYrdtmprJgWpORTPp6hbDap9A8mWI3A/uOyjMy0HArJksYzGHfpIomyraxiDuGTXCEyBF9b9kKq4cfd8H5098FebqaKXtIbjo/lRZSco4ayDZPXHFcPKpF8Is4bNmAq/Ozp0jW2iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8TTsj3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8TTsj3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B12BC4CEE9;
	Mon, 19 May 2025 21:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689794;
	bh=3JZ+J2Vm8ML3pFJKhoXIlMdHqBp8i4FGSQqaiIZu1Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8TTsj3I2eiasrXdmGnHM3dZo6We3tvJzlxvFjSM0kD+zdW6Eai6stJHqUS2GaXUI
	 vQbZHadesLzs169EogaOeGEQnpWwAMryANvMl/6kr5ONL4oX0GHbSiGsMGh8nuBcfW
	 yteWviAkySWDdklTqT50Ea78XtSTOaGIctPTgT0g87/9LtwtMocbBcIcFHG5YGD53R
	 GRUhb0Lvo1L812DDagKJaKuqt0LCZoOV9YIQgFxlXVEBBEu/6urDV8UQThWyblgMhN
	 qqTHP9vszvxjsxu7W2uaL7oUxKBGFSojb0OMpY2nohRhlrrDKvZKoaVb8XGiECa/pd
	 uoMxumpo126VQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Chau <johnchau@0atlas.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	ibm-acpi@hmh.eng.br,
	dvhart@infradead.org,
	andy@infradead.org,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 3/7] platform/x86: thinkpad_acpi: Support also NEC Lavie X1475JAS
Date: Mon, 19 May 2025 17:23:04 -0400
Message-Id: <20250519212308.1986645-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212308.1986645-1-sashal@kernel.org>
References: <20250519212308.1986645-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.183
Content-Transfer-Encoding: 8bit

From: John Chau <johnchau@0atlas.com>

[ Upstream commit a032f29a15412fab9f4352e0032836d51420a338 ]

Change get_thinkpad_model_data() to check for additional vendor name
"NEC" in order to support NEC Lavie X1475JAS notebook (and perhaps
more).

The reason of this works with minimal changes is because NEC Lavie
X1475JAS is a Thinkpad inside. ACPI dumps reveals its OEM ID to be
"LENOVO", BIOS version "R2PET30W" matches typical Lenovo BIOS version,
the existence of HKEY of LEN0268, with DMI fw string is "R2PHT24W".

I compiled and tested with my own machine, attached the dmesg
below as proof of work:
[    6.288932] thinkpad_acpi: ThinkPad ACPI Extras v0.26
[    6.288937] thinkpad_acpi: http://ibm-acpi.sf.net/
[    6.288938] thinkpad_acpi: ThinkPad BIOS R2PET30W (1.11 ), EC R2PHT24W
[    6.307000] thinkpad_acpi: radio switch found; radios are enabled
[    6.307030] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    6.307033] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    6.320322] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    6.371963] thinkpad_acpi: secondary fan control detected & enabled
[    6.391922] thinkpad_acpi: battery 1 registered (start 0, stop 85, behaviours: 0x7)
[    6.398375] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input13

Signed-off-by: John Chau <johnchau@0atlas.com>
Link: https://lore.kernel.org/r/20250504165513.295135-1-johnchau@0atlas.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 5e44a4338706a..b994e07a61111 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10935,6 +10935,8 @@ static int __must_check __init get_thinkpad_model_data(
 		tp->vendor = PCI_VENDOR_ID_IBM;
 	else if (dmi_name_in_vendors("LENOVO"))
 		tp->vendor = PCI_VENDOR_ID_LENOVO;
+	else if (dmi_name_in_vendors("NEC"))
+		tp->vendor = PCI_VENDOR_ID_LENOVO;
 	else
 		return 0;
 
-- 
2.39.5

