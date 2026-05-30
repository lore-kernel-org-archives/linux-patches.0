Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D9320CAD;
	Sat, 30 May 2026 17:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163502; cv=none; b=qu7p6PqZXiDZK0l54IGsLobRnlqK39yz0aEhXeaSxLkPw3psck2UD/afHFXjSd3iok1iUZI+gtDXX7gIh4HBaApveYQ1jwM3Y59/EzIFwBjsaAYbUpwZGtFMXDkhMISD832RQrBTqK4n7MTZhhMsZrj3JbsvvXB6CAlukh0vOoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163502; c=relaxed/simple;
	bh=JgPDRw1vDu26HIx8x2TAWzX49IPnZsrCxxLhhKUqg9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcKCn9dnCgmiTo3ZHiNpFLNnvNEhQVJSjQXRod99af2m6fhcZIRSiCQpjz0HDUFbOaEyRVSohLtamM5nsvpm2TOdq1JDZvALNDJrwgCUoYDC4ec5Y2EtrIpTN/tIcxshKcISxqIRAiHhlosoQEIwAxtkvb8LyZTPDDe6VYfwkks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iveo8e8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iveo8e8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8FF1F00893;
	Sat, 30 May 2026 17:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163501;
	bh=+HwFabfDFiaj47k/1UWvqBhuJaPPoIQo4Ig/lcqEaEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iveo8e8b2wXhKuwJhzyx3opZRfbWaT8g267Q0/ycb7ug7uP36KXQwkhzLHMEGOSto
	 72cqdUiKd87pWgcjuedo5iV9gqI/FnK4/t8mQRoirJ5rfOGtd3tI/Bgo7maRuEgC1L
	 1dOvFFXof9Aq1XoV7LJS5XlOpRwiL2TI6stk2CoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 278/776] ACPI: video: force native backlight on HP OMEN 16 (8A44)
Date: Sat, 30 May 2026 17:59:52 +0200
Message-ID: <20260530160247.743784360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Shivam Kalra <shivamkalra98@zohomail.in>

commit 4b506ea5351a1f5937ac632a4a5c35f6f796cc41 upstream.

The HP OMEN 16 Gaming Laptop (board name 8A44) has a mux-less hybrid
GPU configuration with AMD Rembrandt (Radeon 680M) and NVIDIA GA104
(RTX 3070 Ti). The internal eDP panel is wired to the AMD iGPU.

When Nouveau loads without GSP firmware, the ACPI video backlight
device (acpi_video0) gets registered alongside the native AMD
backlight (amdgpu_bl2). In this state, writes to amdgpu_bl2 update
the software brightness value but fail to change the physical panel
brightness.

Force native backlight to prevent acpi_video0 from registering.
Confirmed that booting with acpi_backlight=native resolves the
issue.

Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Link: https://patch.msgid.link/20260426-omen-16-backlight-fix-v1-1-62364f268ea6@zohomail.in
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -154,6 +154,14 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEH3U1E"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* HP OMEN Gaming Laptop 16-n0xxx */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16-n0xxx"),
+		},
+	},
 
 	/*
 	 * These models have a working acpi_video backlight control, and using


