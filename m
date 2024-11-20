Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2B1A4F19;
	Wed, 20 Nov 2024 12:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107510; cv=none; b=H5unaKiarEJyJYGkGoS1QVL4CL6otzftFctupTnRRKJ8+bbKxpOZnsB0x1cE17NzpLJZ10LSouSfniRHhqs6dZC314p6C5zwupuMxveh3xYxRupPIpwbp7lQqE6rHB6G2qcQFBccmuZzUodbggTIU6pUPvbZRB/21/B0mHwHYmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107510; c=relaxed/simple;
	bh=PDnneC787xmymV7wh3NP6xqyhVxIlMEhBd+KejtoxKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtbQY1SQVTlgzATadOMoy2Cp/dUmEVV93AZ6oI2jE60AWhIXgtSsDiL9A4kdyWfdByiTCCFlYkIGXIUYXg9kK8OWgxgIrzFR1/OKLMdSEZJ592cI4W1aNBhCdPJpJxYrHm5D0C14bSxImmFWCQAUMqpQ5RucdkILnQ3Uva3Fysk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrN8V2DI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrN8V2DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6899CC4CECD;
	Wed, 20 Nov 2024 12:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107510;
	bh=PDnneC787xmymV7wh3NP6xqyhVxIlMEhBd+KejtoxKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrN8V2DI2egArkd4zdoZ2Vq39LW3ekyTBO3e9tvNde2kl5LyBF75o3hp+ZkxvzGu2
	 S4WqD9V+veDXezBkbwI6RmTvr0vAvSisGpuW/5+wzcF9dEmmBlVWrseacW8eP6CIec
	 x5iHTDXW8kPjSm4eEr+vDahl8bXewneqetEDQUS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/107] mptcp: cope racing subflow creation in mptcp_rcv_space_adjust
Date: Wed, 20 Nov 2024 13:55:42 +0100
Message-ID: <20241120125629.849751868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ce7356ae35943cc6494cc692e62d51a734062b7d ]

Additional active subflows - i.e. created by the in kernel path
manager - are included into the subflow list before starting the
3whs.

A racing recvmsg() spooling data received on an already established
subflow would unconditionally call tcp_cleanup_rbuf() on all the
current subflows, potentially hitting a divide by zero error on
the newly created ones.

Explicitly check that the subflow is in a suitable state before
invoking tcp_cleanup_rbuf().

Fixes: c76c6956566f ("mptcp: call tcp_cleanup_rbuf on subflows")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/02374660836e1b52afc91966b7535c8c5f7bafb0.1731060874.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f3e54c836ba56..7913ba6b5daa3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2082,7 +2082,8 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 				slow = lock_sock_fast(ssk);
 				WRITE_ONCE(ssk->sk_rcvbuf, rcvbuf);
 				WRITE_ONCE(tcp_sk(ssk)->window_clamp, window_clamp);
-				tcp_cleanup_rbuf(ssk, 1);
+				if (tcp_can_send_ack(ssk))
+					tcp_cleanup_rbuf(ssk, 1);
 				unlock_sock_fast(ssk, slow);
 			}
 		}
-- 
2.43.0



