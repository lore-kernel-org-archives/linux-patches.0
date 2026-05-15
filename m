Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3921530569C;
	Fri, 15 May 2026 16:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860973; cv=none; b=qPwSjvBlFlpM+LmfJoX2h4PZeyZuJYsu90gp+ZRXxZOIuUBleKyo1okWSiLovdp8iyKiXd7k08+MjlzL9/dVaFUqo8Hsc4iM+gUQkTB4C38ZJadFjBenSIywa/zzBs3reO/6uPLrwlzyTOEfTK5q/4Y5eZiYmSEMTvVRnvZXy/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860973; c=relaxed/simple;
	bh=e34r+lI1mOB49XlUGKiU8IAs6mgCil1gBBhxu/Xsns0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0PEi+eIKcUjf5AXo06A0cRT7e5y+xuW9alpvtO0V1rDqJcDvQ/pE/EBM2N62uNMKGQW/kp+SsF6JY3UdIBAO2XUm1ABOWXcBUx5bi9Squ9N2swBDE6EQGidg0c0kKwBf+EBNB7rOFY2F5DQpdkL8SzlDkQkgtQpNr7UDxSIKyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0k0HenJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0k0HenJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19ADC2BCB0;
	Fri, 15 May 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860973;
	bh=e34r+lI1mOB49XlUGKiU8IAs6mgCil1gBBhxu/Xsns0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0k0HenJYlj8qsBchAkGTotVAJeUCgNq1M8CvCY0Jt7FFMTGVaA+X0wqFQduJYSxDN
	 E0Qlg3DAT7xCWWiXilZOpSUmOIcK4z7q5PzfgLg8Gs9g8iN2pkQ3J1T0ShH5m5zDm3
	 gVcP4grl3Djj0Jw4EsF343O5DdtCFglFsWgzn3/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 6.6 149/474] ACPI: scan: Use acpi_dev_put() in object add error paths
Date: Fri, 15 May 2026 17:44:18 +0200
Message-ID: <20260515154718.251258845@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -986,7 +986,7 @@ struct acpi_device *acpi_add_power_resou
 	return device;
 
  err:
-	acpi_release_power_resource(&device->dev);
+	acpi_dev_put(device);
 	return NULL;
 }
 
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1862,7 +1862,7 @@ static int acpi_add_single_object(struct
 		result = acpi_device_add(device);
 
 	if (result) {
-		acpi_device_release(&device->dev);
+		acpi_dev_put(device);
 		return result;
 	}
 


