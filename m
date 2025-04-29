Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E421772B;
	Tue, 29 Apr 2025 16:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945465; cv=none; b=LXBObIm1E2FQLLLZJXx8CJZgcGc/HSNyZwwdoE2ZiikHabM62HUihMeP/cSZxi/6UjFUQ1I23cytnqTdAcleitnOMXmT+47FRtRswxdZMIHXJn5tBP9cHU/e14JlRwOAugKLKbylS7dhsrFTgEkT9llpo8r14dFuzeYpe3/T1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945465; c=relaxed/simple;
	bh=xKZbTEae3B5RAoajgA2A8JPLDxxfRramshGopkB1ADc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jd0uLnssrcMaIBuhGW8FsVT6TLWWH6/OK2wLmvGVuceIkOUG0RpbtmgulsI9JNjDTF9zm+OhVdkaNy65kJ61aj9KFWuYDOEgIxt3xuyDHirvEUrD0SqtKqcAI3fQ8GbHLOqziOoniBc5d3/2ZHjENZRGUbRRqw+CNvSwbl02cbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtsCqNEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtsCqNEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2899FC4CEE3;
	Tue, 29 Apr 2025 16:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945464;
	bh=xKZbTEae3B5RAoajgA2A8JPLDxxfRramshGopkB1ADc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtsCqNErEXHnQoqauEKTvFsTVNsznV9ImvEygX1S1fArcPrPyKNBZH7CqGLefTp3f
	 66SO2VF3gxmnB6gyKcyoL87bphut934ltVma7H5CCfVPmK5CX7F1RYnUsiSBKMxPYG
	 aXzGpxpE2MRNs/iQbhiqggvCcztDbO3Pf92esoBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/179] Revert "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 29 Apr 2025 18:40:32 +0200
Message-ID: <20250429161053.085365018@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f8d72f3e4def8..461cff7b94ad7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3661,7 +3661,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
-	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



