Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FFA30BF6F;
	Mon, 13 Apr 2026 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097412; cv=none; b=brPqnkBR7LVDi84XByeKetNNpZ893/wlPm0gIMZ+Hjx35HzVwyNC8dJ59qxoiDSU7XHBlFN7xEFt4OojtD4p1kk0zOpXzuAetbvTn6oOycVwGteYAd8z07NlVfz/AKPEoDRhZsh9Xwro9BrLDycjdvmSUReLwUcHGxmm/FgXsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097412; c=relaxed/simple;
	bh=/4h1rsz5NAuVr0FzEvQzv8gIihlVWNrFd/Wm7kMpn6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo1KB1a3eA0zRo4bKIkpzGWrdiftPSNDqVviiSWPm/VGgbvPABeX9xMh78IRfBAYG35q3tNE7tMjwg1NIwJlCnUkrFkM8K5pFWUSk5Pti2WyLxjKvjL30Nf4R6GVMFjXHa+zFNNNPPO8SeiM+lFi65cftA7u4jrSEmiX4oU9SNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbn8ZoCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbn8ZoCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD65C2BCAF;
	Mon, 13 Apr 2026 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097411;
	bh=/4h1rsz5NAuVr0FzEvQzv8gIihlVWNrFd/Wm7kMpn6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wbn8ZoCM94H+7qjuDS5oRnStw3eInavL52GCOdBLo107dbWSZbWJ7kw4xoxfSwdHB
	 WYZqYOdzqe2V9jNjO5F/cnLgxyf7c1rXZx7eRhfyruKmtIRK3RxOP45pnO+kbYa2LD
	 mfH1TwGP+t0963rr+O09n2GhTWZtTsodDc+QfgGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sofia Schneider <sofia@schn.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/570] ACPI: OSI: Add DMI quirk for Acer Aspire One D255
Date: Mon, 13 Apr 2026 17:53:45 +0200
Message-ID: <20260413155833.964986761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sofia Schneider <sofia@schn.dev>

[ Upstream commit 5ede90206273ff156a778254f0f972a55e973c89 ]

The screen backlight turns off during boot (specifically during udev device
initialization) when returning true for _OSI("Windows 2009").

Analyzing the device's DSDT reveals that the firmware takes a different
code path when Windows 7 is reported, which leads to the backlight shutoff.
Add a DMI quirk to invoke dmi_disable_osi_win7 for this model.

Signed-off-by: Sofia Schneider <sofia@schn.dev>
Link: https://patch.msgid.link/20260223025240.518509-1-sofia@schn.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/osi.c b/drivers/acpi/osi.c
index d93409f2b2a07..6913264490225 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -413,6 +413,19 @@ static const struct dmi_system_id acpi_osi_dmi_table[] __initconst = {
 		},
 	},
 
+	/*
+	 * The screen backlight turns off during udev device creation
+	 * when returning true for _OSI("Windows 2009")
+	 */
+	{
+	.callback = dmi_disable_osi_win7,
+	.ident = "Acer Aspire One D255",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "AOD255"),
+		},
+	},
+
 	/*
 	 * The wireless hotkey does not work on those machines when
 	 * returning true for _OSI("Windows 2012")
-- 
2.51.0



