Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DBD3F825F;
	Tue, 21 Jul 2026 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661334; cv=none; b=HLC/wwCLz0OoJ7m17i5KglllAfg2Uy1PQH2ygGaOODJYgQr5BNxf3eaMy72XehAvr/97JK3G69n8hF/1LnQS4StHyA2kChSNTJey/GqsZr7knifr+6hrNDU9P+RTTGu1V3L4T6lA/RvcqE81y3D3jyLFY09SIR9JBisJeQHnnbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661334; c=relaxed/simple;
	bh=imD6kNzh0vVbIYu6+i8qkgSjWqX1fwt5OmZ5ydDYoqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYG7++Z/nflzLWdUAo7QHihWAYqSix0QW79AJNzfPdxAADTo0rLbXOJNv4abhUMHfiY1bRcCJGqH1t2xXVPoTaTGIPsiXnQWNOHGSkNIklXyysbzYLsemX8x0ACOYXUkbnbxO6uSyQ/QUYdr4kFYgJc50RPpzvH+26tj1ktG6B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MW8FwAG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MW8FwAG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DEB1F000E9;
	Tue, 21 Jul 2026 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661332;
	bh=BO3rvGx85eAvfyTnvnRqgusfHS5szA/Ad3zib2zP6tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MW8FwAG9E5KebrE1/95fd2qItH8IWiBn5zMOmH19IXhEjOWyeKuuJab9s+YU9OMy2
	 wbskOQ2YwR6vtEC8AgQhCpgcq9aQuATplKoAGhOOpnq2yEyKfAQvqjLOnG3A5tVA81
	 bOtC26JBgU1Mg3hXftQC39qvNYZpO2L8pwrADpME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0027/1276] af_unix: Set drop reason in unix_release_sock().
Date: Tue, 21 Jul 2026 17:07:50 +0200
Message-ID: <20260721152446.691468983@linuxfoundation.org>
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

[ Upstream commit c32f0bd7d4838982c6724fca0da92353f27c6f88 ]

unix_release_sock() is called when the last refcnt of struct file
is released.

Let's define a new drop reason SKB_DROP_REASON_SOCKET_CLOSE and
set it for kfree_skb() in unix_release_sock().

  # echo 1 > /sys/kernel/tracing/events/skb/kfree_skb/enable

  # python3
  >>> from socket import *
  >>> s1, s2 = socketpair(AF_UNIX)
  >>> s1.send(b'hello world')
  >>> s2.close()

  # cat /sys/kernel/tracing/trace_pipe
  ...
     python3-280 ... kfree_skb: ... protocol=0 location=unix_release_sock+0x260/0x420 reason: SOCKET_CLOSE

To be precise, unix_release_sock() is also called for a new child
socket in unix_stream_connect() when something fails, but the new
sk does not have skb in the recv queue then and no event is logged.

Note that only tcp_inbound_ao_hash() uses a similar drop reason,
SKB_DROP_REASON_TCP_CLOSE, and this can be generalised later.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250116053441.5758-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 3 +++
 net/unix/af_unix.c            | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 76311b3ebfc890..06912797712a69 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -6,6 +6,7 @@
 #define DEFINE_DROP_REASON(FN, FNe)	\
 	FN(NOT_SPECIFIED)		\
 	FN(NO_SOCKET)			\
+	FN(SOCKET_CLOSE)		\
 	FN(SOCKET_FILTER)		\
 	FN(SOCKET_RCVBUFF)		\
 	FN(PKT_TOO_SMALL)		\
@@ -124,6 +125,8 @@ enum skb_drop_reason {
 	 * 3) no valid child socket during 3WHS process
 	 */
 	SKB_DROP_REASON_NO_SOCKET,
+	/** @SKB_DROP_REASON_SOCKET_CLOSE: socket is close()d */
+	SKB_DROP_REASON_SOCKET_CLOSE,
 	/** @SKB_DROP_REASON_SOCKET_FILTER: dropped by socket filter */
 	SKB_DROP_REASON_SOCKET_FILTER,
 	/** @SKB_DROP_REASON_SOCKET_RCVBUFF: socket receive buff is full */
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 4682cc59b7a7aa..4caff11068c380 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -731,8 +731,8 @@ static void unix_release_sock(struct sock *sk, int embrion)
 		if (state == TCP_LISTEN)
 			unix_release_sock(skb->sk, 1);
 
-		/* passed fds are erased in the kfree_skb hook	      */
-		kfree_skb(skb);
+		/* passed fds are erased in the kfree_skb hook */
+		kfree_skb_reason(skb, SKB_DROP_REASON_SOCKET_CLOSE);
 	}
 
 	if (path.dentry)
-- 
2.53.0



