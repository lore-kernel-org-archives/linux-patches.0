Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541D147126B;
	Sat, 12 Sep 2026 11:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212081; cv=none; b=Ed/7/MmUdO/BOT2pycWvSugBPQR1iUfgIsUTjOkZKUx5OCZzTzBFwlCzQDl2lH/E8c7X7KctwFSKxfxEuBpvdmOZXFbek6aJS/kqSQ8EUgz5fDuHiPr57ZSbO74xKOuDGt/0ziezBw0JVrWFxcGh57dAhY5O5co7VVGmtpw9YGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212081; c=relaxed/simple;
	bh=7csVpdxxi5L5AUhr1ZFHrhvTzySKyQvzkv7RCm1r0EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiWL9NHBamdhEidGVhXn2JxikU6DPmfl6aXQbMEoM5+qyOJlFBOpiyoEbICzketlP0f0Tt9tYPVXszC32f0RIG+FY7W+16Z3p9NTdFqUbLDd7MrvB+PBoZjTYHJSnu+R2VzForU6alL9nOEyPppWiUINWoBup7Gh2OKbVQHxk38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfEOTFBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfEOTFBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B5A1F000FF;
	Sat, 12 Sep 2026 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212080;
	bh=4QpE5BibWMefg3uKNu4P5gro8bQL1BFdymOKfnqmMBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfEOTFBCRNUU+fkDrJHLbv1KHHl7khwOsHtSikc5UyA+KgeK2tcrkh3RSCE36j5o4
	 fohddqqrQ1xV2Xs1swwsIXV4kqHlnhT402xk6cqE58RuexoctO8uHr+HT9MiqSKDLn
	 ORcVhwu1tqVLznO7ouiGIJsV12ac8EfkOnV+aNzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Bobby Eshleman <bobbyeshleman@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1362/1518] net: tcp: block mixing readable and unreadable frags
Date: Sat, 12 Sep 2026 08:58:51 +0200
Message-ID: <20260912065654.345030910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit d9c56501c72fdac937e8b770f31655c46832f1a5 ]

Protect tcp_sendmsg_locked() from mistakenly mixing readable and
unreadable page fragments in the same SKB.

Check that the devmem binding matches the existing SKB's readability.
If a mismatch is detected, avoid collapsing and create a new segment.

Fixes: bd61848900bff ("net: devmem: Implement TX path")
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20260814191336.187243-2-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index db80b81a74cbb..02f5d53245547 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1203,7 +1203,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 		trace_tcp_sendmsg_locked(sk, msg, skb, size_goal);
 
-		if (copy <= 0 || !tcp_skb_can_collapse_to(skb)) {
+		if (copy <= 0 || !tcp_skb_can_collapse_to(skb) ||
+		    unlikely(skb_frags_readable(skb) != !binding)) {
 			bool first_skb;
 
 new_segment:
-- 
2.53.0



