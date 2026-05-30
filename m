Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE92D32BF24;
	Sat, 30 May 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160238; cv=none; b=kLVpQBpH/UOhJ7dG/ExuJ5erOogwcaORXDYVHySf09+X1SBgSHxmSuGEr/iumgWY4JD4VmsUaRzS0BC1AS/aT78fHWO66EXoLDcWAhlHo6oAhwXNxRMCkdVrdqk1a+1YJ+B1Zzrv7Z2nI7JzBEVlhtKx5cHuOBO1FpvTgtLAwJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160238; c=relaxed/simple;
	bh=6rCqa+D/FR26uYAWEQJaffvtmCQwjkl036F8UKqLN1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWbJL8hmL8CQRgL+PzaOC+jz84TbSfwlU89Ta2j3TNnVS3B0+uEMv32ZDcByGEPRpfCJsgf//8RVCS2OD6aJHDUF9ZWQ3kRv0Q5cstMa9Aj8zm29n+WCAkP7DoaFv1zwhX2LBzeoYQVE3kenW1SZvVUxD2CWuZyPTalGrl9FaYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OS/m/YUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OS/m/YUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8F21F00893;
	Sat, 30 May 2026 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160237;
	bh=ND7scoCqHgq0jqbppY7efFN57yg9CmDf9TFSRTlKlT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OS/m/YUJHq9/HF7mdGVzh/yVITANq+/Pf3zrPHxF+cAoN8E/rj1cNEhI2GnuwRuwg
	 50xdibB1MUxvK71BGWmpMiNB75GopjmQxxcF48l+WDQL06xSBWSTyLxdHk9CQbzu1N
	 gMcGZGVwG9Svj4YV4nMIyocTgby1cxHygs1VrMu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 6.1 284/969] ACPI: scan: Use acpi_dev_put() in object add error paths
Date: Sat, 30 May 2026 17:56:48 +0200
Message-ID: <20260530160308.306430130@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1856,7 +1856,7 @@ static int acpi_add_single_object(struct
 		result = acpi_device_add(device);
 
 	if (result) {
-		acpi_device_release(&device->dev);
+		acpi_dev_put(device);
 		return result;
 	}
 


