Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0125B0B3;
	Sat, 30 May 2026 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165531; cv=none; b=RI9fRcu8bhyUyqDArAGMJkQwcJTs8SWVDrE8i39VKaLa7J6m1XiYYlADybnE1AKKvc3AgcUY2D4zZMmcCm0Pf8lNr/OOrgl2c9ea5iivEKBveApMZ0X/GYvqupOroEIQJ/O8yl/G9w5EOcjdcKznbqjidG2VHaAQJEcm6VKRc0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165531; c=relaxed/simple;
	bh=Schzmzdn//zX7xb0PgYshWvKNoOCMC5hV0YiDmjuBuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4RhXvm8OqHEGro3ph/VudT1/T4XpLMg0xrq/4YJe2m1gCLGF3wKPcs0A06A242cm65+ezkQnnEmeLBidKjsV77MXeGW2WnvIBusPO0ppdCcoYXcdt6v3rDHckdABeppoJ0Vdi4zSNtzoH+M+fGAPSBxLCyHo2q7jPL+/KePvLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q50wjiyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q50wjiyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1D01F00893;
	Sat, 30 May 2026 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165529;
	bh=Ge+t+1/ypj0lZause7s5iI9Tg2mot+z/hGFk3Gbc87E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q50wjiyPQsQtGMAcqkoFv8bcYM86AIhmnzAw3Mv3YTvi/L4+VdPs8fPvfmn4NGQzS
	 1YKoUXX7/zrQjzGz93dVEVvrKxkOgis5FYsvfxrpsIhDGGTIbbsoG9mwCpJyTzMJzO
	 eKmLV6IvevD1NpFLTeEMWfmsA6qygxcM+P/5KH28=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/589] rxrpc: reject undecryptable rxkad response tickets
Date: Sat, 30 May 2026 17:59:47 +0200
Message-ID: <20260530160227.531449629@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyuqiabc@gmail.com>

[ Upstream commit fe4447cd95623b1cfacc15f280aab73a6d7340b2 ]

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
[ adapted `rxrpc_abort_conn()` call to existing `goto other_error` error-handling pattern ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxkad.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -941,8 +941,13 @@ static int rxkad_decrypt_ticket(struct r
 	sg_init_one(&sg[0], ticket, ticket_len);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, ticket_len, iv.x);
-	crypto_skcipher_decrypt(req);
+	ret = crypto_skcipher_decrypt(req);
 	skcipher_request_free(req);
+	if (ret < 0) {
+		abort_code = RXKADBADTICKET;
+		ret = -EPROTO;
+		goto other_error;
+	}
 
 	p = ticket;
 	end = p + ticket_len;


