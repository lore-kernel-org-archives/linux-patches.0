Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C339B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302640; cv=none; b=QRUSuLecjftT8EbK/PmAZjGvbjD+EyvRsLMmc9kc6gUOqeDWvcW5iJIk1OdagMpuwhpqZFaIilppCTKqiBW/GatO9nt+sYxFMFtjI25JAbBzvEmQoq7miYvO6h5BUNfv0EvjyyIGqdsGS280J89cx2akyRLrVV1qd2WG6t8J7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302640; c=relaxed/simple;
	bh=NN7nGb1beWUZXDlqn/i0aTeQYrzpcWrf9NS9gW+PTDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW2i4K4Ls0NzXDY5nCKbs+7tlxLxvLbNjTQKprdq6i2hZfyE0AFYKpnn8WiSk41b/GsdvMbiJ4sm3VZEEML3Ura8KIvRxVr59Q8zdZx4qC6B7j7N2Sf4SZvw6X9td4Toz/c8bjzOV/AL3RY7YvEQJqmGrESij5IvdPhNhYZr/wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRG9GhJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRG9GhJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A67CC19425;
	Sat, 28 Feb 2026 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302640;
	bh=NN7nGb1beWUZXDlqn/i0aTeQYrzpcWrf9NS9gW+PTDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRG9GhJP5T8kboQKjzTAo1hXfo5/jIWU8wJZSMy6zujjt3YlamHy8Vid15uNHa3xV
	 MxXu4RVt8bUZlVGxO033kPN/ndT6UfDZSoYyCC8bBKAcFsDLfWyx+LnTpXcBqkEvzG
	 poRGp7Ih/Q/WGGWzJuyKJqzlC1umuIkN/oPDInZUFosYievauRzwFthP++k62sE2gY
	 SQGTHBPLXVFLux+hPMYrc6aglkmk8hBysuXRyXq0HLeigwrrFr0OEUY9aIq39iyRjD
	 J6mBFL3IxhAR4HrZwP6SlexO8k43KZi0I8q/xy79NUu6RreIZdjaJqNx9qLvB/kgBL
	 T+IUbfBphCaBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/164] ipv6: fix a race in ip6_sock_set_v6only()
Date: Sat, 28 Feb 2026 13:15:01 -0500
Message-ID: <20260228181505.1600663-162-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 608943944ce1a..dcae37154d3c2 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1186,12 +1186,15 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex,
 
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

