Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2522E47F774;
	Thu, 20 Aug 2026 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247339; cv=none; b=JEf7QeO2+I1vbi0V+qtLX3x19cRlr0nvuMSrhYmRYjycm2Ca6PE9qlhAUg+9ROomAJAhb/SMLZPwl9+KFqx/Vz0b1sp+KiqGROojUl9wu9MR2q4KIVeM7qpjVENJcUe21aFUU406MBvGTDxsYhPMIodiqL5gV8oZmWJFqslBvFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247339; c=relaxed/simple;
	bh=cqHJ52dF6A26oRzTzEIEZzSa7P1esmE8KW6pXFGKyRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOnAMZPUzcAaeMSqQJXTMQtetrGVF0phC+grbik3S9yIISZq+cMtfBVM8rcpTxkgJ71SKaPwFWw1WktQVsGclFBliAn693wuEPjDD1LMv4aCrzAisbl+eMsndfgcYAr7XQjZNzhF/j63fdTN3yDmeDPi4O03l06/IZ1xTkBV/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWpsW9x6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWpsW9x6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883E71F000E9;
	Thu, 20 Aug 2026 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247338;
	bh=GyMAIfubz+FjkHn9P3IPbxCK63wHHLf9nNU8MEIXfEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWpsW9x6ByPK8xwnnJ2uU+N1wG7obAQutnBfTflRYSE7Mfwpa0Yxsm0MpA02ZXUSc
	 EHpJbJrxitnXu8LFCk/+2ZdGDafoipDh0ZAagCEgxzp8QG545Ogj9kqm9V+x1t4Kp3
	 Nm+O08HcsfglDV3C4RxZLZLBh3JKBNpEDqCFrWvU=
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
Subject: [PATCH 6.6 012/166] mptcp: fastopen: only mark MPTFO subflows with SYN data
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145211.559034540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


