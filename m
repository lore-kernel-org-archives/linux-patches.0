Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814832BF24;
	Sat, 30 May 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160246; cv=none; b=san0MKp15m0DwgryjZmv1pd9H237QTg8hDoj+ocusRCqJMU2xwCupaf/3IU7+wMoHYq9n2RUWhBczgsGg2ihIVNkDCQhZi74OpBfpsA/H9UCIs+14EyV5UZPvIiniW20uMBGhJ6cqktnqy6tHn3NRi1NZQb4jhVWEyXSZMc0srE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160246; c=relaxed/simple;
	bh=NJT4+An7P2Zekv5/6orJoK4t7QLyCOX7caeHG9FnsUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcyX03yemdg5LO1xh1/eEy8iXao88ozZUvuVgNXJ4aD/bFbZ2AATspkkCHX1xShNdtR9TowfIfJs+ovGfilqkCzCJo1r07QVU1BgNplczH2leZKC4fwSauZronmQ1eMXcAMVJBKdBsxib/fCbYVyCUtuJI3Rk2nXGHgPjqT9DU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr8K52c7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr8K52c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F07D1F00893;
	Sat, 30 May 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160245;
	bh=71fZt2PQwPk8Qy9fTHNddi5j5UhRXN9GsmkL0M0wpGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gr8K52c7tPtJjq5lzV6JFzWHBZhoH/ZIWD2BueMbYXtSeyx5RIqauEwZs29M0GanV
	 PDAXj0bk8oF+DS/+U6gbZoQpq5XhxJRlccHWjWwsKa0/9Tx9VNrioG7Pqsm4ANj5Dc
	 /zXA3eIXkkmf43EAn8L9sG2sxveg0Ya3KfpzfF5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 286/969] ACPI: video: force native backlight on HP OMEN 16 (8A44)
Date: Sat, 30 May 2026 17:56:50 +0200
Message-ID: <20260530160308.360619774@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -776,6 +776,14 @@ static const struct dmi_system_id video_
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


