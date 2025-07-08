Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730532045B5;
	Tue,  8 Jul 2025 16:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993399; cv=none; b=K3tZ5AS8SmSCmYghDhmGC1qbOnhCaWgFQnZQqnh54Ljvv4GEJEcvG055iZe52pvP6uaW2P3Nciw93sFxWyyZRM1sPidt5lqYEk5qXRtfHKO/5gWVdGDUHB26ZFgO3MrcyAA2/VIdDmw1Ef26pjYowlz/W7yzQOL9aFODKpV89/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993399; c=relaxed/simple;
	bh=PMTHx41yr3dXxLpLaLVNYKluu45UWhWG+bBB/RtyP1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvkIQQOEVjW+cywztlpwju2sr05As4rZxTt0EhJTcNpx63i+EyyNCU0SkJca3tKt3CGUdON8eGky35gu1GoEybzoLVRy0R+hOfkbP5Mvo3t0szrjNlWn4wMyJYV3khgYIGZfbmevEHd4Ep9wmitq+Yya+0wHAENyfjk4qfTXaMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nz/FP/AD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nz/FP/AD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989F5C4CEED;
	Tue,  8 Jul 2025 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993399;
	bh=PMTHx41yr3dXxLpLaLVNYKluu45UWhWG+bBB/RtyP1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nz/FP/ADKWZRlCTgr/fjIKYUV89fyMl7WNRQfkbWSNZMPOG3UlnT5/y0O7yLYkZ1Y
	 l5OT/XXBTLutT1OjubYzmHWcbm1IZ0e5Y9/p8k1nybSvu2a3cXBfrECElDAQ267jbD
	 r/iy2qC1UoH7hCA6ZLJSLeysiJsHot9aFWd9JzIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Bagrii <dimich.dmb@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 060/178] platform/x86: wmi: Fix WMI event enablement
Date: Tue,  8 Jul 2025 18:21:37 +0200
Message-ID: <20250708162238.247989860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit cf0b812500e64a7d5e2957abed38c3a97917b34f ]

It turns out that the Windows WMI-ACPI driver always enables/disables
WMI events regardless of whether they are marked as expensive or not.
This finding is further reinforced when reading the documentation of
the WMI_FUNCTION_CONTROL_CALLBACK callback used by Windows drivers
for enabling/disabling WMI devices:

	The DpWmiFunctionControl routine enables or disables
	notification of events, and enables or disables data
	collection for data blocks that the driver registered
	as expensive to collect.

Follow this behavior to fix the WMI event used for reporting hotkey
events on the Dell Latitude 5400 and likely many more devices.

Reported-by: Dmytro Bagrii <dimich.dmb@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220246
Tested-by: Dmytro Bagrii <dimich.dmb@gmail.com>
Fixes: 656f0961d126 ("platform/x86: wmi: Rework WCxx/WExx ACPI method handling")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250619221440.6737-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index e46453750d5f1..03aecf8bb7f8e 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -177,16 +177,22 @@ static int wmi_device_enable(struct wmi_device *wdev, bool enable)
 	acpi_handle handle;
 	acpi_status status;
 
-	if (!(wblock->gblock.flags & ACPI_WMI_EXPENSIVE))
-		return 0;
-
 	if (wblock->dev.dev.type == &wmi_type_method)
 		return 0;
 
-	if (wblock->dev.dev.type == &wmi_type_event)
+	if (wblock->dev.dev.type == &wmi_type_event) {
+		/*
+		 * Windows always enables/disables WMI events, even when they are
+		 * not marked as being expensive. We follow this behavior for
+		 * compatibility reasons.
+		 */
 		snprintf(method, sizeof(method), "WE%02X", wblock->gblock.notify_id);
-	else
+	} else {
+		if (!(wblock->gblock.flags & ACPI_WMI_EXPENSIVE))
+			return 0;
+
 		get_acpi_method_name(wblock, 'C', method);
+	}
 
 	/*
 	 * Not all WMI devices marked as expensive actually implement the
-- 
2.39.5



