Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020625;
	b=Py5f5CzUc1SLSYRGdGsNJeOZbKAXShchUQgWHKCDZOg7J8CbyaV3mjr0akDujlXAmGuL
	 6rc6/E0yRxRRyTcAqGSvD1jeJvmygt6k96GAo0+K6pco4sFpEcPnjAeEwIBwBGiYino2B
	 381TthsK0gOKwcuodqs/llmC9I1sMlotMIwfzw1R3kHs0Ofc37eW9e/wQHp0JofmyWU2D
	 C4MYAN/qBkUhQkIEb4HXb4KTlVHuG+4iS9JqfzL+U67xDWDNKTkcrkfWpx6KKo9pJqDYL
	 owZllbbUvdYK0M1HE7S/Ey+3uqiINHCBjaHbDBJOyUce9HQlx31V9ZfSCYoOAGUtEFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GrpB+J/d+uaVT0ujZBZbfiDrocDIunEuqVQqY3JmWGE=;
	b=NuUJyzF+9yjdM1ok+IZzhGJk9HoaU5jYe2XFObOHnEnbcQwa8OxRNlmc+2TXMmZRp1xN
	 CBZQKjEdRsWPJFzBox44cCbwKi9zS2av/8Az9nfBaDzGJmz3Rtw2AdwmkvpJVBZEqnTQX
	 hubrPGkUdazAJ+P3WWczI/Zvw+qwvIG/Cn+rwywDL2AdwNTNu8svnPnIXBKjGCwGx8C5L
	 6/7TQz5+KOx+YC07kzAUxfvMwhTgIBb/iz2wxPTiQr06A1YFbocUDQGNNSfav0ff3wtC3
	 qFAlTxM8sVdxZ4u+tlB/EBLKbW+cRKvGmwYjCp5jvR8Zm6euZ4wEGzeYFLlhSp3N9/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZivdxZvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD362606A32A;
	Wed, 18 Nov 2026 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZivdxZvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0948A1F000C4;
	Wed, 18 Nov 2026 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020625;
	bh=GrpB+J/d+uaVT0ujZBZbfiDrocDIunEuqVQqY3JmWGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZivdxZvT0ZfHjIrA8q6ZpkpWHbUbN/o9qr6ZOKrLMZvyeBVaI1D5t65LqvR1OOyGs
	 L1rMxvRid16RvbRBDk0EwO+5I0pjKh9Ykp/1cKyukaL/epoSYhyeuut2S5SKTNfEdv
	 ZkxJo6JsEL/95HxamEVjUsZcielZ8GrxZRZexqHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2019/2651] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 15:54:19 +0100
Message-ID: <20261118150358.907608993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 78a19b1346321..233391acebb0f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -486,6 +486,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -493,6 +496,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



