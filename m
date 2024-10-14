Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEFB1C231D;
	Mon, 14 Oct 2024 15:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918929; cv=none; b=s3GuTGIrbJbjzSKhjcJBdtDkSYaDHA5p0uqItG3yi967lJf2ZiIsKQ7LF8oqGboatupT/AtRs0vMQIxcL/Xbn6fvqVn+wpCnG/0dUZ2HXOYypHiFbbRCqL1jyD6BIFNIPNHErEunm1bB2JQX+8dnk601YkuFP8fMDE3UA0gdA0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918929; c=relaxed/simple;
	bh=IBCLFLFQ0jYtEQCXWOHFCzp0lMUcTDMEWuucEODjO30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDOW0yTRULv9RBgZTJ5Oo9XCoIEq1lAXBdsQSxZ+NtoCW1EoPF9mVsRYjpzQGSBcrOcllcyex1nZpYWwVT8olXr4CSI7nHbLbd7WdgcvZ8A4vXpLNOpE+dI2jObEQ7+ulbOL9dzutUDB11p16FEA5MHOutJOyNBZNRiSJbJsM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gviklQWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gviklQWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4F1C4CEC3;
	Mon, 14 Oct 2024 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918929;
	bh=IBCLFLFQ0jYtEQCXWOHFCzp0lMUcTDMEWuucEODjO30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gviklQWrpKQQhf4kMJTOWlJow2AZX2QYm1dzITo3omvsas4BgyYeCTqgPkxE9pSCL
	 mzMXXHTMvH85h8ZmmSySdtAvqBwBXE1kS3QpfpV5r4UBMMP43x+M3n9bhXxgjjOs6I
	 BpLrc0B27fzA0xz7Mxvjv9e+kPtNDBam2AFm0KfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 432/798] ACPI: video: Add force_vendor quirk for Panasonic Toughbook CF-18
Date: Mon, 14 Oct 2024 16:16:26 +0200
Message-ID: <20241014141234.932479429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eb7b0f12e13ba99e64e3a690c2166895ed63b437 ]

The Panasonic Toughbook CF-18 advertises both native and vendor backlight
control interfaces. But only the vendor one actually works.

acpi_video_get_backlight_type() will pick the non working native backlight
by default, add a quirk to select the working vendor backlight instead.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240907124419.21195-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 60b0128a10e86..f7a2ab62c6c20 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -258,6 +258,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "PCG-FRV35"),
 		},
 	},
+	{
+	 .callback = video_detect_force_vendor,
+	 /* Panasonic Toughbook CF-18 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Matsushita Electric Industrial"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
+		},
+	},
 
 	/*
 	 * Toshiba models with Transflective display, these need to use
-- 
2.43.0



