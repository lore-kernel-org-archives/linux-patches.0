Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AA41D0164;
	Wed,  2 Oct 2024 13:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876916; cv=none; b=H2tXLznqFuRdUyTg+5AIcMpsgmYxcHRGN36nUWekBcomuoyaCBxfYu58880KpfyFZF3oyFgWBg2hbUTlzLy++GwQ/psUfyKDNIljOQ3zdpLF1T5xPoJBlZILra9GyTgQMm9wWOh05NIPeaoQEggOrSb0G3A3xam/6jXUgDYaors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876916; c=relaxed/simple;
	bh=AKgrMY8GDJgJ0x10Lld8lJkhLijcfXK1nMSmwcS/OIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PiKpxVVXNwsGoMxb4lh/eb01GU/jexfTkneI5NKuUprcJ/WZP4DW+Zh8oYkkJtseQedOm1HFZctpUAVoAn5fyvXBMREnrONLwbzPgEeFdGewIkoEZxwNvN7o7FagzAHIPRvAmvevc9QZiFkxhWuLXPxF/PHDiDYzbVc8pTA66P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5eKpOt8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5eKpOt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC4C4CEC2;
	Wed,  2 Oct 2024 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876915;
	bh=AKgrMY8GDJgJ0x10Lld8lJkhLijcfXK1nMSmwcS/OIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5eKpOt81uNElCvR9sw4ivgBr7JvVDenhEE/AUGXSOuO32FQA6wQQKaSEhgsEcmSz
	 2eELxedPgU4VqDEiSmjBM3mPDVVYZ+ke5McBr8IvARyICwDMWgqV8ZIpQbuILAfSRY
	 qvZDG+3TV/8WIuEuf7VLIIdyRLjnr8V28WCFLwCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 604/695] ACPI: sysfs: validate return type of _STR method
Date: Wed,  2 Oct 2024 15:00:02 +0200
Message-ID: <20241002125846.623981762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 4bb1e7d027413835b086aed35bc3f0713bc0f72b upstream.

Only buffer objects are valid return values of _STR.

If something else is returned description_show() will access invalid
memory.

Fixes: d1efe3c324ea ("ACPI: Add new sysfs interface to export device description")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20240709-acpi-sysfs-groups-v2-1-058ab0667fa8@weissschuh.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/device_sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -540,8 +540,9 @@ int acpi_device_setup_files(struct acpi_
 	 * If device has _STR, 'description' file is created
 	 */
 	if (acpi_has_method(dev->handle, "_STR")) {
-		status = acpi_evaluate_object(dev->handle, "_STR",
-					NULL, &buffer);
+		status = acpi_evaluate_object_typed(dev->handle, "_STR",
+						    NULL, &buffer,
+						    ACPI_TYPE_BUFFER);
 		if (ACPI_FAILURE(status))
 			buffer.pointer = NULL;
 		dev->pnp.str_obj = buffer.pointer;


