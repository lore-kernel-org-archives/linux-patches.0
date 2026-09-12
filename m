Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8684478870;
	Sat, 12 Sep 2026 12:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215258; cv=none; b=KBCbtUwrbuYtCWQTe5hqu9HVz38aXygw3xGNMyRztLXts6YgCwhUV6LQNQZao2nqn5oaojtxRrCEFAr4JlZIgGV7c4mn8Zt0yV2uYySUNdH5Ht0xexv5yLCum6gVbTuPTMsauWipPY2lYW4q8URhYRSZNNRDeN8YLQCG/A6vbgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215258; c=relaxed/simple;
	bh=ENk2jgZ38SuZRBY9fWVfoDzNHAYQjIeWEXkgkr3+zEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUjI6CnDCs6NZC6c9CWso09d4nFhrUdHlaeERFuOjt1DJ4LlJsJuEF7k0uc6K1z0nEAlTO1bxPxs2aZ38nbX3RvA9UVRAskEf60g9efE/ktusweNbTviik45TiHB7QuS0AnpS72utJPTp7N4JP0goXoICsPFHAyThiK7HuLmDc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uoj/geGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uoj/geGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5021F000FF;
	Sat, 12 Sep 2026 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215254;
	bh=MtlObgMbFVxbXpf2cmx0tIDWPGUxy1comSkSvAOAh6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uoj/geGd+RUqKDPCSTlRkgz1UGdfNAUF11AqIiiMfnn70sIihBLfR1jcoUFK9BLeL
	 Jl1Jyv7f+qoNLNoSbEcDunaNnewpT9+SyEluIiiCd2LXNNAllTVxtmGDrPRNpq/zgc
	 a7p4oQhenA7a8rFugKhqqTU7ujh34Pdge+O5I9mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0494/1376] usb: renesas_usbhs: Fix power-off ordering on unbind
Date: Sat, 12 Sep 2026 08:48:40 +0200
Message-ID: <20260912065618.549471103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 589b9e6f96be6bd8dd0d45fda8e948c31dc2fe94 ]

Move the usbhsc_power_ctrl() call to before hardware_exit() and
reset_control_assert() in usbhs_remove(), so the PHY is powered off
while priv->phy is still valid, rather than after hardware_exit()
has already cleared it.

Fixes: eb9ac779830b ("usb: renesas_usbhs: Fix synchronous external abort on unbind")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260702073832.175047-1-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/renesas_usbhs/common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index ef9c3bd950ca4..75600dc6703d2 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -809,9 +809,6 @@ static void usbhs_remove(struct platform_device *pdev)
 
 	flush_delayed_work(&priv->notify_hotplug_work);
 
-	usbhs_platform_call(priv, hardware_exit, pdev);
-	reset_control_assert(priv->rsts);
-
 	/*
 	 * Explicitly free the IRQ to ensure the interrupt handler is
 	 * disabled and synchronized before freeing resources.
@@ -828,6 +825,9 @@ static void usbhs_remove(struct platform_device *pdev)
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);
 
+	usbhs_platform_call(priv, hardware_exit, pdev);
+	reset_control_assert(priv->rsts);
+
 	usbhsc_clk_put(priv);
 	pm_runtime_disable(&pdev->dev);
 }
-- 
2.53.0



