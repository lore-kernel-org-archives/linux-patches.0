Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1673C108F;
	Wed, 30 Sep 2026 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794882; cv=none; b=okRbJvX4TkBqzx/tVN/YwUYU57A1MZIoDmMcGtkwfduiLFt4rszbeQsbStutf099qe31jU6VoCYyQRlmdPA/HlnqO0ZHmASNRr1Qb0WgXtkkoYi4yOO0RQ0+CcVsXmVoZ7eCFWG3ZtcMAkMMCxQnrHEjTY0ljqajbT8Sid0fP1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794882; c=relaxed/simple;
	bh=rNahraFEbEtbYEoZiBjImBoRFO2mU4/G2N/3wWOV3Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZqTyf3NEgJi5XkI6w1By0R4wbJRrrVNzGFL/+1q0uUBENk0VHrzSDzAsq7vF2pTp4ZYAQ44kK0w050tkRYn/trI4ZjS/oTOQwjKLugTCp70K4l4vZp3Q0zteksfKxSStryL47v1iUmmKKHu8r7eLQdKfZhvOFKX7U+qQYUPsAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyIVtBdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyIVtBdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7888A1F00898;
	Wed, 30 Sep 2026 19:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794853;
	bh=wjuZ8Kdwy8SodkPjSJErzcdS8zf0z8w3hBTSY4iLd+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyIVtBdhQirLPYq2wfsgeT5nTmRgUSQD15uw1eZwuf0QdZ9vzuvDGauGjoxIPqCOJ
	 elkWguv7IY9TRRIq/Jo/3i88YMBc0HD56DnidaYvxZj+DX14heU7VBniejQSsZw0S7
	 re2ymrkxkZtcHgpQiHfDG6QG04L8qVoFnxTPgQN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0355/1193] tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()
Date: Wed, 30 Sep 2026 17:17:19 +0200
Message-ID: <20260930152442.054453318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit 47f42ff521b4eeb46e82f9a46a4783a99f7570d7 ]

In tipc_recvmsg(), the copy length is computed as:

  copy = min_t(int, dlen - offset, buflen);

buflen is size_t but min_t(int, ...) casts it to int. When buflen
exceeds INT_MAX (e.g. 0xFFFFFFFF via io_uring provided buffers), it
wraps negative, wins the comparison, and the negative copy length
propagates to simple_copy_to_iter() where int-to-size_t promotion
makes it SIZE_MAX, triggering a WARN_ON. tipc_recvstream() has the
same pattern.

  Kernel panic - not syncing: kernel: panic_on_warn set ...
  RIP: 0010:simple_copy_to_iter+0x9e/0xd0 (net/core/datagram.c:521)
  Call Trace:
   __skb_datagram_iter+0x123/0x8b0 (net/core/datagram.c:402)
   skb_copy_datagram_iter+0x77/0x1a0 (net/core/datagram.c:534)
   tipc_recvmsg+0x3d7/0xe80 (net/tipc/socket.c:1934)
   io_recvmsg+0x47e/0xda0

Fix by changing min_t(int, ...) to min_t(size_t, ...) in both
functions. The result is always <= (dlen - offset), which is bounded
by TIPC maximum message size (0x1ffff bytes), so the implicit
narrowing on assignment to int copy is always safe.

Fixes: e9f8b10101c6 ("tipc: refactor function tipc_sk_recvmsg()")
Fixes: ec8a09fbbeff ("tipc: refactor function tipc_sk_recv_stream()")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260720214103.47732-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 6d9bc9397b03c..157d68b91c5c3 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1940,7 +1940,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	if (likely(!err)) {
 		int offset = skb_cb->bytes_read;
 
-		copy = min_t(int, dlen - offset, buflen);
+		copy = min_t(size_t, dlen - offset, buflen);
 		rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
 		if (unlikely(rc))
 			goto exit;
@@ -2072,7 +2072,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
 		/* Copy data if msg ok, otherwise return error/partial data */
 		if (likely(!err)) {
 			offset = skb_cb->bytes_read;
-			copy = min_t(int, dlen - offset, buflen - copied);
+			copy = min_t(size_t, dlen - offset, buflen - copied);
 			rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
 			if (unlikely(rc))
 				break;
-- 
2.53.0



