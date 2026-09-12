Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6062594BD;
	Sat, 12 Sep 2026 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229430; cv=none; b=YqClXWGxbF17mzC9G4egmOfWYkzWKMq9lnPrKgRNy/j0j8REYfqjpWYNgIgJUUILFE7PWRsfn1mYnc82hCnFSUpdya+dmfA3shfRH1cfyu/57M/XgLRRUch+PdxsI5/XAxwSlVCS1Jb6g/skdRArjANL7qvq5mSqkomzD9mtscM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229430; c=relaxed/simple;
	bh=wwYxF8A9iYky3ZGLkbk+qh9qO4I3CBW+ynd9QXSN3dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F++QMrDhO5ELTpM5Y0G+cFY2OAy28DtO8Ibd/fsjUSZbIHtp5naDi4+Gi/sChVI3aN6YJHMp6b8a7vCVF2Gg8BxJ5Bt1SILRop3eake/BdrHxHl6f5utacDsllUZDYabc5iFzksJRT1GoXpapRdqAQa4xWsuh2BGDcUAsKprLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHEbw6bW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHEbw6bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD201F000FF;
	Sat, 12 Sep 2026 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229428;
	bh=xfHOFM7XLU/OQAqaVkEl5rQ+WvB3AqkMxbRQE+B31aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHEbw6bWb7hIkAuAwjYX2UkvMPMRlwkbjBeHPOZDKpXTDxc5LQl9rOblBtVDYvk5i
	 B2QlE0DouUuCTYu/gejB32rmXr4wpWMrJpTATBP7SdvQ+/HeYRUYUIxDxbrmbISJRl
	 CLw3U3PufxvtkDvEO5ylmJEx9MLlSVTNnUcAHckk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0587/1191] usb: renesas_usbhs: Fix power-off ordering on unbind
Date: Sat, 12 Sep 2026 08:55:15 +0200
Message-ID: <20260912065601.431989552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index cd70e7641d3da..3be4b2f06eac7 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -798,9 +798,6 @@ static void usbhs_remove(struct platform_device *pdev)
 
 	flush_delayed_work(&priv->notify_hotplug_work);
 
-	usbhs_platform_call(priv, hardware_exit, pdev);
-	reset_control_assert(priv->rsts);
-
 	/*
 	 * Explicitly free the IRQ to ensure the interrupt handler is
 	 * disabled and synchronized before freeing resources.
@@ -817,6 +814,9 @@ static void usbhs_remove(struct platform_device *pdev)
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



