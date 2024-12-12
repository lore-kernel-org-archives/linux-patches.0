Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3B621578F;
	Thu, 12 Dec 2024 15:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016751; cv=none; b=TQHjDi+hycaPC88pmySTYrEliCfdYsZZP0AVXKWT5ASBBR6yJhGA6VBee+ku3MOYj1jp+qA3xU6JowQK5vcESfxh6wnwWF73Bn/dcflYIpR1DKEwmED6paWj3Ej//jgjjhpFb5/RCQyr7mlNs0/VjTpTHPUgyK9ByFLy8/jCRpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016751; c=relaxed/simple;
	bh=qzIym7pKp2UzO0HXuygrTaqhzFXaX5qvLn/C+08x9Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXwuhZUwtwy062ED/lrbqoFFRgDOuJUrY6+P9/leMxlDqlrzrj6wGK2oEs0zdKQe5hXiH9Y4AWre55/Afl7MGohQZWP0KmBwICGb5HB4T90ysvHvWi+qALN998OxBixTkyBbDoo6tQUK7fqH3P8aF9M3f2HFiO5Epu2Ne7c9TzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGwbXi1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGwbXi1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42D0C4CECE;
	Thu, 12 Dec 2024 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016751;
	bh=qzIym7pKp2UzO0HXuygrTaqhzFXaX5qvLn/C+08x9Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGwbXi1BYhWH0u7g3p4DzGz4aRLeNzqHEYKij3REe/MFap4ob2tcmRhsIVx921je4
	 0wMUQfYWCh/9V7u0/HmgNW9X17RsX6f7Y2uzaFKOcOhlmJm6vau9Rsgmte8SlCWq9M
	 q88N59bUWLGPQRBO+956NzC4jpSOnilsstVZ+uts=
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
Subject: [PATCH 6.12 287/466] af_packet: avoid erroring out after sock_init_data() in packet_create()
Date: Thu, 12 Dec 2024 15:57:36 +0100
Message-ID: <20241212144318.128162403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a705ec2142540..97774bd4b6cb1 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3421,17 +3421,17 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
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
 
-	err = packet_alloc_pending(po);
-	if (err)
-		goto out2;
-
 	packet_cached_dev_reset(po);
 
 	sk->sk_destruct = packet_sock_destruct;
@@ -3463,7 +3463,7 @@ static int packet_create(struct net *net, struct socket *sock, int protocol,
 	sock_prot_inuse_add(net, &packet_proto, 1);
 
 	return 0;
-out2:
+out_sk_free:
 	sk_free(sk);
 out:
 	return err;
-- 
2.43.0



