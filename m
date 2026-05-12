Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E503CE0A4;
	Tue, 12 May 2026 17:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607730; cv=none; b=EQ4PdL/rFxd2irkVtTmS8NkFROZ/k1wAGlO8h7M+nl2ykJUYPuRuO1eNK3N3LW/5jHpK1PaB5kQxdF+3r2hKHuoT1j6gLRRhHdBy1Oacv907qcv+PyAXF22g2w4Las7kkfYceHx6nAtM8xSH04KpK0r/qGuRbgV14Ie0GumYi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607730; c=relaxed/simple;
	bh=JxhVupe8++98lk8x/dbrd4XSLkAy7XfSLPk1BnmzMAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjtItrYsCvIprmBKjZtmH85/bsqacqCDzznG66zqNBIioQhgAY3VXr7qm/kZO6rRpWlRvYl6sbCeUC9pGqidPcLc8BUpGucI8bYQiYrpCq+7XF7Gq2O9c+1t/sXoJgaa5avDnaJw87U/PN2D1sj82N55KAwU7L9xhwKXBaffHoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsW7Mi2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsW7Mi2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC50C2BCB0;
	Tue, 12 May 2026 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607730;
	bh=JxhVupe8++98lk8x/dbrd4XSLkAy7XfSLPk1BnmzMAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsW7Mi2R4ZsLEgzK4T5vsHzEG+EUU0PsgWqR5qrLimXpHM4KHW2t75bkZfWcWr8/s
	 pExGRfHrzfXZi6g/a2Cw0Zwyvp4c3pClTXbjOI0scxfN5uxyXIkgP1i14mLOzv/KxT
	 rwDRLZaiCmGbAmXWLmE865yxcP2EOyzaB9TltrtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 6.12 006/206] ACPI: scan: Use acpi_dev_put() in object add error paths
Date: Tue, 12 May 2026 19:37:38 +0200
Message-ID: <20260512173932.952505236@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1914,7 +1914,7 @@ static int acpi_add_single_object(struct
 		result = acpi_device_add(device);
 
 	if (result) {
-		acpi_device_release(&device->dev);
+		acpi_dev_put(device);
 		return result;
 	}
 


