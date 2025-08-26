Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564EF11187;
	Tue, 26 Aug 2025 12:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212562; cv=none; b=Rb2++XOSOGx4qCYVv6yGNNKn0sBOcrKiRJYPzLylhMKN8Q3LwMkUWoX4bVZk1+LMToRGQWsXA9lLad2Q9+k33XViD8Kt2IQNL59tQMSCOl4hPwnolUVnj7uhJRvik37EoVHU2O2On+O2IKpOIfdWnIXUpN9ePU0SabnD65zMLtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212562; c=relaxed/simple;
	bh=pbQgeMLnkrcYQFrS0T56cuprPmARJOx3usr1whXfQ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBeGojjppjZ7hH/7Z6VwoObU9c81z2MmfEgZ9xGZMKKrag6jMHp4Qd6rPkZ1vqJskcLMf07id5ub/770sA5GEbYrF2cBrD2kigNGM2yX3n99c6plJu/XzlRUEnsnj4WA9f5rSvLF1QZOq+FhRdEn+IzJ8tAQS3tWHr3aMsrjwuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09dOmAeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09dOmAeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E7C116B1;
	Tue, 26 Aug 2025 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212561;
	bh=pbQgeMLnkrcYQFrS0T56cuprPmARJOx3usr1whXfQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09dOmAeH8FX5z0Atr496dmhlgjzPYjgD46g9k/nr0oZxnjoNmxNW2PggwlkuEjP0a
	 76OrXiL8gqRj05w7pJVpe/4MGLWfaQEvtxpTgSgeD1+F5WMIxqlDPR2YHrsK0pY5kJ
	 af2de3JvDttepNhnKJZ78B5A/dMgXs6jLNOryth8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 017/587] net: mtk_eth_soc: fix device leak at probe
Date: Tue, 26 Aug 2025 13:02:46 +0200
Message-ID: <20250826110953.391412534@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1886,7 +1886,6 @@ void mtk_wed_add_hw(struct device_node *
 	if (!pdev)
 		goto err_of_node_put;
 
-	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		goto err_put_device;


