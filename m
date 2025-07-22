Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159CA2EA478;
	Tue, 22 Jul 2025 13:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192526; cv=none; b=MW1yFXMo7RPap9MZyMwtNrGFHNoaZlrJYawXg9rbyf+UOpKpJ9Q6Fo9op700NCnQsSfUHjGqBopYAqSn4a4sVwPva2NWUrmgGj3gJL3vvx3QVQVejeHLRBKgvpLYha3xh5qz3aKY/pL1qbEQ02TfeZ+upiHhhcSRTSpAA/kunlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192526; c=relaxed/simple;
	bh=cAgaCe/MMBi9mCXg8qNjWZROVYeRNSPY2guF0uW18w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCtS4ehrxOrxqTmnQkxdAlanUwTxTrFXOPSs0humyfJomvXF+9Wm39uOaZn0nUOQkTkKdVe3IAD/xNTbYw5F/UTwnFUrwlUYnmEvhG7cPWZP6Pd+seCyBH9DfU8SGU5zsItZe9bsuOWMcRpRwA7m+kcqnrwyOA7ho8aMrJN1oJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=185nE7Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="185nE7Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088CFC4CEEB;
	Tue, 22 Jul 2025 13:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192525;
	bh=cAgaCe/MMBi9mCXg8qNjWZROVYeRNSPY2guF0uW18w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=185nE7ZeZFNjn1aqrEaryM8tKD/LLt1XEK/FOwjBPR53GtrXjDq9PY7CCCisx7YX2
	 YXYeNh3i0EaYciSpVdnZHvuTCI7cDwecjN3GqsoLcD1YzhsAvxGB+Ldjl78lUemUOW
	 7TYyR1VofmG/EejZ51Oiigk61VP5StRfw6hLKTuc=
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
Subject: [PATCH 6.6 091/111] rxrpc: Fix transmission of an abort in response to an abort
Date: Tue, 22 Jul 2025 15:45:06 +0200
Message-ID: <20250722134336.803869805@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cad6a7d18e040..4bbb27a48bd8a 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -589,6 +589,9 @@ void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	__be32 code;
 	int ret, ioc;
 
+	if (sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
+		return; /* Never abort an abort. */
+
 	rxrpc_see_skb(skb, rxrpc_skb_see_reject);
 
 	iov[0].iov_base = &whdr;
-- 
2.39.5



