Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5402347F2CB;
	Mon, 31 Aug 2026 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184746; cv=none; b=krVWHQxotecCPqTo2rFfBNhx9Wvpzyhn7uqM62Qxm0DMOgvAd5xgr9LfGj5GU2qY02jSLMR1/6F1i4Mq8qRp4t4AvDGeUMe2AhOvt29woS7ZxkWhJDrKsQviGBtcBx96Ds1n0l6RH6Ad1itFpFoi4Cn+tgpoxsm74gKo0Bye8Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184746; c=relaxed/simple;
	bh=vWfhXLi2E8f0EfGV598mm7YcxuT9nZmxuP4GHDCM6Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+G7k2eTEbOeU1KsMFLhjm80ZROkhN+9XepteLco2Po+1ucyuzLKV7N0yWcP3t0gS1w6VRtvjJLCHVF/dwCSnfTN8px1WEjiHIRkOitBZajFpj2vLiWcV8kLB3g3atbEJszgqQFPUfj6uMkUvy/knLyf8UBw6/V6o6sqEijJaz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+ruooUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+ruooUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA651F00A3E;
	Mon, 31 Aug 2026 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184745;
	bh=9hUyMTBPcs2yqkE+tvGV5NtoEI+eCBKOJHJH2i9iBsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+ruooUB29cuUWNdYpPb8aX5Qcs6t0JsXf5C3rks79LXva3IIkZQBN7JE/wuPoi9b
	 Y765Z/A9Sryp7/ukd+oW3yJOBQqf5/2u/Dm9mqC3pzi/Djxa/FZjGMaNnp0034i1Do
	 pNmFCkCBgDCleKVH6UNIwVl2z3QDFx9dwKbqFxJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/92] Revert "usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal"
Date: Mon, 31 Aug 2026 15:34:05 +0200
Message-ID: <20260831133359.851200475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

From: Ralf Lici <ralf@mandelbit.com>

This reverts commit 4476c73bbbb09b13a962176fca934b32d3954a2e.

The reverted commit uses disable_delayed_work_sync, which was introduced
by commit 86898fa6b8cd ("workqueue: Implement disable/enable for
(delayed) work items") in v6.10. The function is therefore unavailable
in 6.1.y, causing configurations that enable CONFIG_FSL_USB2_OTG to fail
to build.

The upstream commit is unaffected; only its incompatible stable backport
is being reverted.

Fixes: 4476c73bbbb0 ("usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal")
Link: https://lore.kernel.org/stable/20260827154302.706689-1-ralf@mandelbit.com/
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-fsl-usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index ab4df5819ef88..972704262b02b 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -987,7 +987,6 @@ static int fsl_otg_remove(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
-	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 
-- 
2.53.0



