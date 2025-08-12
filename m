Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2202F7461;
	Tue, 12 Aug 2025 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020573; cv=none; b=VYFzA/EXZvFO6+LjPsFnU9MylOD7SQR1bcRx1vNdMOnH+uJKgP2uRlT8cfyLiRt1IpJaoIqUrzr4dFai+Rqd5KPEOlkkfv0/1Dvq6RwdQ9qfbOnUL5ztp079Qyt3m8xmKCVX8Kae4xCwKh0NtoCUZKk9Ekcp/Pjf7cYJbfvNQOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020573; c=relaxed/simple;
	bh=w7KwPsTtA48KeJKUhL+xPIj/gRXqEJEqwbGAnYecpDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bua38tuhPys/5QigDozYJP0qzHpphSqnI5BXR2kqvSrg7bpOLfblGPJEig6PRGEFFs0lP5/xDzUOZkgELxp7M1wFkSSmuqJXlNds/9crmIbhdXomBk14FU6bimF26QfC3TxufdHNfekqCQbiH1bQO2itB7C9SF4p7iiVaXBbDq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaMdAAoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaMdAAoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57696C4CEF0;
	Tue, 12 Aug 2025 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020572;
	bh=w7KwPsTtA48KeJKUhL+xPIj/gRXqEJEqwbGAnYecpDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaMdAAoSxbHp+cLjBDcWwx6lG8wLv5EJPSOK3/JsJojA9+uIzPKd3MappazLD+094
	 xZGTgoDPojerApMboNH/DnjAitgTdVy/WR76lC34GsUFuBHVIM8OeOSf0aDXHFS22W
	 EGjHJu0JBrxyPN1ZUgaI6TQqq7xdqZE+1+pEjSO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/253] wifi: rtl8xxxu: Fix RX skb size for aggregation disabled
Date: Tue, 12 Aug 2025 19:28:27 +0200
Message-ID: <20250812172953.771560162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaistra <martin.kaistra@linutronix.de>

[ Upstream commit d76a1abcf57734d2bcd4a7ec051617edd4513d7f ]

Commit 1e5b3b3fe9e0 ("rtl8xxxu: Adjust RX skb size to include space for
phystats") increased the skb size when aggregation is enabled but decreased
it for the aggregation disabled case.

As a result, if a frame near the maximum size is received,
rtl8xxxu_rx_complete() is called with status -EOVERFLOW and then the
driver starts to malfunction and no further communication is possible.

Restore the skb size in the aggregation disabled case.

Fixes: 1e5b3b3fe9e0 ("rtl8xxxu: Adjust RX skb size to include space for phystats")
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250709121522.1992366-1-martin.kaistra@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index cd22c756acc6..c1bc55f0e4c0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5858,7 +5858,7 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 		skb_size = fops->rx_agg_buf_size;
 		skb_size += (rx_desc_sz + sizeof(struct rtl8723au_phy_stats));
 	} else {
-		skb_size = IEEE80211_MAX_FRAME_LEN;
+		skb_size = IEEE80211_MAX_FRAME_LEN + rx_desc_sz;
 	}
 
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
-- 
2.39.5



