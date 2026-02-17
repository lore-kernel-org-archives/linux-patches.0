Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F8D266581;
	Tue, 17 Feb 2026 20:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361237; cv=none; b=Cm50pk+SzRoM2FutTCT9h/vPfnP56yZt/BBdI5wfvowp7GEaMdN6yemMjlnLRgC9PVxkZb7BfiXJUQKtiQnPq121Ghq/aokPHqaux+5crEtxO9tiUy8MnNE+EI/hkq2TKWUtzTMTC54XODkjrNDJcTE3nXd8gnUXDG4+yS/RR7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361237; c=relaxed/simple;
	bh=ZhcE3WBzT6oOl+Yzl9dqfY62cZ/J8zKoZF4nsaTWfZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0+XD/lQs8IjM1gB1eK3QWbQwUJS7+O7rKtk+rvu+jgIUdxwVyFzApTpCesiitXS28N6PtL06XM/EcWwLEkBUr0sZh4GUdJFY8BNDlCmMMRfOonzGRPBD1cgswaE+etLYh8WD37VDx+XS/8+Jb0Nflvbm8Rh/KG/Q1itMZGN2Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdYWGzA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdYWGzA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A90C4CEF7;
	Tue, 17 Feb 2026 20:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361237;
	bh=ZhcE3WBzT6oOl+Yzl9dqfY62cZ/J8zKoZF4nsaTWfZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdYWGzA3cNpuzxmHt7RHfxFBAAl7zxpUc0uU5XmMKb9QapPnb+VPi5jw9gqXVDxfj
	 skFAgdyoJBNJtOK5jPBmXSBLTb+mkkV3DMgyr+GsqK7fZdRImApsQqdGUoAB4RCrbc
	 fjxK6MPKrAK8MplfEth/rrr1n6FI+gfuRU59hMt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 42/64] mptcp: schedule rtx timer only after pushing data
Date: Tue, 17 Feb 2026 21:31:38 +0100
Message-ID: <20260217200009.081605431@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 2ea6190f42d0416a4310e60a7fcb0b49fcbbd4fb upstream.

The MPTCP protocol usually schedule the retransmission timer only
when there is some chances for such retransmissions to happen.

With a notable exception: __mptcp_push_pending() currently schedule
such timer unconditionally, potentially leading to unnecessary rtx
timer expiration.

The issue is present since the blamed commit below but become easily
reproducible after commit 27b0e701d387 ("mptcp: drop bogus optimization
in __mptcp_check_push()")

Fixes: 33d41c9cd74c ("mptcp: more accurate timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251205-net-mptcp-misc-fixes-6-19-rc1-v1-3-9e4781a6c1b8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in protocol.c, because commit 0fa1b3783a17 ("mptcp: use
  get_send wrapper") is not in this version, and is changing the
  context. The same modification can still be applied. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1666,7 +1666,7 @@ void __mptcp_push_pending(struct sock *s
 	struct mptcp_sendmsg_info info = {
 				.flags = flags,
 	};
-	bool do_check_data_fin = false;
+	bool copied = false;
 	struct mptcp_data_frag *dfrag;
 	int len;
 
@@ -1703,7 +1703,7 @@ void __mptcp_push_pending(struct sock *s
 				goto out;
 			}
 
-			do_check_data_fin = true;
+			copied = true;
 			info.sent += ret;
 			len -= ret;
 
@@ -1717,11 +1717,14 @@ void __mptcp_push_pending(struct sock *s
 		mptcp_push_release(ssk, &info);
 
 out:
-	/* ensure the rtx timer is running */
-	if (!mptcp_rtx_timer_pending(sk))
-		mptcp_reset_rtx_timer(sk);
-	if (do_check_data_fin)
+	/* Avoid scheduling the rtx timer if no data has been pushed; the timer
+	 * will be updated on positive acks by __mptcp_cleanup_una().
+	 */
+	if (copied) {
+		if (!mptcp_rtx_timer_pending(sk))
+			mptcp_reset_rtx_timer(sk);
 		mptcp_check_send_data_fin(sk);
+	}
 }
 
 static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk, bool first)


