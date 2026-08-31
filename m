Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E78A42E43F;
	Mon, 31 Aug 2026 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184492; cv=none; b=sgB+nS2IwbrZAFj3H/aH3QlIh+/qCw/f2929mf85XCo7QZtUg6MY2mxixcc4K2wDKvhk77/q1zsIHJ7tP/hAztv9xQvoaTqbH/YjhwWwIi1RzyFfgsWX/e3HKxvJBOfz+0NxXT08G3GFAWNidgf+MlVEg5F18rjsDFeGJJLH8O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184492; c=relaxed/simple;
	bh=VnxZnaAjODe6Vniv0gAJUEgt2/pHZbGu0djXJUfIGqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFgNMBe/1F0vEEOTj3ZlGNCddREzDs419HdTD0ovfYPSdzFHqGYGDvlFfVn37ofCWoXUCUxjQAhjKltG+bwXUSZC1lWQdD026ACDAsLR/7sg7E39HEpUR7ojcgBJUd4naxpXeYFVPrjqt2ksyI91+j8sjpl8ivwthEAKXEfUCok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft3x2iPO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft3x2iPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9156E1F000E9;
	Mon, 31 Aug 2026 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184491;
	bh=JVUPwsdtOGQXSMUm6aBIXoXaGgyBbOXi26w1JEEGC+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ft3x2iPOWR37MF484mHNws1B1n3v1Ie2C0pjEeUHm3E7A9x5ro7zlfyUZxWb9GdhZ
	 NiBLWwDv1oOHB9AyD3Z0SG+xZgv4YcJqoqPLBHEHU9/kchyA+m8N3g6sVtItUbck2y
	 ZIHvdWynMyPIZ7433S1UYo+mL+2mnKHRvIQZ0yQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/91] Revert "usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal"
Date: Mon, 31 Aug 2026 15:33:53 +0200
Message-ID: <20260831133359.750156338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

From: Ralf Lici <ralf@mandelbit.com>

This reverts commit 319f7a85b3c4e34ac2fe083eb146fe129a556317.

The reverted commit uses disable_delayed_work_sync, which was introduced
by commit 86898fa6b8cd ("workqueue: Implement disable/enable for
(delayed) work items") in v6.10. The function is therefore unavailable
in 6.6.y, causing configurations that enable CONFIG_FSL_USB2_OTG to fail
to build.

The upstream commit is unaffected; only its incompatible stable backport
is being reverted.

Fixes: 319f7a85b3c4 ("usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal")
Link: https://lore.kernel.org/stable/20260827154302.706689-1-ralf@mandelbit.com/
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-fsl-usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index 552899fa985ed..79617bb0a70e8 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -987,7 +987,6 @@ static void fsl_otg_remove(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
-	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 
-- 
2.53.0



