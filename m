Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062805;
	b=B5gCCjPJj/PeyJT1LtwJax0AA/oI9Y3E7z/lZRFg4r2mztnCq26K3JcU6c2GzohPmcPg
	 qsgqOy++cvqUFRo1Bz57exAPYbLHBDLVQjt+fMUgtgg46tawXtLqkd0nDe03ldl1n7/Uf
	 disfwoFksRXANpY+6RSDSqx7ZCcLPh3WrChGwKydx1eYN28A9LEQVgRBI9x7LqArzZXuS
	 8Q+f0One0HN/vUnwuG2WBtvOU3oX5YEKL7EKN/YAvzhmSo8n9aVlf6gdxAoFuEA0/Mx1V
	 VzTprc20lIl7eCk2wp+cIQKx0PTMPWxPGCUm5lVlTc9li9p/3KBE3SaBQr8mds9lUmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lSkX8m90nTuPlszUNUzdEUpw1BCy7IwbzQoVXAtxJ5E=;
	b=30rhnNc0kkeHRfxyqE7UyUF7k0SgzRbIi8dngQw96AUH2AfZpxoXkMGbEYL73+vggoiR
	 DdhZE0vZCf3uy4xZyigJReAGyOi8JmoI3wPohA91NNmDeyrnq4SR2yRXknMcrgbxb9Zm/
	 dDDiA5vNQ4ZbPNlVnpxRaci4lXRNMtYyFEDaBlorO3a/KC9OUZIpI+xVQiEwWUM+XBccN
	 uqLCgTN88xcBI8ufI4IFKJ3mrfGWRdqh6lTCA72ib5gQJOoiXyD7EQNzZFawq1OYyQIWs
	 +FeLmQ/wXNwuawPBWTFLUQvn6hjhHRWm6FdEn5YE5yWMPLMUSyfNswtXDJP5UjatrxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvZgHbvd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F47606A338;
	Sat,  7 Nov 2026 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvZgHbvd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779431F0089F;
	Sat,  7 Nov 2026 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062804;
	bh=lSkX8m90nTuPlszUNUzdEUpw1BCy7IwbzQoVXAtxJ5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvZgHbvdvTIQVurr+qhX6U5C7cCQdjcAwwigirItnZEMzfJogJT4z6g0HIlvd8io5
	 2mDNYZtQSAWRY5sgZg3ksSQ0OjxmVp+YcYk3Bgkhd2rxik/i/Eg+XIQyupqcImm3cg
	 WGCP0lNpnsR6L+7HeYzUVg8+3nVfo525G+BDHBcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/869] media: stv0900: bound DiSEqC reply length to msg[] size
Date: Sat,  7 Nov 2026 08:46:28 -0500
Message-ID: <20261107134856.208378946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 6d7e70111b9c80a9e4cb17fe6a6c4f5470847722 ]

The FIFO_BYTENBR field is 4 bits (mask 0x0f), giving a length of 0..15
but reply->msg is __u8[4] in struct dvb_diseqc_slave_reply.  A faulty or
malicious device reporting more than 4 bytes will the array and clobber
the stack.

The stb0899, tda10071, and s5h1420 drivers all properly bound the FIFO
count against sizeof(reply->msg) before the read loop, so do the same
thing in this driver.

Fixes: 99277b3824e4 ("V4L/DVB (10803): Add core code for ST STV0900 dual demodulator.")
Cc: stable@kernel.org
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/stv0900_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index e7b9b9b11d7df..ce228f2ef330c 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -1775,6 +1775,8 @@ static int stv0900_recv_slave_reply(struct dvb_frontend *fe,
 
 	if (stv0900_get_bits(intp, RX_END)) {
 		reply->msg_len = stv0900_get_bits(intp, FIFO_BYTENBR);
+		if (reply->msg_len > sizeof(reply->msg))
+			reply->msg_len = sizeof(reply->msg);
 
 		for (i = 0; i < reply->msg_len; i++)
 			reply->msg[i] = stv0900_read_reg(intp, DISRXDATA);
-- 
2.53.0



