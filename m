Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FAC2A1B8;
	Sun,  1 Sep 2024 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210537; cv=none; b=IoSs8vh2dOH3prYAOZn3X2epU8UHEu2nt3C/s3YRnNIY5AmC8BruzQebvj4gxreqordWN8BVCz0w0h2lYrC759aUNQwWBrSsxFU++C9WRIGsu9hZuztg/FG++gGiqqZLRCMeK74CRQwdT0V9s3vwaQmQVs7iGHdAZuZ48/AeIZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210537; c=relaxed/simple;
	bh=Zqa3Y7xkA0jd7+ItfVstSy9JYfBu/rIWcasfTNLOkDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxcdfaeizibiwy/KI9ZMyQg/07Hs9yb8L3832+8JcnDTDCXntVfG8hVYFJjs90ClKwvKU5x1JUzJXWlljnlAUOioYlFo+Q4fC8KdwhFtxRydmT1ZhHoMpUKSw/ShnWNizFp6VXIxrTRVc+J2XWlA7Ajpd2K9kky3N56LUV4Aknk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK7iq9Pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK7iq9Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC03C4CEC3;
	Sun,  1 Sep 2024 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210537;
	bh=Zqa3Y7xkA0jd7+ItfVstSy9JYfBu/rIWcasfTNLOkDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK7iq9PcUnJg332l0ETY63e+SpuL1xlF/ZuvMnlgD+HlDdNWK8st0/86M5XflLg75
	 EU7Ty991bpJ1bN1VzAxrurfy1WnIXVcpvNn70O6A31Lk39elCGnEM2sD+fnzLtDa5W
	 sPbk1mB4+qUM1y1XflwXDYUGjLRgN6ABX0z7a1FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 209/215] usb: cdnsp: fix incorrect index in cdnsp_get_hw_deq function
Date: Sun,  1 Sep 2024 18:18:41 +0200
Message-ID: <20240901160831.253369308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pawel Laszczak <pawell@cadence.com>

commit 0497a356d3c498221eb0c1edc1e8985816092f12 upstream.

Patch fixes the incorrect "stream_id" table index instead of
"ep_index" used in cdnsp_get_hw_deq function.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: stable@vger.kernel.org
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95381F2182688811D5C711CEDD8D2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -402,7 +402,7 @@ static u64 cdnsp_get_hw_deq(struct cdnsp
 	struct cdnsp_stream_ctx *st_ctx;
 	struct cdnsp_ep *pep;
 
-	pep = &pdev->eps[stream_id];
+	pep = &pdev->eps[ep_index];
 
 	if (pep->ep_state & EP_HAS_STREAMS) {
 		st_ctx = &pep->stream_info.stream_ctx_array[stream_id];


