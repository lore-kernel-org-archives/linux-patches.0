Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2C67C0A5;
	Tue, 23 Jan 2024 00:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970984; cv=none; b=QiMQADoHh+ArZl/NVXXWpVYrU21py/FQFiF5nwVEQ5UC7uW8GqEP2nNUftuSMA0DY1lZ81sA7zrwVCeyHMaY0M4ieGk1tXVABbrIEmQdyoJjbUn2bh/rfOXKwdSCa57KFA3F9ELTJhNeeUYys9pjV8lo8I/QOxacOyN+X7QaIYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970984; c=relaxed/simple;
	bh=Z1e+5UNXgWhB5YLDb6homE/qGAby4SfPHRTv4yFD8/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8dLn00hmJ1qCehFxg7e+eQCdU1EA0XrFSjMQimbTNKBC/FDgaLS6p7mVPbe4AHuHRxalnrBfdGWgUKcdc8dylXc40sp2bb+BR+/qg+gigDSOCnaoRvtSo5WXx5GpvMgq2rAvJUkZtS5ye1QR2/QbGUGq0jmzde2p3KK9ZkVOYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK4jXnJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK4jXnJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D10AC433C7;
	Tue, 23 Jan 2024 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970984;
	bh=Z1e+5UNXgWhB5YLDb6homE/qGAby4SfPHRTv4yFD8/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KK4jXnJTkiO3Dzb7l/Di5wsL9Re8LaXE9G0sNfSNzsZaUHM8KFqiDpp1WEHyO1EM1
	 2IIbxbThMyqbCTzRwhmoIBAG0jsddw84+MgiCb3YM0AQ7rZ15vmHoi7iovgG7spKGX
	 e9VwQ5jUjxBUp5OlzzljW2MIC+BKB6ja7/gt3n58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/286] ACPI: video: check for error while searching for backlight device parent
Date: Mon, 22 Jan 2024 15:56:09 -0800
Message-ID: <20240122235734.454549166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cf6c9ffe04a2..9d384656323a 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1788,12 +1788,12 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
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



