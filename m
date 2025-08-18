Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E0D19E82A;
	Mon, 18 Aug 2025 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524806; cv=none; b=qdIdnBI5CREf+D+l8ZnWEtZt9wF+bEwS1XCjMYO3q4kjABmuzAeutDMRoh2MtchH6EdxZjuJFCwlfL/VrcHgDsLf9Hcc7Qppmykp3mZu+MeJcdbOoQnBtJwshO3kdxWq/7Z4w+uuzDQfhVuumB9xokKtHb3F/bvh1uvWM9r2cI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524806; c=relaxed/simple;
	bh=gpeEfauk4aerQn4rO2CnugNxHXxzhZnIqESgORBLcW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkD+cvDIGdzwQ7rglbfSP+7/nSFTrMgMUhiEm0mpGc7wpq46OMPFwxMkimLBhlveTXXpkYC5dU5Ie+auSBZ6rYYN/MYTrskEV4MZ+uXIlybmTRYc1Ua5tFd8urX9woJeGUezuq5mVsjaYiI0Ex24CJaIHk0jHxYxBtWqHt8OmK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nb4xfHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nb4xfHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B753AC4CEEB;
	Mon, 18 Aug 2025 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524806;
	bh=gpeEfauk4aerQn4rO2CnugNxHXxzhZnIqESgORBLcW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nb4xfHBDVJs/iWXxJyA89GGujtthmQM89tBHkKuUJ5IYF2JAdoBp6EOSCdmF36JM
	 z7f+kHnVVGNqfN1VXc8zlizH7Y0Zayofz9fj0OfIPO8XD/UYydMDujooNxcpY6AGAk
	 TmIwNam2DLKwK3iNw6oP+uBCYLB6kND03fVTiw+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 026/570] net: mtk_eth_soc: fix device leak at probe
Date: Mon, 18 Aug 2025 14:40:13 +0200
Message-ID: <20250818124506.822651591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2794,7 +2794,6 @@ void mtk_wed_add_hw(struct device_node *
 	if (!pdev)
 		goto err_of_node_put;
 
-	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		goto err_put_device;


