Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930EF36AB6B;
	Sat, 17 Oct 2026 16:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253729; cv=none; b=DB+FZK+7+8+NtjcbiscB7s+r7mV4zwcpl3eF5pqCuNbakbmBLnF9xmF3NF5RPriSDCqpolZ/R9Q+1QfgkAJn7FbaaH2EJ3NcfQY9G5PckForRhQCIgj6NxdXDKlCvdvSeQvKBm3N6wHGdqHh+qP4xoMUsT5GHUbo+vsEnA4KkyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253729; c=relaxed/simple;
	bh=Z1mrIyYQFQRcIFkreHgoRh+8v4HtdqwD7FEdvfdpZpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7ZYdw9BNE7m5Cyp87LN0tLaMG3vV8gAUl9PbkILu+wfeaLT7G2kHwJuFlbtA8pI59tS7rQZ7wlfGsyl9n3/sFiWh6tIAw/TgsfkM5wlxSw4lOWUgv1wwFClPQPjr9Z1/Lo5zthfS8QTXsjgv9+heL2jaSZS1VTwPWjMU2W7bIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC14HNgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC14HNgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50561F000C4;
	Sat, 17 Oct 2026 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253728;
	bh=bmSyp9AETt1bKqFBQlAXm1XGGYR2gM9gyzw+OkR80zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BC14HNgqieQ4W18BYMxixlG5Le2cfuuWhNfdP+vS0Sl0YQJ2zAE3zFDC8OuBMelRQ
	 N9m4OCmFxzQ/m+lVC0HeTB9dAzi8AzLE9bum12TFcnM9J0cXO6uRhT325rERWO6K2A
	 WPL54wVySgaIJVDrpMLLOZtyh5FYS2r9CVD/R+Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/869] mptcp: leverage skb deferral free
Date: Sat, 17 Oct 2026 17:50:55 +0200
Message-ID: <20261017160042.539632102@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9aa59323f2709370cb4f01acbba599a9167f317b ]

Usage of the skb deferral API is straight-forward; with multiple
subflows actives this allow moving part of the received application
load into multiple CPUs.

Also fix a typo in the related comment.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250927-net-next-mptcp-rcv-path-imp-v1-1-5da266aa9c1a@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5dd8025a49c2 ("mptcp: fix soft lockup in mptcp_recvmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5e094c72dcbb7..894fbda97f45f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2020,12 +2020,13 @@ static int __mptcp_recvmsg_mskq(struct sock *sk,
 				break;
 			}
 
-			/* avoid the indirect call, we know the destructor is sock_wfree */
+			/* avoid the indirect call, we know the destructor is sock_rfree */
 			skb->destructor = NULL;
+			skb->sk = NULL;
 			atomic_sub(skb->truesize, &sk->sk_rmem_alloc);
 			sk_mem_uncharge(sk, skb->truesize);
 			__skb_unlink(skb, &sk->sk_receive_queue);
-			__kfree_skb(skb);
+			skb_attempt_defer_free(skb);
 		}
 
 		if (copied >= len)
-- 
2.53.0



