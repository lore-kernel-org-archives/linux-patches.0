Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF972C237E;
	Mon, 17 Aug 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977444; cv=none; b=hffg2atZ+tyAvz72OKY3pA5L2N1OECjWjYrHgMqrMEP9NNN9CcsDoBZE4SNKIaafGDgLxuEOC8yUF355NnwnSlZ2SzsycsgkMmR1htDU/awj0pUt/icOSO/jU/jRstlsPzl954EpOfPO4fZ9rXIrpiAQfSQN9Y7g9B+pNWl76uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977444; c=relaxed/simple;
	bh=rINgUYCR2odwuvzxiQ+vmaTv+scTbSaqv6UVxC+1Xlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7imPCNsWQclAsgpXNjRmF+pGOJfuDbtYO10JtG0h8BzNb8FxjvCWWaRVjtIL/132/K1EyLWfTEdQIDDzQAPbWIzTHoRZBtBs9M7J/W2I/Ldwx2C1UjA9sGyI6d0+IxFy7PjCAQjNgc7XjbRfzLh8txRF6MS43rSkKLbKY+PAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMW2pTuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMW2pTuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B297F1F000E9;
	Mon, 17 Aug 2026 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977443;
	bh=tjd3zAQXbdjw5GPfphaRM9sQptwwD5fnI9cI4ZvuwPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMW2pTuwDBUpjpl5dd4Q0oa48neETAHrchVg+OM7U7TylrXO6JC+nSp/0641hpijN
	 EXa29c2h3lc3cdjEQYXIUP/8EuOLLmg5jW3SskeqIswyHdbj7PzMgW4w9USZOwdrGV
	 euSooDZLXp1jVJiaCSTlp6+LW9Vi9k07aufYeqJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 331/456] sctp: prevent peer transport count overflow
Date: Mon, 17 Aug 2026 15:32:01 +0200
Message-ID: <20260817132552.581298774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit bd0e9289e2642f6a5c54faad304ce0f41e926d22 upstream.

sctp_assoc_add_peer() increments the association's 16-bit transport_count
for every new unique peer. Adding the 65,536th transport wraps the count to
zero.

SCTP sock_diag uses transport_count to reserve the INET_DIAG_PEERS payload,
then copies one sockaddr_storage for every entry in transport_addr_list.
After the wrap, a diagnostic dump reserves an empty payload and writes
8 MiB of peer addresses past the skb tail.

Reject a new unique peer when transport_count has reached U16_MAX. Perform
the check after the existing-peer lookup so a duplicate address continues
to return its existing transport at the limit.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Cc: stable@vger.kernel.org
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260725032053.521705-1-manizada@pm.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -616,6 +616,9 @@ struct sctp_transport *sctp_assoc_add_pe
 		return peer;
 	}
 
+	if (asoc->peer.transport_count == U16_MAX)
+		return NULL;
+
 	peer = sctp_transport_new(asoc->base.net, addr, gfp);
 	if (!peer)
 		return NULL;


