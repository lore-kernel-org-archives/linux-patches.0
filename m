Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA58478E36;
	Sat, 12 Sep 2026 12:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217595; cv=none; b=QeRfWsGFB9dp6RixPSEL7459ENoXalsur1ha790oKu0gL9UF1oYpfRqWzkss+rQEC6E3arBAoyHsZTNMotYo6bXR8+lObdsGYQFMWHXXU67cDfM63XYbfoC+Q4n5CuTc9nFEFiBj/2g6UfNF/XaKyaHYz3WdB7gz4noQMEOkz44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217595; c=relaxed/simple;
	bh=UsZCbIypJk7YFrobAlM6O9MbE2xiQve6TvO/VIvmMA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQ4CxAPzOcMCxguX91ZKePNKVCP7kn7nFL2xQNUohPKYvLXrpEMcu42AKGy/atm1kg5ebEBf9Xv3EQWWbv4ke3kg6/LjklQLgEBSfQ10uakSk6zfPl1mNcEiRxQJKx/D7HCCEu+CWiXnDcP0kRje+J8SN99J0F+zUNHOXXJFbyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lgk6wbF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lgk6wbF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006A51F000FF;
	Sat, 12 Sep 2026 12:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217593;
	bh=ihg62mlCv2xWyYvgrGrKgLht1Qdlqlj9SbWPp9ywoIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lgk6wbF8afk5zy9ul9+jBjBi93N2ZsW/4v9+uX5yJkNEj2uM0W+1nJGVM4u+wQ6gt
	 k/GyXVijUg0+rq732h6fEqZ1FXue5UkKB9/Rs9BJfXPdCkyxZ5Q+hJ5pDmrbsV9WVN
	 t0Z6jlDZtm7qbxFXFvBSelvvl8s1yIPvagztrPtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0963/1376] ACPI: video: Release PCI device reference after lookup
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065629.022628787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 3d7ed9b8ef47b8bcae1fc3e12f7590a217862a89 ]

video_detect_portege_r100() uses pci_get_device() only as a boolean
check for the Trident CyberBlade XP4m32 device. pci_get_device() takes a
reference on a matching PCI device, but the callback returns without
releasing it.

Drop the reference after selecting the vendor backlight quirk so the PCI
device can be released normally.

Fixes: 35a341c9b25d ("ACPI: video: Add acpi_backlight=vendor quirk for Toshiba Portégé R100")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260807015734.913361-1-dbgh9129@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 2c120ade8f51a..2a562cb425081 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -137,8 +137,10 @@ static int video_detect_portege_r100(const struct dmi_system_id *d)
 	struct pci_dev *dev;
 	/* Search for Trident CyberBlade XP4m32 to confirm Portégé R100 */
 	dev = pci_get_device(PCI_VENDOR_ID_TRIDENT, 0x2100, NULL);
-	if (dev)
+	if (dev) {
 		acpi_backlight_dmi = acpi_backlight_vendor;
+		pci_dev_put(dev);
+	}
 	return 0;
 }
 
-- 
2.53.0



