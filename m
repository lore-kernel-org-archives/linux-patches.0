Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64202BCF4C;
	Mon,  9 Feb 2026 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648504; cv=none; b=pahcXoqQbt4rPHYeWo6HLnncLvVF9/LkH2YSh+uu1ZtVasouE7YP+2FGeE/wQGUKFvMopZmt5vq8D2FxDH1Ktz/YIqlHRmo/P9dWtgwnMVzYTyeoBRJuyNep1rchdTccPBPGwl5pR3qzK26n/JgeO6CNlgN0PzzpmKsdj6ZT3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648504; c=relaxed/simple;
	bh=dM9kOWJvRQTPpHcAw56alqmPRifjJgSmv4rIaOqZ4HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8Ta3zv3GK5v189FAPFuOdVYpXKKSB9FEwO6eUFgGi4++bTgOec7aBkBzb3FlJshXAQMe2qExdNsfDyFEmPjlXG30kmdhbxAWoyVBw3MX9oNOEmlJpdZSkZIodBZKdD5/9bgN0dJdajgqCj8Fp7C44s4BYkAMJuSoB2v7V5GB18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwBVGLVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwBVGLVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C08C116C6;
	Mon,  9 Feb 2026 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648504;
	bh=dM9kOWJvRQTPpHcAw56alqmPRifjJgSmv4rIaOqZ4HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwBVGLVUwqt1FTLyuJHqlITzbdg4+jdcdlxlO8X9q1T9Mq71o47VW7TTJ1H3/Gdpt
	 TAyn/UgjLYi4ieHkvOzFrRSwDyaNEmiTg/kQGV7VIvZak+CHvMkWvk8V6j3R9mNiWp
	 GYFlSykhFXD1hksonpmR4AnvWkZ/QF1kXspQmP6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Astrand <astrand@lysator.liu.se>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/86] wifi: wlcore: ensure skb headroom before skb_push
Date: Mon,  9 Feb 2026 15:23:46 +0100
Message-ID: <20260209142305.621750172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7bd3ce2f08044..75ad096676561 100644
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



