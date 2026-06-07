Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8536B071;
	Sun,  7 Jun 2026 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830008; cv=none; b=DAUexjue884ZXEw4w6tuBkB1BoO6SaWh0RFjX7hDq3EhJ+eX0q/7W5FQCxnbWjdvy0Nek/2qPyO4tpNDr+mG/83PxHrXm9GIpUonKQFxJZFL8x+85ZuKYAUpuXNFLlMCDcCJR+9uQlWkEn2wbuOnUXUHRltOM2uMkPftJsDREkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830008; c=relaxed/simple;
	bh=bzjk62nZP5G1Yk90SUXwpq8Kfb6cZ0GjN+0MhctbR+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5rMV9h4viGZqO5fFO3FLkVB5tKDRVRGZwP15rjc51tU8SbVm5aPn/KDBMHC6ilfGEWRWnTDfeh1oEDkDLv9y7AvgHrxIfRlb6ZzxVccuF2F17BIuMkP4ISv3QTLArteIXYPuBdysNNISj045YpAi77jWuY+3s3wu//VLjQZu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcrBH81V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcrBH81V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3BE1F00893;
	Sun,  7 Jun 2026 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829998;
	bh=ZZStdIpdmWC0pThnYKtyzFtEasdh5VDwYe5L5HWTA2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcrBH81V3pCbvv84aWKis47dkq+soEf1gMt1VzhDSABbpfeqRwsRcUGJpHfseGDGa
	 7UrVJR322LJkK3Vt2CtgWdBDQR1HY4VbVgYmeStDakNR3ww6jM5uZ4vOIsBumznLVx
	 9eq+GIuGn2Sk2VIrb88WERT81WwYj7mJwTQuXafQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 298/315] mptcp: cleanup fallback dummy mapping generation
Date: Sun,  7 Jun 2026 12:01:25 +0200
Message-ID: <20260607095738.541844462@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2834f8edd74d5dda368087a654c0e52b141e9893 ]

MPTCP currently access ack_seq outside the msk socket log scope to
generate the dummy mapping for fallback socket. Soon we are going
to introduce backlog usage and even for fallback socket the ack_seq
value will be significantly off outside of the msk socket lock scope.

Avoid relying on ack_seq for dummy mapping generation, using instead
the subflow sequence number. Note that in case of disconnect() and
(re)connect() we must ensure that any previous state is re-set.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Geliang Tang <geliang@kernel.org>
Tested-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251121-net-next-mptcp-memcg-backlog-imp-v1-6-1f34b6c1e0b1@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0981f90e1a05 ("mptcp: reset rcv wnd on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 +++
 net/mptcp/subflow.c  |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3333,6 +3333,9 @@ static int mptcp_disconnect(struct sock
 	msk->rcvspace_init = 0;
 	msk->fastclosing = 0;
 
+	/* for fallback's sake */
+	WRITE_ONCE(msk->ack_seq, 0);
+
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);
 	return 0;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -491,6 +491,9 @@ static void subflow_set_remote_key(struc
 	mptcp_crypto_key_sha(subflow->remote_key, NULL, &subflow->iasn);
 	subflow->iasn++;
 
+	/* for fallback's sake */
+	subflow->map_seq = subflow->iasn;
+
 	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->ack_seq, subflow->iasn);
 	WRITE_ONCE(msk->can_ack, true);
@@ -1435,9 +1438,12 @@ reset:
 
 	skb = skb_peek(&ssk->sk_receive_queue);
 	subflow->map_valid = 1;
-	subflow->map_seq = READ_ONCE(msk->ack_seq);
 	subflow->map_data_len = skb->len;
 	subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
+	subflow->map_seq = __mptcp_expand_seq(subflow->map_seq,
+					      subflow->iasn +
+					      TCP_SKB_CB(skb)->seq -
+					      subflow->ssn_offset - 1);
 	WRITE_ONCE(subflow->data_avail, true);
 	return true;
 }


