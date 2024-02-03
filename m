Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D044412B9E;
	Sat,  3 Feb 2024 04:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933446; cv=none; b=G0itndk2JyvZBKej2c8YaOXs31DKNDiP/eaQQ+vEuUetjD3JrwWTd8Hzj6zfbMMbV/hWvYl1oU7DAFIqGeiPRZlRZ5hE4wEun3+17+kPAT5pakBOCyxaGLs18lqdZRH8znAwmES+oRgwr9jO6Tz+G6PUPB2sWBc4uUe1Go6JQJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933446; c=relaxed/simple;
	bh=fx/HIbC2hy9sOfr9ngUTw6XVjTrStDo8+a6QSdncg3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvNAHl3dhxx0De4dFeESHbEViRKk5vO6oJzx883s30Acncl4DXY2FRhTI1tdJuDAGJLFJ7eJnTAfbiHJfSQmIL9eeTzhxZWl8vQTKq8USYx72Cfiob4+ZpAqLMg14SH6Utk9u1Xj0HqkKOcGRTXr1oUsgUsOO7Uiz85mbxSXyxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+6AkNKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+6AkNKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8FAC433F1;
	Sat,  3 Feb 2024 04:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933446;
	bh=fx/HIbC2hy9sOfr9ngUTw6XVjTrStDo8+a6QSdncg3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+6AkNKIkTv+ZDYBPn/x3X/iEKMogLnfWxjsBpUD6RHDXHtSJ9s6ErP4yaTYDX9Tz
	 sxwky+flZOic0EG0jHJPoEIM2xHMfb9297gO2ksLZjv6z2BCuptA9x9dUa7fKkVofH
	 kH7om+BmYGNd7herwS5ZUxI/5Y3O7vYG69xPUBQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiaowu.ding" <xiaowu.ding@jaguarmicro.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/219] mailbox: arm_mhuv2: Fix a bug for mhuv2_sender_interrupt
Date: Fri,  2 Feb 2024 20:05:28 -0800
Message-ID: <20240203035338.524559645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaowu.ding <xiaowu.ding@jaguarmicro.com>

[ Upstream commit ee01c0b4384d19ecc5dfa7db3fd4303f965c3eba ]

Message Handling Unit version is v2.1.

When arm_mhuv2 working with the data protocol transfer mode.
We have split one mhu into two channels, and every channel
include four channel windows, the two channels share
one gic spi interrupt.

There is a problem with the sending scenario.

The first channel will take up 0-3 channel windows, and the second
channel take up 4-7 channel windows. When the first channel send the
data, and the receiver will clear all the four channels status.
Although we only enabled the interrupt on the last channel window with
register CH_INT_EN,the register CHCOMB_INT_ST0 will be 0xf, not be 0x8.
Currently we just clear the last channel windows int status with the
data proctol mode.So after that,the CHCOMB_INT_ST0 status will be 0x7,
not be the 0x0.

Then the second channel send the data, the receiver read the
data, clear all the four channel windows status, trigger the sender
interrupt. But currently the CHCOMB_INT_ST0 register will be 0xf7,
get_irq_chan_comb function will always return the first channel.

So this patch clear all channel windows int status to avoid this interrupt
confusion.

Signed-off-by: Xiaowu.ding <xiaowu.ding@jaguarmicro.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhuv2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index c6d4957c4da8..0ec21dcdbde7 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -553,7 +553,8 @@ static irqreturn_t mhuv2_sender_interrupt(int irq, void *data)
 	priv = chan->con_priv;
 
 	if (!IS_PROTOCOL_DOORBELL(priv)) {
-		writel_relaxed(1, &mhu->send->ch_wn[priv->ch_wn_idx + priv->windows - 1].int_clr);
+		for (i = 0; i < priv->windows; i++)
+			writel_relaxed(1, &mhu->send->ch_wn[priv->ch_wn_idx + i].int_clr);
 
 		if (chan->cl) {
 			mbox_chan_txdone(chan, 0);
-- 
2.43.0



