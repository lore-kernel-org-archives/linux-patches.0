Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B76215710;
	Thu, 12 Dec 2024 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024732; cv=none; b=fbGX7qEivUsM5YVgQziEYYIjXC1myLc6ImBdDTqCZdRCDxfSUNJ3J2OOVcyC2sxeLEVTVkULy30BrR3kUf07hYzCYgChgE/sqtkOx8dexwcp1s2bTp5Ad39C7tjSuJHx/yuSHjgtUikbueIjjRq0a1gjQUk0n156ETFdkyLm0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024732; c=relaxed/simple;
	bh=S2Q4vfhm9hYL7w5Grrp69UKIFGL43vPPCgIJmqT+Wa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyGXz3Nso5it7DQv9yxhe9B7estbwaQmEu6oaQ9knYzEBgT8EvVkiOBDZy36bcP3H0dKrOnheWMogQXkb8WBxfB5DKLz4rORisuGagYDkn67NAybaJdrUR90r/kqencp7jgBgpb53QVpgZOaqizBurSY12bNLF+q4BR+7tOoV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipzaMDLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipzaMDLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A28C4CECE;
	Thu, 12 Dec 2024 17:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024732;
	bh=S2Q4vfhm9hYL7w5Grrp69UKIFGL43vPPCgIJmqT+Wa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipzaMDLl6yIBsnVXCMMXGFCyS27O03lqqxMLMaovJ4BbdgEaiEYbYrNBRfhKxuAl5
	 bxF0K0cArRA8GS7WzdoKnCMnbsChKfagIi63A1ukWH0UoToAg96EJTb4HbXWOkZrqX
	 je1MDvM5dsjyY9uJ7Q1r+HCJRchWW1SaECF3apWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/459] af_packet: avoid erroring out after sock_init_data() in packet_create()
Date: Thu, 12 Dec 2024 16:02:12 +0100
Message-ID: <20241212144309.327496547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 46f2a11cb82b657fd15bab1c47821b635e03838b ]

After sock_init_data() the allocated sk object is attached to the provided
sock object. On error, packet_create() frees the sk object leaving the
dangling pointer in the sock object on return. Some other code may try
to use this pointer and cause use-after-free.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-2-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ce3e20bcde4ab..01a191c8194b4 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3386,18 +3386,18 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	if (sock->type == SOCK_PACKET)
 		sock->ops = &packet_ops_spkt;
 
+	po = pkt_sk(sk);
+	err = packet_alloc_pending(po);
+	if (err)
+		goto out_sk_free;
+
 	sock_init_data(sock, sk);
 
-	po = pkt_sk(sk);
 	init_completion(&po->skb_completion);
 	sk->sk_family = PF_PACKET;
 	po->num = proto;
 	po->xmit = dev_queue_xmit;
 
-	err = packet_alloc_pending(po);
-	if (err)
-		goto out2;
-
 	packet_cached_dev_reset(po);
 
 	sk->sk_destruct = packet_sock_destruct;
@@ -3432,7 +3432,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	preempt_enable();
 
 	return 0;
-out2:
+out_sk_free:
 	sk_free(sk);
 out:
 	return err;
-- 
2.43.0



