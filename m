Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F4B4C97;
	Tue, 11 Nov 2025 00:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822260; cv=none; b=tU/No3N5BnqbuZAo5Lz+UCW3ZTX4jqwufF2Y+v8eomjm97pO1I6ASyomaQSpZEdI3uvrU3GBRi37cGk8NyL1pXplXe8G22l6h2bJlSCHE6b9y6upFpJQlj0buDNZ6iC2FNg3EjyTh3sp0hO/MYLNo/mzljnemzuhnPS3R4w/uNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822260; c=relaxed/simple;
	bh=4WApMxtJqfX65bjHdX1BiiDPKme86yY3p1CDzq0s6+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br3k+fX1FFFfH2CAUNmFiwHe5BsETa+fp79e3m+NxANLTTXXet7Hb/rWeaGaP2v+IvdXtonqOKaL8tCDyEFS09CBHiT4BqUUyex1EkUM+zweHTpo2A9Ky3l8MZRYQg/5OMB0rlmclV9rXACXbzhtVnlwjc7scQlF8I/VGP1BPqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdlhoNSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdlhoNSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFC2C113D0;
	Tue, 11 Nov 2025 00:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822259;
	bh=4WApMxtJqfX65bjHdX1BiiDPKme86yY3p1CDzq0s6+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdlhoNSuCQNkzX08QBdo0mTft/u319k3FMSkXcjyTQgh2WkAA5ejktl/N6L1Y14+m
	 +hGkhwEnKCT1M26IahLlC3vLGToHmwKYaYlOW3LPISUqBJJdQmiIm8EJ/+FihyBZKF
	 TGCosCWU4u0HMUdcISI1t0l5DYby885dH6kLZSBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 013/565] mptcp: drop bogus optimization in __mptcp_check_push()
Date: Tue, 11 Nov 2025 09:37:49 +0900
Message-ID: <20251111004527.159238392@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 27b0e701d3872ba59c5b579a9e8a02ea49ad3d3b upstream.

Accessing the transmit queue without owning the msk socket lock is
inherently racy, hence __mptcp_check_push() could actually quit early
even when there is pending data.

That in turn could cause unexpected tx lock and timeout.

Dropping the early check avoids the race, implicitly relaying on later
tests under the relevant lock. With such change, all the other
mptcp_send_head() call sites are now under the msk socket lock and we
can additionally drop the now unneeded annotation on the transmit head
pointer accesses.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251028-net-mptcp-send-timeout-v1-1-38ffff5a9ec8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   11 ++++-------
 net/mptcp/protocol.h |    2 +-
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1047,7 +1047,7 @@ static void __mptcp_clean_una(struct soc
 			if (WARN_ON_ONCE(!msk->recovery))
 				break;
 
-			WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+			msk->first_pending = mptcp_send_next(sk);
 		}
 
 		dfrag_clear(sk, dfrag);
@@ -1593,7 +1593,7 @@ static int __subflow_push_pending(struct
 
 			mptcp_update_post_push(msk, dfrag, ret);
 		}
-		WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+		msk->first_pending = mptcp_send_next(sk);
 
 		if (msk->snd_burst <= 0 ||
 		    !sk_stream_memory_free(ssk) ||
@@ -1937,7 +1937,7 @@ static int mptcp_sendmsg(struct sock *sk
 			get_page(dfrag->page);
 			list_add_tail(&dfrag->list, &msk->rtx_queue);
 			if (!msk->first_pending)
-				WRITE_ONCE(msk->first_pending, dfrag);
+				msk->first_pending = dfrag;
 		}
 		pr_debug("msk=%p dfrag at seq=%llu len=%u sent=%u new=%d\n", msk,
 			 dfrag->data_seq, dfrag->data_len, dfrag->already_sent,
@@ -2940,7 +2940,7 @@ static void __mptcp_clear_xmit(struct so
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
 
-	WRITE_ONCE(msk->first_pending, NULL);
+	msk->first_pending = NULL;
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(sk, dfrag);
 }
@@ -3494,9 +3494,6 @@ void __mptcp_data_acked(struct sock *sk)
 
 void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 {
-	if (!mptcp_send_head(sk))
-		return;
-
 	if (!sock_owned_by_user(sk))
 		__mptcp_subflow_push_pending(sk, ssk, false);
 	else
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -414,7 +414,7 @@ static inline struct mptcp_data_frag *mp
 {
 	const struct mptcp_sock *msk = mptcp_sk(sk);
 
-	return READ_ONCE(msk->first_pending);
+	return msk->first_pending;
 }
 
 static inline struct mptcp_data_frag *mptcp_send_next(struct sock *sk)


