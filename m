Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4913043AD3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJfHZtcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA9FC4E779;
	Wed, 15 Nov 2023 20:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081636;
	bh=6IdA5aniX3OFtNbNiVaMG3zvwID+TW5Jz6lteN9OY/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJfHZtcsiyzwffRVuzGmgOjbZKtKlwELSF8BBlgOY0PWWBMGorBaUZq2Th+91+uW1
	 T+ubJ0qzOy1aS6Sl6B3FU9zoTzWIeH903TRPLJizjnStTz/gXWcMmreSjHCMzalZzw
	 s5gmoSul4roJi4PlV3EPhU0S7CAshFhNxvll5Tsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/191] chtls: fix tp->rcv_tstamp initialization
Date: Wed, 15 Nov 2023 15:45:05 -0500
Message-ID: <20231115204646.354033283@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 225d9ddbacb102621af6d28ff7bf5a0b4ce249d8 ]

tp->rcv_tstamp should be set to tcp_jiffies, not tcp_time_stamp().

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index cd6e016e62103..ccf2bec283d35 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -2259,7 +2259,7 @@ static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
 
 		if (tp->snd_una != snd_una) {
 			tp->snd_una = snd_una;
-			tp->rcv_tstamp = tcp_time_stamp(tp);
+			tp->rcv_tstamp = tcp_jiffies32;
 			if (tp->snd_una == tp->snd_nxt &&
 			    !csk_flag_nochk(csk, CSK_TX_FAILOVER))
 				csk_reset_flag(csk, CSK_TX_WAIT_IDLE);
-- 
2.42.0



