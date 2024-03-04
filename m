Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C187D1F92C;
	Mon,  4 Mar 2024 21:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588444; cv=none; b=HMd5x5sgOkF9y2eDTc7UVP1SDdYMrMv/9HU5edKZzYO2NCOGCRaGcrDeVnRrSRh1+iIhMXPeO7ZD8AsJCh8DzyomgwRrlG6Lk7l+Wf+2b4tokMi/qNIQ6V74zApq56sD6Mvn/yY9Ja52Y5LdiL6BsA2yFtha9hYr/DhwO8gBpQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588444; c=relaxed/simple;
	bh=xPdeTWpzQMAsUS0WWDtbLDBihfOce55kjtyZGn09Iyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J14ApSWS8v4LRRTZ/rqp1E4yNNgIOcBjmQEaffScYSPmOp0iqLs43kOnH+/XQUSuWqpUpYlN7rDCipVkh9q00niUBLlEylhkLhj8GaowW8yX40c9oCD28MzraAt+jRF6bnAv0DnjultyqPqTqwj4PfMV6x7EnTqnZInQTwenNI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taW/yT9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taW/yT9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFF2C433F1;
	Mon,  4 Mar 2024 21:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588444;
	bh=xPdeTWpzQMAsUS0WWDtbLDBihfOce55kjtyZGn09Iyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taW/yT9q0gS5WFTpgOIDVt8RFn1odBQAG9F7HVwhaCGRbBacolvX/tEOg3BJZEp8W
	 sGVZ6t/9CaC+vU0WxCxUDIBW+qHFAribZFPW1byoXF6jrG8kf65C8Gbm1S269GMcAG
	 QwqJfWPDWgMqXPpERKV8TSZtt5mJnDz1pwDHvnV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 110/143] mptcp: fix snd_wnd initialization for passive socket
Date: Mon,  4 Mar 2024 21:23:50 +0000
Message-ID: <20240304211553.442523762@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

commit adf1bb78dab55e36d4d557aa2fb446ebcfe9e5ce upstream.

Such value should be inherited from the first subflow, but
passive sockets always used 'rsk_rcv_wnd'.

Fixes: 6f8a612a33e4 ("mptcp: keep track of advertised windows right edge")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-5-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3220,7 +3220,7 @@ struct sock *mptcp_sk_clone_init(const s
 	msk->write_seq = subflow_req->idsn + 1;
 	msk->snd_nxt = msk->write_seq;
 	msk->snd_una = msk->write_seq;
-	msk->wnd_end = msk->snd_nxt + req->rsk_rcv_wnd;
+	msk->wnd_end = msk->snd_nxt + tcp_sk(ssk)->snd_wnd;
 	msk->setsockopt_seq = mptcp_sk(sk)->setsockopt_seq;
 	mptcp_init_sched(msk, mptcp_sk(sk)->sched);
 


