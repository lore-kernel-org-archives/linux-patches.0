Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6293339B41;
	Tue, 11 Nov 2025 01:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824989; cv=none; b=ahRrQO2X7SzqHcRxg1Q7O+/LV2Pw4dceZEkksuBj0pXy7HmsZulAoK7lHhwe/9RhM9x+CMvlLJ8eGHVZUJHbm+MXq9MQeMI1gXJbi8xvtwSmKOfoP7PZ0guz1xGdv/ktty6k+UUayDvjzwekvi6h5beL1/LItSRBvuS5/tzEp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824989; c=relaxed/simple;
	bh=7i9nFh/tbPBoNcB4fwYpzAw4coBj6sYgvma9m8eEgEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdnnfg1DeB0WcfuLTL1DNBRQfZF2aZXRbNL4exi1ifxuNbPVJRpIp06XtmLlgWJ3qB0ADA1KvygOHHoVPTBM5PpSjl5zt/Yx7Msc21d1rGyP7M+kDupQedUMA+oPM78RegSUjo1HmQQtyeqSV3KQTGObsiQrRiyHQxIGhkthEFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1xs4TC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1xs4TC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027F5C113D0;
	Tue, 11 Nov 2025 01:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824989;
	bh=7i9nFh/tbPBoNcB4fwYpzAw4coBj6sYgvma9m8eEgEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1xs4TC2LlgdirebpH1jdjCq0IlqXZE2+xnAiCdEDT2z6I3Bru4sjeNw3cdriWUmb
	 7UnRmhLMhY5R8Aquk1Ptnq8NkAY2/M25Ev8q5bvIbPMTMG2h+JISx5/Fp312ML7N1X
	 OA2Hi7DkDjHCtdMEdXMohHfYUdC8mKAF/OQUVeFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 580/849] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Tue, 11 Nov 2025 09:42:30 +0900
Message-ID: <20251111004550.443061266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 41cf11946b9076383a2222bbf1ef57d64d033f66 ]

Allow autosuspend to be used by xhci plat device. For Qualcomm SoCs,
when in host mode, it is intended that the controller goes to suspend
state to save power and wait for interrupts from connected peripheral
to wake it up. This is particularly used in cases where a HID or Audio
device is connected. In such scenarios, the usb controller can enter
auto suspend and resume action after getting interrupts from the
connected device.

Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250916120436.3617598-1-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 5eb51797de326..dd57ffedcaa2f 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -171,6 +171,7 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 		return ret;
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-- 
2.51.0



