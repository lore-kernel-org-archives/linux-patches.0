Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BE6443E4A;
	Thu, 30 Jul 2026 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422179; cv=none; b=rgoAVlXZn2C7VqX6yEHCsFyQr/QDqU9cEdeJ3BGg/xOdGG46WbBBPmAqFDxPfgmy0DcqG/HRrQADYM80ko16gTMaYWKJh1P2xCm4wxSDMCNgqkXhamaaFseu6/Y4aIJFIQvzfUotH8VNHaHZe3xrHpMfr9QHJTeHZrDDcaRGxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422179; c=relaxed/simple;
	bh=eSzGv6DQfV6Biwt4F8nGFP2g3BzkwdUwEapFU3f57yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpYaC6JzzYCpxfGhC+7a47eFTyDAH+LmgTfqQIUEmiAivXlLAEAsZ6PoASgfP0RHXA0j3bn1o4aEs0IEUv3wLnJtgATLHyOumPdZ4wwSyQnjg1MJddtA0/9yAmTe4uK0UWdvzpZApyDC/BUN/hk+Ij65/VrlBhm6JhzQxOfs2O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/VQsQ1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/VQsQ1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C951F000E9;
	Thu, 30 Jul 2026 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422178;
	bh=XD8CwCgNv7J7HVZySszp7gF4IoctTrBRBtKQGQiXFmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/VQsQ1O136c/sTd0sNoErN0K0f3qEPiIh9uWRv3aCFcah2IFd3iOOVoTfzsxy5h2
	 VCS0Gr3pHYfg8s+nb2WYP34RxuoE0BYTE1Tr+yJW9wGpZlKfHLT8nkrE7IWShWLXql
	 //mpPbeeeqf4ep2lJ9kMXroDZJZ8t45v695oL0c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 350/744] tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()
Date: Thu, 30 Jul 2026 16:10:23 +0200
Message-ID: <20260730141451.727508331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 490f30899b5a9a..14f3f2e5dba092 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1934,7 +1934,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	if (likely(!err)) {
 		int offset = skb_cb->bytes_read;
 
-		copy = min_t(int, dlen - offset, buflen);
+		copy = min_t(size_t, dlen - offset, buflen);
 		rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
 		if (unlikely(rc))
 			goto exit;
@@ -2066,7 +2066,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
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



