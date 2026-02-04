Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9792D8763;
	Wed,  4 Feb 2026 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218203; cv=none; b=kCeWZt9zkWXB39/nB9An3DEbXi4PDB1CBoEoTIvHKxDP+0LW9um8lMplEHBy82jjQ/vZQoiH7Kozts40AGGA2TTzPDPGBTM6NSWp+lACKAj8NFG4+M9MgWhsQF4Dh2p7l1wN/VGcxL1zzsUGLD52qLRBr7neVrUmX2rmIdcCpu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218203; c=relaxed/simple;
	bh=7/j070MXezMgz8ufW0ATx+bCmtHrVogbr0yuit1KIhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlDJ2LyJqz32qxCpL3fS1N8AuzClX/XRODX+ol/+UhmaNG2dAjJIJZyWoODKCkMrlY68n2vTpsWfrwRfZ+g/7w7E+Fg+afRYT701gb+WoQpPzXZN4hGT6ADsk/rHmHRr/FIP0SNL9N+OXFgKCPshjk0DGppnv8P6Vy7lXuDDhQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE4nPSnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE4nPSnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4683BC4CEF7;
	Wed,  4 Feb 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218203;
	bh=7/j070MXezMgz8ufW0ATx+bCmtHrVogbr0yuit1KIhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE4nPSnK90qhAIx66TafFAc9V4De5mewmUQogHKbv02ajiwkkvcmzb3m5mo3HCIYd
	 fWLzxTVk/Q2jEEX9W7ns4UAHSVM5cKYCPo6MVuwzs7IltWUeL81KBJWERSIhm3FAUd
	 OSjx5Z1cWD1uTXt/sQBA/8foPfmi/nDJhg9XmnqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/280] phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()
Date: Wed,  4 Feb 2026 15:40:17 +0100
Message-ID: <20260204143918.380299453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit e07dea3de508cd6950c937cec42de7603190e1ca ]

The for_each_available_child_of_node() calls of_node_put() to
release child_np in each success loop. After breaking from the
loop with the child_np has been released, the code will jump to
the put_child label and will call the of_node_put() again if the
devm_request_threaded_irq() fails. These cause a double free bug.

Fix by returning directly to avoid the duplicate of_node_put().

Fixes: ed2b5a8e6b98 ("phy: phy-rockchip-inno-usb2: support muxed interrupts")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260109154626.2452034-1-vulab@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -1330,7 +1330,7 @@ next_child:
 						rphy);
 		if (ret) {
 			dev_err_probe(rphy->dev, ret, "failed to request usb2phy irq handle\n");
-			goto put_child;
+			return ret;
 		}
 	}
 


