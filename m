Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3954527F010;
	Thu, 27 Nov 2025 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254920; cv=none; b=Vc8LuqMWALsoVtlArulbC3SYk6/osKtOU74TGHBIjdFm0HxKy+nj53wkrOIvXDFj1Qi1s7pZJJmQqKW+ZOgB6YQ1AVe1M/ZfF5rSTRHA6gvKu7nm5wrbsaXPojMni1iA5MJncP2aqCnXBVdmPiu9dwTHF/Lk8UnpRKsVfjytoe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254920; c=relaxed/simple;
	bh=t/9BI1piF5HscR+CRFRLGuB7zyUC39v9Pdpbzr/Ij20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCKVkX02TRX4vR4GR+sQUOOkOcCtaSxDsgttJQI/lV8cS0WN8NvVkokd1ZlnWwUO6kvhqDLiUJDNMGFLDEH6gQ0gtrTfzME/Y3R2r0SCRiFgddJrgmC89IdBnkmGNjnWDpopVzgUkXGPGtqjzxHv+ujApKNcP1hdhYEhceSxPMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqdDKknT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqdDKknT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA37DC4CEF8;
	Thu, 27 Nov 2025 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254920;
	bh=t/9BI1piF5HscR+CRFRLGuB7zyUC39v9Pdpbzr/Ij20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SqdDKknT+26w7evkSfgEAaUDjajLgIsDn2rSOVKPQ+TZdXmF3CHLRNcyP+fW4AxSk
	 xIvYhTUP1mEeHJ+N6gj8jDhjrpoPMzqtKKQQkIuSbyVa5OPinhXnKWZ/wY5y9ogdIz
	 cMfowD/L6ag81xdv1eZpZk2AORTU+M78WG3nKXXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 32/86] mptcp: decouple mptcp fastclose from tcp close
Date: Thu, 27 Nov 2025 15:45:48 +0100
Message-ID: <20251127144028.997443532@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit fff0c87996672816a84c3386797a5e69751c5888 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   13 +++++++++----
 net/mptcp/protocol.h |    2 +-
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2822,7 +2822,11 @@ static void mptcp_worker(struct work_str
 		__mptcp_close_subflow(sk);
 
 	if (mptcp_close_tout_expired(sk)) {
+		struct mptcp_subflow_context *subflow, *tmp;
+
 		mptcp_do_fastclose(sk);
+		mptcp_for_each_subflow_safe(msk, subflow, tmp)
+			__mptcp_close_ssk(sk, subflow->tcp_sock, subflow, 0);
 		mptcp_close_wake_up(sk);
 	}
 
@@ -3250,7 +3254,8 @@ static int mptcp_disconnect(struct sock
 	/* msk->subflow is still intact, the following will not free the first
 	 * subflow
 	 */
-	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
+	mptcp_do_fastclose(sk);
+	mptcp_destroy_common(msk);
 
 	/* The first subflow is already in TCP_CLOSE status, the following
 	 * can't overlap with a fallback anymore
@@ -3432,7 +3437,7 @@ void mptcp_rcv_space_init(struct mptcp_s
 		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
+void mptcp_destroy_common(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
@@ -3441,7 +3446,7 @@ void mptcp_destroy_common(struct mptcp_s
 
 	/* join list will be eventually flushed (with rst) at sock lock release time */
 	mptcp_for_each_subflow_safe(msk, subflow, tmp)
-		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, flags);
+		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, 0);
 
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
 	mptcp_data_lock(sk);
@@ -3466,7 +3471,7 @@ static void mptcp_destroy(struct sock *s
 
 	/* allow the following to close even the initial subflow */
 	msk->free_first = 1;
-	mptcp_destroy_common(msk, 0);
+	mptcp_destroy_common(msk);
 	sk_sockets_allocated_dec(sk);
 }
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -871,7 +871,7 @@ static inline void mptcp_propagate_sndbu
 	local_bh_enable();
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags);
+void mptcp_destroy_common(struct mptcp_sock *msk);
 
 #define MPTCP_TOKEN_MAX_RETRIES	4
 


