Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07118FC91;
	Tue, 12 Aug 2025 18:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022329; cv=none; b=CV+v7KGZ+2WFCXj5qx4e65TOjYRWExKuStBGuweLiolgQnAYAoXhmdLc1JMRkea1qMKL218mDhpddb0E2a+sYSN55TSI7NNA83kgk5O9oS3hQ5Hgg/fv15a9tu7xU5SyrG9KhGd2Q6bjLffYEONckMACrGwvRwgAz/8leYIj3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022329; c=relaxed/simple;
	bh=xcfSfaPd1vD9QM6Yg2DhhWjyZjdBX0SK5n2MsiXt58o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARAg9Tp1+mx64f3nef3+7vQCfef0pxKFJ0o0yNmcXBXr2uS2QRM49C1bSEf0SVcyfdVj5eapXKGzFEIIFjnUa/u9JFX3aKd2tPCwDd0YW5hDkaUdMULH3vu3EmhOWFBKDmUJsBqQ0GLm67GiRMl0Wq/zb5T2SYbu+AkE9Wo0SeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9q1Uzp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9q1Uzp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F573C4CEF0;
	Tue, 12 Aug 2025 18:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022329;
	bh=xcfSfaPd1vD9QM6Yg2DhhWjyZjdBX0SK5n2MsiXt58o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9q1Uzp0iLTQd2lkYkV6QZ82qNvdErIl3j5SlTEHy361UAqjd2y2fGafDXVQEJYX5
	 46Bqxc0PQZ9QinA0pEEB77bCPihzBmHpGJYRgLn6r9qOAIMSyIzdYgqsF52F0t3yX6
	 ppqdpH85tPnfWrsii9CmqP2IGad/Opn8qXiXEIKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/369] Reapply "wifi: mac80211: Update skbs control block key in ieee80211_tx_dequeue()"
Date: Tue, 12 Aug 2025 19:27:00 +0200
Message-ID: <20250812173019.393419795@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 754fe848b3b297fc85ec24cd959bad22b6df8cb8 ]

This reverts commit 0937cb5f345c ("Revert "wifi: mac80211: Update
skb's control block key in ieee80211_tx_dequeue()"").

This commit broke TX with 802.11 encapsulation HW offloading, now that
this is fixed, reapply it.

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://patch.msgid.link/66b8fc39fb0194fa06c9ca7eeb6ffe0118dcb3ec.1752765971.git.repk@triplefau.lt
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 16a997d8442a..9c515fb8ebe1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3892,6 +3892,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
 	 */
+	info->control.hw_key = NULL;
 	r = ieee80211_tx_h_select_key(&tx);
 	if (r != TX_CONTINUE) {
 		ieee80211_free_txskb(&local->hw, skb);
-- 
2.39.5



