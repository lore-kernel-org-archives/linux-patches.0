Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F023F1DE8A0;
	Tue,  8 Oct 2024 13:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393187; cv=none; b=o7yQdSGYGfr+5W3bzBrk+xAqE6j/f68qETF+YCUKMAS2cwaflkhrngljp9Ujm5E3/0GcBZ1zbP+q9fpw6hvI3y1sk402cd9A/9qOYcybHMRA8Yi59M0AZTxGHeiwSGQNX9FM1rIy1vTTCTlrrlDa8zT217+Rpfc062V79JJCbHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393187; c=relaxed/simple;
	bh=SrprZEYxNoSeSUG/1SJ7qBwmWrtzpgmCq1Y11gQ22hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df6jf8fPuli4FtAGcgzUk7FVvUlqS0JLZNwD7434DoKzKbn/3IIRuRobNJCpkj4gBSMd6d1rHhEqBolGgG7+lVy/2lVISQd3BpnbCm0jo516pjl6R8XCTB6dwDf4S3ylxTGyELE1UE3dSGD/R0G0LhJv+I576sD1s2Xh9/CZiBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSG5yNIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSG5yNIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599F6C4CEC7;
	Tue,  8 Oct 2024 13:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393186;
	bh=SrprZEYxNoSeSUG/1SJ7qBwmWrtzpgmCq1Y11gQ22hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSG5yNIOdvE/Q9+SV1lPpnu2CVfHQCfXsF+TLuBNghxeCnY08272itoiRx1iw9oQg
	 bTeaObeZDlNDTlZJ5PnoIvuQ+P8S4Q3k/sKlsHUquzLYbsrQOemM4RbX6ahqC1/v9M
	 boKgf7FtCPPIPv1Qv8AHdIMGSIpvaxZVbeC4V+N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/386] ACPI: video: Add force_vendor quirk for Panasonic Toughbook CF-18
Date: Tue,  8 Oct 2024 14:05:23 +0200
Message-ID: <20241008115632.531460183@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16ab2d9ef67f3..e96afb1622f95 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -260,6 +260,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
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



