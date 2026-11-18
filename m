Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028782;
	b=WnxDbkgb4J5RRxePd0WrqHS96HDifgavuk3Ew6kbtl527NmRf7DqFxe7AimFjY0+5lrh
	 ArhZGZK96XFG5WomqzdZJTzwo87eDQ6gKvnmjYAw7QegT1Y0dpvXo7Kdyem9uK4lgz5Pt
	 kGd+bh0B3QnAVTwOe99xB5514GiU1JMCbbG81nEEBxOv6JMgaJ0NRmFTrl65i19OZwATx
	 ZInFjb942F4I73PfWO6XLLRhBz7M1fu1xJwrxEs4cLoa6aFWxYxYixdPQpWuMAFIFV6D3
	 iGey0ebAO10ByWtd9O5vWAFTnH00zsL6MagWLamp6VEh2Wy6cRkY/4yooqFB1NMHzAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUEPlObGO/kxR7+OU5nZ7emyI3e4WU7GSh25gjOWbrc=;
	b=zn89BvpFFZpyrLH38bAkOwdYntjRJJpVWE/d7uClYlh4AJgqHYpvuOZbO5lozzIV2rUv
	 +BcA4WytkMF/X3ZZiUWJnM85M9MshEcrUtLJIqMIZeuOj89kkcrhTSyvDAl257RB+5phk
	 W8iEmyWg+SLms53bZh2c2+w6XAaCDGwlmE8gTr1NIPnOyzYg7JO4friaod/gQN9Gg4FU+
	 +O73wgG+njObiIVcGWIlDcc6/SRiGkKXFjWdHw3wCvbZzx2Phtnijd6VZ9YABNDgAnlqv
	 8YYq8aKu5CWfU6/uG+MVkRlPSmuhcnMbz+mhOmQcS3i6AjbQrkTV+txAqJgBEeVQ0kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jr7n+cEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E929A606A333;
	Wed, 18 Nov 2026 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jr7n+cEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462A71F000C6;
	Wed, 18 Nov 2026 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028781;
	bh=MUEPlObGO/kxR7+OU5nZ7emyI3e4WU7GSh25gjOWbrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jr7n+cEz4ysZTmYzgi5McKxz3IyeOCVSgwixCa0rn3Jr1iTQwwv1xssTVH3/CAeHr
	 vAEzlhkspPzv2pw8poWiOwfrxFsqku1gW/DLEGQHXlQQajwiQRtfsFemXjVKJ5zpK9
	 NgqM+OdF8Gg2GFblpzFXQK/edc/mOVXTjFZ7NKuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0110/1756] rose: keep a socket unbound when connect() fails to autobind it
Date: Wed, 18 Nov 2026 15:37:17 +0100
Message-ID: <20261118150012.585331141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 332d267716813..1b5230ed4a452 100644
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



