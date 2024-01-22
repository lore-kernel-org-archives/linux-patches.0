Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B67B610E;
	Tue, 23 Jan 2024 01:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974065; cv=none; b=tzvhd0fgJw/lNDgzidaFFwoOygr0KAheG0HcX2k7c0mP2RFSYyH5ULbv5t4aHmO4iOmkfWpyY28IirzYSd6mnGZmNV8fgTn30ByOTxBJ1zGI7flWLKWoqTB3urbT9MNvLleqdny4x0BZfJbDiSQt9s6ZRVNApmSu/HySNzdz5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974065; c=relaxed/simple;
	bh=bB8etuSfJOHJ8ANnRcX0mfmSwFeUGFf942wtyMiNyf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3CIEgabiYLFlsGggoS3xw4sA9QPk88T9rTTFrYEFEcIG1BKhA+rK3i/jfD0nI6KZRVn0ELN4P/d6mHFigOW2nLOigudE2kTO7TugHlNLxd3msnAIPPIX5Km8DvGEnW9lFImkTToSrsmcC79s1Wrf768U4/AbWj7YSV6CrryVJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIG9tXln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIG9tXln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F48C43390;
	Tue, 23 Jan 2024 01:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974065;
	bh=bB8etuSfJOHJ8ANnRcX0mfmSwFeUGFf942wtyMiNyf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIG9tXlnD8aK2J5ZrjKzjqqAFjwxo+i5BM0Saq0mS6SDDRV8zrXg8PduRP/Jr37q4
	 SffoEa2KkjWnzh3laS6UKV6e5oxSaS8g6Ei1fXqmf+zyDqJaEJ03vluTpU9TD907Zc
	 ISuE8fcA9FBWL866xGdNvSn6/jvYgSjFhgm/f62w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/583] ACPI: video: check for error while searching for backlight device parent
Date: Mon, 22 Jan 2024 15:51:15 -0800
Message-ID: <20240122235812.939684951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 35f071ad9532..27a6ae89f13a 100644
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



