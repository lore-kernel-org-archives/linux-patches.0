Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8733242BD;
	Fri,  4 Sep 2026 05:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500975; cv=none; b=QXRQUqoFnubwY1+syIUS+Dk3UbepDKnqiYH7eWW3B2mjhBFDzI5FVx4ULmt5b6+VbKDt64C9KwYsxDX3GruMN8aovpdamlxxX6JQDlkKfLLQ4lsG6oak5Ru9J0H6VEbDNhq7hWuVJN5szdLzfPpJkU3J4l+pH2mVCi1CrAxJbzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500975; c=relaxed/simple;
	bh=7jdA6NkQ03mQuS4n36CKhVuPJ6pkFztOVJiEKdp1Cvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIU3jFZv+9x/WLzzFFrffs8IEeJOELjp8/U9ztaqi97mU7286RRx9cBht9TtfIR1iYeFQTx/LXGGYDXppRPfnUp+2tHSpRlRC3xwHFAku8+idF/MToX47NQi00BXO4SJ7w1Vpd0vDIRPrJDwOWDoppGJzHfBHbPYkQcZO/Jw9CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEHlRCcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEHlRCcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2583A1F00A3D;
	Fri,  4 Sep 2026 05:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500974;
	bh=Fjx174hofmy/vE5O+Q01Xw0/i6F4qI+Zx+oGLOZoMRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zEHlRCcnHJBgS+5Www/RlwaAgWqjHjj3JsClqyrVsT5WYO5TS+OC0lLOiXoZxLp1V
	 If3ldf3uuR+i+BEB8nOiYQvaCUbCloFNHPsOJlgWJOp+SmdnYCsZ5jrB120BLYj7iB
	 Y8cQRmaiC47f2XWiZgV7DXCWG633oano2KQCKlsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 245/552] Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:56:42 +0200
Message-ID: <20260904045755.082772631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


