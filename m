Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0924A9A4;
	Mon,  8 Jan 2024 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3D+rc1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7297AC433C8;
	Mon,  8 Jan 2024 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726622;
	bh=in+UkFAiCiPz2VkhJerZkNsvMOgEmbWgRwu3s3Th1OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3D+rc1mCpTj//wWAzUAkzr+802EEp8c14BhoDjLpG3vyF4RYwe+rudjobGUQ3V09
	 CW1p4Ye7TMAS0Y9ufZ0Hb/rIyldcCznYCFK+CGCjwoL1adZ++D2J+sr0VEMK1rzIlT
	 SOYYzhi0mlwjgEdDWGGjr0ZzyyyVrgbayg+soOyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5a01c3a666e726bc8752@syzkaller.appspotmail.com,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 009/124] mptcp: prevent tcp diag from closing listener subflows
Date: Mon,  8 Jan 2024 16:07:15 +0100
Message-ID: <20240108150603.397513950@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 4c0288299fd09ee7c6fbe2f57421f314d8c981db upstream.

The MPTCP protocol does not expect that any other entity could change
the first subflow status when such socket is listening.
Unfortunately the TCP diag interface allows aborting any TCP socket,
including MPTCP listeners subflows. As reported by syzbot, that trigger
a WARN() and could lead to later bigger trouble.

The MPTCP protocol needs to do some MPTCP-level cleanup actions to
properly shutdown the listener. To keep the fix simple, prevent
entirely the diag interface from stopping such listeners.

We could refine the diag callback in a later, larger patch targeting
net-next.

Fixes: 57fc0f1ceaa4 ("mptcp: ensure listener is unhashed before updating the sk status")
Cc: stable@vger.kernel.org
Reported-by: <syzbot+5a01c3a666e726bc8752@syzkaller.appspotmail.com>
Closes: https://lore.kernel.org/netdev/0000000000004f4579060c68431b@google.com/
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20231226-upstream-net-20231226-mptcp-prevent-warn-v1-2-1404dcc431ea@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1974,6 +1974,17 @@ static void tcp_release_cb_override(stru
 	tcp_release_cb(ssk);
 }
 
+static int tcp_abort_override(struct sock *ssk, int err)
+{
+	/* closing a listener subflow requires a great deal of care.
+	 * keep it simple and just prevent such operation
+	 */
+	if (inet_sk_state_load(ssk) == TCP_LISTEN)
+		return -EINVAL;
+
+	return tcp_abort(ssk, err);
+}
+
 static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 	.name		= "mptcp",
 	.owner		= THIS_MODULE,
@@ -2018,6 +2029,7 @@ void __init mptcp_subflow_init(void)
 
 	tcp_prot_override = tcp_prot;
 	tcp_prot_override.release_cb = tcp_release_cb_override;
+	tcp_prot_override.diag_destroy = tcp_abort_override;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	/* In struct mptcp_subflow_request_sock, we assume the TCP request sock
@@ -2054,6 +2066,7 @@ void __init mptcp_subflow_init(void)
 
 	tcpv6_prot_override = tcpv6_prot;
 	tcpv6_prot_override.release_cb = tcp_release_cb_override;
+	tcpv6_prot_override.diag_destroy = tcp_abort_override;
 #endif
 
 	mptcp_diag_subflow_init(&subflow_ulp_ops);


