Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037082;
	b=cf8iGuSQ+IEE3GUWBjq6mm8dY+HsIDKrdvpuejhk1aZWrYwoZN8wc58yhxsGv8L6/mUJ
	 0zdlqyEPZTs0w264rDjXmlo35i/iyXctLq6Vz6arkHLN/iO3wM3Vk3oRV3Qr5uEi1JWII
	 HZCORpzoGGyt7SbFTSMfn0g35juPYPiOhTnk98erN2sfC8eiG99sEeg1O8ExehPEkFGhR
	 AJZoTJmLxoZkVetUZXn1UT92/P3rhMaXjz/ImLcSYqKH5secxawuylmhNnJDvgOxgDGjV
	 xDVelh+3vvpB6c+KJywAz9w3WaJPoYDx1chqR7QBzu0plSmbZwC675Wot15VAUedVPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UGlE8oGLqk6MI0HYDttR15bcCtiExwRE0rEUSPKlYU=;
	b=K4e2q4YePkboo9Mh0gr3rqgl5MTaT7JR3mWnHxboPz5w7SsOZAoXlpkUS5H1RymkdK3y
	 6nrbyYfOIF64+Il60Fmv7mFHhrqYWGozddsd27wA+pB1E6UXvicMezudWa4fs/xe7C5id
	 /8QWjEQGVmBvNrADMN81wCNg0bh1mnw0HPriaSxghW+PPK6tBwBQN4JUt6Qs/MjftBgZP
	 V1M/NQKJ69TLuvmCzmdIKLvr8RWyJSaFaM/PL/Sf1I6EqSl1tZNkPwO3MzFMf3ctR0irK
	 6I+MLV/lTo/tu4pwZQYNCqGxeM1xaN6LfSTvSLzMjLI6/uHNgUdjxO/9B0Y1jpqX7KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rva/Ywyi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75785606A320;
	Wed, 18 Nov 2026 21:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rva/Ywyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFB31F000C4;
	Wed, 18 Nov 2026 21:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037082;
	bh=4UGlE8oGLqk6MI0HYDttR15bcCtiExwRE0rEUSPKlYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rva/YwyiZo62OLOIkhSJN7PhsBrX9qNjrre8EsoihkFnie5vIMxCa+dapcArTD8xa
	 WY5rIfGaxIDs+b9s5MtEwIqSmP8Tk+O+CqWYyUXf0OGpxrM/gkX4xDRdI9GSNzyGzm
	 PjiYAuEdXfaJ7mvJAyo2eAjgHq7QKp0w4JuCq6Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1285/3318] tcp: check congestion control restriction first
Date: Wed, 18 Nov 2026 15:31:47 +0100
Message-ID: <20261118150358.803799869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit dda51b73721684637ab8e9bd97c78228b99c4bd2 ]

tcp_set_default_congestion_control() takes a reference to an algorithm
before checking whether a non-init network namespace may select it. A
rejected request returns -EPERM without dropping the reference.

This affects module-backed algorithms too; BPF is not required. For
example, after root loads tcp_bbr, a user with CAP_NET_ADMIN in a
non-init network namespace can repeatedly request it as the default
although it is not in tcp_allowed_congestion_control. Each rejected
write leaks a module reference. Since module->refcnt is an atomic_t,
2^31 such writes can make it negative; later module_put() calls warn,
and rmmod can hit the BUG_ON() in try_release_module_ref().

Check the namespace restriction before acquiring the reference, as
tcp_set_congestion_control() already does.

Fixes: 8d432592f30f ("net: Only allow init netns to set default tcp cong to a restricted algo")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/71c142b2d45af6a2fe7fc6cd4a5ca52c53afbe23.1793075984.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cong.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 2959243e98f06..f9c5bea3fd3ae 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -289,12 +289,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	ca = tcp_ca_find_autoload(name);
 	if (!ca) {
 		ret = -ENOENT;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
-		ret = -EBUSY;
 	} else if (!net_eq(net, &init_net) &&
 			!(ca->flags & TCP_CONG_NON_RESTRICTED)) {
 		/* Only init netns can set default to a restricted algorithm */
 		ret = -EPERM;
+	} else if (!bpf_try_module_get(ca, ca->owner)) {
+		ret = -EBUSY;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)
-- 
2.53.0



