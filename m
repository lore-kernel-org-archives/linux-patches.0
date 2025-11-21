Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E60246762;
	Fri, 21 Nov 2025 13:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731604; cv=none; b=e1aZeE6yy4tnrMlwfbVDkyDlM5GCRBIYjJxT+0ZMXp/sI9aVVBFkyHt08x4rBLqw8uQrVvVeYldI48ckA5LCwvWKmr8Mfu72VKzDeEB7qiCXHTG1hp3jH+1K/VvqgMKkhdok+zd9XnBo0HcilCK5Om8ExRsftTrwETXlRv0g4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731604; c=relaxed/simple;
	bh=i+r8P9JL34cguQCpUkSiW7K4tHzdPo/sjOoQTIBxyTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sl80GSNgAofkXYGd/s8n+H8q2q8mbkdJEgQw2g/2B4Um9rDyLqr5XsS26uynOrXIgCXZ1n1vr4EdGZQvS0wzuxPE24wkfnNVbIPa1MqFgMmHtZJa40X8j+ElWLQzTKc5qNBaHDJZo+Vw2JPOq1PnKlH15YW6Ouc3+/zoqJZajL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsM1+If7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsM1+If7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B09BC4CEF1;
	Fri, 21 Nov 2025 13:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731604;
	bh=i+r8P9JL34cguQCpUkSiW7K4tHzdPo/sjOoQTIBxyTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsM1+If7LrZqOB7p4aROnnZ8x83BsrkLix8UUVuFVvKTNJT1QvHCmD6sozKB0irXt
	 TGaQzjPK6Gw2+WS5o7oMIXuXW7hbZchZemmdxtXmkQc5FdvEzP5DoPFk6EGSeXqlQ+
	 f04I3GF47IKAIV5m3pgzgXo6iPBQf+RqubIwpPi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/185] drm/xe: Do clean shutdown also when using flr
Date: Fri, 21 Nov 2025 14:10:36 +0100
Message-ID: <20251121130144.206232588@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit b11a020d914c3b7628f56a9ea476a5b03679489b ]

Currently Xe driver is triggering flr without any clean-up on
shutdown. This is causing random warnings from pending related works as the
underlying hardware is reset in the middle of their execution.

Fix this by performing clean shutdown also when using flr.

Fixes: 501d799a47e2 ("drm/xe: Wire up device shutdown handler")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
Link: https://patch.msgid.link/20251031122312.1836534-1-jouni.hogander@intel.com
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
(cherry picked from commit a4ff26b7c8ef38e4dd34f77cbcd73576fdde6dd4)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 3fab4e67ef8c1..161c73e676640 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -809,21 +809,21 @@ void xe_device_remove(struct xe_device *xe)
 
 void xe_device_shutdown(struct xe_device *xe)
 {
+	struct xe_gt *gt;
+	u8 id;
+
 	drm_dbg(&xe->drm, "Shutting down device\n");
 
-	if (xe_driver_flr_disabled(xe)) {
-		struct xe_gt *gt;
-		u8 id;
+	xe_display_pm_shutdown(xe);
 
-		xe_display_pm_shutdown(xe);
+	xe_irq_suspend(xe);
 
-		xe_irq_suspend(xe);
+	for_each_gt(gt, xe, id)
+		xe_gt_shutdown(gt);
 
-		for_each_gt(gt, xe, id)
-			xe_gt_shutdown(gt);
+	xe_display_pm_shutdown_late(xe);
 
-		xe_display_pm_shutdown_late(xe);
-	} else {
+	if (!xe_driver_flr_disabled(xe)) {
 		/* BOOM! */
 		__xe_driver_flr(xe);
 	}
-- 
2.51.0



