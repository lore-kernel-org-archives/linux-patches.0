Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3FF3CD8A4;
	Fri,  4 Sep 2026 05:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498580; cv=none; b=qK14L/RYj4gFfhxtrIaaDlkJvsOQcBu+7c5tNA3tksRL37ArAqed8vWX5YxrTp8KwgeSCAiZuyUHKW2sT03NyETL/DVlRhrPxH0kgJHjQ1Yu6PyjJULpXAtWwauLMpfc+1ZKNLqcqH01cBcz4515CLjhBEwQOJgnwfdmJZhgiIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498580; c=relaxed/simple;
	bh=roen/z2i45L+SzkQlNqyrh7wAJ0Fq8alaxiAzetRNgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSyZGNDh8J0JFyrdSbEShBWShlohMxsCousfd2Kiy15q60aOTl+kKmc4t7FQjJXCkG2aFFe9rr3GR8wScXjjk4RRUEpFOBpOk1RgdUesf8h2pRNAMstZQRLZTraHBteoXebRcXUIb0ztcQ3f0XEWobh9RSVD/vNOpxlZDP2QaTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA1/RDsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA1/RDsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7201F00A3D;
	Fri,  4 Sep 2026 05:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498579;
	bh=2cokaxtVLUVZszrYQy/RcoqlzWxvHtOsBscg2pOpnKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA1/RDsjxgd40UpwVk305MPCf73WcQV64IzjLgvE22PIobbiDX8ftlJDpuKxXIvXY
	 lneUc3T7+NqqfeR35Hy0hUkaus0L9GqTDiz5iVmc4mQdZ+dpkS1z2LHyRWh4yX3qnx
	 151Pwg7nYNXcAiTRzp3nSPoAzHF8XTxghkqYLiZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 7.2 112/713] usb: gadget: snps_udc_plat: clean up PHY on probe deferral
Date: Fri,  4 Sep 2026 06:51:20 +0200
Message-ID: <20260904045806.347240081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 886338ea7d40e4ba5123c58204d7f7e53d825825 upstream.

When the referenced extcon device has not registered yet,
extcon_get_edev_by_phandle() returns -EPROBE_DEFER after the driver has
initialized and powered on the PHY. The direct return bypasses the common
cleanup path and leaves both operations unbalanced.

Store the lookup error first and route deferred probing through exit_phy,
while retaining the existing behavior of suppressing the error message for
deferral.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1b9f35adb0ff ("usb: gadget: udc: Add Synopsys UDC Platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260804140510.37639-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/snps_udc_plat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/snps_udc_plat.c
+++ b/drivers/usb/gadget/udc/snps_udc_plat.c
@@ -159,10 +159,9 @@ static int udc_plat_probe(struct platfor
 	if (of_property_present(dev->of_node, "extcon")) {
 		udc->edev = extcon_get_edev_by_phandle(dev, 0);
 		if (IS_ERR(udc->edev)) {
-			if (PTR_ERR(udc->edev) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
-			dev_err(dev, "Invalid or missing extcon\n");
 			ret = PTR_ERR(udc->edev);
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "Invalid or missing extcon\n");
 			goto exit_phy;
 		}
 


