Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9AD43E490;
	Tue, 16 Jun 2026 16:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625734; cv=none; b=RgOmLbYI5BLWhTOe/ozvJLXgRGsXx8v6BE80yrf5j4LH2MADtSEZx5w5kPIFSR5/JcNszKpANy++Ou68EU9tgFYHUW+jzk9vCBGkEK90XzE6cVjpkQrf7h5CYSquY82bqGK4Pxf5e6kK8/nQgRzAGhFEBItfAmv6YC+DMDKuuuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625734; c=relaxed/simple;
	bh=QgFme6i8evAFcuxCKi78Lud8ZwdECQgfosDRj7rZM1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eftLAcTVV1MEsNE9Ba2tgB7VfEobZpTIMp1sihf4QDweGAqmMcn0AZ8We9CCPk/9QUrJ/ZvnQ6RW3iQnrfwecZLtfGjd0h+fS4bB1A5z7FJlbNQ9SHGNwg5nnj5x+4gp+a0oO+pcYgNSXo99/WUeX3OmE2AMzKpOPbL8dNRhMGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c64MPKNQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c64MPKNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ACD1F000E9;
	Tue, 16 Jun 2026 16:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625733;
	bh=cpAbALUdfZApUvNFxVy+qlsSdeAt2+/4m+wrtZP8Hmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c64MPKNQ6ZIRgFAHTzU2+HIQxMK9YuEmwPzG9DN151TW9SYfFl5D9F+H21d4klebs
	 6vPi4bXx62ZzGV5mL6q43lk6MQnmD4B39NdfiEpGQW8hhDYZgHIcc8rCWc+y095FHl
	 7jeq4lwibKaMUfUJ0aS4VXpLF7Avj/JLCdd9XnuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 197/325] mptcp: allow subflow rcv wnd to shrink
Date: Tue, 16 Jun 2026 20:29:53 +0530
Message-ID: <20260616145107.797542691@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit da23be77e1292cd611e736c3aa17da633d7ddce7 upstream.

In MPTCP connection, the `window` field in the TCP header refers to the
MPTCP-level rcv_nxt and it's right edge should not move backward. Such
constraint is enforced at DSS option generation time.

At the same time, the TCP stack ensures independently that the TCP-level
rcv wnd right's edge does not move backward. That in turn causes artificial
inflating of the MPTCP rcv window when the incoming data is acked at the
TCP level and is OoO in the MPTCP sequence space (or lands in the backlog).

As a consequence, the incoming traffic can exceed the receiver rcvbuf size
even when the sender is not misbehaving.

Prevent such scenario forcibly allowing the TCP subflow to shrink the
TCP-level rcv wnd regardless of the current netns setting.

Fixes: f3589be0c420 ("mptcp: never shrink offered window")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-4-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -566,6 +566,7 @@ static bool mptcp_established_options_ds
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int dss_size = 0;
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
@@ -614,6 +615,12 @@ static bool mptcp_established_options_ds
 	if (dss_size == 0)
 		ack_size += TCPOLEN_MPTCP_DSS_BASE;
 
+	/* The caller is __tcp_transmit_skb(), and will compute the new rcv
+	 * wnd soon: ensure that the window can shrink.
+	 */
+	if (skb)
+		tp->rcv_wnd = tp->rcv_nxt - tp->rcv_wup;
+
 	dss_size += ack_size;
 
 	*size = ALIGN(dss_size, 4);


