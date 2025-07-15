Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5D52E6D00;
	Tue, 15 Jul 2025 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586571; cv=none; b=WV9cO3Df3Mjc7Ts0lzSv2/K7Aj3yIkKiMi/NApHJkAREIYWZzv/YQC6xwAb3lolrewepshOEcyyzVwjMrqAEeDStH17zSLvox/rZPMYTx0YJAQRRf7KVlKvnqIkqGvWL1664lcE6bsPBzrfp+uSCv9AHiHLncw7cvfFo1ztcGZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586571; c=relaxed/simple;
	bh=3vxas5e5u8UrAkm/YflkWF9+Q+DxO9y6mBW3EgDLgNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIzscHB5VoO7/nRwSVAHN2PEQodGrRchW3Gsy+SqSgwUa3PV0KhdMx9/AqXgVrWZrG37q9Wm0T9hXAeBQLPhnIvxpMq6/MJIiuNaUwM9KxBP2kbdE5nXKTNbmf9bH8uKFxNnlCHncQmVx8SeGbIdqMBMsXNAVB/bYYeyLKbwjGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abljTGdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abljTGdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84536C4CEE3;
	Tue, 15 Jul 2025 13:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586570;
	bh=3vxas5e5u8UrAkm/YflkWF9+Q+DxO9y6mBW3EgDLgNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abljTGdFBV3HmTQ+wKS1nsqlR48KdrOq73Q/utSQ8vr2jZ09zrtHApKYquWVqrXDx
	 L6LCtHHb4kK59qwr/iaIGwuktYPpwopCAPb/r65S347M5sehVHE7l0HCzf2g2NLxHo
	 4kecJft+BT//APPXcl3AMtmR251r5K3ZqS7eUGQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	David Howells <dhowells@redhat.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Willy Tarreau <w@1wt.eu>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 116/148] rxrpc: Fix oops due to non-existence of prealloc backlog struct
Date: Tue, 15 Jul 2025 15:13:58 +0200
Message-ID: <20250715130804.950057173@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 880a88f318cf1d2a0f4c0a7ff7b07e2062b434a4 upstream.

If an AF_RXRPC service socket is opened and bound, but calls are
preallocated, then rxrpc_alloc_incoming_call() will oops because the
rxrpc_backlog struct doesn't get allocated until the first preallocation is
made.

Fix this by returning NULL from rxrpc_alloc_incoming_call() if there is no
backlog struct.  This will cause the incoming call to be aborted.

Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Suggested-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Willy Tarreau <w@1wt.eu>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250708211506.2699012-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_accept.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -281,6 +281,9 @@ static struct rxrpc_call *rxrpc_alloc_in
 	unsigned short call_tail, conn_tail, peer_tail;
 	unsigned short call_count, conn_count;
 
+	if (!b)
+		return NULL;
+
 	/* #calls >= #conns >= #peers must hold true. */
 	call_head = smp_load_acquire(&b->call_backlog_head);
 	call_tail = b->call_backlog_tail;


