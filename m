Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504FC3CE495;
	Sat, 12 Sep 2026 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231145; cv=none; b=o7D0k5QHK9+XxRlBpjVUPfZ6Mo3dgtuGQD5So8+gIhs/hb1TSc9EpF0veCgtIDmsgpuueMBYVYwajQtTH/9Jn7IcBSu54schhkfigxRPM4O4KaT2h8Vd50D3hEj+T/1A1HJE9FhIJsdPQl2QYUO6r9/kYepmEcyrXz/n/WeFPJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231145; c=relaxed/simple;
	bh=fs7EojZC7nq8UbNZCR6zGDqB1OBaJ0Fiim8SUONyuN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UT/3Y63W0FS3YS0O5vb93ZAcgGDV66TTy9BnNIHqPIq4TTJ5zKg7z3AfNv3seZVFgu588AVgWpHefwJ2E+fu9Eku4LvfJZvVvKzQFTbbV8j+fBDG7uMH6F8wN6Cz1M/IfEQahKZt5nP+I78p95jhGOQuRohFjQFGgbRv/z4lmZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/FRsuTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/FRsuTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3294F1F000FF;
	Sat, 12 Sep 2026 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231141;
	bh=pYCy23tec0ftbuA7Cuvq9S/uttAIBeVhIZwzt6iO0jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/FRsuTQ7St0omLlQNlrQLdwr6yYYIFoBVT4smpJ9OutmhbeeUvvQ1rz7ssW5yZ7P
	 H1vbs5JeLKNmLsfFyyW6QI2Q8l2PA2Y5iChpBj9eTHFC82daUmflXaUrXvxnRfih2e
	 PelMp0ZbhxEx1RiSlzvXgkOdQITGfZeUcKL8o+i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0921/1191] ACPI: video: Release PCI device reference after lookup
Date: Sat, 12 Sep 2026 09:00:49 +0200
Message-ID: <20260912065608.919615772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3ccc790b5aeed..f6a6ed638767e 100644
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



