Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9CC14F9DA;
	Tue, 20 Feb 2024 21:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462888; cv=none; b=ROEn4LC+OOtTlw2wfKUJJYo+UV+GH4tG4TJaJ7l3idYSY69pmK6n4yMlKyg1sXHPg5XPcy1eXP4/GJIKGrL7eN0r7GtW2+mApUYkWaVF/V8I8f73laqCa4PiavImINYSGoNoh78sl9KkR4p1DQCrFEu0ibLtJwAHT1zXYAY8Euo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462888; c=relaxed/simple;
	bh=Y2qSltzdY/t0UdaELxy7wotyEUTJVz58EY7kefWHvlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfLKKwHzUzC4wMFEhjoGqy4ml1BOL6eWiGnrQE983s/OSzq3hn66ViE5CSwRtFnfu4SrdWhRO7gjJqgakBfOgT/bpiOP7XyoN+smW/kYE0ZZeKI3Gj0p3DLxwHfm2lxPLNQzwJQ4Iz1N8cwu+f1soUoWfYL0tnM7nzbp0PSNpSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss/5DNlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss/5DNlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929BFC433F1;
	Tue, 20 Feb 2024 21:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462888;
	bh=Y2qSltzdY/t0UdaELxy7wotyEUTJVz58EY7kefWHvlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss/5DNljhc2xZjtSfODFOT40K5aNvBM692H1CBrz3jG9c+aLLV+Ae9djq96Fjms0B
	 9vh6sNLO//iDkV61XWZH2dwE1ykQynlJK0hI41G2DSb7B5jOTUtWsRyIL3cZ/Zl/PG
	 A1Ams7aOZ/tDml39g6paN1S6q/P36efW0H7UHaHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 067/197] mptcp: fix data re-injection from stale subflow
Date: Tue, 20 Feb 2024 21:50:26 +0100
Message-ID: <20240220204843.085469580@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit b6c620dc43ccb4e802894e54b651cf81495e9598 upstream.

When the MPTCP PM detects that a subflow is stale, all the packet
scheduler must re-inject all the mptcp-level unacked data. To avoid
acquiring unneeded locks, it first try to check if any unacked data
is present at all in the RTX queue, but such check is currently
broken, as it uses TCP-specific helper on an MPTCP socket.

Funnily enough fuzzers and static checkers are happy, as the accessed
memory still belongs to the mptcp_sock struct, and even from a
functional perspective the recovery completed successfully, as
the short-cut test always failed.

A recent unrelated TCP change - commit d5fed5addb2b ("tcp: reorganize
tcp_sock fast path variables") - exposed the issue, as the tcp field
reorganization makes the mptcp code always skip the re-inection.

Fix the issue dropping the bogus call: we are on a slow path, the early
optimization proved once again to be evil.

Fixes: 1e1d9d6f119c ("mptcp: handle pending data on closed subflow")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/468
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-1-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2336,9 +2336,6 @@ bool __mptcp_retransmit_pending_data(str
 	if (__mptcp_check_fallback(mptcp_sk(sk)))
 		return false;
 
-	if (tcp_rtx_and_write_queues_empty(sk))
-		return false;
-
 	/* the closing socket has some data untransmitted and/or unacked:
 	 * some data in the mptcp rtx queue has not really xmitted yet.
 	 * keep it simple and re-inject the whole mptcp level rtx queue


