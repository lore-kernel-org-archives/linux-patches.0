Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2478B4F85CA;
	Wed, 30 Sep 2026 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786629; cv=none; b=mqRNOeByVHjA2BgJ9UknRCwIWVVGFWX+vDCvyYp4ePeYa0lsDtr6qzjjwWUrx7ZLVkPG4Df30tMlTQ4K5Aifvndn73CtoA5IDM/3gMyk/Bu2OHmFC1LoZNV3nO2ZJHUbWH4yUQtCORX51oL6yPYGP6WZLvHm6hyLaOd42R/dB58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786629; c=relaxed/simple;
	bh=6ZpWiGt1tjCwRLeARfCWhA1QLfctktPecq36bFpyMIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uAfq2o9kla/QJuwxMpa/aZMQXn5WmCfa2wGGxE0f98yRk1qzPhPUMZNRu1iaBE+cwvmenv6EmF6t+yTkh0wqTZlWy1HKvEoJ2I/SSwqGnflgOo2dnQ1nY5JEs2XJNnx1iydE0VRKHZUQ0N73XNUplFAggHhDhWY91h2kY8WevhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnhxe58e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnhxe58e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803AA1F000FF;
	Wed, 30 Sep 2026 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786628;
	bh=ErdUYYqasce7+1+zx+7D3SRIYvOX4cIhzp4aMphrNtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnhxe58ezeQNfttx2wtqF9Wo1opkd+g6NRpCyPnngqkuS6enYCi3EJyleSuFjXPnA
	 1tEkUasNy4WA/4H4NFsjSkNKzId0rUnOMSQIXaPSVdHMvF59lLxweSUDI2f7O9Bu4C
	 BN8o0SdP5hQ5r7Enb5aU6IOkfw6N16kxCqcUt6tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 884/982] nfc: llcp: fix -ENOMEM on connect with zero-length service name
Date: Wed, 30 Sep 2026 17:27:00 +0200
Message-ID: <20260930152435.736861818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit c04981e42d94f39c1dba965cc462a046e946a6c5 ]

When service_name_len is 0, kmemdup() returns ZERO_SIZE_PTR which
passes the NULL check, causing nfc_llcp_send_connect() to attempt
building a zero-length service name TLV and fail with -ENOMEM.

Fix by setting service_name to NULL directly when service_name_len is 0.

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Link: https://patch.msgid.link/20260909122029.34081-1-omermetekaya0@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 8764b6d82a97d..a841d8474e2a6 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -759,12 +759,16 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->service_name_len = min_t(unsigned int,
 					    addr->service_name_len,
 					    NFC_LLCP_MAX_SERVICE_NAME);
-	llcp_sock->service_name = kmemdup(addr->service_name,
-					  llcp_sock->service_name_len,
-					  GFP_KERNEL);
-	if (!llcp_sock->service_name) {
-		ret = -ENOMEM;
-		goto sock_llcp_release;
+	if (llcp_sock->service_name_len == 0) {
+		llcp_sock->service_name = NULL;
+	} else {
+		llcp_sock->service_name = kmemdup(addr->service_name,
+						  llcp_sock->service_name_len,
+						  GFP_KERNEL);
+		if (!llcp_sock->service_name) {
+			ret = -ENOMEM;
+			goto sock_llcp_release;
+		}
 	}
 
 	nfc_llcp_sock_link(&local->connecting_sockets, sk);
-- 
2.53.0



