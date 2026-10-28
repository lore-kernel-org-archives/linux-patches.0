Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216032;
	b=M0Zygad81xbj6T0gt+EA4Ds18i/O1k0R77uM1811NjRZoJyTLQKqZScMW5VkByO+g/aa
	 WRRLsCqWTkPCkWeecmekKIVNCDRa9krIjfAO/jUibcJRgaUQ/BvC6wliKErPPeF9IMS7M
	 qFkZA5CjkmulBYNHGMG3edq2ftLZWJG0Hw8zuWkWWiAal1vsVeOJhTy1Kid6Hq9TiECck
	 FJ9XcuOD5AxnIHwYwaSTwjQpxEuxkhp4AUSIXDmBjDHbjvvB8ArR5GuVWFXHklncyhZ9K
	 Mwk9aC6QOUk5tr/GqyF9MdiK3WtAE50Wg+p9EPand68WV58RNgoOq/+r4COqAas8O8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwzpsjtmTjC6d5++Nk3SA5Z6mlvjBxwRSDxgVnRc5mY=;
	b=v7x7wVpXoYW6ruqWh2b5HkpKbawlfh+Sant/32eWXOix9D4NIZkkHnIbLV9G5XspK0fy
	 uP90Vat8TwA3tj5DxOHFCFpGhDBrvRrRsOK7LhlDy78uQ+wq2lDyDQfYa1Ojh0RMLZA+8
	 CpcNgizBDy47w3LozZtphI4QdStKObFzj+VkOoO913owZHlt9ZptcD23Tn8rQzDC+jQo3
	 vMx0QrKwULTT0sQJ3tMtVy/zN6NUBIDZQVbiiKv6oo87FiMJKvfUIefLdcLUzHjFZ5Jf4
	 bZxtpD+SUDcym/SzvlqcxxvZKYBSRNOF8tXzZHUWWZcXG1y0cJ+9dxY18BIGahNU+Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SBJlG2/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2171A606A31A;
	Wed, 28 Oct 2026 19:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBJlG2/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDE51F01825;
	Wed, 28 Oct 2026 19:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216032;
	bh=GwzpsjtmTjC6d5++Nk3SA5Z6mlvjBxwRSDxgVnRc5mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBJlG2/4pQNN06fTfygbXqZTrbn06TDolA+lryIolFlwRLstAKHKUcDA9GqxL+FMb
	 0OqbKATNQogihMEkI2+xQS3h5ROg8bMjbP2+mEfUuQwnGcu8wjGWFxQPOEn8DdCVT0
	 tdxQbnLJDMtUZQ7TtlWyGyOYEUZDPL2AmcJcgOL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1373/1887] net/smc: stop killed, freed and out_of_sync sharing a byte
Date: Wed, 28 Oct 2026 17:57:49 +0100
Message-ID: <20261028170530.694377863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidayath Khan <hidayath@linux.ibm.com>

[ Upstream commit db51a8658c11a82432b64999519a269c3aabb447 ]

The three connection state flags are single-bit bitfields, so they occupy
one byte of struct smc_connection and every store to one is a
read-modify-write of the other two:

    u8  killed : 1;
    u8  freed : 1;
    u8  out_of_sync : 1;

They are not written under a common lock. smc_cdc_msg_validate() sets
out_of_sync from the receive tasklet, while smc_conn_kill() sets killed
from process context under lock_sock(), and the receive path does not defer
to the backlog when the socket is owned -- smc_cdc_msg_recv() takes only
bh_lock_sock().

Give each flag its own byte so a store no longer touches its neighbours.
All readers test them as booleans and are unchanged. struct smc_connection
grows by two bytes.

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260820074642.966856-2-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index f480b956c45ef..8ad6ff655f913 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -233,9 +233,9 @@ struct smc_connection {
 						 * 0 for SMC-R, 32 for SMC-D
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
-	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termiation */
-	u8			out_of_sync : 1; /* out of sync with peer */
+	u8			killed;		/* abnormal termination */
+	u8			freed;		/* normal termiation */
+	u8			out_of_sync;	/* out of sync with peer */
 };
 
 struct smc_sock {				/* smc sock container */
-- 
2.53.0



