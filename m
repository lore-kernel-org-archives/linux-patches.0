Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045912;
	b=SyghMpuXQPEoLdGZxX0tX380UWiB8YOefURdBzp+q2+ahpQMMMM2yzw45pJwMBkiK66s
	 7B843IhPs+5MIomehCn+vVsQYLi+UM/Km2XGjnMwV/Dggzky13QsCb6FK+4ht6FgbQUrP
	 h3Cq2h6M93ZgBRbhgm00qp8R2H9n2PgP4Z1FKhUBT6XldRChbnJ9FGmB2l/uJizKo1S3w
	 3St0IcFGcfJDpD4TVE4zbR1vRCvYsPYOGBK8x6lw/B7g1xh3BEGRTxsUe+IOhBK9dLSR3
	 yQMn4TkPVfgs+hO/LE2SVIiaUNXuYotrLQVqeuE4roZG3T29avaOAaUONp0p9Qe+TMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qjlyJfPnsqN0KzFDxjpnJaZP7rmpPlEzwM0OKrLlVl8=;
	b=K/JUGC2rFRDsJCX+qsGyNgLPnenzbAmlFfMssFaS+7TrRfLetnm2bRQeMgRppf4gHN9H
	 hfuRYOu1o/LA8zb+5eIwOOQw6sb/TzuZM4FmEFXZyt9p+yaS4cB1/l/MoqfoFHYGKgehc
	 DcT0gXTxTB82GTm4R/lGZDicHwgGZgE9KGXAqMlNx0bx2cCPJiPGbdc6+ZWNtg0wId4+7
	 GgGFrDJmtbxmG8BliWVH2cwsn3tq6VdWcU9NCISd921yM2jfF6G982wLaytmeKmecFHKh
	 jxqBr7e5rZR6/xVG30uGKZV5/xNxyV5eQqI7tlqSpIue4z/FKB4sVhYm2HVOOUYDxiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2Nocr2E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCBA606A320;
	Wed, 18 Nov 2026 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2Nocr2E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B866B1F000C4;
	Wed, 18 Nov 2026 23:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045912;
	bh=qjlyJfPnsqN0KzFDxjpnJaZP7rmpPlEzwM0OKrLlVl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2Nocr2ETgsSw8ph5+e7sO77lkYOLdjeJYPmddK7wQ7gDtUsnX0BBRMEXBu9GZi0f
	 6BIaoO4h4OTHQzX4J1mLzNA7UyPdamIDVProQbxDABImJYjz09My3W/5SbOUVwCKNl
	 TegKg2cg/C2HAh8yWBleQYcWhtOKyaiQNAk1qupQ=
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
Subject: [PATCH 6.1 1093/2857] tcp: check congestion control restriction first
Date: Wed, 18 Nov 2026 15:35:27 +0100
Message-ID: <20261118150240.977215811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab12c7cdbb4b6..b12dd42980824 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -238,12 +238,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	ca = tcp_ca_find_autoload(net, name);
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



