Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339F4343893;
	Sat, 12 Sep 2026 10:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209900; cv=none; b=uHtNd3cnMkTHXLUADPsIXeH2usF2uOEuPBB0BqhRK0safbf4GdWhiIR1+XUF5UjpeV22Ky7JxKQNb3HiqTbpglU5hsmxK53n16tN9wUT3Tw819PNtKd5n5qlVh4qZKY8+fI1benvjU5OdY21FwyEf7O7z6cP6rZyvgl88n9mWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209900; c=relaxed/simple;
	bh=mpimgsQS+u0LMSGTu4klYN0bLmX97bxfN9yJ/XAlh54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6VSzhrawcPYJHrM7gAH/Vqd64fVlNUMG0mMN3ISjzYeJ86yDkrOs6UuB78MtdnXU8KpXCGllR7MFinJ1h9jpI8TN0bIZNe/Uuq4DQGJWsk3lpaGJUxjA1LtYlX8zAFt9XaZ+t2AuamGBCdstU/1Pw3gVcvGIerYyemXLQ1pEpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0hJ2rUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0hJ2rUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26C71F000FF;
	Sat, 12 Sep 2026 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209899;
	bh=Y4W4NZPQrBQaSE4eOj8o2ZwxXg5vHU7eWa4c4b6ZOnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0hJ2rUqqXz4AwkMfhKW+lbn3mYVma9PeaNn91aJbiCEwhKP+Da8NR1soQJaKJu3Z
	 tRjrdJCtLkV23SUBAjuh7tzHSNUjZjwW3hBZMnmoqxs5pgG5uXGMpQc92Jg/NOAhKr
	 kv2MkjlZ3rggRvZh8RCVk3McbOuBqJQxzKSQlSEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0914/1518] drm/sun4i: hdmi: Dont leak sync polarity bits into packet control
Date: Sat, 12 Sep 2026 08:51:23 +0200
Message-ID: <20260912065644.130517634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index ab0938ba61f7d..c7b539b3497f6 100644
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



