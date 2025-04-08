Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E6D26A1CD;
	Tue,  8 Apr 2025 12:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113892; cv=none; b=WFrHDBrrO3k/IDMg482VHRIeL/dU/Oq9EalwsBbeGMrT8ccnjLgUFsuqmhxFFL49RgOnJUQAijWhk/StA4tX4SgCqNf/38uXBjV2WRL4wTukt0IeOP+Uo27jDBNupDkngO0Vqe8lO1SL/erz527SLXoZNVA+tW4yH7gLzEYsHUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113892; c=relaxed/simple;
	bh=wKyaDaNa3z3FRxxCLX2rmSeBlYEu4innudLuhV6bqN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4BmUzTDhU2pdVrRLGaRIDVnftnZY+eucahEsY3ij6cYy2dHWZbQMaByqeNFePy0Ts/owbhMehM+lvMPb+KGe4aldslIWbBQH+B02rGYXz1eJ2ifK8/wvl2ZeLZeR0SDuKmr1ogFfkzhWAoLdcHnlN+2Ibc8tP9Z948mzcxok6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnFXyIq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnFXyIq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AE1C4CEE5;
	Tue,  8 Apr 2025 12:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113892;
	bh=wKyaDaNa3z3FRxxCLX2rmSeBlYEu4innudLuhV6bqN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnFXyIq7ntS8NjRc9WiojnYmF1I3gCnjUJgI+zJWLSdL27WG9jhLbzSw4ktJ9fFBK
	 pKQ7hXRpZfeWNANy5BWbifqkEicoej8MLZGUlk2VNZ8rRxwDURxXYKJolIyjCf5HSf
	 C7ZYwTEcyKEcscaW32LeiaP/Y2UH9KOwOxKO44R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/154] net: atm: fix use after free in lec_send()
Date: Tue,  8 Apr 2025 12:49:59 +0200
Message-ID: <20250408104817.145896075@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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
index 3625a04a6c701..07d4f256c38c1 100644
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
 
 static void lec_tx_timeout(struct net_device *dev)
-- 
2.39.5



