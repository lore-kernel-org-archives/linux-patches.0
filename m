Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590602EBB8E;
	Tue, 22 Jul 2025 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193661; cv=none; b=QynXSHNtEutrB1eyP0e2z5MfEgV5totzb0m1N+aWqWzQSy8oPZGC1GFx8XaTq73hUqwpXsj/uI+mrCLNm9L64REDtv2c7czViNp9C3cQVLytyonrVTMNv73ukDA71q2M4m0MfTMnVaXrYvs/CZAZs+eRrnMsKD8A8gqolyZQuco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193661; c=relaxed/simple;
	bh=3eDNjNHseR0MMN8oiS/iFFiQYkHMkqvk3Hf9KUVyYOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2yVVt4PeaIzGRrfopvkv8tKWfjgZAAFjKf3jN12p7f06q7DofO8UB+jIb9JJxsTHMIML4/6PnHdYZQfv/uw60SF6XMpakP92IMs45YTMHSyiq7f+k0ykypjNtHyw7s1dNSBHIWklLW6svqDCEa8mppZ+11Pc1l4YrEo23ENil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYloxr8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYloxr8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864F4C4CEEB;
	Tue, 22 Jul 2025 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193661;
	bh=3eDNjNHseR0MMN8oiS/iFFiQYkHMkqvk3Hf9KUVyYOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYloxr8/YBgCK3efN5+ZrttaqK4IWeAIIfuf7FlQHH/XpOCR8YNIgeaOK2SRrqCIO
	 t+Yf2+mVNpi7ZOd1fFCpfdCaOjz4s2Lb6qZkyBdcRsnFwV/M7lQkVYxwVM/1WJezkH
	 mOHdeB86mECQFyQHC7Rh6cDWUkfQFU8cklNX7ofw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 159/187] rxrpc: Fix transmission of an abort in response to an abort
Date: Tue, 22 Jul 2025 15:45:29 +0200
Message-ID: <20250722134351.698238796@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit e9c0b96ec0a34fcacdf9365713578d83cecac34c ]

Under some circumstances, such as when a server socket is closing, ABORT
packets will be generated in response to incoming packets.  Unfortunately,
this also may include generating aborts in response to incoming aborts -
which may cause a cycle.  It appears this may be made possible by giving
the client a multicast address.

Fix this such that rxrpc_reject_packet() will refuse to generate aborts in
response to aborts.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Linus Torvalds <torvalds@linux-foundation.org>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250717074350.3767366-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 95905b85a8d71..d0d04ee9667ef 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -814,6 +814,9 @@ void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	__be32 code;
 	int ret, ioc;
 
+	if (sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
+		return; /* Never abort an abort. */
+
 	rxrpc_see_skb(skb, rxrpc_skb_see_reject);
 
 	iov[0].iov_base = &whdr;
-- 
2.39.5



