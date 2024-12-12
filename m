Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FEA218594;
	Thu, 12 Dec 2024 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021724; cv=none; b=b33Th9VCCUYZIU7YbGDOiDz80Py7h0gDsaUEd31Wcq/PFdUDJB234tsmkE4Z+Puo00UdcdqNV75OaKzvvWXoREYzk6n1XRpTgOWUfF3fA7AewcqImxXzGAkrM5ES7SeJu4lkzdsisdbbEeoqH+PX2PTdTT6qm2r/dqTEZGAV3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021724; c=relaxed/simple;
	bh=y3W63cNpyYYPPacEylSM2pC7zGXA9YSd6kRK/oNZz9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOel9GYmO53mlYnQA8SWhSyG0ci2EIF1DzkxvfFzK1ua02O+fqrIwgDhk4q4DrDw1NPMvvy7FozJzoR/UphHoNhnRUD9ugqaCyumw0rLG+Q0MQBMQsLqJ5Hb15sefIp8OIYPvWFifP/ilN5zZW9Kn7mE5Pz7I8OjnXk3TVy5+u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS1Hj8hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS1Hj8hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BDFC4CECE;
	Thu, 12 Dec 2024 16:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021724;
	bh=y3W63cNpyYYPPacEylSM2pC7zGXA9YSd6kRK/oNZz9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS1Hj8hk0pHNW2ugDhAT7PDAwV8Tjwwux8WjTjIyHeif77yM3KespOEZi5i5vDwFw
	 /htxjKaSzN0dTGSU5b7bi8QXyc1OKTmcah44PhkkcFYbzKKhDzRFrx624e4gUsBl+g
	 i7CbOD5bV+1ODMsIVt3ZqnKUQ2wYsZYtGEKC/V/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 044/565] mptcp: cope racing subflow creation in mptcp_rcv_space_adjust
Date: Thu, 12 Dec 2024 15:53:59 +0100
Message-ID: <20241212144313.216736139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit ce7356ae35943cc6494cc692e62d51a734062b7d upstream.

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
[ Conflicts in protocol.c, because commit f410cbea9f3d ("tcp: annotate
  data-races around tp->window_clamp") has not been backported to this
  version. The conflict is easy to resolve, because only the context is
  different, but not the line to modify. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1986,7 +1986,8 @@ static void mptcp_rcv_space_adjust(struc
 				slow = lock_sock_fast(ssk);
 				WRITE_ONCE(ssk->sk_rcvbuf, rcvbuf);
 				tcp_sk(ssk)->window_clamp = window_clamp;
-				tcp_cleanup_rbuf(ssk, 1);
+				if (tcp_can_send_ack(ssk))
+					tcp_cleanup_rbuf(ssk, 1);
 				unlock_sock_fast(ssk, slow);
 			}
 		}


