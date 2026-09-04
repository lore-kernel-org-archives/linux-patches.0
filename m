Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F63378838;
	Fri,  4 Sep 2026 06:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502356; cv=none; b=ePIVDGmxZ/8e72ZHRrzZ0rPGC28NAjln2Zke74rXtIgXAl5xpOOyI2Y+SXJFpB0Bcaj/JglGBMZzw5PGOQW+N6WhAVfQ95DGPd/9l5PniQSFB0KqoW3zlvdcjlrfFhwiNlM+KI+cP441DS7wUiTZ5WYZsNLGdyssIfvnpJwOAHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502356; c=relaxed/simple;
	bh=xOkRLV/GgdG8W10/sdrbzsCcx4iZwozEIuMS8H7GeTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzmBryqpnb2+PfsEAoXsTnHZFVWfewoTjD6ntCERr80N08iX2bMhw3l2Aq1/zy0bGgeq/IlNoIbcHyfU1iPed2rLXCAeqpZzB4MRc8AsEzbdSCS1oN4e/EPKiqDOqZpxVmpeRiRmmpLcVM8Ezsox5AqV2PdmAxVaBYrPkrz9ROE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glp/Vo0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glp/Vo0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17411F00A3D;
	Fri,  4 Sep 2026 06:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502354;
	bh=pmd5Z/0QBtWIwmLH8iE1pFkLmvgk06QIGXIMAjFG6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glp/Vo0fSju87UIdTqKlSa/bonKdvfr6eiCJxjw8IKCwLWpG4jrRw6QlV8zkMDlc8
	 gM51aHOv1pisO2zRumZ3uh1Ulf4bKSkflcqCT/VbNzxkC8mmaw1FL2HXcxZSX/HpeK
	 K9UMlm0irK2uT0SH0CtOkUPTKo2/GaJnewNXRjco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 176/403] Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:59:39 +0200
Message-ID: <20260904045738.860816506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,6 +548,7 @@ static int bcm_close(struct hci_uart *hu
 		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
+			pm_runtime_dont_use_autosuspend(bdev->dev);
 			pm_runtime_disable(bdev->dev);
 		}
 


