Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B031509AC;
	Tue, 20 Feb 2024 21:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463637; cv=none; b=meAzGdH8Q6mtJgvU3HAQpe10cthXh/lN3HvbWTbZ1rw/+QrrCpoWPzZeF0pQtxmzcJv9hnKxoH9PLQ02YZOrpMo5QYStp5yRQ/o3QgnYMkbUK+ruEiLHXFQLQ9O4uRxGM18P2OrxCnlwXpZKnyLz1r76N8b3o2oCIMpjpxCTcg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463637; c=relaxed/simple;
	bh=pHg+fo5y5ooLBlTxWCIVBaFNihGdfJvrTp9q2QWXLyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6+7Q0Igm/QbumN7HcmAjVuLk6fHkmGeTCamLzax6yfo48Pc+aPTCnZu9yqBDrRJCBiQ4nIAG0gDRO3bvBie5N1dJdlpLtqiHxhxUxhNDB7esgTGTg0r3YSEB3+994NIU1vZUu5a/j8Lv+BQf8peVDOzcCK03c7ZE1wYlcaKgVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CB4HAr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CB4HAr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91E3C433C7;
	Tue, 20 Feb 2024 21:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463637;
	bh=pHg+fo5y5ooLBlTxWCIVBaFNihGdfJvrTp9q2QWXLyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CB4HAr4k3m8HTQ5Tqvx8KzDonkw9V7POt+KxpDwkoeccArCZr7ak/J90Q6ZHku2T
	 6/mrVxHXEcbehAiqt9qDq4zjKJCZv46I4NnH/QNAzU4yxy6JcIT/neEOUf5u5iftAn
	 hx/JNWDKPNST3vR8wBTdNsiLEfeALXY8u8qP/vWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 105/331] mptcp: fix data re-injection from stale subflow
Date: Tue, 20 Feb 2024 21:53:41 +0100
Message-ID: <20240220205640.889553922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2318,9 +2318,6 @@ bool __mptcp_retransmit_pending_data(str
 	if (__mptcp_check_fallback(msk))
 		return false;
 
-	if (tcp_rtx_and_write_queues_empty(sk))
-		return false;
-
 	/* the closing socket has some data untransmitted and/or unacked:
 	 * some data in the mptcp rtx queue has not really xmitted yet.
 	 * keep it simple and re-inject the whole mptcp level rtx queue


