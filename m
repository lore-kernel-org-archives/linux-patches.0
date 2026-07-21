Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F53647127A;
	Tue, 21 Jul 2026 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659437; cv=none; b=sKHgHDjxV4G9lqb1IEz4sfHLmDZ+hXq+3v5Nzrb5p89NthbSRTS7G9VrY9Yr3vF2p2bfWwBXl10dSGJK+2PZM+pvBfquL+0R2ti5CM5EMHk2BAdyG2oGyLzpXZmYT+Znw81IfWxNmvNDAxcUSmlxmICnGMANuLQ7aN9nHHvmIBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659437; c=relaxed/simple;
	bh=U8q7qhVZuKDlkR+pKb9RIRT64Z7vc9Rco/fb7dsTFEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phEMwgn3qepmhu0WQHPK53fDvxbeHbJIX/l/VCAWadiuQJA59stN4E4D+YfYTG6t9QSwwv0ARtP8SZ1IREw6FZvvKZnRHsvYG02pvGBVsopABEvi/Sxncu5VkB8Fp37eiyqJNFwjNTStQltdO0oPliaC6BJri48pOrnTsGGNqsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZXKIEaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZXKIEaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856E21F00A3E;
	Tue, 21 Jul 2026 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659436;
	bh=JmJZehkiXBRlwTOx+3/Y61HpdghEEtpeXfvXEsycMAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZXKIEaV/0Rr4bRfB8M7gH+l6KnO1KrCi458ISA5Qq5fpdHx3OclL91CwCzsw0tJM
	 u2MY+I3fzIjt4z+HHbxGDBqbxixXNQxmPTeedxF4RSvXEUQ/fHmDMfWVXYu9ip+6Tg
	 oV9QFa3Ep7a1jM5X1zlYuKtBVb5Rs58Wg6dnqwAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1519/1611] ACPI: NFIT: core: Use devm_acpi_install_notify_handler()
Date: Tue, 21 Jul 2026 17:27:15 +0200
Message-ID: <20260721152549.611449347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


