Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD4235BDAC;
	Wed,  3 Dec 2025 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779261; cv=none; b=bwABaVmH4i5g+Jawcyw27+QtSCiZ2G/dAb5FnTntCp9RZLCTyh55t7BwRWh5N4FA3I5e+7pWI/wtuglKPyx4nsHv1xb64urVkH8e1kkGSW6muG0nWuUb9DqEpzAwjyi3RsZMUyapLODY4BlgVroggOG+iS2MzmdbBiB3Qowjcf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779261; c=relaxed/simple;
	bh=smG5r0YBEUDPtz2mO6g8Yp3wWVqi0Gcxvm5+m/QNthA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqYagOw8JFytmyKhuajmksrYERXzPMge7mPZ5VZ/Y041CGM6JjywnAOFTNpSUequ0JMYw9a3ATKfO+TaRfAIJd7KnVrExbax25Hh/BFO8FxeS4Guh/XOPC9uBt0EEsQQIMTrQ2EoGO4yoJWLVT+EG6WuUVgerJW3ct89l2dIUdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1jQB1Vz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1jQB1Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847D6C4CEF5;
	Wed,  3 Dec 2025 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779261;
	bh=smG5r0YBEUDPtz2mO6g8Yp3wWVqi0Gcxvm5+m/QNthA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1jQB1Vzjy6c4eLraj9XT5QhGYRlBPH0KwHCPEaRwuJIrqaA7U40nrtfkwspOXRtw
	 iQ7OVOUnYrJhAFRt/yoU732HbewNHiONKYKjWPO4WySOKd5IL1796cYJYzDQOLDrju
	 uDtBp5nCOcqjMXXqPrhIQqxoiTrIwXujvunDJSEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/568] usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget
Date: Wed,  3 Dec 2025 16:23:25 +0100
Message-ID: <20251203152448.161306578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Chen Yufeng <chenyufeng@iie.ac.cn>

[ Upstream commit 87c5ff5615dc0a37167e8faf3adeeddc6f1344a3 ]

In the __cdnsp_gadget_init() and cdnsp_gadget_exit() functions, the gadget
structure (pdev->gadget) was freed before its endpoints.
The endpoints are linked via the ep_list in the gadget structure.
Freeing the gadget first leaves dangling pointers in the endpoint list.
When the endpoints are subsequently freed, this results in a use-after-free.

Fix:
By separating the usb_del_gadget_udc() operation into distinct "del" and
"put" steps, cdnsp_gadget_free_endpoints() can be executed prior to the
final release of the gadget structure with usb_put_gadget().

A patch similar to bb9c74a5bd14("usb: dwc3: gadget: Free gadget structure
 only after freeing endpoints").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
Link: https://lore.kernel.org/r/20250905094842.1232-1-chenyufeng@iie.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index ccd02f6be78ae..51dac7db52841 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1975,7 +1975,10 @@ static int __cdnsp_gadget_init(struct cdns *cdns)
 	return 0;
 
 del_gadget:
-	usb_del_gadget_udc(&pdev->gadget);
+	usb_del_gadget(&pdev->gadget);
+	cdnsp_gadget_free_endpoints(pdev);
+	usb_put_gadget(&pdev->gadget);
+	goto halt_pdev;
 free_endpoints:
 	cdnsp_gadget_free_endpoints(pdev);
 halt_pdev:
@@ -1997,8 +2000,9 @@ static void cdnsp_gadget_exit(struct cdns *cdns)
 	devm_free_irq(pdev->dev, cdns->dev_irq, pdev);
 	pm_runtime_mark_last_busy(cdns->dev);
 	pm_runtime_put_autosuspend(cdns->dev);
-	usb_del_gadget_udc(&pdev->gadget);
+	usb_del_gadget(&pdev->gadget);
 	cdnsp_gadget_free_endpoints(pdev);
+	usb_put_gadget(&pdev->gadget);
 	cdnsp_mem_cleanup(pdev);
 	kfree(pdev);
 	cdns->gadget_dev = NULL;
-- 
2.51.0



