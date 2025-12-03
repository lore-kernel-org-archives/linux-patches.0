Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EE434E74B;
	Wed,  3 Dec 2025 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777865; cv=none; b=PyrNmjbjqmhd8P8JPTzx5Mu8VzKSIxO5yGVVOJaBkgaTwFn9VfHjRtWK96Q6DeNsRXN0ETryEbNNVliyIQ62hBSwCKRrI+R4bEw8/ktqaPE6wEkOEc3BkfP+LuSPGCU2J5nAat+3elqeMlPeaAl6OsM3dMAYKcKhYB6ItRz98kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777865; c=relaxed/simple;
	bh=Ztg4Dth53FC7NT0bZIqWM2a2OdXW7X1nm3+eydv48XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5hKR5fVLvgafyF82+Daa1lO0of+mdkU1yeNvOD7ZhJJe/iCtyxtmp308fCFjFFjvm1xBaOWSnhXxV9vckSLjetoPfNSghO429ohRb/6InHq5ThkO827TxXIr0wGyBpytbHDawSizWsUuLkCZl8lwm+gvpmRyTvPtpONJw29yrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5Tojhsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5Tojhsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA42C4CEF5;
	Wed,  3 Dec 2025 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777865;
	bh=Ztg4Dth53FC7NT0bZIqWM2a2OdXW7X1nm3+eydv48XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5TojhsllD7bPMbEVX149dhcWZkEsGEklVZUL2XY1giNadAT5nLFkf0416IDEBp8s
	 IBYNDuyY7Q7NMdcXLYWBks8T9mjIsJ0CjpowTwUuSfdodrh3U1BioY9iN3Jt8S2GoG
	 PEwlwMTe/e1oXMiiUtGyiFzg5Iy+5OIxH6AWQWAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/392] usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget
Date: Wed,  3 Dec 2025 16:24:48 +0100
Message-ID: <20251203152419.166924484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1de82fb9dcb48..6bd9a2ebf687d 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1978,7 +1978,10 @@ static int __cdnsp_gadget_init(struct cdns *cdns)
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
@@ -2000,8 +2003,9 @@ static void cdnsp_gadget_exit(struct cdns *cdns)
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



