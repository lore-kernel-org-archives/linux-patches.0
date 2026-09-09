Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFCD572694;
	Wed,  9 Sep 2026 14:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962675; cv=none; b=HyZoQoMyx3L9u5t3jRlhxOizIMy/hfG1U1cAS+HMSrqh+m0yaiVDw/Hmm6kEOkVeaAHtsq3CbPzv9kSdXkRd8DUGam116hKWSxXUWsdXht7sKJ1DoyeLbhAtEGq0Vypy66ZzZg069BRW7lMZaFKJRVFfyz19CssYH8bKumHLSXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962675; c=relaxed/simple;
	bh=jpG7NzloZIj7t9OmFpz9gZkD012Ua6jihqrsZLAzRx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WpOWC50TiVBrvKwHWjb/wcOoigNkWD/lpZpPBeBIG0FkBov/C4WHZITOwEZN4CyQ3aoDvHpob7r/Aza5azpgPDCB2vwXfc6xMLDZXtjiOIzxzxF7Qk444uJ8kULHtJMsvhHbtLbXgHf4HqIeK2KAVZYsV4iJ+acqim6ro3dYT2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTtUIthA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTtUIthA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5C91F00A3D;
	Wed,  9 Sep 2026 14:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962674;
	bh=5+GsmyajfbHVsDaaIwco3WNxEHVj3Qro4AvH2ZUOjbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTtUIthA5Te+1pTxDMulzGP1a3pyua3TWmEA3EJ6elrpwkY7pd0xgC9Im0L4VJQyO
	 qC94mVINXUDSXHOkpa4Y0hRxZw4l3zOu4fpM0X3pYlaDRp1tG1iA8+cA5GsCFPC5CD
	 wjk6FddLDIprf+0qJLCkHb4VGOAFXZMM8jUbhrKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Mar=C3=ADa=20Mart=C3=ADn?= <jmmartinf@hotmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 372/556] media: ipu-bridge: check all DMI entries when overriding sensor rotation
Date: Wed,  9 Sep 2026 15:40:52 +0200
Message-ID: <20260909134243.780349575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José María Martín <jmmartinf@hotmail.com>

commit 4900cad020c0580dfb1be27776ff10a4ef110cfa upstream.

A machine can have more than one sensor whose rotation needs to be
overridden, which takes one upside_down_sensor_dmi_ids[] entry per
sensor, all sharing the same DMI match but with different ACPI HIDs in
driver_data.

ipu_bridge_parse_rotation() uses dmi_first_match(), which always stops
at the first entry matching the running machine, so any further entry
for the same machine is unreachable and only one sensor per machine can
ever be corrected.

Walk the whole table and match every entry for the running machine
against the sensor's ACPI HID instead.

Fixes: b75710155a82 ("media: ipu-bridge: Add DMI quirk for Dell XPS laptops with upside down sensors")
Cc: stable@vger.kernel.org
Signed-off-by: José María Martín <jmmartinf@hotmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu-bridge.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -298,9 +298,11 @@ static u32 ipu_bridge_parse_rotation(str
 {
 	const struct dmi_system_id *dmi_id;
 
-	dmi_id = dmi_first_match(upside_down_sensor_dmi_ids);
-	if (dmi_id && acpi_dev_hid_match(adev, dmi_id->driver_data))
-		return 180;
+	/* A machine may have one entry per sensor, so check all matches. */
+	for (dmi_id = dmi_first_match(upside_down_sensor_dmi_ids); dmi_id;
+	     dmi_id = dmi_first_match(dmi_id + 1))
+		if (acpi_dev_hid_match(adev, dmi_id->driver_data))
+			return 180;
 
 	switch (ssdb->degree) {
 	case IPU_SENSOR_ROTATION_NORMAL:


