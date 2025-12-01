Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1859F2E5B2A;
	Mon,  1 Dec 2025 11:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588561; cv=none; b=fhLO07FPXPXn8dzCcooZpAnwyXqOsoPSwu10++mhM9vuVdHfpN3zf5CJNXpwb031E/GDLEbrVn7UscD6Y0Typv39vXuYIBVDozcAhnRyScRGfveCNNPlbKUV/LxMPZX6+uQ6YO4IOBGDOzs3MkFwBUlYFzZEHKez0BFr5CJnR44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588561; c=relaxed/simple;
	bh=LptRPwXDFU5ZcLVXH/prHqJ7a6OVFqnUtMRJn9NADZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+W3F3pweQoiMVKBO8vVQ3ZQZsyW16Z+co/9hh8rsWwA+a2gx+zzdFO/BV4pALjvuflWmhWvnqhGlb4bsaN6Y3JvpzwPP12XoU+KmqLuANE2jWeEMWKcAP+PaunZ2zuMpdrpKLX9vn8MNlfMXUJJ1gdPfpdhFNa7zxCM/BscM34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4OsTNBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4OsTNBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931E1C4CEF1;
	Mon,  1 Dec 2025 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588561;
	bh=LptRPwXDFU5ZcLVXH/prHqJ7a6OVFqnUtMRJn9NADZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4OsTNBO5vWeTGVB5VxQA4A08mDyp1UCAtZvDboksVUaOWRI3EuDM2n+dp7nPgQrH
	 efJUe0RnYQQ1cyxwlTz6JmXV5cK3k6mtEaqHS2VOFZ2QxMSg/C+DBCdBOhbDXv7WZj
	 XzTpOzkf/3huVDsuDdoPyNNJVxOp1y4g4l4/U7+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/187] ipv6: np->rxpmtu race annotation
Date: Mon,  1 Dec 2025 12:23:20 +0100
Message-ID: <20251201112244.566399695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9fba1eb39e2f74d2002c5cbcf1d4435d37a4f752 ]

Add READ_ONCE() annotations because np->rxpmtu can be changed
while udpv6_recvmsg() and rawv6_recvmsg() read it.

Since this is a very rarely used feature, and that udpv6_recvmsg()
and rawv6_recvmsg() read np->rxopt anyway, change the test order
so that np->rxpmtu does not need to be in a hot cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250916160951.541279-4-edumazet@google.com
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 731485b18de31..90d828c98b736 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -474,7 +474,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index db948e3a9bdc8..3ed835b308044 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -297,7 +297,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0



