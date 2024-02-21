Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE473C2F;
	Wed, 21 Feb 2024 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523235; cv=none; b=Xj5y1AdipyUWl3TqB4XDlW/wk9l1lJ4HOLpGipI1sn9CMG9dDsAYOitvAibYArZC8bb+caChQH2XwJ1pPGJJMzSeils4aAawgMzXmzeH4Fc+htoN5oNhZlYrRQp0ng0DDLr6lRUJovUKZ3JCF7wDVXOPY4CG3QIOpg2wPRpkzzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523235; c=relaxed/simple;
	bh=DEEh3Qr2NxmADGR5S9dyILj6H/2aAU3c7pZQUVLdKCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+asXWyRbsnB/iw5qDS6m9/PGLRi18zb9NXyE127qZ8LNB83cjXNPoHHy6x4A9EdD94ArdCXlkaufGIG7JzqmRMxfZBKEeWpBhzbaYqpzlkhh1voFKcu7pN34gwNUjORew48z+BwD5ubNFHs01V0pNCwW5rQHaHLPAZQEt3pfNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNTi8PQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNTi8PQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C002C433C7;
	Wed, 21 Feb 2024 13:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523234;
	bh=DEEh3Qr2NxmADGR5S9dyILj6H/2aAU3c7pZQUVLdKCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNTi8PQwy9nvv1sZl4OQ76rUoJkAl+rqRhgoJIejexgoOpdgL3jy9jf5L4FO/v89T
	 l2E2H3BB90m6WIdXSx0ozTAm//X8OELRn1OpmtBCZJxFCRrXIeZ253JAjcsc4MFfVN
	 3ERd60Es27LmYnGy+yFNURytgDm7i1GI7FFCfKzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 375/476] mptcp: fix data re-injection from stale subflow
Date: Wed, 21 Feb 2024 14:07:06 +0100
Message-ID: <20240221130021.885274184@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2203,9 +2203,6 @@ bool __mptcp_retransmit_pending_data(str
 	if (__mptcp_check_fallback(mptcp_sk(sk)))
 		return false;
 
-	if (tcp_rtx_and_write_queues_empty(sk))
-		return false;
-
 	/* the closing socket has some data untransmitted and/or unacked:
 	 * some data in the mptcp rtx queue has not really xmitted yet.
 	 * keep it simple and re-inject the whole mptcp level rtx queue


