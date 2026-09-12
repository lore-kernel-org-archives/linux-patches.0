Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D993B325726;
	Sat, 12 Sep 2026 17:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232838; cv=none; b=DLozJvh0q0N2sN5WTglufAHndCRzS16NUH2L9V8X06xDeAEhiV3WDokEKxGnHAFaaxMLSzn92Qu3s4O0m5qhshTB4wOwTKY1wxOSJZGNJIaGvZ7Ie0eLZHROHVWBM/i++YF1eL4OPSrzpLZ9gbCzQtiz6i+an5PNH8zm9wl0vTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232838; c=relaxed/simple;
	bh=rSjYYe3mwWbjEFvX8Fmqkb83Neowuu1vp2QZtRxtaRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SViKy8scjGE3XDsyPXrmTGtkMo+w9J/r858O/WYhujwOFs4cU93xN3D+UanZGUmpTzmLXWdIxD/RZCrB3U+pIQzZvoJj1bI/jIqY8J8mPCTVg9aU5A/Z0Nfsw2GfKB7SIOnSbJpI5mfo/lD+4WXoXHHwmRxPaRFazvSoq8YSop8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VF2OIJ04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VF2OIJ04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73CE1F00893;
	Sat, 12 Sep 2026 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232837;
	bh=WN2+hwUDDkOcXfK5nyI1MZFjNQy1xcIvZ25yhomehjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VF2OIJ04K/7k2utyYnfrqExdzuqhJQK6decemx7hou/uUdcIqEmXM9p6hJ460ghPe
	 MgDYlVZCmgkgCLoLVlntKcfqDUcvS4az5K0+z8nR1c0N+41MCE+IDEnVNoEih4kykO
	 zmdjxEGLqbWlTnbDbfjO1zd+1tKfe+PQlfeGscYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 093/935] Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:52:03 +0200
Message-ID: <20260912065528.959138048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit dc6b7c771a963e20aedf4a21ffa22543b9837ba8 upstream.

bcm_request_irq() calls pm_runtime_use_autosuspend(), but bcm_close()
does not call the matching pm_runtime_dont_use_autosuspend() when
tearing down runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: e88ab30d3669 ("Bluetooth: hci_bcm: Add suspend/resume runtime PM functions")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -529,6 +529,7 @@ static int bcm_close(struct hci_uart *hu
 		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
+			pm_runtime_dont_use_autosuspend(bdev->dev);
 			pm_runtime_disable(bdev->dev);
 		}
 


