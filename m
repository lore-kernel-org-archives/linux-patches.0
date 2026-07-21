Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427D0403E8A;
	Tue, 21 Jul 2026 19:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661347; cv=none; b=HRuNngKHt4jQCSQvJZx3I47B8ixmRlFZv2LvrengU06wBWvSR4brbU6T1nSBIrn8gR6AllsqWA1uQTO6rHZkhcb20sy+l82it7ZBt/LVVdnYnlTPFCVEKMoTLBc9gpsTn7h+wyjZ5+MlHrGRfyFHuILFQG6LWqWAMpdsyyrBIj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661347; c=relaxed/simple;
	bh=hnZK2iuSOk9MugilstPD70W3iIgM2Rw0z4qsYaENAjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqdPwd/opqfY35s5nJnJwB/yQRgD4nsI0yg6QtBIS3RpnsgNufsvBH+gGOggUpDKp1/5SsAYxIGRiPA3HfX56sMHNfUgWK9k5jyRTkUD0PNa3zasUUxD3nU/zDSgBeGSKkfz5643IyeK2ParnunNzfk3aUTdHmjeCB67au9qe3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOcEoZI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOcEoZI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F6B1F000E9;
	Tue, 21 Jul 2026 19:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661346;
	bh=LJWjMwXqEnnMEeGeACGO0CXVC/TaAU4aLak7RHHMVQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOcEoZI2eB01gmwTfDQ9M1kvKuBXX7guyzhES+hXhUxzoNwsORTntV+9TRd6WRaXx
	 P997MQ0TL/Adi+FVV+SJQhQZPYEbqnOQjzJHWDA0J5RKDuaLi0NtNtc87kq+ySScKE
	 UvGMdG/yNycfciQZByESZQ08fSjlFmSYaIYwKZT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0032/1276] af_unix: Dont check SOCK_DEAD in unix_stream_read_skb().
Date: Tue, 21 Jul 2026 17:07:55 +0200
Message-ID: <20260721152446.802492826@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 772f01049c4b722b28b3f7025b4996379f127ebf ]

unix_stream_read_skb() checks SOCK_DEAD only when the dequeued skb is
OOB skb.

unix_stream_read_skb() is called for a SOCK_STREAM socket in SOCKMAP
when data is sent to it.

The function is invoked via sk_psock_verdict_data_ready(), which is
set to sk->sk_data_ready().

During sendmsg(), we check if the receiver has SOCK_DEAD, so there
is no point in checking it again later in ->read_skb().

Also, unix_read_skb() for SOCK_DGRAM does not have the test either.

Let's remove the SOCK_DEAD test in unix_stream_read_skb().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250702223606.1054680-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f50049ea54a5a4..a18a4b0229707f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2737,14 +2737,6 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (unlikely(skb == READ_ONCE(u->oob_skb))) {
 		bool drop = false;
 
-		unix_state_lock(sk);
-
-		if (sock_flag(sk, SOCK_DEAD)) {
-			unix_state_unlock(sk);
-			kfree_skb_reason(skb, SKB_DROP_REASON_SOCKET_CLOSE);
-			return -ECONNRESET;
-		}
-
 		spin_lock(&sk->sk_receive_queue.lock);
 		if (likely(skb == u->oob_skb)) {
 			WRITE_ONCE(u->oob_skb, NULL);
@@ -2752,8 +2744,6 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		}
 		spin_unlock(&sk->sk_receive_queue.lock);
 
-		unix_state_unlock(sk);
-
 		if (drop) {
 			kfree_skb_reason(skb, SKB_DROP_REASON_UNIX_SKIP_OOB);
 			return -EAGAIN;
-- 
2.53.0



