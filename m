Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71341ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291A1C433C7;
	Tue, 25 Jul 2023 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285041;
	bh=Y0i3atlbK5EFYwVxusOXKUtvIlwno+3m+NO4fCogX+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXFLdWRSB4Y7GqR3NVd+HVE1jP5wDhWKXweJJXXr5hy+SVMIWxppBm1PyWeg6urLw
	 Mxn4gM7QQz9WwqGUjX9vRzMUEJpiknmHs9aEAT+dp4auIfOlKgtBJ8XVIbWQ2I++Z0
	 3tgagodX47sW4pUMP1Iky38nnWT6pLhwZAZ0qaR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/313] nfc: llcp: fix possible use of uninitialized variable in nfc_llcp_send_connect()
Date: Tue, 25 Jul 2023 12:43:07 +0200
Message-ID: <20230725104522.569126262@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0d9b41daa5907756a31772d8af8ac5ff25cf17c1 ]

If sock->service_name is NULL, the local variable
service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
later leading to using value frmo the stack.  Smatch warning:

  net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.

Fixes: de9e5aeb4f40 ("NFC: llcp: Fix usage of llcp_add_tlv()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_commands.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 3c4172a5aeb5e..bb9f40563ff63 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -394,7 +394,8 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock)
 	const u8 *service_name_tlv = NULL;
 	const u8 *miux_tlv = NULL;
 	const u8 *rw_tlv = NULL;
-	u8 service_name_tlv_length, miux_tlv_length,  rw_tlv_length, rw;
+	u8 service_name_tlv_length = 0;
+	u8 miux_tlv_length,  rw_tlv_length, rw;
 	int err;
 	u16 size = 0;
 	__be16 miux;
-- 
2.39.2



