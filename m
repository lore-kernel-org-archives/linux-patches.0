Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D1333A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301944; cv=none; b=P/AVbwhtTc5QOHcNl+20ui+TBIU7KTIfTryn+71d1Ipuo8Tl+TiM/vSI9dD0eh2eFM+gHfXP6jkA3+HkGdJVFvB2Lj8NiZCIS7UAIdwbcaEwpjY9wsEJ+OTCZcP90WbPgiVKDWZWuHKd3v3Wq/6MVK9roudbgk9JE9GN/P+DkwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301944; c=relaxed/simple;
	bh=qBKfzOHZ5O1q4wiyxKfFbLhgfP/oLXbnGu2JRKx/Ebk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9Q7K11rTuzZT538ns8RxSAIuEJVVNqxWoIamSAtnx5h7jt25ZPKsjB5F0vD0wbi2wXyDEhsuvGb+P1xrSwsX1WSjXd6adn7B7fMIJS7U4tQn8YiK+/t280xWlkhNeZgLEQNe6Vn0xAAhwgf9i/JQXJM/DPz8T6NG9RTZP9ta7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fc8h41mG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fc8h41mG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE98CC116D0;
	Sat, 28 Feb 2026 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301944;
	bh=qBKfzOHZ5O1q4wiyxKfFbLhgfP/oLXbnGu2JRKx/Ebk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fc8h41mGBQfcduqh+jCVbzoS38ziO0DuM792cupCHuKiyK6jkjJWgMSpW0d/XXqUz
	 2cN32WL4UFVYwwrDOatp/3l5CyDYK/HJ41Nl1595YJovd7xMQomGJvDcKNQ8k0uyZ8
	 9fIRjGhgXAPDR+n2c8Cgf+71Na6hHxpq8jNLZzISNel7AzZ5IDjh2t7S8ZQoeZ7yLJ
	 VUl84CcS9IMAiTAtMKSfUc/NHlLOvVBKWCKbubJ6QqwM+bK4uv43d5u1ArWVfre35V
	 HIww+sFO9yyCqer+YzyHch9jvrhSjIZ0FqUjT7a61JX+MBgaW4UajKEpaglTWmYZ7S
	 NLBa9p8pAeTag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/385] ipv6: fix a race in ip6_sock_set_v6only()
Date: Sat, 28 Feb 2026 13:00:04 -0500
Message-ID: <20260228180011.1568201-382-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 452a3eee22c57a5786ae6db5c97f3b0ec13bb3b7 ]

It is unlikely that this function will be ever called
with isk->inet_num being not zero.

Perform the check on isk->inet_num inside the locked section
for complete safety.

Fixes: 9b115749acb24 ("ipv6: add ip6_sock_set_v6only")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260216102202.3343588-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 6d52b5584d2fb..2651bd76e5b75 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1275,12 +1275,15 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 
 static inline int ip6_sock_set_v6only(struct sock *sk)
 {
-	if (inet_sk(sk)->inet_num)
-		return -EINVAL;
+	int ret = 0;
+
 	lock_sock(sk);
-	sk->sk_ipv6only = true;
+	if (inet_sk(sk)->inet_num)
+		ret = -EINVAL;
+	else
+		sk->sk_ipv6only = true;
 	release_sock(sk);
-	return 0;
+	return ret;
 }
 
 static inline void ip6_sock_set_recverr(struct sock *sk)
-- 
2.51.0

