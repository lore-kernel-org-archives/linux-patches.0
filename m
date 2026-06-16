Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0C35AC3E;
	Tue, 16 Jun 2026 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635249; cv=none; b=ZNZ9xZCWHWyFl4af3CqoTbI0mbE7cVsIz/Pc8JVQ9ie3o8QeSXyxk6WLoxwp2SAK/uXL5llbOqrr3a8hWK0sJVUBKBFzYY1TAUKpYrzMGmei+eZz9fmfyvQysvHYXj9Holuaq5mrrpmlE6njNx0eZNIih7oq1LOUQtcnuf4+Fv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635249; c=relaxed/simple;
	bh=/C7uDt6YOM/cP+1opqJTx3SpAwIiyaqGyLc/IjhzBxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgVEfaKxuO6puM7QsZ+bxOyuSCtZAVjbJEm/PWUGoVLio8+hXblnRe3rYZUQYBx5RZ3wZ2AJJ4XarTbnFbrq1pf2PVGRQcb2nck0ZNvaxt2l2aX9r/99p1Q3+DWdHeyBX3uqOzEUKYx/v01o6dgk+KLi6fXPlxFtGF2sqsGqH9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgMss9Y5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgMss9Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE891F00A3D;
	Tue, 16 Jun 2026 18:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635247;
	bh=2JFWESXicoochUjorIr1WVpytMWNjLRqpu7Px3YzKqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgMss9Y53bNxnPbRpThB+7U0NeY3GdfacLKKL6Rne/Mb0x3ZL3MLHGBbCbVf/N7In
	 97XNOVifNPQiO4Iytg1YGQN6BwEnS+lA2iV4IkxcAo4XFA3IKrHHHuJuh/rWMTsosU
	 ZkPasIWm531jjJNb0j/1ZEzjztll0HwGyrF3hAEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/411] mptcp: close TOCTOU race while computing rcv_wnd
Date: Tue, 16 Jun 2026 20:30:46 +0530
Message-ID: <20260616145122.825698083@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8ab24fdebc369c0dfb90f82c1650b1e66662bb45 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -555,7 +555,6 @@ static bool mptcp_established_options_ds
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
 	bool ret = false;
-	u64 ack_seq;
 
 	opts->csum_reqd = READ_ONCE(msk->csum_enabled);
 	mpext = skb ? mptcp_get_ext(skb) : NULL;
@@ -587,14 +586,11 @@ static bool mptcp_established_options_ds
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
@@ -1235,17 +1231,16 @@ bool mptcp_incoming_options(struct sock
 	return true;
 }
 
-static void mptcp_set_rwin(const struct tcp_sock *tp)
+static void mptcp_set_rwin(const struct tcp_sock *tp, u64 ack_seq)
 {
 	const struct sock *ssk = (const struct sock *)tp;
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk;
-	u64 ack_seq;
 
 	subflow = mptcp_subflow_ctx(ssk);
 	msk = mptcp_sk(subflow->conn);
 
-	ack_seq = READ_ONCE(msk->ack_seq) + tp->rcv_wnd;
+	ack_seq += tp->rcv_wnd;
 
 	if (after64(ack_seq, READ_ONCE(msk->rcv_wnd_sent))) {
 		WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
@@ -1369,13 +1364,26 @@ void mptcp_write_options(__be32 *ptr, co
 		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
 
 		if (mpext->use_ack) {
+			const struct sock *ssk = (const struct sock *)tp;
+			struct mptcp_subflow_context *subflow;
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
+			mptcp_set_rwin(tp, ack_seq);
 		}
 
 		if (mpext->use_map) {
@@ -1559,9 +1567,6 @@ mp_capable_done:
 			i += 4;
 		}
 	}
-
-	if (tp)
-		mptcp_set_rwin(tp);
 }
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb)


