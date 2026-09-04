Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB16737C106;
	Fri,  4 Sep 2026 05:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500998; cv=none; b=pd+DzgR837qsARNLbLSEgZvAW5hhOs+sxp0yJf76b5d/IjIJ+zHvGgeJDljPYNXJFEUox+dhKyquewknF3OSbF9qaTYBS9a8qJ1V0QpEild1WMfRIH8SPpaIpEDiR31F5rOaHM81W/l9cmuj6hl62W3pUGXNIggFMBiLtQOtdmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500998; c=relaxed/simple;
	bh=MC2IwNU32Ge7/iQRs+N7I9Uhtd3vxqDNC6cMDnqvoeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTe1hVGDpww0cbZ+zlpH7MgUOqJ9R9s7LfFwRbCCfvLKKVhJGney4jkYRYRQ0TPhBJGVpHY18kmf0v4XHLjbvrWKk/tcqh+GVOQ8KT5mmba6sGXtsKwlnMCTB9QtN93pZtlwP72RZ1Srok4rFWYjA4w0KYsyxFYGxYPRP+QMmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXF7aXPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXF7aXPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB51F00A3D;
	Fri,  4 Sep 2026 05:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500997;
	bh=nH36wFhCLHxH/T/AqeciBXihemL0goX/0aDUv1WLqHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXF7aXPLZbOOl97dGzZATDQH4n6AuH+7vQXuwMZFUz22dikz1QVDRakQzkOkb23r3
	 TEIza5pLsDHVJHcCkHNBke+dVIMQqEV6Wx0kKpGPY9o2685Bp+n8KyIjkwTqlUSaC3
	 KlU9bcSl2XmLZp83rHVLMVL6Q3cZaSLmX0iZdoyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 252/552] Bluetooth: hci_h5: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:56:49 +0200
Message-ID: <20260904045755.374207091@linuxfoundation.org>
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
@@ -987,8 +987,10 @@ static void h5_btrtl_open(struct h5 *h5)
 
 static void h5_btrtl_close(struct h5 *h5)
 {
-	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags))
+	if (!test_bit(H5_WAKEUP_DISABLE, &h5->flags)) {
+		pm_runtime_dont_use_autosuspend(&h5->hu->serdev->dev);
 		pm_runtime_disable(&h5->hu->serdev->dev);
+	}
 
 	gpiod_set_value_cansleep(h5->device_wake_gpio, 0);
 	gpiod_set_value_cansleep(h5->enable_gpio, 0);


