Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1746D3B8BB9;
	Tue, 21 Jul 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660646; cv=none; b=lkvS6EG7qaHW/EsjFKOhTS3dh+jOAUcKzIQgCE9kKt4QSlg2gY4J0eyV3q6pwbaNBlPQEuXUjTvfcsbHkhNTf0da8R2AF4OZGYJ7oUcHsO65/EfESoID+f+hWqBLUm4AHyHH9oMW71jGKBuj0ygv+uVtMpEPgoiytP79KVFVuWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660646; c=relaxed/simple;
	bh=dgbcJ6T9UWTTt0XkOjMY9obf9nw0FBwIbALyFc/jyR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGyl8Ly90jKLaYDKsRn7ZsRvzU2WfszAie1zp3rfFBCdJ5mmPnid3RuhlDVsAcaxBIvMTEVeQtwMBmRSk9WktryOVARfCWVIzuIdSlTYf+sbaqikLunJV2FKSvx8g3l81P2U1hLtUxrAX62M5C2UDQpzdicjagjZs6UwVKruUB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccyQ8D9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccyQ8D9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFCE1F00A3A;
	Tue, 21 Jul 2026 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660645;
	bh=Rk42xOxh3g9w/4bKSQfV/OftBb1IAyJa6S8SIymK9E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccyQ8D9WjzMV520xWciGOJsmftuvsToOlVbVf449OOIiha8+Gy+BRMQpsEpiqbCYh
	 oCKeTgBihbJyiWkcmeFNZnBdnb5OMeKVomNDR9ZFs8yKQDkJ65ia+bipuR+xeMcgmU
	 FcHaFrK3EWHO68duRLBvsUapHXKQ/KPpr/2+HszA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1056/2077] i3c: mipi-i3c-hci: Fix suspend behavior when bus disable falls back to software reset
Date: Tue, 21 Jul 2026 17:12:09 +0200
Message-ID: <20260721152617.728965264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 57e181af13de36571380ef3cc74000559826fa9b ]

Software reset was introduced as a fallback if bus disable failed.  The
change was made in 2 places: the cleanup path and the suspend path.

For the cleanup path (i3c_hci_bus_cleanup()), after software reset the
function continues to do cleanup for the current I/O mode.  For the
suspend path (i3c_hci_rpm_suspend()), after software reset the function
returns early.  However software reset does not reset any Ring Headers in
the Host Controller, so returning early is not the right thing to do.

Instead, continue to call suspend for the current I/O mode, which for DMA
mode will reset any Ring Headers.

Note, although Ring Headers should not be active at this stage, performing
this reset follows the procedure defined by the specification and keeps
the suspend path consistent with the cleanup path.

Note also, i3c_hci_sync_irq_inactive() is still called via the PIO and DMA
hci->io->suspend() callbacks.

Always return 0 because the device is quiesced as much as possible and
returning a negative error code would unnecessarily prevent system suspend.

Fixes: 9a258d1336f7 ("i3c: mipi-i3c-hci: Fallback to software reset when bus disable fails")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260603090754.16252-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index b781dbed216500..afb0764b5e1fbb 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -762,15 +762,10 @@ static int i3c_hci_reset_and_init(struct i3c_hci *hci)
 int i3c_hci_rpm_suspend(struct device *dev)
 {
 	struct i3c_hci *hci = dev_get_drvdata(dev);
-	int ret;
 
-	ret = i3c_hci_bus_disable(hci);
-	if (ret) {
-		/* Fall back to software reset to disable the bus */
-		ret = i3c_hci_software_reset(hci);
-		i3c_hci_sync_irq_inactive(hci);
-		return ret;
-	}
+	/* Fall back to software reset to disable the bus */
+	if (i3c_hci_bus_disable(hci))
+		i3c_hci_software_reset(hci);
 
 	hci->io->suspend(hci);
 
-- 
2.53.0



