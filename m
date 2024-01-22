Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC9212A17F;
	Tue, 23 Jan 2024 00:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968793; cv=none; b=Kyn9dCe7AiZ7tz8XXH6Ojeg9owJH/tbaO7mMlVa2ESrnLMqa/aIHrd+u6/LLkcJWCllhrgeGNyfefw/FwaX8gFNm9tsMjF5ncyvjiT6h9viVRG9i2k7PnykOgZ9+1peoSDIAIxMRFfZ3xOMrvhPNPzCQ0qXCmQs1l4QdHRYjpxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968793; c=relaxed/simple;
	bh=T9vbUkcq99ai/jvmvMIdljL6ED2kcry9zBwg6LEzaxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=key/VBcrb6nftzXy1wNfi0MBliD4izjH8PsDv2xNzrCRpzKod+zbPlQnskWv+2s5h+hQygpG+8zV+TwT5xDgenHz1tJSYsTJ35FcQ5/ib2Yatp92XJA3622pSGAs3KO1zGHJwJXYnfAtoKl1N2uctfS6+/TzfBf6g8+SixLnnT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDnNBsIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDnNBsIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47943C433F1;
	Tue, 23 Jan 2024 00:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968793;
	bh=T9vbUkcq99ai/jvmvMIdljL6ED2kcry9zBwg6LEzaxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDnNBsIeC/kZx+2y1gC6eewe3AuomfYp6NUA0wDywasnipFLcuWVHoNxD/tPxfhsr
	 Azkfe8Ya5ORW1Mdd71x4Mk564VST+kfdiu6ah/AtSr01de7PJE3UUKOU27l+E6INV0
	 4XBKT2hoVc/eYgxK7mLnuvz9msGfDV07bOPh7CDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/194] ACPI: video: check for error while searching for backlight device parent
Date: Mon, 22 Jan 2024 15:56:22 -0800
Message-ID: <20240122235721.433479808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bf18efd49a25..9648ec76de2b 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1784,12 +1784,12 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
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



