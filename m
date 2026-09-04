Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7964D3B7B7B;
	Fri,  4 Sep 2026 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499237; cv=none; b=Gp+bjdg5fArbNFkclKH7f2KSctK9bzGDgjQRmp3G2MKmXnka5jTrkUWhwNZ39E/9nIrUhOUAB2d6sJdlDFxqoM44qVJrl/HYNQJdSDKuB2yBh8kGwWkZu+MIXpGNdWWzxjOTIODKkM1EbEZUcTKAzx6i+OGS34cU6UF8y3Bg3g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499237; c=relaxed/simple;
	bh=vOwmmu8I+CvK6Gb/1n6ttdojGHhYchA1kgXsExb5wYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo0Uho1RRa9Lf1GD9DmSpFrztn+0mFobiVo7q3Cjgab57HCsa3UtTmGkDk2IYrs2mf8HAIp9NiEiiCw79JGrrSw/4Udc5ud+mbnLuG6lS67xwgBcIhGRpGl08HSafbh++oga2py3OuOT/Ki6bJQTgRmPD8jCxHkSp47krMGJtGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdsbmLZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdsbmLZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A1A1F00A3D;
	Fri,  4 Sep 2026 05:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499236;
	bh=vTjofeV3ozAnm1FSyHMTxz60cr16i5ldcAaSpiKCAeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdsbmLZD2LPPKYyEJgBedb54H4Epj/SdgOfaB45QYF32pXzY3Ht6XqmpZOp2enrXV
	 xNqy1h0Vat94GNzWcgV8bu/YP9pgfK84KvjktFfVog3RtkQ22qPHPvfPaQrhAxsIu0
	 dAG8UKbMahpQVbY4SX9ppQs10yp7fmI/onxq+MDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 345/713] Bluetooth: hci_h5: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:55:13 +0200
Message-ID: <20260904045811.564577891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 853a92b97ca547a7ddd9790ff90651b2fd943498 upstream.

h5_btrtl_open() calls pm_runtime_use_autosuspend(), but
h5_btrtl_close() does not call the matching
pm_runtime_dont_use_autosuspend() when tearing down runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during driver teardown, this reference is not dropped and usage_count
remains unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: d9dd833cf6d2 ("Bluetooth: hci_h5: Add runtime suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_h5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -1023,8 +1023,10 @@ static void h5_btrtl_open(struct h5 *h5)
 
 static void h5_btrtl_close(struct h5 *h5)
 {
-	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
+		pm_runtime_dont_use_autosuspend(&h5->hu->serdev->dev);
 		pm_runtime_disable(&h5->hu->serdev->dev);
+	}
 
 	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
 	gpiod_set_value_cansleep(h5->enable_gpio, 0);


