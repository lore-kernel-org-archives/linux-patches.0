Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD351714DD;
	Thu, 15 Aug 2024 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731035; cv=none; b=RlJfpzMHj7t1t3lqYjDhOg+jUfKrsbRxy6CIACyDDlFMouN5NfBVI9tkT/bY0oJl4WPoVBHEAzAtB2mUCiIataozuodr4NReZTrQ9zUnaWtGeMF5qtrJ7kE69jpi1wMOP7waQjgncWdEqDLo/Br3E2qFA+vi0W8wU+lq4Lg6K/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731035; c=relaxed/simple;
	bh=MM4asV3Zk2RSx86yBZe5BsC8gnst1I4kXwqqTsSoxbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uifhdfa0tpgf6H5HXaaCFQdzzZts9oDFUeX76fktE9jvVacvJQEdMCWSeoQ3UydCSvP6hypG7Ny63Pf91wEWX62evz3MgPu0+x8t7whUP7RZIO4wvL60WG1Kyp0IVD1Zqg6Zw9ARtU+gwFMkAqJH49+kERmziIh17icRghCOANk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtleWEQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtleWEQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEDEC32786;
	Thu, 15 Aug 2024 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731035;
	bh=MM4asV3Zk2RSx86yBZe5BsC8gnst1I4kXwqqTsSoxbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtleWEQUKwIrsJ1PfUGpuO0a/JlNAF824ccjgry9wHblUrT+6URCqrD3nTrSzJnhu
	 W6lKNjp9XhRJsKd6m2xKK1Mptq02wImGkH0oNYh96DO18cS7HUum0Vr11EEYjwj710
	 8ECKUIEkGxSNnfkCphlnKrM83DWK5fjIuqVOX3S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/67] fou: remove warn in gue_gro_receive on unsupported protocol
Date: Thu, 15 Aug 2024 15:26:10 +0200
Message-ID: <20240815131840.457726013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit dd89a81d850fa9a65f67b4527c0e420d15bf836c ]

Drop the WARN_ON_ONCE inn gue_gro_receive if the encapsulated type is
not known or does not have a GRO handler.

Such a packet is easily constructed. Syzbot generates them and sets
off this warning.

Remove the warning as it is expected and not actionable.

The warning was previously reduced from WARN_ON to WARN_ON_ONCE in
commit 270136613bf7 ("fou: Do WARN_ON_ONCE in gue_gro_receive for bad
proto callbacks").

Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240614122552.1649044-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index 0c41076e31eda..b38b82ae903de 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -433,7 +433,7 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
-	if (WARN_ON_ONCE(!ops || !ops->callbacks.gro_receive))
+	if (!ops || !ops->callbacks.gro_receive)
 		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
-- 
2.43.0



