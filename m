Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D79318A6C4;
	Fri, 27 Sep 2024 12:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440254; cv=none; b=VJquRxg1FU7L/h/HD4aJ4Z+3TfmlqxA52Ag4DNmF3dNEcVedER56rTqYO65Ay0BHYEaeIsFRYHNNDjY/V3vrS7BkaPjG539+x7HccmtECzQ1zIch9DoY3r1ZJEC8q8rOq6yZOaieoHwhLZic4sdFhAjQjvAxyHMiNNBpgbbzais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440254; c=relaxed/simple;
	bh=eVRSUMh4qEB8xzEjyz+2fzjix/LxIEI4R1ki3qGNxtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTzIhl/NRiiVxx1WmAf1yM1MEaIYhxUlZeQfcwEoJandexnS+hFO+KvBfaluNIZ83xOgWxfCNphKkOdaZ5woqyaLZ/Q13kVgcyqHWzbT1Gdk58kiWcGa1tRwWJYSjC4CZz1L00hjab339AAgz6bXRtJnPR6Erun3zFxq3lWPlAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hn0o/Blf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hn0o/Blf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979BAC4CEC4;
	Fri, 27 Sep 2024 12:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440254;
	bh=eVRSUMh4qEB8xzEjyz+2fzjix/LxIEI4R1ki3qGNxtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hn0o/BlfIZ/qDEfw9q6/u57B6j3J0ol+r4zxFd6AgnVQCBV5kGo4wr9NAn3THg96Q
	 YRk1sq8LCmznjXjOH4FT5rtNDJsxq9XTsZotMuyxjvXUpAk1XFuxe8S2fpox+l+/ox
	 kaJXsrIyLKnCpf/QYOqO6yCP/sh8TFM6dKX2ADE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/73] wifi: mac80211: free skb on error path in ieee80211_beacon_get_ap()
Date: Fri, 27 Sep 2024 14:23:27 +0200
Message-ID: <20240927121720.526167153@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 786c5be9ac29a39b6f37f1fdd2ea59d0fe35d525 ]

In 'ieee80211_beacon_get_ap()', free allocated skb in case of error
returned by 'ieee80211_beacon_protect()'. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20240805142035.227847-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 419baf8efddea..0685ae2ea64eb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5196,8 +5196,10 @@ ieee80211_beacon_get_ap(struct ieee80211_hw *hw,
 	if (beacon->tail)
 		skb_put_data(skb, beacon->tail, beacon->tail_len);
 
-	if (ieee80211_beacon_protect(skb, local, sdata, link) < 0)
+	if (ieee80211_beacon_protect(skb, local, sdata, link) < 0) {
+		dev_kfree_skb(skb);
 		return NULL;
+	}
 
 	ieee80211_beacon_get_finish(hw, vif, link, offs, beacon, skb,
 				    chanctx_conf, csa_off_base);
-- 
2.43.0



