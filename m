Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180C843B6FD;
	Tue, 21 Jul 2026 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667788; cv=none; b=iL/WGTYuOHE8LAjs0Hg8JR+P5oPqPelb33Cno//H4afQ03/RwTrzbZYQPI2UA7QV/ch21FIB6MDI8dKU7T8qFwWPysKc5UEgZFpSQZqhwuxOhvnbFAeoE+IUyIoqIod6rd03kDeZq1d9GJNE/BKiV6iCHZMIhSB1m6FHa0OJgW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667788; c=relaxed/simple;
	bh=092hM5afSKsod356i40oJEcVBDZBMhN8KntLqU68ARA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buSxgPE7HiDukFoeMXjlT4Y9uzLcWGw32Xc91moPv91UbuVKfJovN9Dg/d5K3Vaybgs/CJ52NSmObm7PLTdqYHnVuD2mFXfXZWCx+eYRPMOlzEYcqKcXiS3cbMdm2D3sSZIS9F/31nPrfq1WTr7ouX60djYL9reqOekm4wR6pK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=is2itl4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="is2itl4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2781F00A3D;
	Tue, 21 Jul 2026 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667779;
	bh=Z1T9JSO8NHafdjjDR6r+f8EegYhHVAAENsT+zU0H/u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=is2itl4mlCm4j6+wY11QCzQVO+ltJwv/JAuTbJq/zlvKT3s5HdEgqUAiqXukvtCcr
	 PboCx/1EPKz2eeos9Rab2dD5SH9aPMo9+MsKR7tdM/GqQiU/N4Pure66/qgu+Yfb2D
	 Wdcxvi0iMzy7UEAYKEmxq0L/YL+4GAxDJygtiawg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1153/1266] ACPI: NFIT: core: Use devm_acpi_install_notify_handler()
Date: Tue, 21 Jul 2026 17:26:30 +0200
Message-ID: <20260721152507.583140136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
 drivers/acpi/nfit/core.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3298,14 +3298,6 @@ static void acpi_nfit_notify(acpi_handle
 	device_unlock(&adev->dev);
 }
 
-static void acpi_nfit_remove_notify_handler(void *data)
-{
-	struct acpi_device *adev = data;
-
-	acpi_dev_remove_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-				       acpi_nfit_notify);
-}
-
 void acpi_nfit_shutdown(void *data)
 {
 	struct acpi_nfit_desc *acpi_desc = data;
@@ -3350,13 +3342,8 @@ static int acpi_nfit_add(struct acpi_dev
 	acpi_size sz;
 	int rc = 0;
 
-	rc = acpi_dev_install_notify_handler(adev, ACPI_DEVICE_NOTIFY,
-					     acpi_nfit_notify);
-	if (rc)
-		return rc;
-
-	rc = devm_add_action_or_reset(dev, acpi_nfit_remove_notify_handler,
-					adev);
+	rc = devm_acpi_install_notify_handler(dev, ACPI_DEVICE_NOTIFY,
+					      acpi_nfit_notify);
 	if (rc)
 		return rc;
 


