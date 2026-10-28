Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211345;
	b=MlxmczRCjY/LnWs3c+96vFHg95eSJODGa0R45D8MhKmnsIXw6jYpTuh0T38ZmHiFihn7
	 E4wOcS2Ikg07LRImsFpw9tGuf/1UUTDsa6Kf0OKjtrHEgsifVxb86E248n8aK2YQepnMJ
	 BpzVmPFFN/af6GidIdX3IWHzd8mh9AmFZO/+zZmTyGxpVhXth/F/i1gTeGmd0evozZE7I
	 Ypc6SWthew/hCCn38kr2lBixaWnGOZXi4YX8pAzwLfWJagGrGD+wyOYpZbdN/UwK70jcL
	 NrXy/JFifKIpiacc2jFGJ6BA7YfnQlWOGurAmvSOfF7jaEjUyRiCW0etgdJMFKwFYMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=20CFTGHSnyzGjmnH1nBQIsBtPdqDuE3N1bY81N5B07c=;
	b=aqwqM9wRuLZa1HLemQmwsUPPsS1RN093dceuqqsTEFgwxAnYiaV1/urP+rWXAK0XgnE5
	 qusJ5jHEAGkE3ZRsqji58ezwv2iMLjgkxQxcMWoWYN+XhNvo0jCW5YgwU1hNBR4DoFplL
	 oT7q69qsLtWlLANeNiw5uZllWYU0YsRPNi4MkhCu9CyTFkOP4tgdAmJmRbikhtBD4APRT
	 OROtBTYSL8Xn2p0/r39Fs5GDu0BXenSkYbL5Fy9UAYH2kT71ETM3WypufUaMSLQpXtpyf
	 HgeOcCy8+eLy1rSI3YuTHuGJysDYNMyiegEWuzu+mak2es5Eh+ZHKw9XwNyi1E3y00w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoOd7YIJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123DA606A32A;
	Wed, 28 Oct 2026 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoOd7YIJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C551F01825;
	Wed, 28 Oct 2026 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211344;
	bh=20CFTGHSnyzGjmnH1nBQIsBtPdqDuE3N1bY81N5B07c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoOd7YIJ5l6LmVtQjqXtv3tL/7hFiSWelAmGzmoXgRLIOoCoUVbeqqklvjQ0+PycG
	 UxiIQWLhSOHIf7v7ao8H9y/+sfCfncg2GZEYPG0B5s4xbIWDgpZHengooqPqLFjdxD
	 cdK2EWEJzFhYqEohkR+lXI+a6WJVQrzlSWfNEp5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 345/571] ipv4: do not warn on route notification size race
Date: Wed, 28 Oct 2026 17:58:12 +0100
Message-ID: <20261028170016.203729766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit e02a5b6588161673ef75a4bc5cdfb62bd493374d upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib hardware
flags are changed") added asynchronous route notifications for hardware
flag changes.

fib_alias_hw_flags_set() sizes the skb with fib_nlmsg_size() and later
fills it with fib_dump_info() while holding only RCU.  With nexthop
compatibility mode enabled, a concurrent replacement can grow the group
between these independent snapshots.  fib_dump_info() can then
legitimately return -EMSGSIZE, so the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261004082043.GB92032@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/b7e203fc5867651cb67ef84aa03e082f0f76008e.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1079,8 +1079,6 @@ void fib_alias_hw_flags_set(struct net *
 
 	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


