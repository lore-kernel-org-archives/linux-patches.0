Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5610C36403D;
	Wed, 21 Jan 2026 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020279; cv=none; b=XZkTyCFKqb7Y0Bol2gc6VhvJdfxtRMiIAx//8WoHqagVtJ4gGbvK7GTNH24m8j7Ih6w9pazHut+1ZJ/OhWbFN8p23+waUF4+LhhfmxUca4tvqGLNC2zTCmmjSZWxNThsqMIElB+KcFjbdEEt2MDgD5PWn5frIu1+NEME4a/hvUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020279; c=relaxed/simple;
	bh=RS/94qGPi3E1BkDCfViX84n4P830hfgaFjzuZS2cUgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtnA+zDwoO2fBz2YGiHtXGZYvGPwxGRHHm6YTft/TGcc/pU5vReE2oPI3bAOPPCKW7lnp5yiFAiP+TvWHqiyND6GDD40TCniujJ4isWR7lx45Col7kPciYHJXB4J7FrI+HS7R7bLHDHmIX15VZ1u1DXmQBobUIe6jlnoRO6PKII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKaIeHXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKaIeHXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C3FC4CEF1;
	Wed, 21 Jan 2026 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020279;
	bh=RS/94qGPi3E1BkDCfViX84n4P830hfgaFjzuZS2cUgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKaIeHXj75zWJHwMQlUYvzgzbL2SkwkhKo/9oGtqKXHXv0pkV1HUmZgDPpeqls1nh
	 YB7cPYK1DGtfF3aQuBCpRMjclisE8Vul6o54zMgmERW4xHTAxbeR1yxD4fmQFh8ecg
	 IPISSYD1prxpdkVcOiHSOa/ZSY7ndMgPKTas6Oug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 112/198] phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()
Date: Wed, 21 Jan 2026 19:15:40 +0100
Message-ID: <20260121181422.586426540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit e07dea3de508cd6950c937cec42de7603190e1ca upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -1493,7 +1493,7 @@ next_child:
 						rphy);
 		if (ret) {
 			dev_err_probe(rphy->dev, ret, "failed to request usb2phy irq handle\n");
-			goto put_child;
+			return ret;
 		}
 	}
 


