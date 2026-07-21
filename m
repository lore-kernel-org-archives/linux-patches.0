Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEAC408624;
	Tue, 21 Jul 2026 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661336; cv=none; b=CWr0lGreOv7v9+Zxl1gDIHlmMDJlN4MJRKW1h3s5oaJRwaoYBAa5LuIo+JVUC4un+p+iC/7pj4oMaRkZWZvi7XBRRqSeFBpigqktvdywjKASk3K9WKFfHFGEfS1OSmPFq83oWBsaqd0xg4w2knnHpWdezzVedZMpcQdeb7Nv7K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661336; c=relaxed/simple;
	bh=3aO+hX6KyKNVutJPb0kpJpjkdD2TAusGNnNdW6W1NlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKoPfQAw34u/6F0B2K5DBg7xCehXm+Bxos1vjT2+vlmeDXo8YGAL3kJyfNZ9U4XTS4TeXv8cxr7b+MsV7WAbUVWhVQR9JPeShnlao/2iS1lb5Y8fLUGQuX4vNqaVfxmOeIp5Tn4XKyHebO6WBfMCSr9pZnteI3uwV+q8RAcfNic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRrjMrtg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRrjMrtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15A41F000E9;
	Tue, 21 Jul 2026 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661335;
	bh=oHeVqaEk050lwpzjKuyyGwThAuXyPJt3L7HdYTDSnyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FRrjMrtgQhUSIWfM39oVSnzshMSgVcomBY4hoE0xZ5FeyxUCDRi9X7oi4seyr/VHR
	 j8+CW9rvsBfAjMyOIW5gLoBicD3/OT0bMZ7FDBHyev4K1lnrzFemrqUIoRplO6OWFp
	 SYY2njVGfiDPo7MTCPhcb48+HdAZKhiWUb8c9iiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0028/1276] af_unix: Set drop reason in manage_oob().
Date: Tue, 21 Jul 2026 17:07:51 +0200
Message-ID: <20260721152446.711915262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 533643b091dd6e246d57caf81e6892fa9cbb1cc9 ]

AF_UNIX SOCK_STREAM socket supports MSG_OOB.

When OOB data is sent to a socket, recv() will break at that point.

If the next recv() does not have MSG_OOB, the normal data following
the OOB data is returned.

Then, the OOB skb is dropped.

Let's define a new drop reason for that case in manage_oob().

  # echo 1 > /sys/kernel/tracing/events/skb/kfree_skb/enable

  # python3
  >>> from socket import *
  >>> s1, s2 = socketpair(AF_UNIX)
  >>> s1.send(b'a', MSG_OOB)
  >>> s1.send(b'b')
  >>> s2.recv(2)
  b'b'

  # cat /sys/kernel/tracing/trace_pipe
  ...
     python3-223 ... kfree_skb: ... location=unix_stream_read_generic+0x59e/0xc20 reason: UNIX_SKIP_OOB

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250116053441.5758-6-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 6 ++++++
 net/unix/af_unix.c            | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 06912797712a69..07826c85d31ca0 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -9,6 +9,7 @@
 	FN(SOCKET_CLOSE)		\
 	FN(SOCKET_FILTER)		\
 	FN(SOCKET_RCVBUFF)		\
+	FN(UNIX_SKIP_OOB)		\
 	FN(PKT_TOO_SMALL)		\
 	FN(TCP_CSUM)			\
 	FN(UDP_CSUM)			\
@@ -131,6 +132,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SOCKET_FILTER,
 	/** @SKB_DROP_REASON_SOCKET_RCVBUFF: socket receive buff is full */
 	SKB_DROP_REASON_SOCKET_RCVBUFF,
+	/**
+	 * @SKB_DROP_REASON_UNIX_SKIP_OOB: Out-Of-Band data is skipped by
+	 * recv() without MSG_OOB so dropped.
+	 */
+	SKB_DROP_REASON_UNIX_SKIP_OOB,
 	/** @SKB_DROP_REASON_PKT_TOO_SMALL: packet size is too small */
 	SKB_DROP_REASON_PKT_TOO_SMALL,
 	/** @SKB_DROP_REASON_TCP_CSUM: TCP checksum error */
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4caff11068c380..e0f5a93821490a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2714,7 +2714,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 	spin_unlock(&sk->sk_receive_queue.lock);
 
 	consume_skb(read_skb);
-	kfree_skb(unread_skb);
+	kfree_skb_reason(unread_skb, SKB_DROP_REASON_UNIX_SKIP_OOB);
 
 	return skb;
 }
-- 
2.53.0



