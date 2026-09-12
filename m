Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A8275AEB;
	Sat, 12 Sep 2026 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227294; cv=none; b=BbWjNmhsKh6n9n4G96zzJLJyXHgqSBXzmhDzHGIjfCzsNl0D/rHXYu2Q77b9EYmVuRznWs4ZneOk2Q6DIvzVYrkLXZwdp1VaznJwvml2p+pHo8wz4s0vaMb3EJz+vAxy44xr6GZcm5/Ka8OaJ14YbcCdQknzirnkYzAwKPasDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227294; c=relaxed/simple;
	bh=98D17pOxLMa1A0DQ+Sc75H//Mhhr2FdgO6HCXbRM2L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/YWF4YLV3tcK6f8T1qES5jIv2eiIvi1DtLpbOL+BKNYzKyVuNwVQp8/pr07RLJGurvyX34H/7viHG92EdGubrm+v92diAJ+JKIvc+fpgNLfQ54ayzpjtSsXg7RGDfJbkOh0zTg/HtZsBSF7dxwCMAFcSTXL2v8Fp0vZWyOvDDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8Rtcin4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8Rtcin4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F481F000FF;
	Sat, 12 Sep 2026 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227293;
	bh=We+ozOxkUlFKUzDjkMBhLIr67cdHylsTJHX+Fz173IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8Rtcin4iB2oFB+HoXaI0qNZm0Nfm/l1RxnWkxWF1cswLP82QA0J2QPFWv/mFU/v8
	 qrylBKe2DAECwHAg+K2JzuHc+HEMsKmRBF2jCM6dUtsaM1n/ofod/0myqdC7ox791D
	 Lep0V0hH6aXVkpaw8W94CyaUhFl25VNizmNhSStg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0109/1191] Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:47:17 +0200
Message-ID: <20260912065550.633803589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -546,6 +546,7 @@ static int bcm_close(struct hci_uart *hu
 		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
+			pm_runtime_dont_use_autosuspend(bdev->dev);
 			pm_runtime_disable(bdev->dev);
 		}
 


