Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0808B41BA94;
	Sat, 12 Sep 2026 08:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202468; cv=none; b=OOeM86i9B1Ae72jGxfOco6svGLWi1Wygw25z/4/9/1FcVpUCVh+EuyPlnLX8D+MFcEqEOcv5LlDKsCn3TiMkXwLi3S++b9XewzEMs3cq7ZH0QnxoTumfFPaYlvAKrMyI1mdWaPwqyj/k0knMsudmrXzgAqEZkOkOPr3PJxT+VIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202468; c=relaxed/simple;
	bh=osa/EGvIY0pVzo5KbBUu8fD5yYa5m1KQ9+BstqVyX+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1Y6NlCA/uJsv4xmkKbkaoM+Ux8rQc2unOKsj/D1H2SQHDHJGT1d/IZ9L13N/1ioM+wPmDdBGKBKtfjgmSqHc9ySYOTmNmymo3+NCqZsJVyk+u46jYHA5miZoG7LiZ4WyExhOjnIOa2iSDBnwQsmNMjFhY/FqHy0ePE5gDTIO3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6nrrNXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6nrrNXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04C61F000FF;
	Sat, 12 Sep 2026 08:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202466;
	bh=RV8BajK8CWYUei+6weDch4C2ndt/QlILbqPIm1x6UdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6nrrNXopF6T5OB7Ce8IlBhN37nkCPT/TJz/I/F/JPo6uiljRYYFEeDMipQPzXYt8
	 o4CvuWqtI0bGM4bl4WZzdCZ6gVIdjncC8YnlMHi5UlMdR4i19pK+NWuh1rs9zNQ53K
	 lNSYJe0WwXEoWR+xE3tRavqPYE9aYyizSN6bfhMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1209/1815] ACPI: video: Release PCI device reference after lookup
Date: Sat, 12 Sep 2026 08:49:19 +0200
Message-ID: <20260912065717.389187504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 458efa4fe9d4b..4c1c3b0b5499d 100644
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



