Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38014C97;
	Tue, 11 Nov 2025 00:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822481; cv=none; b=MYEquFxUt+F6YRSIvJB6uqZPF+CTXRtAbuHDvjOpoaPmuMLCHr/nigbw50BsR2IwuS2Plc8fKGb2HS9XS/WtfUzU8/4uglmHdoTsJOSPmdNTVK5Fq2ZEAcS61ahjlZbiJ0CmVzWR6BMPZrv675zbA5Pr30CO8VbaHrr9mr/Ho4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822481; c=relaxed/simple;
	bh=MKpuEWu5/CpJ258NqHWl/tfmz8jUOYPUxODUVK8fCEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoAGPzyOxIHHo04d223ednTD0X/lEWrtyXjAZm6gvybyjSgtL/mgsA7iQCCgTHKgGki+IoCbuEB6fcihpJ078QDjREjoEUcPYU+oaY+CTBknC9xV0JFkdFpkZCbbDglxUPQWXbLmkIFXT3lnyJOH4BGLIH/XxWCzsVV09HpJJrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8AFX/Bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8AFX/Bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D67C116B1;
	Tue, 11 Nov 2025 00:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822481;
	bh=MKpuEWu5/CpJ258NqHWl/tfmz8jUOYPUxODUVK8fCEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8AFX/BszbY+80xBm37leC6Q/rTxl8eAOGkQwM13/I/hl2FiQFehp4lYcwWhG8CKQ
	 BxRxiRFybLQNrQjWhseZfjnwusxXM4fqY5HJvKQH4baP0yPDaXU4rbjKuMJJjJLgNc
	 tCF2WJ0Vmv/9l4+TgzMrGtaJE7i7iQXHDxRJ3fI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Heijligen <thomas.heijligen@secunet.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Michael Brunner <Michael.Brunner@jumptec.com>
Subject: [PATCH 6.17 116/849] mfd: kempld: Switch back to earlier ->init() behavior
Date: Tue, 11 Nov 2025 09:34:46 +0900
Message-ID: <20251111004539.203484328@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heijligen, Thomas <thomas.heijligen@secunet.com>

commit 309e65d151ab9be1e7b01d822880cd8c4e611dff upstream.

Commit 9e36775c22c7 ("mfd: kempld: Remove custom DMI matching code")
removes the ability to load the driver if no matching system DMI data
is found. Before this commit the driver could be loaded using
alternative methods such as ACPI or `force_device_id` in the absence
of a matching system DMI entry.

Restore this ability while keeping the refactored
`platform_device_info` table.

Signed-off-by: Thomas Heijligen <thomas.heijligen@secunet.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/7d2c7e92253d851194a781720051536cca2722b8.camel@secunet.com
Signed-off-by: Lee Jones <lee@kernel.org>
Cc: Michael Brunner <Michael.Brunner@jumptec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/kempld-core.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- a/drivers/mfd/kempld-core.c
+++ b/drivers/mfd/kempld-core.c
@@ -779,22 +779,26 @@ MODULE_DEVICE_TABLE(dmi, kempld_dmi_tabl
 static int __init kempld_init(void)
 {
 	const struct dmi_system_id *id;
-	int ret = -ENODEV;
 
-	for (id = dmi_first_match(kempld_dmi_table); id; id = dmi_first_match(id + 1)) {
-		/* Check, if user asked for the exact device ID match */
-		if (force_device_id[0] && !strstr(id->ident, force_device_id))
-			continue;
-
-		ret = kempld_create_platform_device(&kempld_platform_data_generic);
-		if (ret)
-			continue;
-
-		break;
+	/*
+	 * This custom DMI iteration allows the driver to be initialized in three ways:
+	 * - When a forced_device_id string matches any ident in the kempld_dmi_table,
+	 *   regardless of whether the DMI device is present in the system dmi table.
+	 * - When a matching entry is present in the DMI system tabe.
+	 * - Through alternative mechanisms like ACPI.
+	 */
+	if (force_device_id[0]) {
+		for (id = kempld_dmi_table; id->matches[0].slot != DMI_NONE; id++)
+			if (strstr(id->ident, force_device_id))
+				if (!kempld_create_platform_device(&kempld_platform_data_generic))
+					break;
+		if (id->matches[0].slot == DMI_NONE)
+			return -ENODEV;
+	} else {
+		for (id = dmi_first_match(kempld_dmi_table); id; id = dmi_first_match(id+1))
+			if (kempld_create_platform_device(&kempld_platform_data_generic))
+				break;
 	}
-	if (ret)
-		return ret;
-
 	return platform_driver_register(&kempld_driver);
 }
 


