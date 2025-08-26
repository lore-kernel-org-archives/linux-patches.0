Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1171A23A4;
	Tue, 26 Aug 2025 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214179; cv=none; b=VuNskHzAKw/CfMtmOs8JS8cD24p1+VlP/wX+EvmMwvr4+45rNs022pN/9vLAGuwAMIpit8F7tENn6Bi9KPlL6Y1vFVR5sB4k85P4b3171eq5beauHhDXR1mCbXf49ls5G0gmpy0IVrywVMqrqM8u73nqg6m36RGkp7xb+41u03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214179; c=relaxed/simple;
	bh=dukydRT4itf/w/M6hfzvZLpX/0Cg7RdzqA3tq4WUECs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRzo+dudNBZTmqPPsvPbhseaNP1WkQJAjJNl5hXEeFcpNvJo6vey/+TJayrZRAsTL1XjuautJyLuU38cp5e4+mZw4RVf0ApUi4Xu7SkCjZljfIvN0v659cOJXBnXjiFuiBSn5zmldEFQzTtIVXoEE8zywh8goR6gK6pU7I57x0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX0HtBPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX0HtBPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E011FC4CEF1;
	Tue, 26 Aug 2025 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214179;
	bh=dukydRT4itf/w/M6hfzvZLpX/0Cg7RdzqA3tq4WUECs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dX0HtBPrH8CONNkadzzwn7PFSZRBeeT138xQx5x+XLzAXFdSaTaRTn4VjL+9dbW31
	 hPC0G8mdYDYYNpa7Va6Tb4y+mzqXIciISAWuJumvI9cufquV+LnjcU/TNYs5Q9CxJL
	 QwjYK69nkUye9T2tLxX6SD+OKjb2u8sTW/TlL0ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 013/482] net: mtk_eth_soc: fix device leak at probe
Date: Tue, 26 Aug 2025 13:04:26 +0200
Message-ID: <20250826110931.114017244@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Hovold <johan@kernel.org>

commit 3e13274ca8750823e8b68181bdf185d238febe0d upstream.

The reference count to the WED devices has already been incremented when
looking them up using of_find_device_by_node() so drop the bogus
additional reference taken during probe.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Cc: stable@vger.kernel.org	# 5.19
Cc: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-5-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1074,7 +1074,6 @@ void mtk_wed_add_hw(struct device_node *
 	if (!pdev)
 		goto err_of_node_put;
 
-	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		goto err_put_device;


