Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ADF2D60A;
	Tue, 14 May 2024 11:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687111; cv=none; b=qggC4Sxe4Z5xrhkWhAg4LCQt3HYFAPuBZLI/V6zAHUzIKZuoigvHfHW2f4TqIUBgWdhyMLRwlN8m505uFFAthCYFam7TUn1JgJ2HqyAsMFFfgqiqaq/UcNlV9O25RfjFrdbSxP5ZHi2fxSWRHX41ddkrMd+lsb1V2KXerBzfnZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687111; c=relaxed/simple;
	bh=D/NlKENOjYbg19PbhD/Z3/sBVn8Mp5hffrgj2UdevFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeavZstlM2siPy73wda5qgxXl8LqmazUgbImm3mm7Z152ChMr6JAxR/NVq/oPNIGw3ZKLa67m+2eImI78NRoHdn1jNI1WmzFoSgJWc7ji014Rr02JKx2HAEvZGuX0awPDoytSQ33g+mxzenUY4GVwfPZgGPjo3i8jbYphbbcNMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4EX49wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4EX49wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF81EC2BD10;
	Tue, 14 May 2024 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687111;
	bh=D/NlKENOjYbg19PbhD/Z3/sBVn8Mp5hffrgj2UdevFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4EX49wY+O2Lsp1jDNMBFfXL+Eu1bq7FwZc5Wkbp6D/3mGYJXqRYwvbc2G1am8AWV
	 CwM5kmhYVgHfe2Qns4p6eSqmagUjJXDhVLBZ2tinzGotoWoXYqzjYlDigWEIvetPzS
	 OOsOfuDFxZWL7SCcuetC3j0WxwMaiIdZlJ9ur/58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/84] net: mark racy access on sk->sk_rcvbuf
Date: Tue, 14 May 2024 12:19:48 +0200
Message-ID: <20240514100953.088014794@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: linke li <lilinke99@qq.com>

[ Upstream commit c2deb2e971f5d9aca941ef13ee05566979e337a4 ]

sk->sk_rcvbuf in __sock_queue_rcv_skb() and __sk_receive_skb() can be
changed by other threads. Mark this as benign using READ_ONCE().

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Signed-off-by: linke li <lilinke99@qq.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index daeb0e69c71b4..2b68a93adfa8d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -453,7 +453,7 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	unsigned long flags;
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
-	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
+	if (atomic_read(&sk->sk_rmem_alloc) >= READ_ONCE(sk->sk_rcvbuf)) {
 		atomic_inc(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
@@ -505,7 +505,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 
 	skb->dev = NULL;
 
-	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
+	if (sk_rcvqueues_full(sk, READ_ONCE(sk->sk_rcvbuf))) {
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
 	}
-- 
2.43.0



