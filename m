Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF2813B2B4;
	Tue, 27 Feb 2024 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042928; cv=none; b=m18pqrcbZaSx7cVUql64ZSEL5ms6SsV+6x9UfXEEm+ZZbyBMybSv9AYwfFNTKYEJoj8LQ8DmbteIHDS8Tl0/KdyHyQM94nwxO5SIDhoebI13Ptkf+YOyI8HxJsPmJAhOsM3DFmN8YffputAJscptlm0U+MZMi+CVfRww1BmY36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042928; c=relaxed/simple;
	bh=Q2NEeazL2S9N1HXelfLF6qRFTMux5eO8FYhJ5pA1CeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjITaiDJc5jWIYh37rLRlpvX0mnkP8OY1ujDi+CaMJu2NnN+JRhKAtzoO8olmkmM413wSf8NYBabV1Inogn5P6e9IRyXAXKPC+r3stuaYDADD/x0kXLoSMUqqYZwvZkaRXxzVFY/frcJNpK0mNVgJYDiEHrr/toxLigIQYG627Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7pzyGi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7pzyGi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1B0C433C7;
	Tue, 27 Feb 2024 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042928;
	bh=Q2NEeazL2S9N1HXelfLF6qRFTMux5eO8FYhJ5pA1CeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7pzyGi0q0Yout1cbtcka0vYjxPWM2shk9sJ2VxufAezbFzmSxr6ruU+gg8Dagfwp
	 PQ1NMB9rpWvMt7j5KZebCnsJu92JrmTfSBYIzpipcb/0sOGjDtuKd2X112+FNBai/p
	 YZDP65mKODZRIwZS5E4iyscLb43/Mx2kCFVILdaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/245] ACPI: button: Add lid disable DMI quirk for Nextbook Ares 8A
Date: Tue, 27 Feb 2024 14:25:59 +0100
Message-ID: <20240227131620.766578913@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4fd5556608bfa9c2bf276fc115ef04288331aded ]

The LID0 device on the Nextbook Ares 8A tablet always reports lid
closed causing userspace to suspend the device as soon as booting
is complete.

Add a DMI quirk to disable the broken lid functionality.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 1f9b9a4c38c7d..d8b1481141385 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -77,6 +77,15 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_DISABLED,
 	},
+	{
+		/* Nextbook Ares 8A tablet, _LID device always reports lid closed */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			DMI_MATCH(DMI_BIOS_VERSION, "M882"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_DISABLED,
+	},
 	{
 		/*
 		 * Lenovo Yoga 9 14ITL5, initial notification of the LID device
-- 
2.43.0



