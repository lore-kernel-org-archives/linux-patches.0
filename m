Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C6130569C;
	Fri, 15 May 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860981; cv=none; b=oyCQK3nqvT+PpCoARnbeFPAuUAhDSBDFlRM1WuAXo0lxGoDv97aZpR3uScWdML04i59PoaPFJpvLSBP//RZX7u8lmOLCISeA18WZnclJ8FS9BH+I5m6pdu15E2X9P96zrMUdNTRZXKTHvRcTVjHPShCWL97w7YvjOdWZP1kHMCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860981; c=relaxed/simple;
	bh=QEOtfw+dVuM36bPCmYqEvBwdHlREAC8obwcUvagroiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P45pxRfOaokQ7RreA322msQ4cadz7VeggHTWd5ZCUWdR4+MNc1ISpxVzr24nRtivV5w5Re+c5rzY8AFnVd669JRPcnzet+VTQpc0SIDTIUQkqkAbyv4yqVQSz/YQoDItayuIJTKDFxg2NCOKmfa7V+ny2BO/o+MYIgvKz/usOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bq5r6Vob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bq5r6Vob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9DEC2BCB0;
	Fri, 15 May 2026 16:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860980;
	bh=QEOtfw+dVuM36bPCmYqEvBwdHlREAC8obwcUvagroiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bq5r6Vob5zDjLBP68n9JBe525p8LVNikPyozcN3VCxVJrG/vCVZXAncn02Ep3TjZI
	 QJ1jCsVAvrz3sA+AbAlrZ/922eoSAuo/iMBdog1A6isa3dFSrlTy/dEFSKnlSMIxMx
	 rakvLbtgUyWjDua8U1yeWJANIqkQz1vGz41Wyj/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 151/474] ACPI: video: force native backlight on HP OMEN 16 (8A44)
Date: Fri, 15 May 2026 17:44:20 +0200
Message-ID: <20260515154718.293736241@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -820,6 +820,14 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "Z830"),
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
 	 * Models which have nvidia-ec-wmi support, but should not use it.


