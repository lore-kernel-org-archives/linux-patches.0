Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2247222DFB1;
	Mon, 10 Mar 2025 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628541; cv=none; b=PnSvKAlfoNxWxk/85HBCoHLSprB6RxqtBbdSStZXTsNKM7OLP2I4RrhCaXzyoOCAq6LvG51+0Wkf6toANbEUvdCDrbAteRTHlzfS1SJv5bOaDldT5QDDTUp3nxacxlpIqLnCHSevZhHLCsi07U0mR5kit/b46DCTTdd/H2xNRsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628541; c=relaxed/simple;
	bh=RoGrguD4LEcWs611ktCH2bFqQC+I14oVZ74DdNpI0V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hk0qInGZbOiCEuANhMW/QjI7dBSlXcJtW75/FR8cdOV4i24jyPDf7KE4aIQSwFqyFNOU3RSruQOg8nEL3IHwkm6sCbKK0ZEgr0x2F+XQL3tv2U3yS/XThMuzxSKlW2UN05tJdxjsCM1pto9rUzKDJ3x3K2YRDMp8eRWPT2omomo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUa36ccb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUa36ccb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4373BC4CEE5;
	Mon, 10 Mar 2025 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628540;
	bh=RoGrguD4LEcWs611ktCH2bFqQC+I14oVZ74DdNpI0V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUa36ccbHv1oBHKzHzAObQ19TiOBkhAz5Rh3IhgB5bfzn2TGdYQoKCLOvd7SOucld
	 er86ubi5E0Wwn4+zvx5kLan02ZZ/hIcOAbUdbLx8xCNoAe1JRt5KR47wkfsyKv49hF
	 vIV85TS1Tha8Q3g48tKOfKT4sDrg662WmQmqClZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Loic Poulain <loic.poulain@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 086/109] bus: mhi: host: pci_generic: Use pci_try_reset_function() to avoid deadlock
Date: Mon, 10 Mar 2025 18:07:10 +0100
Message-ID: <20250310170430.983555680@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a321d163de3d8aa38a6449ab2becf4b1581aed96 upstream.

There are multiple places from where the recovery work gets scheduled
asynchronously. Also, there are multiple places where the caller waits
synchronously for the recovery to be completed. One such place is during
the PM shutdown() callback.

If the device is not alive during recovery_work, it will try to reset the
device using pci_reset_function(). This function internally will take the
device_lock() first before resetting the device. By this time, if the lock
has already been acquired, then recovery_work will get stalled while
waiting for the lock. And if the lock was already acquired by the caller
which waits for the recovery_work to be completed, it will lead to
deadlock.

This is what happened on the X1E80100 CRD device when the device died
before shutdown() callback. Driver core calls the driver's shutdown()
callback while holding the device_lock() leading to deadlock.

And this deadlock scenario can occur on other paths as well, like during
the PM suspend() callback, where the driver core would hold the
device_lock() before calling driver's suspend() callback. And if the
recovery_work was already started, it could lead to deadlock. This is also
observed on the X1E80100 CRD.

So to fix both issues, use pci_try_reset_function() in recovery_work. This
function first checks for the availability of the device_lock() before
trying to reset the device. If the lock is available, it will acquire it
and reset the device. Otherwise, it will return -EAGAIN. If that happens,
recovery_work will fail with the error message "Recovery failed" as not
much could be done.

Cc: stable@vger.kernel.org # 5.12
Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/mhi/Z1me8iaK7cwgjL92@hovoldconsulting.com
Fixes: 7389337f0a78 ("mhi: pci_generic: Add suspend/resume/recovery procedure")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Analyzed-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/mhi/Z2KKjWY2mPen6GPL@hovoldconsulting.com/
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Link: https://lore.kernel.org/r/20250108-mhi_recovery_fix-v1-1-a0a00a17da46@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -824,8 +824,9 @@ static void mhi_pci_recovery_work(struct
 err_unprepare:
 	mhi_unprepare_after_power_down(mhi_cntrl);
 err_try_reset:
-	if (pci_reset_function(pdev))
-		dev_err(&pdev->dev, "Recovery failed\n");
+	err = pci_try_reset_function(pdev);
+	if (err)
+		dev_err(&pdev->dev, "Recovery failed: %d\n", err);
 }
 
 static void health_check(struct timer_list *t)


