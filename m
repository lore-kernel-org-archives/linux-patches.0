Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3336D2AF0E;
	Thu, 12 Dec 2024 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016872; cv=none; b=b6sezzTPgDdKTkO3G+XOZw00QF2Vm2rWqa/GXYcIISBBVzAnNlTa/FtYwGDCTwZnwnZ4rYhWCn32v/cNnMFllxxCo9Hr9Gl7f9I2BbYhNYQqlxqM77c17BRMircFpvgtMDIsOUkU9j9s0oQqAHOHgKrZu3PsDXlWg8YTNkCgKYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016872; c=relaxed/simple;
	bh=7mY8VWk+36opfDQEaHPS9D4kSVs1Kk0w/i0Rxp9Om6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUuyHSorqG2m8CPj3wA6c7AzMfShtTGK/Ljw3H8t+H1H48U1gfSa/kPoZUE01fssVQOD57Wb93C9iKIHpiSCYnx56sKDgrb94AfNXtRN5qyEkzjsBQkoVtpZO9L9c2HGq/5lKa9QDRYGa6EbCnQTbnPA6emo5AEYGXtY6+srsfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bw183Xkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bw183Xkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9374BC4CED7;
	Thu, 12 Dec 2024 15:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016872;
	bh=7mY8VWk+36opfDQEaHPS9D4kSVs1Kk0w/i0Rxp9Om6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bw183XkvBrLoKh0/+8Hud6Qdh8LrrnGnoIkgj3Rl7SiVLvbwFvpcNHSzyYznf5pGt
	 NA3ZQxR/qTdpy9K/zU/0z+7ZKVsAG8aRwr9PYb6ztZoCVq5dVPIlr8s9CS9+abt1of
	 sMTGHPfyGyvu/ClGRvvfBVgozLrLk5o1cv5Q57wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/466] net: inet6: do not leave a dangling sk pointer in inet6_create()
Date: Thu, 12 Dec 2024 15:57:42 +0100
Message-ID: <20241212144318.361942994@linuxfoundation.org>
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

[ Upstream commit 9df99c395d0f55fb444ef39f4d6f194ca437d884 ]

sock_init_data() attaches the allocated sk pointer to the provided sock
object. If inet6_create() fails later, the sk object is released, but the
sock object retains the dangling sk pointer, which may cause use-after-free
later.

Clear the sock sk pointer on error.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-8-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/af_inet6.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index ba69b86f1c7d5..f60ec8b0f8ea4 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -252,31 +252,29 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 		 */
 		inet->inet_sport = htons(inet->inet_num);
 		err = sk->sk_prot->hash(sk);
-		if (err) {
-			sk_common_release(sk);
-			goto out;
-		}
+		if (err)
+			goto out_sk_release;
 	}
 	if (sk->sk_prot->init) {
 		err = sk->sk_prot->init(sk);
-		if (err) {
-			sk_common_release(sk);
-			goto out;
-		}
+		if (err)
+			goto out_sk_release;
 	}
 
 	if (!kern) {
 		err = BPF_CGROUP_RUN_PROG_INET_SOCK(sk);
-		if (err) {
-			sk_common_release(sk);
-			goto out;
-		}
+		if (err)
+			goto out_sk_release;
 	}
 out:
 	return err;
 out_rcu_unlock:
 	rcu_read_unlock();
 	goto out;
+out_sk_release:
+	sk_common_release(sk);
+	sock->sk = NULL;
+	goto out;
 }
 
 static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
-- 
2.43.0



