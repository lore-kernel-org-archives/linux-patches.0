Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE09446C9;
	Tue, 20 Feb 2024 21:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464724; cv=none; b=meKN5blk0bsuhOxRivnYbkOlB7dPfj198JCPoR6XdTFu0fz3XG9zlgJzf7BKORpzZ08YBDCIhT3KfHXbQPkitQRPV9M2yYF3iZydVdFrgdG2BU6VFPmV69QoaxoKTMDedsvBcUx+edPu0BRi17qutJPVXgVsaouXug0roERF/9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464724; c=relaxed/simple;
	bh=7Plem0xvR1sn7zmM3dOTq6JhjFht52rxWxfF5kfp4Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avFePtPadW1+JuPUzH3ACkowDy50yxHsGRkCTu0oq9T9dS2VkHFefA8SW9/YOSy1VtWN1qOPr19cfWjbNtOlafst7qmaLkOY7f3NBoxGj/AExT9JlnfyBqd5Ir4u+UaGHSAFPU3ezUTk6fYE2DCYD/6T0d4dIPnSO4Fy9Y0zKRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJ2FxWgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJ2FxWgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BABC433C7;
	Tue, 20 Feb 2024 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464724;
	bh=7Plem0xvR1sn7zmM3dOTq6JhjFht52rxWxfF5kfp4Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJ2FxWgU5EsBH2OHAC4vDfgR4p3KNp6CJgiCgLv/tfRzjYfyLYVKZVMCmluds4bcD
	 9p6hHK1mqYlIFlTFDz9+TXxZkkQzzTUc0bWA7P+OhCgcSpKTQkdcjznfHpLG6Mux4D
	 AexeZ8psS5zv0a62mAoeH+9rDssMKTFAn0xJ5ej4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 116/309] mptcp: fix data re-injection from stale subflow
Date: Tue, 20 Feb 2024 21:54:35 +0100
Message-ID: <20240220205636.812750904@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2328,9 +2328,6 @@ bool __mptcp_retransmit_pending_data(str
 	if (__mptcp_check_fallback(msk))
 		return false;
 
-	if (tcp_rtx_and_write_queues_empty(sk))
-		return false;
-
 	/* the closing socket has some data untransmitted and/or unacked:
 	 * some data in the mptcp rtx queue has not really xmitted yet.
 	 * keep it simple and re-inject the whole mptcp level rtx queue


