Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D37258CDF;
	Mon,  1 Dec 2025 11:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588558; cv=none; b=EBrjD72fFgJwOwGmLtPbL7HLcYcUZNKiKRINSkt6Gf4dJygTsdahoa7ArSNcf4/Qm6G/9Eqjt3h2DUvsbEo0S9J0mL6UZyL7vO5P8vFTEmkFechaWI2/ARW7oJ+MWgcjKNqgfjsi7Ce+wGz6iJcPjPnYqE3pjAE3LlKbk3UazVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588558; c=relaxed/simple;
	bh=8OKBeeMoOFiKXl+3jTqDbbb70PQm5uJ7h9jJ2Ex8xs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/zbRST8o4WhWpD5+gZfX+kP4mY0dVZwWJadKdqz+IAQX9vcvQ7i9Uc5uB0anemAMT4O1H9uW8A0exA8sr0DUW9tUBwlUSu2TZ46oyl5ZQWHPUqdGnyG1uN8ppdlF4WjOXBNE0UGbIyT4MVYkgtO0CUoztJKEYy/Qrd50u6o2EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7aWWOup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7aWWOup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA018C4CEF1;
	Mon,  1 Dec 2025 11:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588558;
	bh=8OKBeeMoOFiKXl+3jTqDbbb70PQm5uJ7h9jJ2Ex8xs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7aWWOupES7w7rd5Oa7sNVfpbX/OfwR8PgSZjal6SewoNNOjBjSJoriJ1T40v1x80
	 Aj7KPVgzj2eBV4cBpTdGDdhuEOdOKusBiXBieUqqhnpegM9bsYoQxqtwL5kBtjCjlZ
	 U9sNN+7qbibepf17kmSPx6FNmb/eqefPvPgAwcfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/187] usb: xhci: plat: Facilitate using autosuspend for xhci plat devices
Date: Mon,  1 Dec 2025 12:23:19 +0100
Message-ID: <20251201112244.530812700@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 73570b392282d..85a39a4b85ce2 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -222,6 +222,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-- 
2.51.0



