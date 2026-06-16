Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AE546AF1B;
	Tue, 16 Jun 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628123; cv=none; b=Dfyj6hyVWG3dHxN94tarHt/DpjGbzj0IYw38bblAZ4o9ephgJvpC5gkuNaf8GUv6zhFilWhHyIZ8hBpx2LpNquqGdXbbEn/o2/1qiD2Ks5nLh6ZJVBYqRa/sIXOj3Na/4EEA28G9Ne0MlTxTfZU/0+6a5/t8ZOC7pUBGNfCsPKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628123; c=relaxed/simple;
	bh=Snlx6Tjue18sKzLc+IuXBUE9CtgsHEUcjqPWNMi2oCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/sL6wkpYeyxL8c+560krpd9thtGFQwB5Q7bl4CqDL+X1a42oCz9L5Z3K+ZuRSKmsg7kaWJvYCkH+GjB7ZG1qaPkGJD6GAIJauvkXa3Q3FKEfhOLG7Os0CMwG/x2JcnFt4sV1znIMPP3nP2uIclKzhUJbCa6Q1SzyccXTlQ7img=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+bYeJZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+bYeJZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF5C1F000E9;
	Tue, 16 Jun 2026 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628122;
	bh=oqJTyphGw0/H2DtqHta9ftTSCkZJZU+djqJ/oQtMwxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+bYeJZ2l9Aeg9koXOpPQspTJc/y9mSg+MbA7vokS/IwiHt0QxUPQq9hD2Gy9UTZq
	 7Lq9LdXzlGd23Kk25+Pk3S9sVFnZRTIM2nC01HT8rdLtx4XAVlEEMa5dyW4muJDG8A
	 gFtJhDC/O6TeQ00kb9Bqx58GUDZ8dxlfUZ5jpdiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/452] Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()
Date: Tue, 16 Jun 2026 20:24:22 +0530
Message-ID: <20260616145119.777554953@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e65d4754c94f4c..b3132079573d4d 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -485,6 +485,8 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 			int ret;
 
 			local_skb = skb_clone(skb, GFP_ATOMIC);
+			if (!local_skb)
+				continue;
 
 			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name,
-- 
2.53.0



