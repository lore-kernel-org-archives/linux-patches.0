Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EE02BCF4C;
	Mon,  9 Feb 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648700; cv=none; b=bnqFHgyp3Q4jTlVL4n65SW5q/01MV7vH7zkZowbPVRdlA/zGA3HWqzCxVyTj1vMvY1IDoGyELlZJfuVYGQRvDmZw9XexxV67/7/rkLXqzHNWHmjBM0dKC5XWJ7LUK7q7hP/vki+oLlc3/JXB/6NKnPMmZatC+/XHEU046cTehDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648700; c=relaxed/simple;
	bh=81CxyeD86jE4irjKmWP8Kmy0+IU7m9HYzJRKZAUZo0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FVW8j5nbqW1U+DZ2lPZ7Z9I04cB8FtyIzZ8TT20g/WfZPzWQTe+f1pClgWyIUyTVAyem3vtwsZlvpYxkMQaRaAPDeSCHjrUkxQDIG3xxFl3m3CpYkeYFTRBfq21UGUaAdx9ddKvs3tARNt6ZfH6zdZqPOJIiVp2FmLPBbaHHF6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykM7Iz7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykM7Iz7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67844C116C6;
	Mon,  9 Feb 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648699;
	bh=81CxyeD86jE4irjKmWP8Kmy0+IU7m9HYzJRKZAUZo0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykM7Iz7rfQy2NI0ayT8yrKpCQKY/qA0ZdB852p5ggPQKabSnOnoolD7Edroos1e5u
	 nkf6muuT72KwT98jdZY+LwAwol8SzBEIswsevTtQEFWERnMKaqiXCc1WkfDrxheDnJ
	 /+udLN10gDohWsRJn/Eosjxmf8MmFMch5DnJ5Ygg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Astrand <astrand@lysator.liu.se>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/41] wifi: wlcore: ensure skb headroom before skb_push
Date: Mon,  9 Feb 2026 15:24:28 +0100
Message-ID: <20260209142257.068688606@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Åstrand <astrand@lysator.liu.se>

[ Upstream commit e75665dd096819b1184087ba5718bd93beafff51 ]

This avoids occasional skb_under_panic Oops from wl1271_tx_work. In this case, headroom is
less than needed (typically 110 - 94 = 16 bytes).

Signed-off-by: Peter Astrand <astrand@lysator.liu.se>
Link: https://patch.msgid.link/097bd417-e1d7-acd4-be05-47b199075013@lysator.liu.se
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index e20e18cd04aed..e86cc3425e997 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -210,6 +210,11 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	total_blocks = wlcore_hw_calc_tx_blocks(wl, total_len, spare_blocks);
 
 	if (total_blocks <= wl->tx_blocks_available) {
+		if (skb_headroom(skb) < (total_len - skb->len) &&
+		    pskb_expand_head(skb, (total_len - skb->len), 0, GFP_ATOMIC)) {
+			wl1271_free_tx_id(wl, id);
+			return -EAGAIN;
+		}
 		desc = skb_push(skb, total_len - skb->len);
 
 		wlcore_hw_set_tx_desc_blocks(wl, desc, total_blocks,
-- 
2.51.0



