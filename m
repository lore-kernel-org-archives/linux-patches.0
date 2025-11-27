Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A822882C9;
	Thu, 27 Nov 2025 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255197; cv=none; b=TFSQ9VLGzfYTg85VL6trTtJkeUMGbOJNYxqt7sugdadJInKZ0HFNq4dfZijYzamPnlL7nbdcWHfBBUsPESkQ3bjiX1+jmvpgFwLCnrLmTq7D3poYmtkqA8Qw4pdh/GgXzzSqY/GGuL11M7Vp08zgDdbiBmo2PVcqIrer+eAXcyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255197; c=relaxed/simple;
	bh=XK35D9czRVtpf+zyZVLrki3fY8/7L4D3wJGxxub3dBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9M5Xub88h4N56rY9tEv7jRqZqIHfj+NrXSiInme/LEIZp+Q+nDql22eP9+iOhn8mxFoqa8flpqdLfWm0ZKuTemATF8wXQ6+m8yMGpP3RE+8z8wOlCqJ10NihDa1g9CHHApcb/4M01l4g3ag4b1xhPhQN5W+GjZ9QzrgYvYdkjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewg2ZYDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewg2ZYDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D03EC4CEF8;
	Thu, 27 Nov 2025 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255197;
	bh=XK35D9czRVtpf+zyZVLrki3fY8/7L4D3wJGxxub3dBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewg2ZYDd5aEh5qnkSLS+cNpj+ygxfL2E43PsHksuRKDX8oc4YK6Dwkwcx6sjBNH4r
	 j8VnKj4daH3toHl8sz4HJgdPIfRqIdYk0LO5ygNM0BCg65DLURoLGAPTbGe1s872lS
	 s7MXiZde5y6wXYF/MV9lOPuUm6LMGR+f4O748MgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 042/112] mptcp: avoid unneeded subflow-level drops
Date: Thu, 27 Nov 2025 15:45:44 +0100
Message-ID: <20251127144034.380486055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

commit 4f102d747cadd8f595f2b25882eed9bec1675fb1 upstream.

The rcv window is shared among all the subflows. Currently, MPTCP sync
the TCP-level rcv window with the MPTCP one at tcp_transmit_skb() time.

The above means that incoming data may sporadically observe outdated
TCP-level rcv window and being wrongly dropped by TCP.

Address the issue checking for the edge condition before queuing the
data at TCP level, and eventually syncing the rcv window as needed.

Note that the issue is actually present from the very first MPTCP
implementation, but backports older than the blamed commit below will
range from impossible to useless.

Before:

  $ nstat -n; sleep 1; nstat -z TcpExtBeyondWindow
  TcpExtBeyondWindow              14                 0.0

After:

  $ nstat -n; sleep 1; nstat -z TcpExtBeyondWindow
  TcpExtBeyondWindow              0                  0.0

Fixes: fa3fe2b15031 ("mptcp: track window announced to peer")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-2-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   31 +++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |    1 +
 2 files changed, 32 insertions(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1044,6 +1044,31 @@ static void __mptcp_snd_una_update(struc
 	WRITE_ONCE(msk->snd_una, new_snd_una);
 }
 
+static void rwin_update(struct mptcp_sock *msk, struct sock *ssk,
+			struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct tcp_sock *tp = tcp_sk(ssk);
+	u64 mptcp_rcv_wnd;
+
+	/* Avoid touching extra cachelines if TCP is going to accept this
+	 * skb without filling the TCP-level window even with a possibly
+	 * outdated mptcp-level rwin.
+	 */
+	if (!skb->len || skb->len < tcp_receive_window(tp))
+		return;
+
+	mptcp_rcv_wnd = atomic64_read(&msk->rcv_wnd_sent);
+	if (!after64(mptcp_rcv_wnd, subflow->rcv_wnd_sent))
+		return;
+
+	/* Some other subflow grew the mptcp-level rwin since rcv_wup,
+	 * resync.
+	 */
+	tp->rcv_wnd += mptcp_rcv_wnd - subflow->rcv_wnd_sent;
+	subflow->rcv_wnd_sent = mptcp_rcv_wnd;
+}
+
 static void ack_update_msk(struct mptcp_sock *msk,
 			   struct sock *ssk,
 			   struct mptcp_options_received *mp_opt)
@@ -1211,6 +1236,7 @@ bool mptcp_incoming_options(struct sock
 	 */
 	if (mp_opt.use_ack)
 		ack_update_msk(msk, sk, &mp_opt);
+	rwin_update(msk, sk, skb);
 
 	/* Zero-data-length packets are dropped by the caller and not
 	 * propagated to the MPTCP layer, so the skb extension does not
@@ -1297,6 +1323,10 @@ static void mptcp_set_rwin(struct tcp_so
 
 	if (rcv_wnd_new != rcv_wnd_old) {
 raise_win:
+		/* The msk-level rcv wnd is after the tcp level one,
+		 * sync the latter.
+		 */
+		rcv_wnd_new = rcv_wnd_old;
 		win = rcv_wnd_old - ack_seq;
 		tp->rcv_wnd = min_t(u64, win, U32_MAX);
 		new_win = tp->rcv_wnd;
@@ -1320,6 +1350,7 @@ raise_win:
 
 update_wspace:
 	WRITE_ONCE(msk->old_wspace, tp->rcv_wnd);
+	subflow->rcv_wnd_sent = rcv_wnd_new;
 }
 
 static void mptcp_track_rwin(struct tcp_sock *tp)
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -508,6 +508,7 @@ struct mptcp_subflow_context {
 	u64	remote_key;
 	u64	idsn;
 	u64	map_seq;
+	u64	rcv_wnd_sent;
 	u32	snd_isn;
 	u32	token;
 	u32	rel_write_seq;


