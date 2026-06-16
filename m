Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B21A44103D;
	Tue, 16 Jun 2026 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624062; cv=none; b=akEuA7huSiKcBnDhFAvx63rpPURXZSXQkPXb8Jzxb95YoWxPE7F1LB8ITr8ek/UNzjfKkZOib9k3lb75ACsImuxslhYUmQ4FYY25ommfRNQ8bbUAizTRsfb1vE5aJn38JKL/b1ng4DUqzYWKBRw9O9W9/nabNAOuOiPhTEoyc9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624062; c=relaxed/simple;
	bh=YeWg3IT2aNFrh9mFcR6onekUkbALkq+8VM6VFVH9aFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWX7zCoU9V6Fydn9EhO8ZMubltLyQlNX19ruBq8coEVaVbXUGb7hguGkpx/nfjKBQ3dVOyBxj1FfqgPT6YH2f0wcGkDMdY8BZ0v4o3b979YUrxXQg9hS24bmkbolfMSx/ohfcp1aEMyVuo2jFBVlEEFOWg+P3kDeyqLOgpVPrC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDHpVIwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDHpVIwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595951F00A3D;
	Tue, 16 Jun 2026 15:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624061;
	bh=/LfHq1+5C+tfegnS0uoKBTjrRPjEt2sYYhd54++67ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDHpVIwV/OFUlvuTKu7vSuDY5ht1vBSzyJSte5SIgooVLwi7Tf2Pwysvnbp1v/aIu
	 vsrLIt5jT5EOeQK5ymJm1UyA+iqr2wvmW/NidISGd+bQ/7RcRV4lN9ag4rCWZafdRQ
	 hRbBr92VnC5BbsVUKsiXaYpGuY79jsU2O53SvjMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 232/378] mptcp: close TOCTOU race while computing rcv_wnd
Date: Tue, 16 Jun 2026 20:27:43 +0530
Message-ID: <20260616145122.468964965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 8ab24fdebc369c0dfb90f82c1650b1e66662bb45 upstream.

The MPTCP output path access locklessly the MPTCP-level ack_seq
in multiple times, using possibly different values for the data_ack
in the DSS option and to compute the announced rcv wnd for the same
packet.

Refactor the cote to avoid inconsistencies which may confuse the
peer. Also ensure that the MPTCP level rcv wnd is updated only when
the egress packet actually contains a DSS ack.

Fixes: fa3fe2b15031 ("mptcp: track window announced to peer")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-3-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -570,7 +570,6 @@ static bool mptcp_established_options_ds
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
 	bool ret = false;
-	u64 ack_seq;
 
 	opts->csum_reqd = READ_ONCE(msk->csum_enabled);
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
@@ -601,14 +600,11 @@ static bool mptcp_established_options_ds
 		return ret;
 	}
 
-	ack_seq = READ_ONCE(msk->ack_seq);
 	if (READ_ONCE(msk->use_64bit_ack)) {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
-		opts->ext_copy.data_ack = ack_seq;
 		opts->ext_copy.ack64 = 1;
 	} else {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK32;
-		opts->ext_copy.data_ack32 = (uint32_t)ack_seq;
 		opts->ext_copy.ack64 = 0;
 	}
 	opts->ext_copy.use_ack = 1;
@@ -1296,19 +1292,14 @@ bool mptcp_incoming_options(struct sock
 	return true;
 }
 
-static void mptcp_set_rwin(struct tcp_sock *tp, struct tcphdr *th)
+static u64 mptcp_set_rwin(struct mptcp_sock *msk, struct tcp_sock *tp,
+			  struct tcphdr *th, u64 ack_seq)
 {
 	const struct sock *ssk = (const struct sock *)tp;
-	struct mptcp_subflow_context *subflow;
-	u64 ack_seq, rcv_wnd_old, rcv_wnd_new;
-	struct mptcp_sock *msk;
+	u64 rcv_wnd_old, rcv_wnd_new;
 	u32 new_win;
 	u64 win;
 
-	subflow = mptcp_subflow_ctx(ssk);
-	msk = mptcp_sk(subflow->conn);
-
-	ack_seq = READ_ONCE(msk->ack_seq);
 	rcv_wnd_new = ack_seq + tp->rcv_wnd;
 
 	rcv_wnd_old = atomic64_read(&msk->rcv_wnd_sent);
@@ -1360,7 +1351,7 @@ raise_win:
 
 update_wspace:
 	WRITE_ONCE(msk->old_wspace, tp->rcv_wnd);
-	subflow->rcv_wnd_sent = rcv_wnd_new;
+	return rcv_wnd_new;
 }
 
 static void mptcp_track_rwin(struct tcp_sock *tp)
@@ -1472,13 +1463,25 @@ void mptcp_write_options(struct tcphdr *
 		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
 
 		if (mpext->use_ack) {
+			struct mptcp_sock *msk;
+			u64 ack_seq;
+
+			/* DSS option is set only by mptcp_established_options,
+			 * the caller is __tcp_transmit_skb() and ssk is always
+			 * not NULL.
+			 */
+			subflow = mptcp_subflow_ctx(ssk);
+			msk = mptcp_sk(subflow->conn);
+			ack_seq = READ_ONCE(msk->ack_seq);
 			if (mpext->ack64) {
-				put_unaligned_be64(mpext->data_ack, ptr);
+				put_unaligned_be64(ack_seq, ptr);
 				ptr += 2;
 			} else {
-				put_unaligned_be32(mpext->data_ack32, ptr);
+				put_unaligned_be32(ack_seq, ptr);
 				ptr += 1;
 			}
+			subflow->rcv_wnd_sent = mptcp_set_rwin(msk, tp, th,
+							       ack_seq);
 		}
 
 		if (mpext->use_map) {
@@ -1706,9 +1709,6 @@ mp_capable_done:
 			i += 4;
 		}
 	}
-
-	if (tp)
-		mptcp_set_rwin(tp, th);
 }
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb)


