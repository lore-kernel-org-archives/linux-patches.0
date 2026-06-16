Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E3B43E490;
	Tue, 16 Jun 2026 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629952; cv=none; b=GArD4FovLP2L3Sn6g2kohk+hPPkoMPPjyei6PpBdkBW8K5SfUluvxnC4wUk+TCaXHb60wY23HYkJiYLKa3zOt8r/N8Pxm65ayW6XX/Z6iHhdvLduwo3EP5sLKTtGFi9zkqYXUgTNIFxtxTGJ/pJR0C3AOQMPTa6iLVvy6K8MHvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629952; c=relaxed/simple;
	bh=dIlr+GdAKWB/khMSNEUjwmXfVopBJuHAIjeY+8qz5aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaUdj8ex1igYDxauxp6z7cpVoahscKoboKqwfgWxVO+S0cwc355Dwylm6IENL9d3qzhunvdLoheh/9McW8fkq41Yi5iGU2JbIkeRl5w70xPzq9WLW7+wbJnUsonSBLgEExVG2fT6XQnKHinGDUdwAmzNe0Zy2gYe1QXqDXYhTnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnYrhEOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnYrhEOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551711F000E9;
	Tue, 16 Jun 2026 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629951;
	bh=WjTq52tIrOKgXkqIp5pofP/lduXIovK61OPR7ewMFGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnYrhEORU/YlMutQULYrHzaS2Obr+ObjnqKKU2gtvMvbJQD3Ds2cjrWoSQc/d73d1
	 n0da6GVWTAgLKE+o6zdc6KJXPGhiPS6OSbaptVXgv2CMK4zwBDXU90c8m6VQ80prZr
	 QEIXWRgGMjziqgjCahf4WiWozBqjAJij8aY5qOyY=
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
Subject: [PATCH 6.6 384/452] mptcp: cleanup fallback dummy mapping generation
Date: Tue, 16 Jun 2026 20:30:11 +0530
Message-ID: <20260616145137.097239506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -3331,6 +3331,9 @@ static int mptcp_disconnect(struct sock
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
@@ -471,6 +471,9 @@ static void subflow_set_remote_key(struc
 	mptcp_crypto_key_sha(subflow->remote_key, NULL, &subflow->iasn);
 	subflow->iasn++;
 
+	/* for fallback's sake */
+	subflow->map_seq = subflow->iasn;
+
 	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->ack_seq, subflow->iasn);
 	WRITE_ONCE(msk->can_ack, true);
@@ -1382,9 +1385,12 @@ reset:
 
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


