Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A4847CA7A;
	Sat, 12 Sep 2026 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217326; cv=none; b=HXWF1EKFRT58gwGABIhg+MLa7m73mqpHUyY2yjmSCbukCfEYbT/8iolV8rOM0vVhJjkjUSqy6JYlvfCW3H2tucSOFzL7mMibOWUeXZA+hEsE2Yj7NK3R6X+AFBTKG8S+0vcn0EPHP5STDbUXOI43pZHEz3vnz9qD8Fxyefu5LNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217326; c=relaxed/simple;
	bh=Qc2qxXWH0LF+VUdjKl+n+5aCGsZy0yOUB4bPpVjIx+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHcZTCpYO0uv6QvTi2wYxOLJjcR+SQ0Lv7gdV+/8Qv55w/cjStV9k3xT83GUAgCDsanw17y8V6wjCvUnNd0wWi72OPerDsjiP6JsSkE7Zg6D0FRhLJuFbmrw255ZEXykG9HL5z85CKtUu7FOTCLND1QgnAQhP22Ifr6nn5mpoBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJqh+DYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJqh+DYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B343B1F00893;
	Sat, 12 Sep 2026 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217325;
	bh=dJDdG2TSRVIQc4fxUZru/64/J9jhdtntF0Xkzluo6SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJqh+DYQpDFK1h0VPJod3zoAcg+ogTRrJTagU5AjWdq6VfXcqWV3wtUFJ7EQU3/YX
	 01e2IKVN2MOJfqCIMFuK/0anahUxXcOiopHSnJFpmzWT6vxzOer7lP1+uGpTFB3aQc
	 Ze2k1XF+LVW0FfQPbqSURI9B3tZ4PlsOnI5QDl28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0917/1376] drm/sun4i: hdmi: Dont leak sync polarity bits into packet control
Date: Sat, 12 Sep 2026 08:55:43 +0200
Message-ID: <20260912065628.003071736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b3649449de302..a48bef891f05a 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -146,7 +146,7 @@ static void sun4i_hdmi_enable(struct drm_encoder *encoder,
 
 	drm_atomic_helper_connector_hdmi_update_infoframes(connector, state);
 
-	val |= SUN4I_HDMI_PKT_CTRL_TYPE(0, SUN4I_HDMI_PKT_AVI);
+	val = SUN4I_HDMI_PKT_CTRL_TYPE(0, SUN4I_HDMI_PKT_AVI);
 	val |= SUN4I_HDMI_PKT_CTRL_TYPE(1, SUN4I_HDMI_PKT_END);
 	writel(val, hdmi->base + SUN4I_HDMI_PKT_CTRL_REG(0));
 
-- 
2.53.0



