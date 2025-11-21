Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADD5313267;
	Fri, 21 Nov 2025 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730974; cv=none; b=GcpgamoAkJYUIomoZyBWUbyJPaCbqr6lMJBCrauQWNpwmLKvT6UBrb97H/FV6XrrD0V0IFAzqu5lJ+enPtrhSdiWU8eI2dWXEKaglKLB8Oz8TcY0Y0wSatu4E/Yjo8t2eZNyJSD2NlMCoBv4PjSM+hdXiGBKyD3LJ3P+sklA/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730974; c=relaxed/simple;
	bh=/mFrZHPZbuDq4b6AoqPcxZwN4RE0hyAsxKWZmqMwH7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpmdJJU9drAnhGEJm7UWmq0482OqNg17x27gpf6wBWy9FAEOaAR+EFhZWfAKu5S2gZUpcY0v2tXcaA31NWxuETOzaOKJaUOAbxq7kcrWeoBuNqNaBFJsD1RlF0hF4V2TAtYWtx2hAmocfzLWHVXSbYoYSH2rru+9IltPIA3RrrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+9+vLp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+9+vLp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDC1C4CEFB;
	Fri, 21 Nov 2025 13:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730973;
	bh=/mFrZHPZbuDq4b6AoqPcxZwN4RE0hyAsxKWZmqMwH7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+9+vLp3UFQPKKvbXpnuPyxUs90NFbJPWxmxRtYH5LrCInyXsTTPx7MJ4k0xOkakz
	 HY4PWOKoROtQmZigvWgz7bErBMCSBnCG78lMMrHOkd6XNXu7k6KARAMhzymyvQUe59
	 eUL6sYSRyl7KzFm5ZaKb8H3QsbwY4LlVBUBrQQ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 013/247] drm/xe: Do clean shutdown also when using flr
Date: Fri, 21 Nov 2025 14:09:20 +0100
Message-ID: <20251121130155.076900207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 528e818edbd7f..107c1f48e87fc 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -962,21 +962,21 @@ void xe_device_remove(struct xe_device *xe)
 
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



