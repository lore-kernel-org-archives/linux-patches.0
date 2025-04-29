Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA87C148;
	Tue, 29 Apr 2025 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948857; cv=none; b=mzvUTYRgJ/aWZQUxz+98GhAwxr77ORfBuN+xDpDYG+FiUGDjvCfXi0V7ZHaAi2uHRzgH1Qa7vua5MLNTh31zFOehKjMaLm1aG2DypNxSMzZZIL0GsYXltO8FlMc57UPXYP7tMkpb3zBne1Hk1TbVxlagDQ2UqNGXNtGK0INMjdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948857; c=relaxed/simple;
	bh=I1EaBKrjgHZAj5j0L4hvhLGhMCUomZmMwQ187dymnHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYY4mtoqqA9zoINMM5tgrbQuLcuRDKbH2iNI6bQ5pM95qIJfkas4fs1EBFoV+raszWgfJGEU4SuVn5co0sZEFAxrNS40ZNrYNiMBJ85FAJMfnl7P5O/TMxO5fozqGd4Z1kh2moNhuxMeXCGs1JUWhuHB7h0eGy4NKcyOObD52f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8Xo7SFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8Xo7SFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C877CC4CEEA;
	Tue, 29 Apr 2025 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948857;
	bh=I1EaBKrjgHZAj5j0L4hvhLGhMCUomZmMwQ187dymnHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8Xo7SFI/z51jhhlwpmCUgObYMQAr/mmKNGbvTKQVmEKj/KUefcCkAq3ffKeyPNJv
	 ASiUH2B4mo56M4NOvNTnZRRuVqXMfDsKFVIM+ZMN6JeDKKThulq5Duy/AZdoIarrZ1
	 IpuFNnbSfcfWAHyX64qdNX4k3xYlkO3S03459/hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/373] Revert "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 29 Apr 2025 18:40:16 +0200
Message-ID: <20250429161128.886432829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a658e747798b..c4e6fbe4343ee 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3704,7 +3704,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
-	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



