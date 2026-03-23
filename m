Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB563AB295;
	Mon, 23 Mar 2026 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274932; cv=none; b=K4UbNYsQhWyxA5cGEf5JOi5Cccd5jL9pAKEzFugSOyFACH/tGIhDD8tFxzi/ARpae+I4U3gY1oI10NY80Tm5eZk4yRgi4yZl55G5IjDSsN8oAQeQgbYAUtvlv/yZDa9zTNLYZAi82rItiy0gzwG31nYlowfXodyxS8/XQ3ZTcGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274932; c=relaxed/simple;
	bh=eAVaQzmFjT/tuHkoJ4YJpJEX8Hh2fCt6wnRBYH9B+3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3a3ZH5pnO6++MtoY0eXeG+QrXLjNFb8BvR/hRc2XJsBc34+GrgZMJBbZvz3o+cER0D3/rwkYSaXU26ycGgQ91P5lRSavUy6z37zULLkn37CUNW/2EeuMRZY4zdHctxTM56UhcJSF0QoBSpnIg2iqQKsXAwlNYY7abuGo5+J2aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhUsyK3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhUsyK3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69811C4CEF7;
	Mon, 23 Mar 2026 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274932;
	bh=eAVaQzmFjT/tuHkoJ4YJpJEX8Hh2fCt6wnRBYH9B+3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhUsyK3yFqSjD6pqiWV9DbVyzEllxw5qRuzDJEn/3lxEXxHzxUjdxXvFL1bZzqutJ
	 rnridNKZWvyYyBme/aHd9qe3GtcMTyFxm8/6tHQWSmVoK6vUNS/um7MrtGNR4T8p8a
	 g2dLn/CpRNdu6bG0Gaft0DTzqJnaBszTPmRe03wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Astrand <astrand@lysator.liu.se>,
	Guenter Roeck <linux@roeck-us.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/212] wifi: wlcore: Return -ENOMEM instead of -EAGAIN if there is not enough headroom
Date: Mon, 23 Mar 2026 14:46:22 +0100
Message-ID: <20260323134508.832922480@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit deb353d9bb009638b7762cae2d0b6e8fdbb41a69 ]

Since upstream commit e75665dd0968 ("wifi: wlcore: ensure skb headroom
before skb_push"), wl1271_tx_allocate() and with it
wl1271_prepare_tx_frame() returns -EAGAIN if pskb_expand_head() fails.
However, in wlcore_tx_work_locked(), a return value of -EAGAIN from
wl1271_prepare_tx_frame() is interpreted as the aggregation buffer being
full. This causes the code to flush the buffer, put the skb back at the
head of the queue, and immediately retry the same skb in a tight while
loop.

Because wlcore_tx_work_locked() holds wl->mutex, and the retry happens
immediately with GFP_ATOMIC, this will result in an infinite loop and a
CPU soft lockup. Return -ENOMEM instead so the packet is dropped and
the loop terminates.

The problem was found by an experimental code review agent based on
gemini-3.1-pro while reviewing backports into v6.18.y.

Assisted-by: Gemini:gemini-3.1-pro
Fixes: e75665dd0968 ("wifi: wlcore: ensure skb headroom before skb_push")
Cc: Peter Astrand <astrand@lysator.liu.se>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20260318064636.3065925-1-linux@roeck-us.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index f251627c24c6e..3c0f8f3ba2668 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -210,7 +210,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (skb_headroom(skb) < (total_len - skb->len) &&
 		    pskb_expand_head(skb, (total_len - skb->len), 0, GFP_ATOMIC)) {
 			wl1271_free_tx_id(wl, id);
-			return -EAGAIN;
+			return -ENOMEM;
 		}
 		desc = skb_push(skb, total_len - skb->len);
 
-- 
2.51.0



