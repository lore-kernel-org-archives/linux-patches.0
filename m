Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F0A1E98EF;
	Sun,  7 Jun 2026 10:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827284; cv=none; b=cp8S7MfhkNY+AAYkr2WCt1cSDhdPIb5Iii4OgZXJA160JmTCUPfGCL++HE6ZQtzKkI/8s8Olom7qLmk/k23fJKraY+69hIYwkRWck22USrbem203NBPboOsOBwK+bixqaUaR75cXn3EqhYoo53xHD7GoY5e+fsLxzsMX7nsvqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827284; c=relaxed/simple;
	bh=ZheYC2cqenjdT6AlVb/Sl5uxvcZaYOzri71bfGlz/gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmXpSTO/PHJr0UKLURj6m6Rf7YHOa0zGkAMKBo3TthTS57RxcJxL75TL1awuOKvCs41URrkWoMy47h5mStYe8gDENcIJ/MX8HQYw8CyzIranXyPIDXheXw9r9nLgWEdnC3sAyVgmAcPkBjaWQvIf1RvUgLxMGw6vegYFVbpCN2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lpeyu/26; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lpeyu/26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CDF1F00893;
	Sun,  7 Jun 2026 10:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827283;
	bh=5RpjwFUkejDmua+55GAPhkLIjLlXzgSpPU1HmmUF+LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lpeyu/26pvapNhGItnhB2JVAaDe0cksIO7IabgnsKx5REhHkEAFO+SAK0Yb5zVwS3
	 Iwb33R0PYxUsXocYUmZkPPFING7z7LO2IrtH+dhW9GTIy/O+GKO4uhUNiuTC1r90Iv
	 P3aRNVTgphrjS25qJ6W8SstFRTbmlBV1uFaJXYRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/315] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Sun,  7 Jun 2026 11:57:27 +0200
Message-ID: <20260607095729.811079310@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

[ Upstream commit 3c40d381ce04f9575a5d8b542898183c3b4b38dc ]

The skb_clone() function can return NULL if memory allocation fails.
send_mcast_pkt() calls skb_clone() without checking the return value, which
can lead to a NULL pointer dereference in send_pkt() when it dereferences
skb->data.
Add a NULL check after skb_clone() and skip the peer if the clone fails.

Fixes: 18722c247023 ("Bluetooth: Enable 6LoWPAN support for BT LE devices")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 2c21ae8abadc22..038f01600eebab 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -486,6 +486,8 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 			int ret;
 
 			local_skb = skb_clone(skb, GFP_ATOMIC);
+			if (!local_skb)
+				continue;
 
 			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name,
-- 
2.53.0



