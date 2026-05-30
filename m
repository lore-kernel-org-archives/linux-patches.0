Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0483A3546EA;
	Sat, 30 May 2026 17:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163496; cv=none; b=fqoc+9JhU6GF1AlRHymLPj2wMYKKPfMqtkOO382vcwigJ4aNC1aEIIGf7XRpqhgf0BfOTbBa18AqLJDr+ilG2WKAQhSn6DaovexUBMWK+OM2EyWm6XOwgiQ4LKq0uJra0elfWfzXqSYoJTjbPN8bcs750Ba5HfqwQw2oODRV7EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163496; c=relaxed/simple;
	bh=1TbaBIseIyDm8WTB0abjA2BdkGjWcl5f95jm3shkgQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jisx9KfdUpd+OMb+mME3RhrRX3lquI8QnbBX+JfNZdcxRT3QR2QeQSDjrvxqcXspDjpJkyR4pwHB1U/oTQIWRdp0pDj7RKC/hrbl+HW3TvDZQsbHu/0JD1MCOUsRjmpkUDinwiBTrRcMJn6p+CkxaulH7HTHNrSXyeV+ouo5R1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgiok1XW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgiok1XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3FC1F00893;
	Sat, 30 May 2026 17:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163494;
	bh=inbFKaHwdozIdJAg/kSPSc/JOSNBBUNI+zEedzObAr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgiok1XWXULcXVi6cNujGEyQif2QSMqguWDDZxndO4dHnBOa3scufWD2FxOsaaJTr
	 R+Vz8o3Jxn/AmqdJjvw/H5tnuaAgxyUsDVO1csCPlCh3zmoezagDAhhHrlZmV7xs7j
	 vunjsDKy/UDWuLqjd1+6SLJQb+ekbzcBvnFvEcSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 5.15 276/776] ACPI: scan: Use acpi_dev_put() in object add error paths
Date: Sat, 30 May 2026 17:59:50 +0200
Message-ID: <20260530160247.692839612@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 9c0acc169ac71535477caedea8315f7041c5f07c upstream.

After acpi_init_device_object(), the lifetime of struct acpi_device is
managed by the driver core through reference counting.

Both acpi_add_power_resource() and acpi_add_single_object() call
acpi_init_device_object() and then invoke acpi_device_add(). If that
fails, their error paths call the release callback directly instead of
dropping the device reference through acpi_dev_put().

This bypasses the normal device lifetime rules and frees the object
without releasing the reference acquired by device_initialize(), which
may lead to a refcount leak.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix both error paths by using acpi_dev_put() and let the release
callback handle the final cleanup.

Fixes: 781d737c7466 ("ACPI: Drop power resources driver")
Fixes: 718fb0de8ff88 ("ACPI: fix NULL bug for HID/UID string")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260413135343.2884481-1-lgs201920130244@gmail.com
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/power.c |    2 +-
 drivers/acpi/scan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -962,7 +962,7 @@ struct acpi_device *acpi_add_power_resou
 	return device;
 
  err:
-	acpi_release_power_resource(&device->dev);
+	acpi_dev_put(device);
 	return NULL;
 }
 
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1824,7 +1824,7 @@ static int acpi_add_single_object(struct
 		result = __acpi_device_add(device, acpi_device_release);
 
 	if (result) {
-		acpi_device_release(&device->dev);
+		acpi_dev_put(device);
 		return result;
 	}
 


