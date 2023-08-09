Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A73415AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2D5C433C8;
	Wed,  9 Aug 2023 10:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577951;
	bh=pbAWn0GIPDOBEjh/Kx1OFk/aogDtGU0NGwB5qsTjY3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yi2m+kLADITfto0c5QJCiCZ7AbJ2NxE/6Q6g27UFBRy6vEGAGioTsjQKjtLHur9kh
	 ZHFJxKYUsQ+mZy70K57nOVeDXf6UcpgH53732O5TKtqE1hwvPBDTLNzQ9xUlU8quxf
	 Qr8GnEle6n8FhMzHcdZfAGbyOTJGEgpx5TYV9XlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Akhmat Karakotov <hmukos@yandex-team.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 052/165] net: annotate data-race around sk->sk_txrehash
Date: Wed,  9 Aug 2023 12:39:43 +0200
Message-ID: <20230809103644.521772870@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c76a0328899bbe226f8adeb88b8da9e4167bd316 ]

sk_getsockopt() runs locklessly. This means sk->sk_txrehash
can be read while other threads are changing its value.

Other locations were handled in commit cb6cd2cec799
("tcp: Change SYN ACK retransmit behaviour to account for rehash")

Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7b88290ddc6e7..b25511e7e8103 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1523,7 +1523,9 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		}
 		if ((u8)val == SOCK_TXREHASH_DEFAULT)
 			val = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
-		/* Paired with READ_ONCE() in tcp_rtx_synack() */
+		/* Paired with READ_ONCE() in tcp_rtx_synack()
+		 * and sk_getsockopt().
+		 */
 		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		break;
 
@@ -1930,7 +1932,8 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SO_TXREHASH:
-		v.val = sk->sk_txrehash;
+		/* Paired with WRITE_ONCE() in sk_setsockopt() */
+		v.val = READ_ONCE(sk->sk_txrehash);
 		break;
 
 	default:
-- 
2.40.1



