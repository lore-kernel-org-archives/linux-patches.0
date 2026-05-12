Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C513537D0;
	Tue, 12 May 2026 18:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608956; cv=none; b=VASRC4lGFLC1Y5kbWR8btjomWmUyt15W+r46h0zCj5S+j8mgXCvZ7drpPk4N1TkXDqj2hurGN32X0rBH0lpEIzRUG+HfUYXR41d8DzC1MT8RnCXoLcDSXILx+kj5SZIBBQQhRRWFFhETNrBsg1zAY+UcSOMl5hb5G1dXE3TyP8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608956; c=relaxed/simple;
	bh=p1ri4/PoHIH4x1CspWMuI6euNuyt7a7jNoiyLdcR8qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzVW8ksH69p1kSW0JS+Q4qXdNdJXxUyJLUys4WsFm+/OrNJuscY9UaoDQ9GmSD5E1ts4nSzaVLqRQ0PX/cSVxB6OPg3tuhVSVORKf9ONcH56ZWn3yc9XIXAPQCxjzdAL4UNzTYzjlRX4z30hHTLGQOWnFCdXRwmEm9mXd1Fw6RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W03qouOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W03qouOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B1CC2BCB0;
	Tue, 12 May 2026 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608956;
	bh=p1ri4/PoHIH4x1CspWMuI6euNuyt7a7jNoiyLdcR8qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W03qouOa373Qj6OJJMeMmZtphLrdaQL+xC8iMKBrxhR8sGo+Vo93YFFjyXvhBrccy
	 x/b7HMu++ilr00a98L5vdyD5tKvmu0e5xgcH0AEoUyyGlrue+7axeyBc4vb1nl//Yr
	 73hS0WJCvemLBQy86MVzCxP/4trN8j9sN+Hqqx2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.0 010/307] ACPI: video: force native backlight on HP OMEN 16 (8A44)
Date: Tue, 12 May 2026 19:36:45 +0200
Message-ID: <20260512173940.342079554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -907,6 +907,14 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 15 3535"),
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
 	 * x86 android tablets which directly control the backlight through


