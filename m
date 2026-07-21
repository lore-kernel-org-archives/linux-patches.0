Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AD946EF8C;
	Tue, 21 Jul 2026 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664266; cv=none; b=jTW/uU8QIo3tEndy69Q9gR7fbPmeRR8UlpdXTshbX5xj35L0viWcdijH9URENwoJC73GQhvSA9ab/ulrXP3mwyJ8LFKjZRajCJFT8uUnqFQKKr6M4NjLTpKLkcdO6veAK9m+i5Ny6dnuUv+b8X6qPvN+dxPOP6i+UllJEll+ZN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664266; c=relaxed/simple;
	bh=jOBvqqSLZ2F48V3MeHhToNhX4FLgMibgpFE5tdAbpiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edtjSWyCu66fZUMQdE8tcI/Y/9nbhIvmi6TK6BeO0FVnxiaWXifGftgVb/N0gxHkILkbEbXT3kchv4t+bXYBh1bsdg6B5/+u4+guCGGwuP04Ld/+f7/yI971gl278DIxnOectX9aDP3cQ7HNzkvP4j+AC06OPKaJdudru2Akaj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMaRfZNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMaRfZNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FF11F000E9;
	Tue, 21 Jul 2026 20:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664265;
	bh=NtBISqKP0AuQqvxjp2yuMe/jwtvoCjVhfEcQdbntj5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMaRfZNtdmc+ZSh6sgvQ2cJOTaxuUN6BynXUjOnlQOOmB+b4LaU71srDV2d91oHvj
	 T5aoGw2JbAFD4C7k+1Yiqw79Ig5PSDwZ94ujOpQO1d6e548O9C5n1WxuLi/ja3E20U
	 sxkp5e2RX/uYnuSK2RDruTHZge2dSG/xTXcFBNNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1135/1276] ACPI: NFIT: core: Use devm_acpi_install_notify_handler()
Date: Tue, 21 Jul 2026 17:26:18 +0200
Message-ID: <20260721152511.396957815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 198541ad53c0d0d891fedea4098f9953a0f566c0 ]

Now that devm_acpi_install_notify_handler() is available, use it in
acpi_nfit_probe() instead of a custom devm action removing an ACPI
notify handler installed via acpi_dev_install_notify_handler().

Also drop the explicit ACPI_COMPANION() check against NULL that is
not necessary any more becuase devm_acpi_install_notify_handler()
carries out an equivalent check internally and use ACPI_HANDLE() to
retrieve the platform device's ACPI handle.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3048737.e9J7NaK4W3@rafael.j.wysocki
Stable-dep-of: 18a00ed0e718 ("ACPI: NFIT: core: Fix possible deadlock and missing notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3285,19 +3285,11 @@ static void acpi_nfit_put_table(void *ta
 
 static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
 {
-	struct acpi_device *adev = data;
+	struct device *dev = data;
 
-	device_lock(&adev->dev);
-	__acpi_nfit_notify(&adev->dev, handle, event);
-	device_unlock(&adev->dev);
-}
-
-static void acpi_nfit_remove_notify_handler(void *data)
-{
-	struct acpi_device *adev = data;
-
-	acpi_dev_remove_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-				       acpi_nfit_notify);
+	device_lock(dev);
+	__acpi_nfit_notify(dev, handle, event);
+	device_unlock(dev);
 }
 
 void acpi_nfit_shutdown(void *data)
@@ -3344,13 +3336,8 @@ static int acpi_nfit_add(struct acpi_dev
 	acpi_size sz;
 	int rc = 0;
 
-	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-					     acpi_nfit_notify, adev);
-	if (rc)
-		return rc;
-
-	rc = devm_add_action_or_reset(dev, acpi_nfit_remove_notify_handler,
-					adev);
+	rc = devm_acpi_install_notify_handler(dev, ACPI_DEVICE_NOTIFY,
+					      acpi_nfit_notify, dev);
 	if (rc)
 		return rc;
 
@@ -3381,7 +3368,7 @@ static int acpi_nfit_add(struct acpi_dev
 	acpi_desc->acpi_header = *tbl;
 
 	/* Evaluate _FIT and override with that if present */
-	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
+	status = acpi_evaluate_object(ACPI_HANDLE(dev), "_FIT", NULL, &buf);
 	if (ACPI_SUCCESS(status) && buf.length > 0) {
 		union acpi_object *obj = buf.pointer;
 


