Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BE5347FD7;
	Tue, 11 Nov 2025 01:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823749; cv=none; b=df89tlerslHDjPrPBt2SmlN9g2XqLBWTJ+KnAxIJ9RON6m/nrqKJkD+NbpnOqH2/ypxC1sXGEB228zU/z4SCru6eYshOFuKV7rO5CCxmGgvz20om/PRjwOWQyfxfC9c1lE6lRwZm961bPpvjdFpuSjPTh6UXfXwKr19ssCuNs20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823749; c=relaxed/simple;
	bh=68nUeEU2oCdEHSvIdnieU9vHM6nQ1L7WYBo0m9y/Y8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY5fI0tJJ8dujo9GwujxaXi5UkMm7EhV7xfqdsUkX07RYDQSROaNajIQQ3dhw423vG0TpGFW3dQCVD2gQa8fRTYYDfajRd/lMKeSd0aqFlpZJdFq2O0Ma8OlvlHOJzRNrvmeF9MDJUVm/7hHSrB09sSfnSFNLrCD8poXqqTmSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0GEu69r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0GEu69r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A558C4CEF5;
	Tue, 11 Nov 2025 01:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823749;
	bh=68nUeEU2oCdEHSvIdnieU9vHM6nQ1L7WYBo0m9y/Y8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0GEu69rswQtQGSMdWtQNVxVB0t9i59/8YklkdCttLimd4U55NFe2Xed8Xdt/w4jg
	 MuNjVI+EI1PnULfjaVkkeRKG1SP+A/zb4/31cvYq9p9b7JyYJg4LS1Ry39e9uSOabC
	 lD8UhP9zHHSSDzCWVwjHtNNDatgMSxylwzJqUc0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/565] usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget
Date: Tue, 11 Nov 2025 09:42:48 +0900
Message-ID: <20251111004533.903981238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 38e693cd3efc0..fb192b120d77f 100644
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



