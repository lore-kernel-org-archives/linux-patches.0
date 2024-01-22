Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2E5B5DA;
	Tue, 23 Jan 2024 00:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970419; cv=none; b=aCdHLutLxvPknvggYjPzY6r6mJPbhWe9vW0tBPddi29dnwEgVMzGFicOjocIIOHRk4ofxwJXbwlZJRGlBsomRLhXJhq9tybuDJSqU+tueyiy25+uv5ssR5C6+ZK5/t+JLu40236XQlc0ZTFKmd8zUrEyjwxL8YT/46IG2MCV5QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970419; c=relaxed/simple;
	bh=PDxiIiL5dOhn0XAeREUrVO1jaePyZpOdeNQ23I5xqpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2jObs9zzYA+XJHXLnBQI5mzfbuEXfuCxJx3cB28Kl5adVGxMaXwacrDLpRYsyFBRVgoA0vnuleWOYPsfsPFFxIP5p2/SpsOgcaSv2tCFHGiUWUEhQl6fu2po16AWsphU02mnb682dd6CvBf7S+AhatsfK2TQ7QUiEOssanObss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6q702bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6q702bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B486DC433C7;
	Tue, 23 Jan 2024 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970418;
	bh=PDxiIiL5dOhn0XAeREUrVO1jaePyZpOdeNQ23I5xqpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6q702bz0TdMfSU/nLzSt9r5AAVVJVkYZyKr8FjHlGVRIndNuBzo5bE4MD5ddtqJi
	 q1X7jNSkt14BbvHR1L/G3c/NYaZze1Q/FzI5q2uaWSa50dRxAjwE9Q+2jJCOJ1noAR
	 Y8jxZ7CqtZ3vrKFWxF3iZLhYw1LR1HarYnbUyD1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/417] ACPI: video: check for error while searching for backlight device parent
Date: Mon, 22 Jan 2024 15:53:03 -0800
Message-ID: <20240122235752.042294174@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed318485eb19..f7852fb75ab3 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1726,12 +1726,12 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
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



