Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807FA1AB6F8;
	Wed, 20 Nov 2024 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107688; cv=none; b=BzryrhSJGyhxIUakn3jQWRwpjykEiaE/1BnuAa7EBdEWdfrSa03/GQneom4ivGAsHmhxxQ3YMUFfXuJhsIciKBBP8seRgxuWtDcoJHn57wJlKHegJMbm3ZsAWpRL2IjEf6ohlmDZ3t8hH3JMQMCxyh9KuSHpzfipy6uuWI6fDo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107688; c=relaxed/simple;
	bh=sUvunWP6Vin6EGayulokAoYe8deZVZiW+yGffbZBCIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNfvSkhS/HGLDKSwCrCBBmYBPeaBDzNXp8LIVfPMmEr9H/GQSScZV+BA0FyHJNU0xRzrpuvEK447SOkW4sZQuRGOnO6GwFw4cxtDVe4CRVlb2IZmCZOwqfaqV1GmB2H3W7vU24HWwo7oa3XoLal04s8uq19Vlqee1lcXo6X1xwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srxrMgTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srxrMgTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB59C4CECD;
	Wed, 20 Nov 2024 13:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107688;
	bh=sUvunWP6Vin6EGayulokAoYe8deZVZiW+yGffbZBCIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srxrMgTxxZY2us9EV4mSQexTbIOwtECmGfK5X7uQrSzgrEv8Ty2EfJGrHY0t7uFok
	 1Rb5BsNUW8RXiIEfpivRZRAq+88rZjEN3FQv6vBgHNyV8fh24MeQxQUPXbkSVYfY8x
	 bnQs0QilwgJfYeoVMOz6TK+iWHzebk5mOORIvbQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 46/73] mptcp: cope racing subflow creation in mptcp_rcv_space_adjust
Date: Wed, 20 Nov 2024 13:58:32 +0100
Message-ID: <20241120125810.715725345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2057,7 +2057,8 @@ static void mptcp_rcv_space_adjust(struc
 				slow = lock_sock_fast(ssk);
 				WRITE_ONCE(ssk->sk_rcvbuf, rcvbuf);
 				tcp_sk(ssk)->window_clamp = window_clamp;
-				tcp_cleanup_rbuf(ssk, 1);
+				if (tcp_can_send_ack(ssk))
+					tcp_cleanup_rbuf(ssk, 1);
 				unlock_sock_fast(ssk, slow);
 			}
 		}


