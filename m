Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6D02727E2;
	Mon, 13 Apr 2026 16:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096792; cv=none; b=c2Xt5EO8oEQqrgSswUVkcKokjimeXEmn1KIKUT55Q9L43GCdZ8h018fNmCu/hea6AhT27Yzv3EduXKH7aOjN9CmNVIjaBIASmRt/uj277qZ3eMO6cAcCyGpEZupMmvP9h5sxvVVo2XbYcpmBnhZqHl+Wid/G6KP2PhEJDcAhV1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096792; c=relaxed/simple;
	bh=7M9I2h8ODuGUKGF8+Qot9RL8RDIkfhHZWbflrlU2t/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNQ1sYgnN0clB8AYeTVGEe1WpOaEfTHA4G0jQt2ciAI0waUp+Ld07cZauDLTKFxFrPDbSXbtNaImkkyC/mN3836spSOnilofS2uO54SAyQurz1KFKdqbxc/s0x4zB+TCsJ7G01rLgc6VifzoL+t1g1jbL8mYj4zSHUFTQrryII0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtVVd797; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtVVd797"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17276C2BCB4;
	Mon, 13 Apr 2026 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096792;
	bh=7M9I2h8ODuGUKGF8+Qot9RL8RDIkfhHZWbflrlU2t/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtVVd797vkGJ6ZgHPlmd4rirx4shCeNoyFZrTlYp+OEvJygeDwv94YFP31A2vDLOa
	 iJC7Zkl0WUEMrKQMdcHbKOCju43Exw+hCV0ECyNK7x8TnsaLwwCJyjFbArk/pCX5m2
	 RDtrQZ8Lkipome6pTIvFizTszOHH7L2dev46wnm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 65/70] rxrpc: reject undecryptable rxkad response tickets
Date: Mon, 13 Apr 2026 18:01:00 +0200
Message-ID: <20260413155730.604497433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit fe4447cd95623b1cfacc15f280aab73a6d7340b2 upstream.

rxkad_decrypt_ticket() decrypts the RXKAD response ticket and then
parses the buffer as plaintext without checking whether
crypto_skcipher_decrypt() succeeded.

A malformed RESPONSE can therefore use a non-block-aligned ticket
length, make the decrypt operation fail, and still drive the ticket
parser with attacker-controlled bytes.

Check the decrypt result and abort the connection with RXKADBADTICKET
when ticket decryption fails.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-12-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxkad.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -870,6 +870,7 @@ static int rxkad_decrypt_ticket(struct r
 	struct in_addr addr;
 	unsigned int life;
 	time64_t issue, now;
+	int ret;
 	bool little_endian;
 	u8 *p, *q, *name, *end;
 
@@ -889,8 +890,11 @@ static int rxkad_decrypt_ticket(struct r
 	sg_init_one(&sg[0], ticket, ticket_len);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, ticket_len, iv.x);
-	crypto_skcipher_decrypt(req);
+	ret = crypto_skcipher_decrypt(req);
 	skcipher_request_free(req);
+	if (ret < 0)
+		return rxrpc_abort_conn(conn, skb, RXKADBADTICKET, -EPROTO,
+					rxkad_abort_resp_tkt_short);
 
 	p = ticket;
 	end = p + ticket_len;


