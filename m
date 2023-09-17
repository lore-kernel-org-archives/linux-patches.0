Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68C7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49521C433CA;
	Sun, 17 Sep 2023 19:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980735;
	bh=0OkTqLyonjHcozqm8YV7DWh56hBi+T+Ce5QdOx4zmKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kN4MsNPC1OjTa5T0XVcnBP/b+BcCXOAayNw9vvaVkB2GzP1fjg7Osh4zu7rtfq6AN
	 amXORSlQ3MsnkJvBgonVvs2T8jBfv6ZdJksGIh46wLdggUZRgVa4Z9V+xRKSoLorqa
	 UGT2l6QfZQgvTLF03xQS2dxE0yVTSTouBR2PSoYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrei Vagin <avagin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 278/285] tcp: Fix bind() regression for v4-mapped-v6 non-wildcard address.
Date: Sun, 17 Sep 2023 21:14:38 +0200
Message-ID: <20230917191100.764547224@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit c48ef9c4aed3632566b57ba66cec6ec78624d4cb ]

Since bhash2 was introduced, the example below does not work as expected.
These two bind() should conflict, but the 2nd bind() now succeeds.

  from socket import *

  s1 = socket(AF_INET6, SOCK_STREAM)
  s1.bind(('::ffff:127.0.0.1', 0))

  s2 = socket(AF_INET, SOCK_STREAM)
  s2.bind(('127.0.0.1', s1.getsockname()[1]))

During the 2nd bind() in inet_csk_get_port(), inet_bind2_bucket_find()
fails to find the 1st socket's tb2, so inet_bind2_bucket_create() allocates
a new tb2 for the 2nd socket.  Then, we call inet_csk_bind_conflict() that
checks conflicts in the new tb2 by inet_bhash2_conflict().  However, the
new tb2 does not include the 1st socket, thus the bind() finally succeeds.

In this case, inet_bind2_bucket_match() must check if AF_INET6 tb2 has
the conflicting v4-mapped-v6 address so that inet_bind2_bucket_find()
returns the 1st socket's tb2.

Note that if we bind two sockets to 127.0.0.1 and then ::FFFF:127.0.0.1,
the 2nd bind() fails properly for the same reason mentinoed in the previous
commit.

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index fb13a28577b01..ae5e786a0598d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -800,8 +800,13 @@ static bool inet_bind2_bucket_match(const struct inet_bind2_bucket *tb,
 		return false;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family != tb->family)
+	if (sk->sk_family != tb->family) {
+		if (sk->sk_family == AF_INET)
+			return ipv6_addr_v4mapped(&tb->v6_rcv_saddr) &&
+				tb->v6_rcv_saddr.s6_addr32[3] == sk->sk_rcv_saddr;
+
 		return false;
+	}
 
 	if (sk->sk_family == AF_INET6)
 		return ipv6_addr_equal(&tb->v6_rcv_saddr, &sk->sk_v6_rcv_saddr);
-- 
2.40.1



