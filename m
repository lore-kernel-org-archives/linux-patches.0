Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A56A646;
	Wed,  6 Nov 2024 13:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899222; cv=none; b=YmvwxJQ5rg//jmPc9d+ebBiklpiH4WuUqvNyj/ORwCwpOlS3hLLroeZQv/kGmfTvqbrFZKukmufvC/RZmfdfz7LZRipkBvN/WKI3eFSS4imB3I/Zaz4E1reQ/qkMNbcWDoD15S64OwO++yJ7pmKlRgpuYoYlD6kptBvu8m89DUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899222; c=relaxed/simple;
	bh=AcKZlEgHW6ijQn3Ukn/3wTDhGOOu21b9TKVIdcwA2V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNWR2dCeNEc529oh/CiLtl71O3AEPUL6cA4D+mdD3GZjYKsbX6tzRfW5c7egbxPMR2u447ZrdgeE2pcWnzQORKEaSFPgu04SSo4JLgiz1dadrwKFiY0fvvtIl4CQdSZ//b7WTN2cvHYgCU5cTg7+bBpq7cY26QcHjkk2ru42i1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7fA31K/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7fA31K/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C30C4CECD;
	Wed,  6 Nov 2024 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899221;
	bh=AcKZlEgHW6ijQn3Ukn/3wTDhGOOu21b9TKVIdcwA2V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7fA31K/VRQz4j224km6phV9uU+YNSEu5ASNOHKTs1f/i9L8HNn+IcTsRv23ca5VZ
	 4b0Kq1SF5l2DsXC9QNL7L+qp/ozSrhkmT/ci0vE4AfXDaLq7LlUpzVGyICHmdq4JjW
	 nkeuEgQolw3SiF0EmZ7y+38Av2ucqYSidHsWBgbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.15 39/73] usb: phy: Fix API devm_usb_put_phy() can not release the phy
Date: Wed,  6 Nov 2024 13:05:43 +0100
Message-ID: <20241106120301.131295116@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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


