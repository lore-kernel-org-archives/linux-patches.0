Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982EC1537C8;
	Thu, 12 Dec 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016834; cv=none; b=HUgY4rmXSTjiqxQYHxMw6O1XZWAVyha08rLIUwVVOqCTXAPWz/UvOCa0W6SQlD9ny7ULvPSuFNBxsS2UJLQLOHpHR/wPUM7pxD+pV/PbPg9KO5CoYOjI4Fuyle6IwBgfH8fMBg9jhDbjv2bkTtrYsQ9Wm0LhLFwBqeP6pR62dCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016834; c=relaxed/simple;
	bh=epHdGEASkMmKwlMes/M/cbqWIhKkmhTQXnzA3j7YNGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SetmKCEkmLh4DtPckWUBxLnElwK6z85Kh5sIVk3o2ixQSOaWGoefW8Ft3CdnOnQu9nsnhu3AysApCsV+xJBsCNj5LzYncXgPC3hg51q+OvjqQA1MiqIusNt+ejAH3mY1z4xWLohMWIUYhRFgW/Jy6BvpdNkD1K5WIfmK4BIjWKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpozNx6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpozNx6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FADC4CECE;
	Thu, 12 Dec 2024 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016834;
	bh=epHdGEASkMmKwlMes/M/cbqWIhKkmhTQXnzA3j7YNGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpozNx6X13OPCE8ESMjsbvXcW2tA9+EY6n0Ni4u6Ziwnfvl1/ti+S6YN69eCvjvHW
	 8qzDaQaai2sr0mLXqIWquwkg+CSEGuRKPPL4i9s8mYcF82Nf/5RHGe3CeUlLJeYLDM
	 4Pf1drLWurHcm3f+YBr5LF10sC1e/eUpr9wv3mmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/466] net: inet: do not leave a dangling sk pointer in inet_create()
Date: Thu, 12 Dec 2024 15:57:41 +0100
Message-ID: <20241212144318.323045870@linuxfoundation.org>
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

[ Upstream commit 9365fa510c6f82e3aa550a09d0c5c6b44dbc78ff ]

sock_init_data() attaches the allocated sk object to the provided sock
object. If inet_create() fails later, the sk object is freed, but the
sock object retains the dangling pointer, which may create use-after-free
later.

Clear the sk pointer in the sock object on error.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241014153808.51894-7-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b24d74616637a..8095e82de8083 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -376,32 +376,30 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 		inet->inet_sport = htons(inet->inet_num);
 		/* Add to protocol hash chains. */
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
 
 
-- 
2.43.0



