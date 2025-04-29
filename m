Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C639211A0B;
	Tue, 29 Apr 2025 17:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946433; cv=none; b=DJaqfpmuvgf2ZnWWBFzRankwMP+kTB16VilbzZPpV2BKqWR/xbxcoX2SKP8ktDoNN43tbllHNgXmGFcW7u2YcFHcvqKTiaZYq+xseaCJ8JksKPMR7b4In/jfbRy5B8Biy257wzOT1KjU5+MGFVn1NNzZLg5v7R3JYUvT3vnIiU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946433; c=relaxed/simple;
	bh=sNlvuSqtNnjoffiLglioY1P9X0Bl9NrdjO3fsryDajI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJSf2V7RCZ+AE8GHUwiRaNmrIahQKkohwZi748Uj3Of2Kug9QqY/9fQ3gvMamEUtnc3pYlEMaJqQTwCk1XBuLHenzHOnux4hx52lv18cX120Q+l3t4UZ7dT3KS67Qrxg8L9i2En8FaBVX/uZrmCBYj6UAqoTgcGwU4YGLbwi62c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nouWPjWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nouWPjWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D24C4CEE3;
	Tue, 29 Apr 2025 17:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946433;
	bh=sNlvuSqtNnjoffiLglioY1P9X0Bl9NrdjO3fsryDajI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nouWPjWDJ+RzXRDjZwp0d2sWJDTTQg9TZaup9jNccp1l+QjYiQJqnS1PwZzSRJPNn
	 istbZC6iryac1EkxntgOPtOx0kePrkB5ueo6jZtC3xwGd00am/4gzRUt5mQAl/hgx8
	 be17TSfeyuM1x/KsaXYYxMySKwZlksDowTZHDdQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 248/311] ACPI: EC: Set ec_no_wakeup for Lenovo Go S
Date: Tue, 29 Apr 2025 18:41:25 +0200
Message-ID: <20250429161131.186092055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b988685388effd648150aab272533f833a2a70f0 ]

When AC adapter is unplugged or plugged in EC wakes from HW sleep but
APU doesn't enter back into HW sleep.

The reason this happens is that, when the APU exits HW sleep, the power
rails controlled by the EC will power up the TCON.  The TCON has a GPIO
that will be toggled at this time.  The GPIO is not marked as a wakeup
source, but the GPIO controller still has an unserviced interrupt.
Unserviced interrupts will block entering HW sleep again. Clearing the
GPIO doesn't help as the TCON continues to assert it until it's been
initialized by i2c-hid.

Fixing this would require TCON F/W changes and it's already broken in
the wild on production hardware.

To avoid triggering this issue add a quirk to avoid letting EC wake
up system at all.  The power button still works properly on this system.

Reported-by: Antheas Kapenekakis <lkml@antheas.dev>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3929
Link: https://github.com/bazzite-org/patchwork/commit/95b93b2852718ee1e808c72e6b1836da4a95fc63
Co-developed-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250401133858.1892077-1-superm1@kernel.org
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 8db09d81918fb..3c5f34892734e 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2301,6 +2301,34 @@ static const struct dmi_system_id acpi_ec_no_wakeup[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "103C_5336AN HP ZHAN 66 Pro"),
 		},
 	},
+	/*
+	 * Lenovo Legion Go S; touchscreen blocks HW sleep when woken up from EC
+	 * https://gitlab.freedesktop.org/drm/amd/-/issues/3929
+	 */
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83L3"),
+		}
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83N6"),
+		}
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83Q2"),
+		}
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
+		}
+	},
 	{ },
 };
 
-- 
2.39.5



