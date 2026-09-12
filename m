Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD91D3D566E;
	Sat, 12 Sep 2026 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225036; cv=none; b=Cde2x6HeclkI0q2sbsXj1NO2zKSBjSLb2L/0lzDK/G+8bK4oM48syT+iQHYNjA5kqmJas2r3PoGedrQ0z5YGLQYUT6CdegLzhEOvfIzQPx1Gh6ngu9DPbI1IryEuxcdGtuPtsJxhDIh02aK2AJYAl1VfHiEIXpDBUrcAfXUvx5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225036; c=relaxed/simple;
	bh=3xVlmv+A8hajO5+QDRfh1Iv9mAxlsQwvffrgCBJBOCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlNfz74qYDqdB44JZnM6KI/MjSDRWog4H3/tq+pygtioa0bTGwU4kK2GgirgVujDCqVqT4GxJmTQja7nHgQTNnCygVJcsV9xK2ghPXFiTDTGPXvZwQGXMzaiSzDijJCJ1v0jHNFi/OKZbdHsN+N9kzduGvcl7lPcuQtoi7zqU74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DzkxKQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DzkxKQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7249E1F00893;
	Sat, 12 Sep 2026 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225034;
	bh=OWIQBgrtD25m68XBsAFwJ8vYIpZ+ZB5kbJ8Uigv7rSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DzkxKQLamQmPrlzQBBJUBwp2WjCN068qu0ch7CFZaMRskLWuO0AuRj3XvbPQXMuT
	 NWlf4QTtuq8r8/HCKOhwnZqC4pa+md4Gll+6IMp0K0qriYo/25BF0YpCik7T0st9Gz
	 g+k/PaNnuiIXeomcAhHvdBi/dz8FP0nCG0uS1XK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1116/1424] ACPI: video: Release PCI device reference after lookup
Date: Sat, 12 Sep 2026 08:59:08 +0200
Message-ID: <20260912065632.294829902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 962720aafedab..886b7affd4366 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -135,8 +135,10 @@ static int video_detect_portege_r100(const struct dmi_system_id *d)
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



