Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CFF171E72;
	Wed,  3 Jul 2024 11:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004599; cv=none; b=JMGpN2GAHfQcpnOkD4T+poEtJPlaTFzCTvAQku8ch+gDRBG7h7+f3RVAxItOygORuG18z0nh/ceBcY1TApLbvnxCcuQT5quHok05lfGvVCK8bVgvoK9JKxZqTILKtNRudRzof8vXulljCWqcONTNrC871l+MBq/DX+YDNYASemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004599; c=relaxed/simple;
	bh=pSDAPyYxgRZf2pTuVuFvCzIfA+zlKBbqVXVB77IO2L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpcD1uDvXJCOFKC6GPiQkjIyhUlkUjqIIfoN34n914sY8T3nkxE4gs+HlQXvsFJtNR9ck3BijelpIwJRF1mARQhKvYzKx1Kc9pKXzvzWcYasaILpvbOtsvXEf7BfJqhVxzd4UJcUMgQPxnr8dUjwCVQCe9cx328FbIXs8zX5Muc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+Kbyo9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+Kbyo9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC6BC2BD10;
	Wed,  3 Jul 2024 11:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004599;
	bh=pSDAPyYxgRZf2pTuVuFvCzIfA+zlKBbqVXVB77IO2L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+Kbyo9+QutiXeFguThDZi29WpY1Kom0hdFefHZ1ZBmyT9pOFAqZLONOucY/IZDCZ
	 mfwkoG06xRy1aP6sDVTI6Lgwfjq8P7iJWZ6UJ2vnUkZiuQgT+25OfIqnsSfGRC7p0H
	 qfiVpDV1fQMyU47KEg6VVCjvk3S4j/fvFXttqrZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 096/290] mptcp: ensure snd_una is properly initialized on connect
Date: Wed,  3 Jul 2024 12:37:57 +0200
Message-ID: <20240703102907.817618578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 8031b58c3a9b1db3ef68b3bd749fbee2e1e1aaa3 upstream.

This is strictly related to commit fb7a0d334894 ("mptcp: ensure snd_nxt
is properly initialized on connect"). It turns out that syzkaller can
trigger the retransmit after fallback and before processing any other
incoming packet - so that snd_una is still left uninitialized.

Address the issue explicitly initializing snd_una together with snd_nxt
and write_seq.

Suggested-by: Mat Martineau <martineau@kernel.org>
Fixes: 8fd738049ac3 ("mptcp: fallback in case of simultaneous connect")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/485
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-20240607-misc-fixes-v1-1-1ab9ddfa3d00@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in protocol.c, similar to the ones from commit 99951b62bf20
  ("mptcp: ensure snd_nxt is properly initialized on connect"), with the
  same resolution. Note that in this version, 'snd_una' is an atomic64
  type, so use atomic64_set() instead, as it is done everywhere else. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2646,6 +2646,7 @@ static int mptcp_stream_connect(struct s
 		mptcp_subflow_early_fallback(msk, subflow);
 
 	WRITE_ONCE(msk->write_seq, subflow->idsn);
+	atomic64_set(&msk->snd_una, msk->write_seq);
 
 do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);


