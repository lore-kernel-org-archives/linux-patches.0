Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E995134DCD2;
	Fri, 21 Nov 2025 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732898; cv=none; b=njRnRJIfQfDW2ASD8d/2vKcvVRVZgrhY4WzX7xDvmM9AOjNUxZHDPO8ZARxDP7PwpMMRZ/+yEIkF9rVngnVqvDjB58wdKY1IIZqsfzm5i2L4C3mPOn8moaOF92t6OAtPrfDcByrtGmhln+h8vZ2SG4mjTuMYtaCogu4JxCR9BDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732898; c=relaxed/simple;
	bh=9s/ZnYcz/XlufUqolKrU4aebWuJSK7QgWvwWuDQtB1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni1X4tp3mUiI9jvkg5CVPo1HPkUYErrLkaw5sicTmUdr5zG7K16E7CK0iMxwOuIVCDo3W5YDGILcnCxhDaLWpneFZCFx9rn4B0EkEb5XRm/nY3WkfqswxR6iXG25N3UDg4UYJ1KgulrgGaRRUd/xzeI38n52DDwvGKsncvjVlQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOeKzaWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOeKzaWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C0FC4CEF1;
	Fri, 21 Nov 2025 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732897;
	bh=9s/ZnYcz/XlufUqolKrU4aebWuJSK7QgWvwWuDQtB1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOeKzaWTG+jioMLrUdsnLqf6JwApLiL7hfm414xm2Or64sSFoQvJo/w+0gotq5J3l
	 bhWgIRBHntirTcTXFKDry8qnEl5mRglHQB5b7/XcWlzWMhUWRH9MKEfX7XTqIYnjz0
	 X80fGue2qeQAe7dKChwdOPJp/zu4hdldRvTCYu0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/529] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Fri, 21 Nov 2025 14:09:07 +0100
Message-ID: <20251121130239.841851823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b350ee080236e..64383566cfb77 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -168,6 +168,7 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 		return ret;
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-- 
2.51.0



