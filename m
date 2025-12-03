Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CC035C1BC;
	Wed,  3 Dec 2025 16:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780179; cv=none; b=FB8erVkuuES4ttrthwvScSWBvSX5B/AQ8yyrV4B0forL7njel4+Q23nwRZLF0GySXwZyXfogu3V4HLkP0u+ll+2cTBa6cwZgBLhBiSi4Oesb0OnNJ2eT6mT6Gh+3ZkpPGSWb+xupiBpvy7WogdKigsULqsZ0o6/8PoU/U+5k+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780179; c=relaxed/simple;
	bh=InTJWyOxvEIUD7sTtWOxoPojfdOUI7A8sBWOqriOAAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=no6/bQS5THLj0cErfw+utHwwIAGHmUHJe1C+dSGxaTv+QZ3flaz2tFKiFF6831sPvUL0zM0A+rCjm1ciQImJgD43p7oDbudjhewqx7eHE7p1Q8aeDFAmjpyKpISvlXCGC8j0hBCc2cr/mQ59avDPsev4oq2j+Q7gRvHPk39H8O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZ0fKdjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZ0fKdjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AC9C4CEF5;
	Wed,  3 Dec 2025 16:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780178;
	bh=InTJWyOxvEIUD7sTtWOxoPojfdOUI7A8sBWOqriOAAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZ0fKdjYWbcr+/Zu1NjXP129OegB7GJx320sJ84jZJn7f6DsyL34h5O1liKYHp8Vl
	 8o5ZWR4x+N4g1YFH+om8TpwdasIYSoGC1iGBmi1bPIBC0XFIaBThbD6riQLKrqKrEa
	 FNPr6YcZMhYQ1Sb+rmHj9R5rwAhES7Wo9FE+ExxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 479/568] mptcp: decouple mptcp fastclose from tcp close
Date: Wed,  3 Dec 2025 16:28:01 +0100
Message-ID: <20251203152458.241003265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

[ Upstream commit fff0c87996672816a84c3386797a5e69751c5888 ]

With the current fastclose implementation, the mptcp_do_fastclose()
helper is in charge of two distinct actions: send the fastclose reset
and cleanup the subflows.

Formally decouple the two steps, ensuring that mptcp explicitly closes
all the subflows after the mentioned helper.

This will make the upcoming fix simpler, and allows dropping the 2nd
argument from mptcp_destroy_common(). The Fixes tag is then the same as
in the next commit to help with the backports.

Fixes: d21f83485518 ("mptcp: use fastclose on more edge scenarios")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251118-net-mptcp-misc-fixes-6-18-rc6-v1-5-806d3781c95f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   13 +++++++++----
 net/mptcp/protocol.h |    2 +-
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2826,8 +2826,12 @@ static void mptcp_worker(struct work_str
 		__mptcp_close_subflow(sk);
 
 	if (mptcp_close_tout_expired(sk)) {
+		struct mptcp_subflow_context *subflow, *tmp;
+
 		inet_sk_state_store(sk, TCP_CLOSE);
 		mptcp_do_fastclose(sk);
+		mptcp_for_each_subflow_safe(msk, subflow, tmp)
+			__mptcp_close_ssk(sk, subflow->tcp_sock, subflow, 0);
 		mptcp_close_wake_up(sk);
 	}
 
@@ -3233,7 +3237,8 @@ static int mptcp_disconnect(struct sock
 	/* msk->subflow is still intact, the following will not free the first
 	 * subflow
 	 */
-	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
+	mptcp_do_fastclose(sk);
+	mptcp_destroy_common(msk);
 	msk->last_snd = NULL;
 
 	/* The first subflow is already in TCP_CLOSE status, the following
@@ -3456,7 +3461,7 @@ out:
 	return newsk;
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
+void mptcp_destroy_common(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
@@ -3465,7 +3470,7 @@ void mptcp_destroy_common(struct mptcp_s
 
 	/* join list will be eventually flushed (with rst) at sock lock release time */
 	mptcp_for_each_subflow_safe(msk, subflow, tmp)
-		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, flags);
+		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, 0);
 
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
 	mptcp_data_lock(sk);
@@ -3492,7 +3497,7 @@ static void mptcp_destroy(struct sock *s
 
 	/* allow the following to close even the initial subflow */
 	msk->free_first = 1;
-	mptcp_destroy_common(msk, 0);
+	mptcp_destroy_common(msk);
 	sk_sockets_allocated_dec(sk);
 }
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -762,7 +762,7 @@ static inline void mptcp_write_space(str
 	}
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags);
+void mptcp_destroy_common(struct mptcp_sock *msk);
 
 #define MPTCP_TOKEN_MAX_RETRIES	4
 


