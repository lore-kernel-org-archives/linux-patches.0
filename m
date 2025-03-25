Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4214526B975;
	Tue, 25 Mar 2025 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906299; cv=none; b=hpIOkg7fPZjaKl3Czqc70BAaBT5JcxpYsV5O26QaeZY+SF+EYT2qtDd/zAYewmbcKkWxJ8Fb+AamLV1F/NFD5E3M7LQCEKbT81EqsOjJTPLdL8PQ2Xl8JxHspaggpnbfKdvN0LnossBhK0gTf/JsteetT53WzK/0O3VxXDDH8AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906299; c=relaxed/simple;
	bh=qDuCWVd1Sky+8ehAYDuX8PuwSjhPcHYTHyUMz+cpYyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHc2d2QJ5dOEylDJqTOOf4dDME9/RjtlUvX+Cn4R/rAJFxlZGupGEf7P58KoSkLkhJm+eydNz3vjZevItntRwwKSK1f6rWhsBM9eCtLOA/sDwE8Q5F+LaEkJh5KNNtJxDs/eLUEvWYXZVKcVVT1iLaxWkBjYEACrkfNX06A7jJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSXwKqNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSXwKqNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CF4C4CEE4;
	Tue, 25 Mar 2025 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906299;
	bh=qDuCWVd1Sky+8ehAYDuX8PuwSjhPcHYTHyUMz+cpYyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSXwKqNmCVPgaYjZbk/Ql+n9gAfKghDzrb0rSxAODtstzL5u5RURrVUY4Kjhzcj7k
	 mkaS+/CXQpL/mepJHEeqyJOFxkcCn3rPOeZl+Yf/ntULtxAJM95ZMT7FcItprxOajo
	 iA41Jt79/ARq0QsZo/I8I/MtwUDuy3JrtRgupulY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/116] net: atm: fix use after free in lec_send()
Date: Tue, 25 Mar 2025 08:22:11 -0400
Message-ID: <20250325122150.334069636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f3009d0d6ab78053117f8857b921a8237f4d17b3 ]

The ->send() operation frees skb so save the length before calling
->send() to avoid a use after free.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/c751531d-4af4-42fe-affe-6104b34b791d@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ffef658862db1..a948dd47c3f34 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -181,6 +181,7 @@ static void
 lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	unsigned int len = skb->len;
 
 	ATM_SKB(skb)->vcc = vcc;
 	atm_account_tx(vcc, skb);
@@ -191,7 +192,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	}
 
 	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	dev->stats.tx_bytes += len;
 }
 
 static void lec_tx_timeout(struct net_device *dev, unsigned int txqueue)
-- 
2.39.5



