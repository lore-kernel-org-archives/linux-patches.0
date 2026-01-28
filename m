Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985562F067E;
	Wed, 28 Jan 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614780; cv=none; b=Yx35xYH4VVbK/PETfuVimXpZUMS98NNMgJgD5MaONv1tRQM6PmWGgp3jgsweQRB2XeBpBpHyR1FTigNTgRAWSJvosSavFNnZnzSPd7TM/edJx0IpvZctdpC7NW3sgjJNHdDl6r9X4wALWG7XE51ZsrhgCzDRQFPxidaOKPs2axI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614780; c=relaxed/simple;
	bh=F3YV15mUU3u8otmhFlTqqLAE11WOaPXhwlD5P7WayIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnz7osA09nbvi55JESTLIwUvbM40dd9escJ/2B+vjKOGJ2v5uD9uzglCld8gjH5D91/9pcPC6Pw3Ob4zdWP0CqyaYsPZR/t8aeseYYqyHFIxbgOvMUeyOeq+sYXeyoaRkX4KnTyROAEhjtD8dKXKdCTCKaw4yuDFKeXSqtoAajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdQNBlf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdQNBlf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E137BC4CEF1;
	Wed, 28 Jan 2026 15:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614780;
	bh=F3YV15mUU3u8otmhFlTqqLAE11WOaPXhwlD5P7WayIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdQNBlf9LVrVTA1RwvLjhv6yJtHpJvJwqKXkJNsUrlqYrd3EvJIz9huvf/IulfI3B
	 4f0xRI3wUwi+G7/s43AB8/bUdjXhugboM18y83qIr6tvemkqQrc+VSL8gQrSGu0+KN
	 3CJG3fKspvFUucFuA0MEa0OTyrbVFhd3IeDY36/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/254] phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()
Date: Wed, 28 Jan 2026 16:23:34 +0100
Message-ID: <20260128145353.358167391@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
@@ -1452,7 +1452,7 @@ next_child:
 						rphy);
 		if (ret) {
 			dev_err_probe(rphy->dev, ret, "failed to request usb2phy irq handle\n");
-			goto put_child;
+			return ret;
 		}
 	}
 


