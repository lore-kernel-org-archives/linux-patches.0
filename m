Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625616;
	b=R4xlnnhBn+oPfdETkLHuuzolIVuK+pC68ZQrFqn3ghoAX1I8V+ikU6tBYuSycwuwv7TD
	 N/9O3NYyDnKZRGseAHUFp/YBzXTvD4BWMPOWflqHN5TqWIwTEdBePicc1Rl5hl3CT+6rj
	 YgjJyvjiRlFF1TgNwOfC2alB2N8lJyG6g1r9MHh46JqMwta4AzCpjd/Dpf5UlPXXgHz+e
	 aX2X3n+dwkkuCBlTYZpRym6F9HtR+Y84dqJ1Ty9BQ4DH5QrYMCBQidNwzAMFH7TbCeRPh
	 +RYPqcN43afy5CLiDqfrsfrga9BTfjzBGMMZPgJlmEUVZ6fpaD/ewZDT2Y9ukYZYVdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GrNWSoBTsse4hjvZS7Slz8+vGxo03uY98SiQcYohv9A=;
	b=BTkDlwR6VB0EN0fyFvW6UnMBmFREPL6QG8yt7/qE+XaBZoKwKBbBJCZ0IRUJb73RdrD1
	 NRhqUBtncQsuxujGptWIDokVypaiESdYkpKolh0FfJ8W+EuPpv5LzzZO+wMtFXZM4zyrw
	 7E26bD0t3mJM4GjalOIIsNiU59O5F2XNWZHo8wvqz/0UYW34G3iFSxQFYkbgKalYPA2eQ
	 90pZYeYpgQzYb37MVAuSKiv9k0dkcPw42CyYDwkyvJEtQZvM0OxB5kDD7AA5l8+Ix+MUD
	 fDMbYuHgyfTEo8UbvTlSmX/ZdpPj41hOIWiPxh5uuEb5+lB8U0xVS2sBXOLHwuKbeew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuyqXf1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E40606A31E;
	Wed, 25 Nov 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuyqXf1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB291F000C0;
	Wed, 25 Nov 2026 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625616;
	bh=GrNWSoBTsse4hjvZS7Slz8+vGxo03uY98SiQcYohv9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuyqXf1zVKOA+hgpBbipH2CEUcVwJQKJZYeq64ULn4VW1Reiza+FhXE62WmE/ldbu
	 v7ceoPhoURRTfvSHEBiBXe2kdZwLgJZ01Z0WAKqnW55Twknc/mBDkRgqwHiFncaP7l
	 iVkVUfY3MWFkT3p4/snPlCE0SnXXRIdCIqku01Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 576/816] mctp: accept MSG_CMSG_COMPAT in recvmsg
Date: Wed, 25 Nov 2026 15:35:24 +0100
Message-ID: <20261125143902.513651333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

commit 350e1d0d3b386fcc0cff2d37aa920fab4800bf72 upstream.

32-bit userspace running on a 64-bit kernel is unable to receive MCTP
messages on an AF_MCTP socket, even though sending succeeds. There is
nothing for MCTP to do with it beyond not rejecting it, as af_packet,
af_key and can/isotp already do, for example.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://patch.msgid.link/20261105160704.2546031-1-dave@stgolabs.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -212,7 +212,7 @@ static int mctp_recvmsg(struct socket *s
 	u8 type;
 	int rc;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK | MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
 	skb = skb_recv_datagram(sk, flags, &rc);


