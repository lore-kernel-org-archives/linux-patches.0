Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F4A27A477;
	Sat, 30 May 2026 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163073; cv=none; b=NZdhJUz0e77r/DQAvvyzI07y7mIpbafXgrtYdJEj7FDs0VcIf3zlEMRaS2g+NUdnnZRrRFwyEiTkyY8c4EVj0w/YVQwlL0ICnRjJLwbX5nbRXOMW5y2cMbyC1dpZAyM9AuzLvY9IKh4q5Fk55X0PnXnMQ4EBWAWgytC5EuTaAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163073; c=relaxed/simple;
	bh=UjR0WD9nIJt7PV5pS/aJPi6LrPJiJVPDc32tpYLGBnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRYqLfFrNv68WY2X7X5Z+59YBzl8OZn/DVRJfTAGmvpNyv2ez7452UcUCcHMAEfA09Zs9Z7MRh9kt/3VlJvv9geYSKniYRqAF8mvfW/0OgmkGVCrAtvahz2sP1AQl5YZp0qV7ty2o4um24DwYOrBWcTZfiD28w1+O5784yt6Zj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWCxMuaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWCxMuaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E2D1F00893;
	Sat, 30 May 2026 17:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163072;
	bh=GWk7Hp1Ko9Th6m35xUcSpJUOjA848Cjclt08z+znC8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWCxMuaKQIL2kUe7KPhH1aYoSTtCnd4qnS7tyYHUclexip32LGM9g91sFjCDcq5iW
	 omYtEK1DoEHR7mid/fiWhonq/8Jri2Ava70rB8a6g3Ayf2Y2nLxTdcg10lnWBQyQE8
	 +1GekuIeGs7Y1MlJP+EIUQqwkY0Zy+Uk0ZO2J3jY=
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
Subject: [PATCH 5.15 111/776] rxrpc: reject undecryptable rxkad response tickets
Date: Sat, 30 May 2026 17:57:05 +0200
Message-ID: <20260530160243.229264955@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1013,8 +1013,13 @@ static int rxkad_decrypt_ticket(struct r
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


