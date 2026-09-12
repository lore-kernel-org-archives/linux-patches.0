Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BDC381EB8;
	Sat, 12 Sep 2026 19:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241673; cv=none; b=GZvo9K8l7xA4P3WXeSl1CRyeeUpu5gglPk4VgsHdo51Uil8U6+EDTBggNqYpyq3TvxUlnTqipE9pmTTtKvTDsnaUDnEAUuXhpAuj4idVyFWQLpv2l/xk6/CTnba3wlRLrRXD3WlZ4Wgfx5pc0QtJrFriQeoU6jpm+cPqAj//9E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241673; c=relaxed/simple;
	bh=SPubxWu2qMrQkkYwb0H6BW/gfYU1PUPu/Szlm2oIa9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7S74TlH/qceoZfg2TqHtgIShQ5/f70KU0U9gyx8tSiNJ8SDhg/3P0QlLdRjK21BAH7cDAFd5bhJaJqjp0hnA2jOJD4NRrOrwu1fmt7vKcAo0eKVYFvf0QxQJVvp3QD/1jUP/pdF5Pm+KeXW8aKMLlBP4KCxJor1LGS21rK4rOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wgb8J3r9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wgb8J3r9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D111F00893;
	Sat, 12 Sep 2026 19:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241672;
	bh=Xz94O3w3vMqIMrtPHKXfsECJTjh6V/Qpcp8ILK4QaLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wgb8J3r9XMk4QQDM+RdXMs5zat+xPtDD//+WFtq3fdbqbT8PrhL9swF/VRHXXQn7T
	 ygvD/lMf5uXklAeXM6zMZzgt4uf4maihZcARVvv7lkFcqkBvi+vSNF39GM9/q7DHAC
	 6SpV+fMsn0pY22olAjbfm9kD3orFs8w/kcNZ7usY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.10 183/798] wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
Date: Sat, 12 Sep 2026 08:56:51 +0200
Message-ID: <20260912065521.232347792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -542,6 +542,7 @@ static int rtw_txq_push_skb(struct rtw_d
 	ret = rtw_hci_tx_write(rtwdev, &pkt_info, skb);
 	if (ret) {
 		rtw_err(rtwdev, "failed to write TX skb to HCI\n");
+		ieee80211_free_txskb(rtwdev->hw, skb);
 		return ret;
 	}
 	rtwtxq->last_push = jiffies;


