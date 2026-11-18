Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022267;
	b=4/ew7XpLDsu9LqWSjIdIDqeIHu6z1F7pVqfHdjy2qcTBZrI3De0CUVeo1ZkUlWZxVBsG
	 Tj1AWwnaH9NIbrW+xLFI2nUJIVu8zFZPhuokzzzBrl8uxsy7s9cpazVXm36Aa9Y9C+T+o
	 bYCtOutYfn5edbTrHKeQ4bQAudH8+kMSX1NNEEigdO/hAHC9h+C+mqx4lQjsALcG6/hH1
	 1Ks0SlObnpSYQzapmEhADISzwfF4TPDeq5uw/jSg3jbKe9rBU6ViQz697aBbMcjy1RI8E
	 oeAeGs6qH7688uCBZpkS2MO22kkeFKX6SxJiI1m54SdEHT7uCwN0PHulBfYBE/AGPxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ZKlMnireTVpIc1An2uu0GXfAKWBG4iUYc3QieAYQWs=;
	b=DJcDnyHVKkNukKMAubWHQ85N2AghBiwpse8ZFg1TiEx4OLiiEdRqZIxL2QYU1e+4p/T9
	 WcBI/x4gwbZNQmufpvFeMtmTugP66G1snX3I1vul+K4vX+/jJ+Hrra2AXngueuh9Gq2vx
	 iYyxPxINgEy49MYn+TWhgnCTIXMdOsWNbMclwoHmWR6UiI5NXDKVynVgzVbbPlx49xkul
	 xGtVd7479B66UsVdJPuH+Mzjz+Equ9u0D3lSrbLXW2aYKA4iFZ/M7/gALJuUytKnux5VZ
	 KGdAAbHSd8IwD3Xuy5H6nOuNCCU2hlcVnDqfPgR0av/6/8v4w6aeVf0451ir7Bw4Iew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtTgliKQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1561606A320;
	Wed, 18 Nov 2026 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LtTgliKQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434661F000C4;
	Wed, 18 Nov 2026 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022266;
	bh=0ZKlMnireTVpIc1An2uu0GXfAKWBG4iUYc3QieAYQWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtTgliKQ5XyCzquJsSRSwbx5NnhpWmGDK6iH10Mx5aQYGhP6a0KjfocGufRmBYFBs
	 XJ6fDhBql8b3wa3k50R9qKJ5CyNbbS3Xp7t1+e4kAHsUOMf5PSVKBOIwTUUtZoWsMV
	 xI29dQulIvRkVbKZ8KTADzQLklyBXTVb6VCfVXMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2601/2651] apparmor: check address length before reading AF_UNSPEC bind address
Date: Wed, 18 Nov 2026 16:04:01 +0100
Message-ID: <20261118150417.900934732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

[ Upstream commit 4890a8b1a9df880dd188adb8b8e8fab107ad69d9 ]

bind_map_addr() handles AF_UNSPEC on an IPv4 socket by reading
addr4->sin_addr.s_addr to check for INADDR_ANY. At that point the only
length check done is addrlen >= offsetofend(struct sockaddr, sa_family),
i.e. 2 bytes, while sin_addr sits at offset 4. move_addr_to_kernel()
copies only addrlen bytes into the on-stack sockaddr_storage, so a
bind() with a short AF_UNSPEC address makes AppArmor branch on bytes the
caller never supplied.

Depending on those bytes, a confined task gets -EAFNOSUPPORT instead of
the -EINVAL that inet_bind_sk() returns for the same request. Kernels
built with CONFIG_INIT_STACK_ALL_ZERO read zeroes and happen to behave
correctly.

Check the length first, as inet_bind_sk() does, and as the AF_INET6
case above already does for inet6_bind_sk().

Fixes: 89ac6aa752ec ("apparmor: push inet mediation into profile callbacks, and improve auditing")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_inet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/apparmor/af_inet.c b/security/apparmor/af_inet.c
index 42994e84cccaa..2a933572fa95e 100644
--- a/security/apparmor/af_inet.c
+++ b/security/apparmor/af_inet.c
@@ -196,6 +196,9 @@ static int bind_map_addr(const struct sock *sk, struct sockaddr *addr,
 		 * AF_UNSPEC if the address is INADDR_ANY
 		 */
 		addr4 = (struct sockaddr_in *)addr;
+		/* Length check from inet_bind_sk() */
+		if (addrlen < sizeof(struct sockaddr_in))
+			return -EINVAL;
 		if (addr4->sin_addr.s_addr != htonl(INADDR_ANY))
 			return -EAFNOSUPPORT;
 		family = AF_INET;
-- 
2.53.0



