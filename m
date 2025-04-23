Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14342280A50;
	Wed, 23 Apr 2025 14:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419953; cv=none; b=AOThzTwGyANNCXLf4n4GZfzCQQuAKCviLggwreMcWdA0K0SQ9xFtKq810/bvWYa8kgrTkU4c51m6UvyGueikNlIhJ0Q3KYkYm1wbfQCxUSlpXWMZcoSVCPSGH/cDgtDZ/hmJn6upsm4Sqr5kKiRIl7eqPy4JesrzduYGfwQit2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419953; c=relaxed/simple;
	bh=AJMsAC3Fi1is7CAeLsD9pCKPi30HTV6uOQu0bTNkAGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5FoDoimnULpvoc4PTm2aF/uy8oT/qMXxeHCDK1GZYkWtwZ1ymnolOdrzZHkR2x9XpkNFeLRuTl7DhAO+qyN2K5DoU6DwnzGiBUu4kzvkjJrNGxhWItJlu0dZLLjIxCRtJIG4kO05z4wMNAzbbLelQUWRRuCHgENZyAOwR8NUWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NF9YO4TI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NF9YO4TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999C5C4CEEB;
	Wed, 23 Apr 2025 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419952;
	bh=AJMsAC3Fi1is7CAeLsD9pCKPi30HTV6uOQu0bTNkAGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NF9YO4TIYVb6Capw79zE8cu0CEFffSUNWgHhi92KD8aK0TyGCYAHeOMuhIvkVCuNC
	 +Q8TLvlOxfxtTk4mC2mCWJTWjlUW5cBQFn7RMGglf9boJp6I/Hul+tK44gFbgIW7gq
	 /NU/maWoE8xmQH3D0qTy2K2mmAIssDSfJT0cM8EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 032/241] Revert "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Wed, 23 Apr 2025 16:41:36 +0200
Message-ID: <20250423142621.830594268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0c6214f12ea39..a24636bda6793 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3893,7 +3893,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
-	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



