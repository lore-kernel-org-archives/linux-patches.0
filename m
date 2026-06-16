Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F02E43DA2C;
	Tue, 16 Jun 2026 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622937; cv=none; b=K/Xzp8a/yhWqq2ZA67Olnda7asUTa8m7FlPAWyyX7Rf/hqXDI6CDh1BC/E61ki+CDyVg+mvqF2Hc1hFSs3VnG25BLZUYtWDRHrDc8aJTjCNbyw/RGWEJpujbCYTHK9thbMHElpmEVSfRAtzIFiJSHG0xqa9x1YlbUavupiobpYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622937; c=relaxed/simple;
	bh=1JyMyZJC/blU6RyYQLPvu+QqH0DxTkBThBDTj4l0qEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuYLluSCW1jhDbe9EQ3pp4j87l/Z0ZCazmT7hStcfM9guxheBH9OefFneCbNqpvjaLMWQQ0m63CV2J9Bh3L2OnZY9RtAAIW1RhYesaIlBD/1jXl9jpQkm+U+I4RucDARMbfynQ2KoPXU5VfpVh6r8HpLOkSmLyDLC3sFb68meMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJWjsvMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJWjsvMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5461F000E9;
	Tue, 16 Jun 2026 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622936;
	bh=NFy4586kmgSwsqEKx+5xJsVDAHL0OP0tizJ+UF1CqGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJWjsvMWt8UkKFLbwP4KBKUKdVmTSc4NAxttgimP3eMlCqomXbnOPA91IXufY/rZH
	 n5VNMz7J8WW4DY6So3GRa/OZ3GPwkZ9CtcsOPpR2WOdhv7na9HCFFKPQO3A06A5G1K
	 DCUSNty9cLCOS12Z+wr272fig92k3stFuglzPeRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyu Li <jianyu.li@mediatek.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 057/378] af_unix: Fix inq_len update problem in partial read
Date: Tue, 16 Jun 2026 20:24:48 +0530
Message-ID: <20260616145112.977450472@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyu Li <jianyu.li@mediatek.com>

[ Upstream commit c1f07a7f2d47aeb9878301e7bb36bc1c2bc2be8e ]

Currently inq_len is updated only when the whole skb is consumed.
If only part of the data is read, following SIOCINQ query would
get value greater than what actually left.

This change update inq_len timely in unix_stream_read_generic(),
and adjust unix_stream_read_skb() accordingly to prevent
repetitive update.

Fixes: f4e1fb04c123 ("af_unix: Use cached value for SOCK_STREAM in unix_inq_len().")
Signed-off-by: Jianyu Li <jianyu.li@mediatek.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260601113640.231897-2-jianyu.li@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c3d68bf26ce19b..62ec16c8ab2ede 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2882,7 +2882,7 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		return -EAGAIN;
 	}
 
-	WRITE_ONCE(u->inq_len, u->inq_len - skb->len);
+	WRITE_ONCE(u->inq_len, u->inq_len - unix_skb_len(skb));
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (skb == u->oob_skb) {
@@ -3059,11 +3059,12 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				unix_detach_fds(&scm, skb);
 			}
 
-			if (unix_skb_len(skb))
-				break;
-
 			spin_lock(&sk->sk_receive_queue.lock);
-			WRITE_ONCE(u->inq_len, u->inq_len - skb->len);
+			WRITE_ONCE(u->inq_len, u->inq_len - chunk);
+			if (unix_skb_len(skb)) {
+				spin_unlock(&sk->sk_receive_queue.lock);
+				break;
+			}
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			spin_unlock(&sk->sk_receive_queue.lock);
 
-- 
2.53.0



