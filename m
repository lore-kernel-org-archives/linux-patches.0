Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6191D2784;
	Wed,  6 Nov 2024 12:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896159; cv=none; b=Ab+3JycGStRS81F6r84ac+j/07+8VKHhwq4FUvSEhtOvIh+zgSoE1kuXtBldiI/9wiK0im8bLkx/5C7rOpknx6QrDkMtsjEhkIt5PKVYkJIE07+r1wZVfXeN9F3uagjqbWeU0iWm3KB9zF1DNKvsfxORokUwUmIMYLDmLIfANvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896159; c=relaxed/simple;
	bh=IJ9cqupX8qko+xVuLaWUCHmWHDr4R3ZcA6xA77/u6y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7BgH5QjaNnkjPSbeEU0ZORxY/FMoPrYrgMva2I+GbjH3USrZUlk6qIya2R6wx4PqgtBL1DMU9saEKp4fWXTdYCdoudIqa9g4eR6ox2RgLBsBOBtWGf66sJyIWqQa6524/uwjmzG/+xHiYPP7WzrsTXu8EwfyLX0CGb10i1aTkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rT2AZRh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rT2AZRh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881CFC4CECD;
	Wed,  6 Nov 2024 12:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896158;
	bh=IJ9cqupX8qko+xVuLaWUCHmWHDr4R3ZcA6xA77/u6y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rT2AZRh97/9XXM9hq3DHRucDC152uJRlm/zYGRGH2UtzLLgfayPeQNkU4ZWTwmdiB
	 AomK8FnfJmNe22/wA+cQbBRJff/7TSKtO0bag5RbYmJntu9xFXNflf1QIGxcWKL8MD
	 HS8MMEAATscbYV0tKRAeonXGHDbf1lr4c4cQMG7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.11 108/245] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:02:41 +0100
Message-ID: <20241106120321.875656247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit fdce49b5da6e0fb6d077986dec3e90ef2b094b50 upstream.

For devm_usb_put_phy(), its comment says it needs to invoke usb_put_phy()
to release the phy, but it does not do that actually, so it can not fully
undo what the API devm_usb_get_phy() does, that is wrong, fixed by using
devres_release() instead of devres_destroy() within the API.

Fixes: cedf8602373a ("usb: phy: move bulk of otg/otg.c to phy/phy.c")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241020-usb_phy_fix-v1-1-7f79243b8e1e@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -628,7 +628,7 @@ void devm_usb_put_phy(struct device *dev
 {
 	int r;
 
-	r = devres_destroy(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
+	r = devres_release(dev, devm_usb_phy_release, devm_usb_phy_match, phy);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_usb_put_phy);


