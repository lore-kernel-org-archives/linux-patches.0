Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E767D1DC198;
	Sat, 12 Sep 2026 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202097; cv=none; b=QtZW81hfMKEG5tkRIfo5h5s9DlN+VHnBDYhcGD3J7UwPoMoGrI8Ft0sbhcZ25W+8ZVQM1zehdQsd2+eHsxD00bYCslA4WDpbtv9P0meCSCbIYOHtf74o2HYO8+LTEBmEOOKNSF6osAZILc7UfXb948Ndo3LxFzsgpKh5mjPdA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202097; c=relaxed/simple;
	bh=vz8XQWpyqwoSml5tnJh7Rpy5JYWAgnzC7Hvm8guJe8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khiJfnrOSWpGw4Xa8WrCj9maRlq0Lks0WvoqWg90rx5EKmVYL9YD53DCEkyivsB1wRSGcx/+fddbYD4zEDS28fplpKyKrF1+7D1YE7EvF3A/9xCPsQ/byX+4jP+DxjHVos8Vj1ZWJi+r8y+ofcyknn0rlW55aYnQDkD8B5U+hcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=if6C8ek9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="if6C8ek9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6161F000FF;
	Sat, 12 Sep 2026 08:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202095;
	bh=OejRiMxqznAXFKAPUV4F7IYySqEd6KiHRn+71qAAvPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=if6C8ek9FzK3Nsyqt3SAObtbHtG8vXcsQCL2/SYNs7Ulp3VyoxUBjO+wwyve3uC0k
	 zLR+kUTSKvgTLA3bOr4c8/Ylh1fiGhdlx9owWYjP68YqL3QRcevvo5rjvhk3BHeXf1
	 0fyKqj+KBUniLgoml5YRaUN1uuuLctRG2zwoD/f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1131/1815] drm/sun4i: hdmi: Dont leak sync polarity bits into packet control
Date: Sat, 12 Sep 2026 08:48:01 +0200
Message-ID: <20260912065715.571799772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit f5c3b1b0d228624786d22973a20c908c84e1a576 ]

sun4i_hdmi_enable() keeps using the same variable after it programmed
the video timing polarity register with it. The leftover TX_CLK, HSYNC
and VSYNC bits are then ORed into the packet control register, where
each nibble selects the packet type sent in one slot.

As a result, slot 0 selects packet type 3 instead of the AVI infoframe
whenever the mode has positive HSYNC polarity, and the TX_CLK bits set
nibbles which the driver never programs.

Assign the packet types instead of ORing them into the stale value.

Fixes: 9ca6bc246035 ("drm/sun4i: hdmi: Move mode_set into enable")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/51ba0918ce016a4b45313d5df1b6ce31b8c8731e.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
index 74c7c3720ba82..a27d394d05708 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -161,7 +161,7 @@ static void sun4i_hdmi_enable(struct drm_encoder *encoder,
 
 	drm_atomic_helper_connector_hdmi_update_infoframes(connector, state);
 
-	val |= SUN4I_HDMI_PKT_CTRL_TYPE(0, SUN4I_HDMI_PKT_AVI);
+	val = SUN4I_HDMI_PKT_CTRL_TYPE(0, SUN4I_HDMI_PKT_AVI);
 	val |= SUN4I_HDMI_PKT_CTRL_TYPE(1, SUN4I_HDMI_PKT_END);
 	writel(val, hdmi->base + SUN4I_HDMI_PKT_CTRL_REG(0));
 
-- 
2.53.0



