Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024E54071E3;
	Tue, 21 Jul 2026 18:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660294; cv=none; b=iQYkl8cXr+CbIUf6vblJO7i94Lq4kB5q0THi8HTLgDaGTMIUz+Kzz+FimSkgM67Cgqae+8FEDV782bmD3mpvNvVwPyA1fKOtKhbWN6nafNW4ZIIXGM8R3oyA7WEYvideKYa03WlFGAQ6w1aViLXQw/JMU+A6mb3WtMxdTOCpoHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660294; c=relaxed/simple;
	bh=WQ3Gdqw6rqoIjWkQMc/ZzTHthl2d11JcPG8OBeiPZ20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGsgUxn3cMiWwv1+S5s/WP6GSt4EK9N3kMVJDmG96KsAta+BOclJAH+wVJCCY5Dqt5UfkiUk3FaKqHN75Gx4qMMYfKKp5bsHUhIlvenlrw/jhy+gdKDCQmqNp6wnkfNWbMVdgoBGabimC0/WVScE7ZEGnd4ABh7om77XzKk5ufk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3txCWBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3txCWBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288F01F00A3A;
	Tue, 21 Jul 2026 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660287;
	bh=aj0BHO3kHX8E7IrN7ZBbNbLVZGzLuT4yG0/XwwmAYGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3txCWBPzu+iPTnTbq9Qv5hj2hYuiH5RVzoVbLrKJ07ZH+X//BbCfE1wqxYKngtWQ
	 vXIfXce55T9GO04OoAFZldKinTRaid4Y7keQWYJsLSolfK0aqrVlu53Yjbi30Ob3Q/
	 dlC02w11vR2U6czBXMGDp1zGXsLg7vvQu1cs9J6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0880/2077] PCI/pwrctrl: Lock device when calling device_is_bound()
Date: Tue, 21 Jul 2026 17:09:13 +0200
Message-ID: <20260721152613.554828315@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 548f3d287d92bcbc908b02db57fb889f8a8276a0 ]

The kerneldoc for device_is_bound() states that it must be called with
the device lock taken. Synchronize the two calls in pwrctrl core.

Fixes: b35cf3b6aa1e ("PCI/pwrctrl: Add APIs to power on/off pwrctrl devices")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260518100700.47581-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/core.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pwrctrl/core.c b/drivers/pci/pwrctrl/core.c
index 97cff5b8ca8852..cd08d590483b86 100644
--- a/drivers/pci/pwrctrl/core.c
+++ b/drivers/pci/pwrctrl/core.c
@@ -161,10 +161,12 @@ static void pci_pwrctrl_power_off_device(struct device_node *np)
 	if (!pdev)
 		return;
 
-	if (device_is_bound(&pdev->dev)) {
-		ret = __pci_pwrctrl_power_off_device(&pdev->dev);
-		if (ret)
-			dev_err(&pdev->dev, "Failed to power off device: %d", ret);
+	scoped_guard(device, &pdev->dev) {
+		if (device_is_bound(&pdev->dev)) {
+			ret = __pci_pwrctrl_power_off_device(&pdev->dev);
+			if (ret)
+				dev_err(&pdev->dev, "Failed to power off device: %d", ret);
+		}
 	}
 
 	platform_device_put(pdev);
@@ -205,7 +207,7 @@ static int __pci_pwrctrl_power_on_device(struct device *dev)
 static int pci_pwrctrl_power_on_device(struct device_node *np)
 {
 	struct platform_device *pdev;
-	int ret;
+	int ret = 0;
 
 	for_each_available_child_of_node_scoped(np, child) {
 		ret = pci_pwrctrl_power_on_device(child);
@@ -217,12 +219,14 @@ static int pci_pwrctrl_power_on_device(struct device_node *np)
 	if (!pdev)
 		return 0;
 
-	if (device_is_bound(&pdev->dev)) {
-		ret = __pci_pwrctrl_power_on_device(&pdev->dev);
-	} else {
-		/* FIXME: Use blocking wait instead of probe deferral */
-		dev_dbg(&pdev->dev, "driver is not bound\n");
-		ret = -EPROBE_DEFER;
+	scoped_guard(device, &pdev->dev) {
+		if (device_is_bound(&pdev->dev)) {
+			ret = __pci_pwrctrl_power_on_device(&pdev->dev);
+		} else {
+			/* FIXME: Use blocking wait instead of probe deferral */
+			dev_dbg(&pdev->dev, "driver is not bound\n");
+			ret = -EPROBE_DEFER;
+		}
 	}
 
 	platform_device_put(pdev);
-- 
2.53.0



