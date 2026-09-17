Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A4850E584;
	Thu, 17 Sep 2026 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665058; cv=none; b=NParHjvvzfGvihjaj/6OG5WF0kaoI7lxeqE6rQEDXafVYfSutagHE6RW4JxJOV9HL58SWOEpUNzfnRP0LBD8DkUCNZFJo4/5VSUmkX0BSSsY5oaP8x/XAXDZsPLLXRxnmIMCOHmjbMG4XCjPMZf5Vgrgo18FBfK2dzayPfiv0VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665058; c=relaxed/simple;
	bh=14G5U/fzAWmXxsh3KG0V8Ncs7SQVCjq8oQqaXJZfwKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0r4WijcwZZcegNasjZqk+3dl7adrOSj2YsIMwBHjvibwnQYLfo4C1v2YG+MZdThDctvQkaKnHhJ3nXP4IJ/DbS0F7HROqKPQE4BwIVHxhJNGu93IdpLJ0+Fm4AovT6zaU68TUaFHMsk2ATbPC5/rG2WN0XJJu6hIj1CGJAYIiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sl22x2Mg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sl22x2Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0FF1F00893;
	Thu, 17 Sep 2026 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665056;
	bh=sYe+y5Z8PePUMo7ajdTzxa9H5FASbXAoy1VKKtyhscw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sl22x2MgYLT1Gjg0f76ZTjWty0f30nlFKNK6ljt6KSptAzEh2RaKr4u8+g+r9/2WH
	 +/MnFNWvsM0tCCKzx6oaimOt1ZI1SsezxomKR/BRLXlOrgGRMIEwbMJVEBNcX5ldXw
	 AWX28PaZYtjazfi487LYF+uDucXFzs5OgEVhc96k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0578/1250] tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()
Date: Thu, 17 Sep 2026 16:06:13 +0100
Message-ID: <20260917151607.562052976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7823bbcd482be..af14b50933f5c 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1935,7 +1935,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	if (likely(!err)) {
 		int offset = skb_cb->bytes_read;
 
-		copy = min_t(int, dlen - offset, buflen);
+		copy = min_t(size_t, dlen - offset, buflen);
 		rc = skb_copy_datagram_msg(skb, hlen + offset, m, copy);
 		if (unlikely(rc))
 			goto exit;
@@ -2067,7 +2067,7 @@ static int tipc_recvstream(struct socket *sock, struct msghdr *m,
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



