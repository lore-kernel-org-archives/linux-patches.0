Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3F646AA69;
	Tue, 21 Jul 2026 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647982; cv=none; b=GM0l8e2f4UBntblbkahR/WI9Xyy9JN57zI3jYLcvIiJUx+Mkdry/+v9XOHC1J58lH+fD9WkDtepT35uotWY9tOEVs6Xhbb05Y8XE2a5nWwCxjC45B1F4buOw3zg3RpDpXNdyJjRbQ82zuXeyBqSbwzAfg3OJ53MDvymBDRWQdEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647982; c=relaxed/simple;
	bh=Z5SudWA7c/EXkZyq9JL1u/rDtVeykGPPEvONaH8yfB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXK/xa4cjWflgurS9Zq3laVfzJBj8FO85qgo1p8OQmNjBaLksk0hVN8qzVTQMTtKR8kdd2jhKyX1+y2VNNgv1x+WXvIdrAoP5rp0I38hM78Q3m+RMxzFe9svyxlb9XrVv/+tRcnlAHYZr5P2Nr+Yizb01jh8sqAcvO3RpRCpT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSlBgX+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSlBgX+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79F61F000E9;
	Tue, 21 Jul 2026 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647981;
	bh=fGJkeoH4nXXhdHbTFAvG1wEFLHs48LxmtMjtqAYg2JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSlBgX+T25lbXc0OXCf5WdMnK+QuxEpRofUu96SybgTNDN/gIzAgO8VUQuLP2VC62
	 GQBE6A6mUw9lCQMp9pnaXc+oV8t6pKZ45WuJAZh0YV1VRlJjUJgkvQTYnJEb1FTAPq
	 k7GIdEg4c95XCTyxnvivtIIKDRTE/N2w6CoUEi5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0027/2077] rxrpc: Fix potential infinite loop in rxrpc_recvmsg()
Date: Tue, 21 Jul 2026 16:55:00 +0200
Message-ID: <20260721152553.316312458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 67a0332f442ef07713cd2d9c13d59db0f1c23648 upstream.

Fix the wait in rxrpc_recvmsg() also take check the oob queue.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-9-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -436,7 +436,8 @@ try_again:
 		return -EAGAIN;
 	}
 
-	if (list_empty(&rx->recvmsg_q)) {
+	if (list_empty(&rx->recvmsg_q) &&
+	    skb_queue_empty_lockless(&rx->recvmsg_oobq)) {
 		ret = -EWOULDBLOCK;
 		if (timeo == 0) {
 			call = NULL;


