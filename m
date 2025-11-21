Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694034EEE0;
	Fri, 21 Nov 2025 13:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732667; cv=none; b=svrqVRZphWtRceqmnyplgHlhoFLh3uEyOxmNBoGASOpa/zhwQIeHPGgAlj+L7yLZbDgkl59FupSqiwGLXsk8NmyYa3Xd2qZC2Nu4Qj2oIJpJHdDW8m4w6szxdiVqcI/bwvQ1qoQlOBBTPA8EO3VdYHZDM7xiMtbk+Bs+rHGOLQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732667; c=relaxed/simple;
	bh=1PHJpNGOO1l47yrUPwBqAgkjTCpG5Qk2zOGPwegAb8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjIdEwmX8oJdV8TqJXp7oMz7SinlCTNZubYWTQMDXLX/31wX1Q9OIZFc7+vZytF6U81lUBOY5IVxA+BNMHtCJLIajfsxHWmTiA3K/WQdgBwcd12qn0E6P2BA7j1mtRoiyJRzJSqWEthp/997eWOwG1DZDtkBsoNs/4PlWVrCsWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAjO0Gh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAjO0Gh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB2EC4CEFB;
	Fri, 21 Nov 2025 13:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732666;
	bh=1PHJpNGOO1l47yrUPwBqAgkjTCpG5Qk2zOGPwegAb8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jAjO0Gh2/Epk0HumcQ32qm5hVn25Ud6S7fBqyH6OhefaIsorifagoTdY8Iibz4G4x
	 ZoQefmUwEGFZOt9/Hihm5KI38P8xxcZnmrpD8K1f7FV0xcf7ZKY+CfXUV16FX5eoXF
	 BrUeZhc0GydL/bb8bAspdBPQV8E/mFNX7hDE/CFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/529] usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget
Date: Fri, 21 Nov 2025 14:08:19 +0100
Message-ID: <20251121130238.132644084@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



