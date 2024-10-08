Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B7E1DE2AE;
	Tue,  8 Oct 2024 13:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392691; cv=none; b=ZntMfoEqeUjmW+iswM0DuZ5cMDaJiOGnQayWoKrkWM0iPOJhPjm5kt2NDSfQV3kVAoaNBjrz64LPWlj6d4JCfho5f/e6ZQDy1frRi65ZqjvyYReERm60u40ZwmcJJqz2/AKt/PUg8Yh+53GME0YHuR2FXAAbQSq+5B+Cyr2daiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392691; c=relaxed/simple;
	bh=nuD1LVts31aq1YgfjNRvV8t8YOp/ElGz6XjH8tE4Eb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/McmYIfnm8SQciOGKTEMFFfgndE+xR2U0TzQrtZ4wO+N4bNizQaWc/0xKrD0WQxYVH3iegreaknD94eSg8E7oJNewIsrKdgZ7S5R5dWKxqzEiFExvXM1prfJjJjVYCop7+hZKPsUDHmHUXA454cjPtkpJ0NTCZU/4J9spNMuZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnZnhyxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnZnhyxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5374C4CEC7;
	Tue,  8 Oct 2024 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392691;
	bh=nuD1LVts31aq1YgfjNRvV8t8YOp/ElGz6XjH8tE4Eb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnZnhyxaO3Zy6KjCtElI5mvPEJW7277PfyuD8v+neunalvwDwRwzCraeoz8PAe60G
	 mJGVfbV6w/6Kq2Zhc6KjuSE0fovWMw+UITLFeae+p++x618pXw8iCe+GBeyyiuRpDo
	 DzVTNnzJyuftfSV3KkKSVo1ou5v9hRVcqnSmoN0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 491/558] ACPI: video: Add backlight=native quirk for Dell OptiPlex 5480 AIO
Date: Tue,  8 Oct 2024 14:08:41 +0200
Message-ID: <20241008115721.554622029@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit ac78288fe062b64e45a479eaae74aaaafcc8ecdd upstream.

Dell All In One (AIO) models released after 2017 may use a backlight
controller board connected to an UART.

In DSDT this uart port will be defined as:

   Name (_HID, "DELL0501")
   Name (_CID, EisaId ("PNP0501")

The Dell OptiPlex 5480 AIO has an ACPI device for one of its UARTs with
the above _HID + _CID. Loading the dell-uart-backlight driver fails with
the following errors:

[   18.261353] dell_uart_backlight serial0-0: Timed out waiting for response.
[   18.261356] dell_uart_backlight serial0-0: error -ETIMEDOUT: getting firmware version
[   18.261359] dell_uart_backlight serial0-0: probe with driver dell_uart_backlight failed with error -110

Indicating that there is no backlight controller board attached to
the UART, while the GPU's native backlight control method does work.

Add a quirk to use the GPU's native backlight control method on this model.

Fixes: cd8e468efb4f ("ACPI: video: Add Dell UART backlight controller detection")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240918153849.37221-1-hdegoede@redhat.com
[ rjw: Changelog edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -845,6 +845,15 @@ static const struct dmi_system_id video_
 	 * which need native backlight control nevertheless.
 	 */
 	{
+	 /* https://github.com/zabbly/linux/issues/26 */
+	 .callback = video_detect_force_native,
+	 /* Dell OptiPlex 5480 AIO */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 5480 AIO"),
+		},
+	},
+	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=2303936 */
 	 .callback = video_detect_force_native,
 	 /* Dell OptiPlex 7760 AIO */


