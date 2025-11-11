Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397E91D86FF;
	Tue, 11 Nov 2025 01:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824217; cv=none; b=PeC+Sdl1Cjy6Z08RaAv5293S1MWBpGEaJCP3K5kpya4RNTbcCKQpkcrBpxpbr5QWH3a98Et4XgGFR+GKf4xmcrFOen68fZEiReIskb3spfz6i46waJDFdgwEIrmfQHvozD1TXKogbK1Gi4+KdJ+kGtWFtfk/c1ad3EXjhe6RfiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824217; c=relaxed/simple;
	bh=xnZoQb3S24EmBYvRB1nnTtWTJd58//duj/zQ0tZnEEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh5AVamUB06V8+HsRA1n2eLPeSjoADmdztrnYiPqgQhGbPiEmaM3VZogSQ6CHOC+W7/yeGxABvY+tBuuHn0dCCoBRhrHopWFN2ytCsrnxhsjS8ZwJJuoS1BCRx7TyWknJklRwWtgcdWD06G4+c7gSUThrC8FgZzY8Y5RmjgLQ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBZzeWeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBZzeWeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9899C116D0;
	Tue, 11 Nov 2025 01:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824217;
	bh=xnZoQb3S24EmBYvRB1nnTtWTJd58//duj/zQ0tZnEEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBZzeWeTOTwndKEGoyQDn6ssaMRkksBuFT/mMcSNh+at+RCaRzWQ5++w1TqKovoNZ
	 h9j0CA2ZoBHD13oyQPvm/S5rVdcPytSO6Rq8NxuDUHyOEf3U3KtJWqTeX863dVe/UV
	 17zD7PNUSLyFI2GlQpTFDGP3Vd88vZsT50QmTNl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 464/849] usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget
Date: Tue, 11 Nov 2025 09:40:34 +0900
Message-ID: <20251111004547.645695089@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 55f95f41b3b4d..0252560cbc80b 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1976,7 +1976,10 @@ static int __cdnsp_gadget_init(struct cdns *cdns)
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
@@ -1998,8 +2001,9 @@ static void cdnsp_gadget_exit(struct cdns *cdns)
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



