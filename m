Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF4736AB6B;
	Sat, 17 Oct 2026 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253732; cv=none; b=ZWpPdpN0MfRnzAWI+xyGzD8JrpqqO1iboehAe3h9qEmGQziJ86nFJLpQBVK0xcRWxGyWcD5ecLV2ZrYODR3a1vGg2ayLG8GvZleR0PyhB1smDGIs/sflS+q3MBUONC4wQFw4hBMfoOVNeC2aU77eisECARDvA7kkg6B6IwRTXA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253732; c=relaxed/simple;
	bh=tK0EiyIwqsOXwiEVTnCcGMKPP+rknh5Jpfx0aaWMYJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEipdWfnDaQubqVofR/aJs4+Y5HHMkwwvrGe0K+44/mqNK1sv5x/W6SiNRR89UWqt/V6Te2Bx3lwcJZGIrYfWEu213G13uvXE1m8lDdmbb/J+NfCUBK4pnJ5em7tyAVGruXcf6PAuOHod5Z3zTziCJotAWps0fUnZvMgmQjLbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Biq1JfTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Biq1JfTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC4E1F000C4;
	Sat, 17 Oct 2026 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253731;
	bh=pQeulsOfrdjjXdlHzzXewvDT1aJqH/a4gKtk70v4lCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Biq1JfTPRMu/r10M0wBefUuASK/1L2zzCYV5Eyn/FiteTe/1bn5fSAjOhEYhIYNZ6
	 1gamVtFoSODaYjoCNE+7s74IuzwqrtVFMbajZzeaiRXruguW1MQLlOFRmtQHYjNaDl
	 04pT7bnb6DdDI+BhK+uZRK4QRUm1p7cqcj7EWE2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/869] mptcp: add eat_recv_skb helper
Date: Sat, 17 Oct 2026 17:50:56 +0200
Message-ID: <20261017160042.564193175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 436510df0cafb1bc36f12e92e0e76599be28d8f4 ]

This patch extracts the free skb related code in __mptcp_recvmsg_mskq()
into a new helper mptcp_eat_recv_skb().

This new helper will be used in the next patch.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260130-net-next-mptcp-splice-v2-1-31332ba70d7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5dd8025a49c2 ("mptcp: fix soft lockup in mptcp_recvmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 894fbda97f45f..21a5991ae0f59 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1964,6 +1964,17 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied);
 
+static void mptcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	/* avoid the indirect call, we know the destructor is sock_rfree */
+	skb->destructor = NULL;
+	skb->sk = NULL;
+	atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
+	sk_mem_uncharge(sk, skb->truesize);
+	__skb_unlink(skb, &sk->sk_receive_queue);
+	skb_attempt_defer_free(skb);
+}
+
 static int __mptcp_recvmsg_mskq(struct sock *sk,
 				struct msghdr *msg,
 				size_t len, int flags, int copied_total,
@@ -2020,13 +2031,7 @@ static int __mptcp_recvmsg_mskq(struct sock *sk,
 				break;
 			}
 
-			/* avoid the indirect call, we know the destructor is sock_rfree */
-			skb->destructor = NULL;
-			skb->sk = NULL;
-			atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
-			sk_mem_uncharge(sk, skb->truesize);
-			__skb_unlink(skb, &sk->sk_receive_queue);
-			skb_attempt_defer_free(skb);
+			mptcp_eat_recv_skb(sk, skb);
 		}
 
 		if (copied >= len)
-- 
2.53.0



