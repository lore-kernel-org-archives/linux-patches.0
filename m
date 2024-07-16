Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D616A1DDCE;
	Tue, 16 Jul 2024 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146118; cv=none; b=eSq5ViBaoPZhH1aMUjbuuj+RT+m6bG+GEw6xLoZe1BfGRe7jnBpzCoMcG9wwlebbARVdKqYGo4be5gN3Rc5s880rnavMoJ1WYNw+xK9b56+pzuto0K+h2Q1pRxd1qviW9VNMDlAzJbImWCYNjZ3EPOpuWvV6nWVOXmJcJPRvI38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146118; c=relaxed/simple;
	bh=1cTUAKK/7OaEHEUgo1kPAtTXyKNOKM5baJf+wyylQ8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j65WmJuL+Ov+/3/X9b9uFgjU349FeY+LmAPI4JtfQUU7j7C9pFCBoULjkyfP34R9NA/BhFbizY7rKrAJ1JVyJADvUF4CWW7C0AynkOm7eUbrut30+2fTzTGRJfdrHf7JE0VTUmTCLERTbAfyzfjp/0BCEXYP5fHpvngWF4VG4vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx64OgG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx64OgG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5259BC116B1;
	Tue, 16 Jul 2024 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146118;
	bh=1cTUAKK/7OaEHEUgo1kPAtTXyKNOKM5baJf+wyylQ8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yx64OgG8TpdD7ZF4eIacEWg4n6WeWcqjL/eryyUwY9UHFGaEjYGOt1g1oqgYiwsvP
	 J+D0tJ2msYgkMZBKw6vEdaXnNI8QMT+VQ271nxdiku8TP1eaFUfspK9xVeqmbiFrBs
	 C+PZJN8b/CbnMPmWM9xUDFNOvmVSx6JFpuFcUsM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/144] tcp_metrics: validate source addr length
Date: Tue, 16 Jul 2024 17:31:41 +0200
Message-ID: <20240716152753.776200302@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66be40e622e177316ae81717aa30057ba9e61dff ]

I don't see anything checking that TCP_METRICS_ATTR_SADDR_IPV4
is at least 4 bytes long, and the policy doesn't have an entry
for this attribute at all (neither does it for IPv6 but v6 is
manually validated).

Reviewed-by: Eric Dumazet <edumazet@google.com>
Fixes: 3e7013ddf55a ("tcp: metrics: Allow selective get/del of tcp-metrics based on src IP")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index def337f72c860..f17635ac7d829 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -619,6 +619,7 @@ static const struct nla_policy tcp_metrics_nl_policy[TCP_METRICS_ATTR_MAX + 1] =
 	[TCP_METRICS_ATTR_ADDR_IPV4]	= { .type = NLA_U32, },
 	[TCP_METRICS_ATTR_ADDR_IPV6]	= { .type = NLA_BINARY,
 					    .len = sizeof(struct in6_addr), },
+	[TCP_METRICS_ATTR_SADDR_IPV4]	= { .type = NLA_U32, },
 	/* Following attributes are not received for GET/DEL,
 	 * we keep them for reference
 	 */
-- 
2.43.0



