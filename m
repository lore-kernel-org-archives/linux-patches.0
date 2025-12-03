Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3EC313538;
	Wed,  3 Dec 2025 16:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778593; cv=none; b=Q/x6s53cf+esbNtAYLHyaUe1b/8sxGEhrUwe8h3KLqr3MfOJ/tibQC+C6GueSAXy5Zr8uH9yeI7IitbcfTg60mfhvmjRR8712mHmYp64xedwrxx2HNu5G1wFU6oY6Y9bwpVnosCKc5S8pVwoTz9OVz1OKjOwWse1Gzu/Ir+M5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778593; c=relaxed/simple;
	bh=CVttcWoj34YdqI5FCe4AIp/PMmhJzMVzBmm7z2yQ9/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9yjmHw8yXzgC438sY29XOb1IazH8nk9IWkfffNSUvgRwFqXh/kUoOVudHH44FfzCXNJ4z1VbI2Pw7DCm64bk3MdtWPz0u8aZlrxFdmCqXVoJBdo2anEvs3krHLQpB9sZwMjK3GzYbs9oxteWIGNhpQ8qVGAPn96a4wLIAkU/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oG6D6K4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oG6D6K4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D27C4CEF5;
	Wed,  3 Dec 2025 16:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778592;
	bh=CVttcWoj34YdqI5FCe4AIp/PMmhJzMVzBmm7z2yQ9/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oG6D6K4xzckwQlmzFeg1PwnsTMUQz58GqpPGP2EL75ZR5yPnO1zMqOTKNcZ5SoZ/a
	 mi8KbCmw4NSCXTjpjq4wZXqN9KVRagSnn5tycZNApNm7yOSGVLvTRRAuzQxt0OEsSq
	 9GtiFD8lUhOrxqzXeKT/xRQhBajI0/+cuaJATU/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 381/392] mptcp: avoid unneeded subflow-level drops
Date: Wed,  3 Dec 2025 16:28:51 +0100
Message-ID: <20251203152428.211012091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Conflicts in options.c, because the new rwin_update() helper has been
  added after __mptcp_snd_una_update() which is not in this version --
  see commit -- and then causing conflicts in the context. There were
  also some conflicts in mptcp_set_rwin(), because commit f3589be0c420
  ("mptcp: never shrink offered window") is not in this version. Only
  the update of subflow->rcv_wnd_sent has been added. Also
  msk->rcv_wnd_sent is a u64 before this commit: in rwin_update(),
  READ_ONCE() is used instead of atomic64_read(&). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   32 ++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h |    1 +
 2 files changed, 31 insertions(+), 2 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1001,6 +1001,31 @@ u64 __mptcp_expand_seq(u64 old_seq, u64
 	return cur_seq;
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
+	mptcp_rcv_wnd = READ_ONCE(msk->rcv_wnd_sent);
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
@@ -1160,6 +1185,7 @@ bool mptcp_incoming_options(struct sock
 	 */
 	if (mp_opt.use_ack)
 		ack_update_msk(msk, sk, &mp_opt);
+	rwin_update(msk, sk, skb);
 
 	/* Zero-data-length packets are dropped by the caller and not
 	 * propagated to the MPTCP layer, so the skb extension does not
@@ -1212,7 +1238,7 @@ bool mptcp_incoming_options(struct sock
 static void mptcp_set_rwin(const struct tcp_sock *tp)
 {
 	const struct sock *ssk = (const struct sock *)tp;
-	const struct mptcp_subflow_context *subflow;
+	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk;
 	u64 ack_seq;
 
@@ -1221,8 +1247,10 @@ static void mptcp_set_rwin(const struct
 
 	ack_seq = READ_ONCE(msk->ack_seq) + tp->rcv_wnd;
 
-	if (after64(ack_seq, READ_ONCE(msk->rcv_wnd_sent)))
+	if (after64(ack_seq, READ_ONCE(msk->rcv_wnd_sent))) {
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
+		subflow->rcv_wnd_sent = ack_seq;
+	}
 }
 
 static void mptcp_track_rwin(const struct tcp_sock *tp)
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -417,6 +417,7 @@ struct mptcp_subflow_context {
 	u64	remote_key;
 	u64	idsn;
 	u64	map_seq;
+	u64	rcv_wnd_sent;
 	u32	snd_isn;
 	u32	token;
 	u32	rel_write_seq;


