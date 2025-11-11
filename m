Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7577342CB0;
	Tue, 11 Nov 2025 01:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824073; cv=none; b=UI+Wv9EwYTArGK6yeIfJOUqMwv/uBxMHppY4GoC/VKU+G7VVwVVNgW6DJAWu9cn2eDpSx8T3ql6bn/nX/WF4LivDlioFnp0yvESOjwHJqiGgk062HEicjJT+DOQUvTEZI+jI+TCsL5JC6H6+7YjGB1OWzaaHtxOFjZGIQKDO/Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824073; c=relaxed/simple;
	bh=MacGqh0bDSfWe4gq+vBtZeeWQznnvsnbGez43zThGWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhiC45s1paSIVXIDN6kpdOZzMxw3nteVsLTcTTmdlTmNQc4JCIPAEn/5eLmmZf7KiUE2pWaM+z5eQ6FKwugLLAoTaeKVico9OwNYHt5/+nO370w1d061FtP20weItm5mJ1dZ9SsCMfCOXxul47+DZDij5+TwFg04U4NHRhSoU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2LxGW0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2LxGW0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A466C4AF09;
	Tue, 11 Nov 2025 01:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824073;
	bh=MacGqh0bDSfWe4gq+vBtZeeWQznnvsnbGez43zThGWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2LxGW0fxOXYkcoJZsdVS6qN083+l8p3QOmHWqY3WM8UXZVQt9aEUy7akTiuTUYAD
	 yRMcxzxANl6KfaWjerNXl+Vbx9wKZpYFwOPHZGkxOE9bZpAyaQ7/Bs8v3UR9r7gRuc
	 dADT46t7ZxnTfiNubG8kWGJ+9d98LmJHN3KTG7zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/565] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Tue, 11 Nov 2025 09:43:58 +0900
Message-ID: <20251111004535.464290705@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 8cf278a40bd91..448656d68e494 100644
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



