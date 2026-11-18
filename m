Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050042;
	b=gZ8vHrT6lhXL1+ZAYa1yh+WTx36EPyRhXcgNeGAxo/mQ1N//74EBHeWstOf49yGrDKcP
	 M2IwlBz8xeXoipacwv6ZfYYlf8XEarBUoZvEhpc359dopENe9PudHGx8DJ1tckSb66UWe
	 w4d9SUQI+g0V2gyAsEgZIq0V8cPdi93dcMXEuMb8NDojIpyEZVKiMv53DJg5g0PMOgbMc
	 J0h6pHv13U2zWuqsU4yrGqPw/uVfn3TmDSZ79HW32e40ZXVCxHZxDu3FoX6vUkMgqCCCC
	 ZSQ4Tldx9wZWD/uKfzXcWDF4dsuXjbyLDksXrLOQ22yT0x39oaI8jrFlpVlcm2ayobQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RXnx3NUQN3r3ZwdOgnkW4X12oyn2sBkx7P9x6FvvVZ4=;
	b=2H0sCWfMFb/39TME3VNzxLC7simb05/tMx3hJfznaRqvy5oxrt/y1il2bdfFc7WbUUEt
	 YUUx/7Tr0GsWi/qCLuCDJKNF3uxm4VLAvXt8nypbPODPd8WNS5rjaODZXrfjrrm6nsMqU
	 4GmP9XqpFc1fGricskhhKLqdxCnFUbzugR+COmhqeRJsCs4z4CvGWrlPXCEAmFdgNljfU
	 UAZt6x1LnE7pVADidM3c9JrejCyTozxDcI4/pH0e0mkMGW+UhYhcylnIAbkr+WQNK1bbc
	 wcnIfq6zyJ4MCsA7N0X4rM0thghYZL4hXi4jLueAVeUXnyuOgPkjD5sJkas8D+5TyeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNYSOYdk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C76A606A32C;
	Thu, 19 Nov 2026 01:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNYSOYdk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638A51F000C5;
	Thu, 19 Nov 2026 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050041;
	bh=RXnx3NUQN3r3ZwdOgnkW4X12oyn2sBkx7P9x6FvvVZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNYSOYdkoUQT4bX/DTwJHkqm/K+TVdzXcyyZsv5PDkiRDspV9HHM5W62NItj4j49D
	 /lBZIVxceMLqLZMNix0fmT0eG4jhi2Yw1M1/iHawWlFkOYi7Ffo1UZ+Zpd6H1bTERs
	 jc4swx4kB+Gsohr+SrgxVHid+sKLSnG8usWfHdLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2566/2857] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 16:00:00 +0100
Message-ID: <20261118150333.881314614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 94d51c59f0a872c57cb8daa1964ec033d77a79fb ]

After allocating the last valid packet number, MACsec wraps next_pn to
zero and deactivates the transmit SA. This happens for both 32- and
64-bit types of packet numbers (at values 0xffffffff and
0xffffffffffffffff, respectively).

TX packets that were still getting processed during deactivation keep
being processed and then receive packet numbers. The first gets 0 and
is correctly dropped, but next_pn is incremented to 1, which makes the
next packet take number 1. It then does not get dropped and may induce
a reuse of the AES-GCM nonce corresponding to value 1.

This race affects TX packets that have already passed the SA activity
check: packets that observe the inactive SA are correctly dropped.
Reactivating the SA after PN wrap without a packet number can also
cause nonce reuse. Keep next_pn at 0 after wrap, even if the SA is
reactivated, so further packet number allocations return 0 and the
corresponding packets are dropped.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20261008080625.360063-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 1bec8ae44745b..1f885846f00be 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -478,6 +478,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -485,6 +488,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



