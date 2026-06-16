Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96CA45BD71;
	Tue, 16 Jun 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625719; cv=none; b=aer8VUf3eLEu2RvFjgskZk5PysmTJbWHv6GJLEc4Sd0FKEvSIPBhFi+OCFMMsS0T/PzC9ril5a86Da3HTLqyyDwIcraF+daKOklhLQrZ75CXXY7rjLX4IihO9hIoU5H5buB2vi9XXXz0YvZZBaNKT7JAOHMlLe1A7Kg5PbsV54Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625719; c=relaxed/simple;
	bh=WuroVrQ2CgqyztHBQGDzSXsxRK8McD/e/eirXkxCbWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAzceL/ozftYpcfQVD3cng/h2Q02Uqdji+feeS5ujchDluB+xrBs1WUHRpb0kF9+P6pgww47NWKXcPhW0zV9aobO1hjaVR+EjcltBDaOB5NpmdtP8qGStHJjHfOhbUFM5c1fgoFIZ19zQWrXf4/6yWU0cdPLMWZGvw4kt6XySbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFPrUhiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFPrUhiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC451F000E9;
	Tue, 16 Jun 2026 16:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625718;
	bh=uKLpg1nrdt6VIxeWRb8EgjNmGdsCCZMA/TLJYgnGkzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFPrUhiMkxCyuFZluX75BfRWLP8kIVd9FNJhdMuAZBEe5RyRUm2pshv6zlBOMAqrJ
	 mPRbmYm0gRqPUnedtVEHYjJ7UzEXibsWzE56wgzF1UvEy4tSiHbRFI3GmJb1pzr6sE
	 N73WyJr4p4PYn3pHdr7td5vw2QK5bZ/p2LHvNtpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 195/325] mptcp: fix retransmission loop when csum is enabled
Date: Tue, 16 Jun 2026 20:29:51 +0530
Message-ID: <20260616145107.676629069@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

commit d1918b36edcaed0ec4ef6888b2358c6b1ddcff47 upstream.

Sashiko noted that retransmission with csum enabled can actually
transmit new data, but currently the relevant code does not update
accordingly snd_nxt.

The may cause incoming ack drop and an endless retransmission loop.

Address the issue incrementing snd_nxt as needed.

Fixes: 4e14867d5e91 ("mptcp: tune re-injections for csum enabled mode")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-2-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2759,6 +2759,10 @@ static void __mptcp_retrans(struct sock
 	msk->bytes_retrans += len;
 	dfrag->already_sent = max(dfrag->already_sent, len);
 
+	/* With csum enabled retransmission can send new data. */
+	if (after64(dfrag->already_sent + dfrag->data_seq, msk->snd_nxt))
+		WRITE_ONCE(msk->snd_nxt, dfrag->already_sent + dfrag->data_seq);
+
 reset_timer:
 	mptcp_check_and_set_pending(sk);
 


