Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06AF331203;
	Sat, 12 Sep 2026 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242485; cv=none; b=Ytk2JlvzYNvVvwZdeXnvGH0yLhD8lqlnRZqaQR03FQh/njnyjmBsvRKtwZsV3a5jGegngjx0oREyq1A/CqQYv7eUXvQq00iVOjLXYdaSCe+F3vMrkDChKjtm91i9HX5qmDLu+DhPebL8BWdJwUSF0+hErpOMAq/rZlgUMeYAZ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242485; c=relaxed/simple;
	bh=RK3yP+NCTM14DtDQWO9LWNx39Degf5nTVF8S+sziALU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlTtEOFYZxfwOPRkPfcOwYz9sY65aLk3VkGBdxF3gLlpLTYDvNxhsv3UBmSt8301hoACcljefAxjAJHOVrkfNU6vjp05YFxiAx6whiUFpG2zsyoSHjmaMwQxQrXvUK2z/ml0bxssdxpCdVdp8hbW1V7L20f0gZhiJ6/gYKWPDqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jT7Qn8tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jT7Qn8tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89CC1F000FF;
	Sat, 12 Sep 2026 19:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242484;
	bh=L/Ibkfm50wK6HxX/Fz1I5e8Z7vSAmvxY0csy/644aVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jT7Qn8ttBF+oBR8rUhdOlkK0dvzq7Yc+GkFBgayiftcbrjWz9MtCC3omzLKNvzA9j
	 b/LgxpVz0uYcM5/g5OyVeaGcieN4L8D+Ss6fqPhVpyYBnOaYbKhmPLUgl4ueku+2u8
	 MNnLiWiQB0jC9Ud7Le8GzEreCS9ybmkZ5cttUc3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/798] usb: renesas_usbhs: Fix power-off ordering on unbind
Date: Sat, 12 Sep 2026 09:00:46 +0200
Message-ID: <20260912065526.731294779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 8fdb7ea49401c..780f94020d790 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -802,9 +802,6 @@ static int usbhs_remove(struct platform_device *pdev)
 
 	flush_delayed_work(&priv->notify_hotplug_work);
 
-	usbhs_platform_call(priv, hardware_exit, pdev);
-	reset_control_assert(priv->rsts);
-
 	/*
 	 * Explicitly free the IRQ to ensure the interrupt handler is
 	 * disabled and synchronized before freeing resources.
@@ -821,6 +818,9 @@ static int usbhs_remove(struct platform_device *pdev)
 	if (!usbhs_get_dparam(priv, runtime_pwctrl))
 		usbhsc_power_ctrl(priv, 0);
 
+	usbhs_platform_call(priv, hardware_exit, pdev);
+	reset_control_assert(priv->rsts);
+
 	usbhsc_clk_put(priv);
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.53.0



