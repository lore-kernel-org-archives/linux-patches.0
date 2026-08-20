Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1B337C90B;
	Thu, 20 Aug 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238040; cv=none; b=XNfjM133KHSN2OiBHL3q5xR6kb+tKbaPKk2hW++cD0ZOjuFjudWMsUfS4z8HuI0NUgng2BMuhArkg2QckhfSGiNy/RY7p9sAOfidG/QV8lpqhqWzPzITib3T4+3KB/P9sWVzK+jzfeQmGgDuvXvSQZ5tAwAjsuaWrwpdOKDIzyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238040; c=relaxed/simple;
	bh=P3PNu2CfyNDnxPT++O2WkPwuiFkHfyfMN5DeglcjtVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4yMNKssvWiymumQvPHJjzTl4YFkJN0PTPn+zdMOs4CgF1vJAiYvN0lTkRqnUREc6mzRzeZUiO1OTGqiLrPJsNKqbkfuBEuq8UiuyAQP1bVdpWtIqjD+QuYt/+QPvhps1Qhfqxztoe/8lBbTDdnmfKAS+n0XXl7E9rJ6S4/+YYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP+T4qm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP+T4qm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689F11F000E9;
	Thu, 20 Aug 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238037;
	bh=jqWKr7UpsxI/w/xzFQbNOajwZRtaP1Hfd/AoRbUy880=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AP+T4qm0extwY2X08EBQjJ0HUr6erU8v9cj3/Yfq1kbBvC+vjKgBWOq9rgyUOCRX9
	 TNERd3PRqFpK3YlLvt32WfHqgy7yAxCHvABHM1phf6wGo1+Yock6Azc6vK3TBOcpVo
	 M1QUTmZDReiyr1eQoRRrasybMbeNPbiKI5hCdnas=
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
Subject: [PATCH 7.1 012/228] mptcp: fastopen: only mark MPTFO subflows with SYN data
Date: Thu, 20 Aug 2026 16:52:34 +0200
Message-ID: <20260820145244.837486118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


