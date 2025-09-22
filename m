Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22596274B2F;
	Mon, 22 Sep 2025 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570131; cv=none; b=N682+2RSDqOq4xJHoO2ebrXPdBx8Zx/wMyGqaiT4qzAnKIl1mFda5Ybm2frrv6Iuoqjce3Ukqe4gXt7Ec19Xf8Il+MfvGJZyKmWkwecYtKigS33q2MczK/YxJwH6+KT2Hyqvu6I5Lpz5B5DJDQhlndR1bbqx9YLuXpPfvEgFHeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570131; c=relaxed/simple;
	bh=2YFfV6eclUhiojLFTSTgj3bTJ5yv6OVqmgzACMf9wLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSXyEp8djEVy4Ui62JPg25fi8xwS2Pk/PSDZoz2Q/5Q3An8Nay+wJiKoRv35rHfqhJXCXh3mK1jNQhOylJrNubUGXCD8Vnw6PtcFD72e96b6xmnfqj2XPPtJP7jm0eGyjsRONzcDps+zMbZuN9X1ht092BH8GMAzDJ9OMmJqTBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdf4ZmzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdf4ZmzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF88AC4CEF0;
	Mon, 22 Sep 2025 19:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570131;
	bh=2YFfV6eclUhiojLFTSTgj3bTJ5yv6OVqmgzACMf9wLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdf4ZmzNyLCERCas9da/WsPwyMcW2rc/dXfaYOAlNXr5kSPcGTqflzd+vvOvpyj4X
	 1atLeMuRazGXLigEYyaPv90dHr8lMfCwba3vLw7wFawH4KfHCCCWUqANUk8vFpesGS
	 j0GpNh4tDZh7Gg3kwISerFxsJ4RETE4KinLXTZMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 017/149] net/tcp: Fix a NULL pointer dereference when using TCP-AO with TCP_REPAIR
Date: Mon, 22 Sep 2025 21:28:37 +0200
Message-ID: <20250922192413.316915661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anderson Nascimento <anderson@allelesecurity.com>

[ Upstream commit 2e7bba08923ebc675b1f0e0e0959e68e53047838 ]

A NULL pointer dereference can occur in tcp_ao_finish_connect() during a
connect() system call on a socket with a TCP-AO key added and TCP_REPAIR
enabled.

The function is called with skb being NULL and attempts to dereference it
on tcp_hdr(skb)->seq without a prior skb validation.

Fix this by checking if skb is NULL before dereferencing it.

The commentary is taken from bpf_skops_established(), which is also called
in the same flow. Unlike the function being patched,
bpf_skops_established() validates the skb before dereferencing it.

int main(void){
	struct sockaddr_in sockaddr;
	struct tcp_ao_add tcp_ao;
	int sk;
	int one = 1;

	memset(&sockaddr,'\0',sizeof(sockaddr));
	memset(&tcp_ao,'\0',sizeof(tcp_ao));

	sk = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

	sockaddr.sin_family = AF_INET;

	memcpy(tcp_ao.alg_name,"cmac(aes128)",12);
	memcpy(tcp_ao.key,"ABCDEFGHABCDEFGH",16);
	tcp_ao.keylen = 16;

	memcpy(&tcp_ao.addr,&sockaddr,sizeof(sockaddr));

	setsockopt(sk, IPPROTO_TCP, TCP_AO_ADD_KEY, &tcp_ao,
	sizeof(tcp_ao));
	setsockopt(sk, IPPROTO_TCP, TCP_REPAIR, &one, sizeof(one));

	sockaddr.sin_family = AF_INET;
	sockaddr.sin_port = htobe16(123);

	inet_aton("127.0.0.1", &sockaddr.sin_addr);

	connect(sk,(struct sockaddr *)&sockaddr,sizeof(sockaddr));

return 0;
}

$ gcc tcp-ao-nullptr.c -o tcp-ao-nullptr -Wall
$ unshare -Urn

BUG: kernel NULL pointer dereference, address: 00000000000000b6
PGD 1f648d067 P4D 1f648d067 PUD 1982e8067 PMD 0
Oops: Oops: 0000 [#1] SMP NOPTI
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop
Reference Platform, BIOS 6.00 11/12/2020
RIP: 0010:tcp_ao_finish_connect (net/ipv4/tcp_ao.c:1182)

Fixes: 7c2ffaf21bd6 ("net/tcp: Calculate TCP-AO traffic keys")
Signed-off-by: Anderson Nascimento <anderson@allelesecurity.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250911230743.2551-3-anderson@allelesecurity.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ao.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index bbb8d5f0eae7d..3338b6cc85c48 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1178,7 +1178,9 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
 	if (!ao)
 		return;
 
-	WRITE_ONCE(ao->risn, tcp_hdr(skb)->seq);
+	/* sk with TCP_REPAIR_ON does not have skb in tcp_finish_connect */
+	if (skb)
+		WRITE_ONCE(ao->risn, tcp_hdr(skb)->seq);
 	ao->rcv_sne = 0;
 
 	hlist_for_each_entry_rcu(key, &ao->head, node, lockdep_sock_is_held(sk))
-- 
2.51.0



