Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CE0131E54;
	Tue, 23 Jan 2024 00:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969105; cv=none; b=oyFOeOnWP+TQjGMGxkGio9DQL//F3cXHApybf0IWQB0qdZzMaXJUKNH1zCY9L/L/LFh5vvEyGd2W0dJAt5NDTJE+CuDwc2iaRASotghRHNZxqL2DUSaoX0YJMT3MSTRdVCRIPoiA+g91DzncdDL9NvCJJ3KOHeFmjMkhPevlpk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969105; c=relaxed/simple;
	bh=SURP2AZK2ZVruFSey0w4wVwYBAJpcpmNu/AmAn1H8Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOfQVuRqtMXB4TwM430h4UqSN1fT/4o4vbC661wWYrE25n3zCEU/KfXWxpmHdMy+RhnQGGT3QsfT/XxcCQrGqqWmgKKXwBNPJr7HCK1QO7jj528/+l8mvKDp8sCQnJIdMqbgNxi+xVNoOVe1St+PoNZI3AlZLGkISPZg3T4uzMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPVuZhUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPVuZhUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DEC433C7;
	Tue, 23 Jan 2024 00:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969105;
	bh=SURP2AZK2ZVruFSey0w4wVwYBAJpcpmNu/AmAn1H8Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPVuZhUCWugQHEUrXbkNxEhWCRBDJDwKQm8le0zwEFzDkzEk8PWgCkMJdocMX/zGC
	 gbpliN4acdqSSLifBmKPVIPz9mWOsggOPNeCO6NUDddJeQjf+Nl/GFtCxEQatUgT/v
	 rdoBZg+JeHnPYtJiuSL+2v+AKVHvr1Whpj/qpS6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 024/641] ACPI: video: check for error while searching for backlight device parent
Date: Mon, 22 Jan 2024 15:48:48 -0800
Message-ID: <20240122235818.857660245@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Kiryushin <kiryushin@ancud.ru>

[ Upstream commit ccd45faf4973746c4f30ea41eec864e5cf191099 ]

If acpi_get_parent() called in acpi_video_dev_register_backlight()
fails, for example, because acpi_ut_acquire_mutex() fails inside
acpi_get_parent), this can lead to incorrect (uninitialized)
acpi_parent handle being passed to acpi_get_pci_dev() for detecting
the parent pci device.

Check acpi_get_parent() result and set parent device only in case of success.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9661e92c10a9 ("acpi: tie ACPI backlight devices to PCI devices if possible")
Signed-off-by: Nikita Kiryushin <kiryushin@ancud.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 6cee536c229a..375010e575d0 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1713,12 +1713,12 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
 		return;
 	count++;
 
-	acpi_get_parent(device->dev->handle, &acpi_parent);
-
-	pdev = acpi_get_pci_dev(acpi_parent);
-	if (pdev) {
-		parent = &pdev->dev;
-		pci_dev_put(pdev);
+	if (ACPI_SUCCESS(acpi_get_parent(device->dev->handle, &acpi_parent))) {
+		pdev = acpi_get_pci_dev(acpi_parent);
+		if (pdev) {
+			parent = &pdev->dev;
+			pci_dev_put(pdev);
+		}
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
-- 
2.43.0



