Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E21346A08;
	Sat, 12 Sep 2026 07:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198194; cv=none; b=EJ7cWQH2/X8p2eckVBKPcbWVj/V17v+9DH/LEwn5zw6NPemuWsu9HRDc3FPlnHsziT12v0p3Qqtpu00Z47nhJkPQmHW1yBJ1ERJoLA7fsL5uvUZqazoWK+bJFazFKxcb+T5bYAdmpOo79X3YDqU8+zPlO5a5PVMoD+wg8C25FCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198194; c=relaxed/simple;
	bh=B6hmdxIokDoTBmkp6rlcOmSQpDVLTBlbFvnwVZu+NSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh5cgawdvSH6L97+hETErd3c7zYRWP8Yr2dis8lwhRar0XjPWNo2l0UAVNCaoyPRrpaiu9yP68KOEkXKdFpg9fc8Q58E7gWRTNggc7qv1T/pjU9nKJEpHVAJ7syjD/kNB/ETM3IL+WfJ4VhvITm5yGCs2yms0271e4jUkyNwuB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Rg+A1oV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Rg+A1oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6FF1F000FF;
	Sat, 12 Sep 2026 07:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198193;
	bh=TyUZYgHyyMFXCr+5PWY/XhyeIs6X7btOJJxBLqecr4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Rg+A1oVwF6pOW/0t8s8Did2nMp5mnK7aXk9321lchYBl/nvxyZP75lmJQjqc8VGF
	 i0odHnRNVdFR8XkuE1iWMDNKyBfJ2YrBCn24j4/gNQPiPw6fJ8sDy+aLpLZUpIKEYb
	 u+d96xuhMQTDBXU0lsb5t5bnm8meP3H/w3a8t+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0331/1815] usb: renesas_usbhs: Fix power-off ordering on unbind
Date: Sat, 12 Sep 2026 08:34:41 +0200
Message-ID: <20260912065656.696691363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 8c93bde4b8167..51d3035f82bed 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -813,9 +813,6 @@ static void usbhs_remove(struct platform_device *pdev)
 
 	flush_delayed_work(&priv->notify_hotplug_work);
 
-	usbhs_platform_call(priv, hardware_exit, pdev);
-	reset_control_assert(priv->rsts);
-
 	/*
 	 * Explicitly free the IRQ to ensure the interrupt handler is
 	 * disabled and synchronized before freeing resources.
@@ -832,6 +829,9 @@ static void usbhs_remove(struct platform_device *pdev)
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



