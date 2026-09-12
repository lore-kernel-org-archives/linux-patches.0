Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2BF3624CC;
	Sat, 12 Sep 2026 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237184; cv=none; b=YqcGtRcVlaJM+rvk2qSOv8K7woR7Nx2X8Cniz55iK9e9iB1bEDzUY1u//tnpZ+RSyBozc0CnMtl6wB6s4kXNFTE6ugPjxb4//hTOtLmckfpwlWR/hsAdRnhlTKPI2+P9LahEuyoeH2EVYMyedZxBuTDab927TqQAxFCEpKFRGHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237184; c=relaxed/simple;
	bh=dq8TrEH/Uv7Ol6y6dISR32Zu+hnvkI7zLRbq45O/714=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABVHX00caV3hn7pYUvdbfN12RtH47Hu967MGGdRB5LJ0hJLSO+lQ2OYiEzmpy8zMi2Hpr5Os7AJq3uCM/fjpPwsxP9pmrTL7nwcsRmCoJ1UA7v/p0wZaaWrIdRpXcYn2f+zBSH8AsuhLELXrtJOFJRdBMJSHMnIa8mDzpR+vcsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU4FJWdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU4FJWdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D8A1F000FF;
	Sat, 12 Sep 2026 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237183;
	bh=F/EFCBJ7Su3BN/S8Mn0DD90sY9acBgxldXaa8u49Iws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UU4FJWdwiV90NXcFMfx9bbi36RZkzJwc711y847ekhPy800rjeFXimnCVkWupEd4b
	 1HlQCAEUdZECw2dM7VT+j/9kqKwuGk4fmkkRU8dRb35jdBP6IXjWsNgoVsRLZU77jN
	 CYvvrtcqurg9utYThzWqlIu2Rui7RBbb9BKzCGq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.15 206/935] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Sat, 12 Sep 2026 08:53:56 +0200
Message-ID: <20260912065531.545175374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 9f2948010764d708bda27369d09ce6f194abe8e3 upstream.

The skb passed to the rtw_hci_tx_write() is expected to be freed when
the function fails, but the error path in rtw_txq_push_skb() does not
free the skb before returning. This can lead to a memory leak in
rtw_txq_push() where a dequeued skb is passed to rtw_txq_push_skb().

Fixes: aaab5d0e6737 ("rtw88: kick off TX packets once for higher efficiency")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260727064223.61836-1-nihaal@cse.iitm.ac.in
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/tx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -547,6 +547,7 @@ static int rtw_txq_push_skb(struct rtw_d
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	rtwtxq->last_push = jiffies;


