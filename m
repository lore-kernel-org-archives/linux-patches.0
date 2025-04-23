Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A627CCFA;
	Wed, 23 Apr 2025 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419647; cv=none; b=BEXF33pyU7+KW2aEcqm/vjlatui0JMNrw8khNuTSrr74DwNR2uQswfr4LGx2kaJqbOEu5Iar2PUOGSItGMdF7/TwPNtrDL5aDBui+0NHAwperbHi4PQ0YuIe+pBsMS/tZnX5caxm3xkP+WAaW9oMw/XdDuQdzmRYOX2SUotst0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419647; c=relaxed/simple;
	bh=4QFva8CgyIACQba/f5c92WyVxVN9rrPQP1oysdcjBTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pobVaqAaBf4Ajwij2YmoRzbkv36tpU8gFkD/fWm5X8mVgkOrFYdMsUP7np47NLr0BjW+cSuC1kM/xb5Q5Ib3ilQPObuI+CzEsDXUK8uBIf/6d3f7+JcPkFfBQ0J9bJuoG1lT0CXlwBDRtbckwy5A5Rwyr/Y7SKbwKaC4IaX3RN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/VFKRQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/VFKRQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0DFC4CEE2;
	Wed, 23 Apr 2025 14:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419647;
	bh=4QFva8CgyIACQba/f5c92WyVxVN9rrPQP1oysdcjBTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/VFKRQnYDb72qa2cc0YnMzyaBQTkkAw83Q5uNMyxDt0GFFtvgIaHHrMpj0UxbsM1
	 T8+J+faocZy8jpaY3aOAZ1flW+PLjB20aLesXBb5i3JRcc1wc3Ji55nJKqrjmr5nob
	 CqAz6TWcfgvQbmTXVUa05lG+1WjTSVogYBhiJork=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/223] Revert "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Wed, 23 Apr 2025 16:41:44 +0200
Message-ID: <20250423142618.420011832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0937cb5f345c79d702b4d0d744e2a2529b551cb2 ]

This reverts commit a104042e2bf6528199adb6ca901efe7b60c2c27f.

Since the original bug seems to have been around for years,
but a new issue was report with the fix, revert the fix for
now. We have a couple of weeks to figure it out for this
release, if needed.

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/linux-wireless/20250410215527.3001-1-spasswolf@web.de
Fixes: a104042e2bf6 ("wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9b3a5ef20f29e..0ff8b56f58070 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3892,7 +3892,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
-	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



