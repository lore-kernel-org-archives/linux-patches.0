Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022713;
	b=A59cNY/ZTPqoynxkb6/UIJKovhPk2KyJku5gy7YFyaC0uCTIq9ZSCS5jQnNAoFWV6gYn
	 rQIJCWC8ow9GwQt/5JBD2LVYZ4UNIbmHlkD/UQgNWu3wTJZojbycNTAcaz61IYH2WEhuG
	 ytBH2pwTcUXmF/SIcEga2tkXNe4DnVz6S24Cce/hpHKbi5pAHoj5fDrCUOCqb4eiK9Gdp
	 /jvcSQzw6QksKn2Od2YlgOXqok2WmAKN0GdF6+gEJslZGKVhBBs4RFvYZXyG0j8yot6O5
	 2yr2zElGR6kTj9BxFHNmaP1jD8Hy5aGzTB42lyvTV8NFyVK6HXegFzprHGyNAA2w0gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d8NuQlSqgmzMyUl7rWXgTVChSjUVlGZfmMQZg4cUu+I=;
	b=4fUU8WId3jEu24I4xZizsgIfsEtnrsNNebOFBkk4gFfyVLzMxYIr4v5JsELCnwwx5Ylx
	 Qw5rV403IpJ4Y9jFn8jRahvBC4UU4nmMJAldb9N8WojFBuR0dyd/9q+7Ni4WfWXTeu/pA
	 BZMWpEhDa0vR5V9FOeZgjTMreulSFQU7XNALA1lrO1QXAYOJrzSLDcT+1IR0Lj42ltY7l
	 Zb8vaJm84m/XCyIyOOm53Gx4NePveQp7/VFdCoCWhVgEnZumqRUlfGIVkK3wOHgqJy5JW
	 FohNzELBKSL8kEhd+rVdF+23Av5CMyhMuMp/DbboA5AR5MN9RM4U0CfChy11mkyg5pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogrb3HOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617D606A320;
	Wed, 18 Nov 2026 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogrb3HOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6F31F000C4;
	Wed, 18 Nov 2026 17:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022713;
	bh=d8NuQlSqgmzMyUl7rWXgTVChSjUVlGZfmMQZg4cUu+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogrb3HOz52shORMJyh455hcMJfbSXUlHr/HkLkjYplxwdQ/ndkePAY+relDsdkOXW
	 fyArVKc/wfJDW0ByG/PEKFumzK1KMmhAupSLyIM9V8pMwukM6eXRnd9z4BR9gbPj4b
	 CV41dXApA0ZjXPYEWJuW0DGGI330pGanRTX1HxtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0111/2151] rose: keep a socket unbound when connect() fails to autobind it
Date: Wed, 18 Nov 2026 15:30:46 +0100
Message-ID: <20261118150125.838335043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When connect() is called on a socket that was never bound, it clears
SOCK_ZAPPED first and then looks for a rose device and for the
callsign of the user. If there is no rose device, or no callsign for
the user, connect() fails, but the socket is left marked as bound
although it has no device, no source address and is not on rose_list.

A second connect() on that socket then skips the autobind and places
the call with an all-zero source address and callsign. The socket is
not on rose_list, so rose_new_lci() does not see the LCI it holds and
rose_find_socket() never finds it: the Call Accepted is not delivered
to it and the call can only time out.

Clear SOCK_ZAPPED only once the autobind has succeeded, right before
the socket goes on rose_list, as rose_bind() does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit f079e74f7889731570e7f53e9a7372e7776e3f9e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index fbf0e27ce898b..52f279aa189ee 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -894,8 +894,6 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	if (sock_flag(sk, SOCK_ZAPPED)) {	/* Must bind first - autobinding in this may or may not work */
 		struct net_device *dev;
 
-		sock_reset_flag(sk, SOCK_ZAPPED);
-
 		dev = rose_dev_first();
 		if (!dev) {
 			err = -ENETUNREACH;
@@ -916,6 +914,8 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 				     GFP_KERNEL);
 		ax25_uid_put(user);
 
+		/* Only now is the socket bound: a failed autobind leaves it as it was */
+		sock_reset_flag(sk, SOCK_ZAPPED);
 		rose_insert_socket(sk);		/* Finish the bind */
 	}
 
-- 
2.53.0



