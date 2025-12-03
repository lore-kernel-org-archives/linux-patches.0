Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63122FB62A;
	Wed,  3 Dec 2025 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776244; cv=none; b=WUX8jY82K4j0n3ef5lAGEfNyZsLKOBp5PLssoY8aF+i4CiP5mdisbY/Wkd/ZeMo/Hj9IeoyKBCOzOL+il0dM2VtKS0p6rUY01nkpRAHbqUKRzDdhAMgOTi5LIo9DLviTVI0OW50LkWDK/q7SKGfDZpeGz+9j3YVX2pUJawxxwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776244; c=relaxed/simple;
	bh=9ijtoy9qnF2bhvjnxiWIHSvqdq9TQcFJOX3eDa58L2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjIDyj0SyVRRj57EZQWrYjrFGdm7JAHej84ws2k9g6pZGf8MiEiW+GusqxLoodAkaPsiGTcR0KhZDWi7s6iOsogEpEGG0msy3lUgNzTjM6VW3FHKAT+0Uwk7fWuVoTsLcMMt35nf9GW4XLz1tpzHmgrweLMDvABwjl/ieLeMgac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8p5eSUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8p5eSUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9C1C4CEF5;
	Wed,  3 Dec 2025 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776244;
	bh=9ijtoy9qnF2bhvjnxiWIHSvqdq9TQcFJOX3eDa58L2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8p5eSUAbXHHSSasYv4pCWcqgala8O8L28kHq1VPYVuLaJMTDPokXzlwB1QP3KpIA
	 nYbf45rpZP8Sgz7QLFw1AZVKNO3Xdaid0CSaTQQWY5OwGZfcg0iTKmq4HG+jbo6rNX
	 qs20/CsLFBHABaWNFcVRS97h/jmce3gttxvyKmIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/300] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Wed,  3 Dec 2025 16:25:28 +0100
Message-ID: <20251203152405.209480791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index daf93bee7669b..c6ef7863c3e97 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -242,6 +242,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-- 
2.51.0



