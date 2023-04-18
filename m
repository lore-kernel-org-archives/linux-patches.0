Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1753F2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D6BC433A0;
	Tue, 18 Apr 2023 12:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822375;
	bh=/NR45N3PgFH8h88ZHi78X5s9YnrV7RoS4zn/luFPmHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aa0p9CnYkFExU8qALzEOOM1PxGS07qMgP6noakYUSmsygeeB0iwv8jZiCfqjV6j7a
	 4U/JPm48WuQ6GYQ7+pU6JfZlG7CsX6gYrWp3of6GLm2sibgSkdE7OTzSfunQrlPl7h
	 sT8gwuQspoWL8R+L3hML8Dx6BpHasyWnOtC+52yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 126/139] mptcp: fix NULL pointer dereference on fastopen early fallback
Date: Tue, 18 Apr 2023 14:23:11 +0200
Message-Id: <20230418120318.587047985@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit c0ff6f6da66a7791a32c0234388b1bdc00244917 upstream.

In case of early fallback to TCP, subflow_syn_recv_sock() deletes
the subflow context before returning the newly allocated sock to
the caller.

The fastopen path does not cope with the above unconditionally
dereferencing the subflow context.

Fixes: 36b122baf6a8 ("mptcp: add subflow_v(4,6)_send_synack()")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/fastopen.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -9,11 +9,18 @@
 void mptcp_fastopen_subflow_synack_set_params(struct mptcp_subflow_context *subflow,
 					      struct request_sock *req)
 {
-	struct sock *ssk = subflow->tcp_sock;
-	struct sock *sk = subflow->conn;
+	struct sock *sk, *ssk;
 	struct sk_buff *skb;
 	struct tcp_sock *tp;
 
+	/* on early fallback the subflow context is deleted by
+	 * subflow_syn_recv_sock()
+	 */
+	if (!subflow)
+		return;
+
+	ssk = subflow->tcp_sock;
+	sk = subflow->conn;
 	tp = tcp_sk(ssk);
 
 	subflow->is_mptfo = 1;


