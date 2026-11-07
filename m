Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062662;
	b=rNo/2eUkN5gFx1aO6KV1D/WlvLBTqiMsSlJtB2tyimrYewBp53KLfMHZN8p/0vyeBaHR
	 zNWOqLNaaq73f+0KesRHN3LJwolw+2jlwnq+ppj4yvDXA6V8FKRUzHFZcFL+RTgYTjWlA
	 xpTFRrIfKdw5XoBI8vyvtfrVki54PwEupDRt+4TPxdWzNsAbpCwNwzo2/hlI24lE3F26K
	 mFGWwIbQzZk2nEdEstf3fH5G84IbHpWyLcsEYbH09hfb/hCt84edLyZg8CuzkHqs6gRMk
	 3MLSa4FxWjA7Z4gJ8FXCKb8oNgrMkjOvZIJidfJYoYKdn1JvaErPz2pXMaT3QkTwyig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8u9q3zxj6T89hO4TXmnVJBtkwHOT196HrhzG6mSjww=;
	b=QxqT+i3yQk8kos3ldlPlwcBLUjTVM92dGY/KJT6bPzsJkLSAwCYqFOknohh/R15eO8cQ
	 jh+OmIYTAwSp9jkPESPQ3qFxmqBfwmbENijYttV0j91DU5yoUX7zI0ThFOi8pHz0MWLM5
	 5Qhm/oMfZiY44j3xbOTD/x2KON0mpP6240TE6q1P5m2sJM3LoD4rj+/vDizJOeOjGUf3o
	 QAdgibkuseufJmMh7w21SzXTbovmZVqiqiqHYmRcH+CGqm0fm/jgKjpb/EEGLg4XPl/rn
	 /Wdn65WtPxjMgz9gm9RbekeZHEqJfO5smqLobagvz61toBTMJCgCuoww5ZNXUKfstkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZwXC7eV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DDA606A331;
	Sat,  7 Nov 2026 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZwXC7eV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D20B1F0089F;
	Sat,  7 Nov 2026 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062661;
	bh=n8u9q3zxj6T89hO4TXmnVJBtkwHOT196HrhzG6mSjww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZwXC7eVroLVVeb0WKWvNNBG6Czaz7SEA4ADumOrb+3BNnjcp2YctUJBHl5uwPdnA
	 gHvClWGKZfOm2BqfLljVatPgRjNFf8MZtrmErMNZrEdcqR4nbXDf164Z69DAQpBMVR
	 x51p/l1lniTfHv5eqETFx0JMhZsP3djtsAG7kYdo=
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
Subject: [PATCH 6.12 1523/1536] tcp: check congestion control restriction first
Date: Sat,  7 Nov 2026 08:58:59 -0500
Message-ID: <20261107135040.655000409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index f3c516da0a942..cfef6dbac6421 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -286,12 +286,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
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



