Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBC13BD638;
	Mon, 23 Mar 2026 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283172; cv=none; b=aIFgtbQ0Mnh03EIbYAKXyBo6dUV0XHCj1dyAlDvS33HNks24TXxX5p28WjzVrn9sGOh1Y6yrOl3p0DbaOKXpD6izSN7NOx6pNpscg/d/Oi2skFFIejZdwNVtLz/2BG3EJ+kI8FXQnI2q7xWHHfObXxdjllOTjv3lfTqWIpM4C/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283172; c=relaxed/simple;
	bh=NL6gZEX03cDtPrM4yXWjqLpXvwpky+cEgeszT3cSDaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZtUFEwj4POpzo5a8pHCnR8jHiAwNJpvKwPlX3XDcifRt30VtPlD+bqJcYMran7GU9bi4XWrcYUDBre+8VJ3LjKnOUsXzL+QJ74oQzw79Gkv8mrqaHYWfUN13Yet+Iov4tbRpzcB8vZzraTuEYurpWElRZTzT8faH59CrMwcDBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2UFxDY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2UFxDY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50385C2BCB3;
	Mon, 23 Mar 2026 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283172;
	bh=NL6gZEX03cDtPrM4yXWjqLpXvwpky+cEgeszT3cSDaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2UFxDY9C000mlZ7L2WwLa5DP2bENW4iN70vs+Lgq3u3WacHc3ilkUSvxa4TMSQqI
	 iEDRhMHfxgYjEug8wh52SEhI+fTEc4PHtlXHWe2uCGo095RD9DBt3y0HivKgllyhIj
	 C+KVYc16mku4n22CKlhGjFtC+4TOnDwCDQxTUnGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Astrand <astrand@lysator.liu.se>,
	Guenter Roeck <linux@roeck-us.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/481] wifi: wlcore: Return -ENOMEM instead of -EAGAIN if there is not enough headroom
Date: Mon, 23 Mar 2026 14:46:52 +0100
Message-ID: <20260323134535.680485326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
index 75ad096676561..1c6373013f66a 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -213,7 +213,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (skb_headroom(skb) < (total_len - skb->len) &&
 		    pskb_expand_head(skb, (total_len - skb->len), 0, GFP_ATOMIC)) {
 			wl1271_free_tx_id(wl, id);
-			return -EAGAIN;
+			return -ENOMEM;
 		}
 		desc = skb_push(skb, total_len - skb->len);
 
-- 
2.51.0



