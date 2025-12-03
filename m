Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8F1346E50;
	Wed,  3 Dec 2025 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779370; cv=none; b=DtS0SA2FgCR/xjKZe+DknUCVp6GrAzyvcwnBAj4Nq2UhXNLliBqQEossgwC6qsZK7RbyktSkyEf7FDpUHegnIstuPZ/xxPUYMun0H87zYBTM+76tXUJTCyd5EI9ECbzl4LFCIy4e/dklXy12+zjeP1XiwzbZOpT3NqojDdEtEY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779370; c=relaxed/simple;
	bh=q0ATraZIk0BqHNBmERNZHHdL2DOpEbyHXaHMn3OFFsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+DgAFKOnbNpZhS24XAcCGzyoe/EsfbQKEwqWboLCGUzr06a2sF+13nLhJF/Ph23ASo9ZvuaKwXPZs52yrFSZFBWBsTcz91t3k7AlHEr5I+92yuUAjWt5Dh5I5E4O42lV4dKsEx7Hv+BYRCB6e5mahdnANBuhQDrK5ZG2CxykyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymdfhkY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymdfhkY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF33C4CEF5;
	Wed,  3 Dec 2025 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779369;
	bh=q0ATraZIk0BqHNBmERNZHHdL2DOpEbyHXaHMn3OFFsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymdfhkY0sIDTMYIpnhI+al26RbP6iCGMK61g0BoageSM03/e5DEKP60ljMwBvQ9kV
	 F3nsKVz2YSIhesJRwu1VyR1qYXrhnjBZFVOxCtnF2dZBeZ9fzssc0bfmwQ2PZHbAwX
	 M2iu9fbr1NCrnGkwd5956No8LVJMYmt8/PPfnkrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/568] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Wed,  3 Dec 2025 16:23:59 +0100
Message-ID: <20251203152449.402394258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 7ec4c38c3ceec..fe799abf252b3 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -224,6 +224,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 		return ret;
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-- 
2.51.0



