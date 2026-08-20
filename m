Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CDB3822B5;
	Thu, 20 Aug 2026 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239361; cv=none; b=Kpe8D3q5LP0qP5wdxBKIaU/hdmjGT9XUuQg+ByL51vyFXt1VGVoqQS421yemD7aIebSmBzRbvmVQtN3eNsBspx7068RQdVJmXKs0EW1sRJkFcDKVuYt5niYM/j1acFtFL9rfbzIJ9dCG/ciy874nxmrYegncl5abvkHrHh1OtJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239361; c=relaxed/simple;
	bh=tFTj2zWnEG0xm8OCReGOlCNggYenUrdoT7hE1r7dynI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy3GkU7p3ilQNbGE8eWgXafZ3QS4bVZZmW0lwUuLviTC54EP3ITf5aJkH8MXaazEpzzHgbvPKjQx+SLo5ef9ZTkYyw1Eb7Mmbbt9kneT2ocZN8ZW/406Q9J43UkhF8xs+aqFT9WeuTnAO8bbR1qVmAjmDiWmhB4h0xBRwkO/pGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB0n5DqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB0n5DqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621741F000E9;
	Thu, 20 Aug 2026 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239359;
	bh=AjObkJcmfQFMbQN3sI5HTWckKFdER2IfAsaVjGbIPAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TB0n5DqEUNVKcpvVfn2O5gXBe0FaCPykPnp/MZzvDjyOU3pW6p7N0lf6sDK7oQbTw
	 SZPyeRUL0Q3lIVZSfG2SYFbfldo7ydjwQCBUmILIFSUDciUTNbbKGEiF6NcRconcEz
	 6W8x6s79IsP/aQPL7bqhXeYi1hi2Al7IMwwIJ3zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 023/220] mptcp: fastopen: only mark MPTFO subflows with SYN data
Date: Thu, 20 Aug 2026 16:53:33 +0200
Message-ID: <20260820145224.204882053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

commit e00b63056fb4f261455b3e5df5268a1f8ce47a87 upstream.

Passive TCP Fast Open accepts a valid-cookie SYN even when it carries
no data. In that case the child socket's receive queue is intentionally
left empty.

mptcp_fastopen_subflow_synack_set_params() set is_mptfo before checking
for queued SYN data. That made data-less TFO SYNs hit a WARN and, if
the warning was non-fatal, left stale MPTFO state behind. The stale
flag could later trigger a state-confusion bug in
check_fully_established().

Only mark the subflow as MPTFO after confirming that an SKB was queued.
Return quietly when the receive queue is empty.

Note that mptcp_subflow_context's is_mptfo field is now not just about
subflows where the TFO was present, but about MPTFO subflow that
consumed SYN data. Only having a valid cookie but not carrying data is
not really "doing TFO".

Fixes: 36b122baf6a8 ("mptcp: add subflow_v(4,6)_send_synack()")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-7-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/fastopen.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/mptcp/fastopen.c
+++ b/net/mptcp/fastopen.c
@@ -24,12 +24,13 @@ void mptcp_fastopen_subflow_synack_set_p
 	sk = subflow->conn;
 	tp = tcp_sk(ssk);
 
-	subflow->is_mptfo = 1;
-
+	/* A valid TFO cookie does not guarantee SYN data. */
 	skb = skb_peek(&ssk->sk_receive_queue);
-	if (WARN_ON_ONCE(!skb))
+	if (!skb)
 		return;
 
+	subflow->is_mptfo = 1;
+
 	/* dequeue the skb from sk receive queue */
 	__skb_unlink(skb, &ssk->sk_receive_queue);
 	skb_ext_reset(skb);


