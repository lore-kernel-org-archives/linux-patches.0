Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084901BA87C;
	Tue, 27 Aug 2024 14:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770277; cv=none; b=h3PA7vtM1j4oGa6NSrZLKIaAB9Ui2dHVpB2edrEwz4sLfZ5i4iBknEhOnPqfUVFGGoLTmpdNX5vrGR+Lh+qVdAWUChlJiWaawplP/3el+BfMLfdrHb0PdTBjFls83uucewciWc4YKhHMy1Y9IcwBbVb0TG+JjthjM6k7KBVmDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770277; c=relaxed/simple;
	bh=Vet9b+lsNKJwPdpWDAWmfJ5URJFxnjvzYZL2r9cjkBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXLwdxSUYPZXC6auGR/q+E5r/cRSKp+ohPJTwgq5DxFVYLpSkej4cNHTCpbOJ4jxs1IIR+V/qN4idklCWtwuRo1InyljTkVPf8azx8t5oZutNF67pjdG0J2W2BrXlY9CWEW3bLFAkuS3/U3dSVso7Ujkge0nJ2hAiaMxK+mo8Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoGpFsKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoGpFsKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0D6C4DDFF;
	Tue, 27 Aug 2024 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770276;
	bh=Vet9b+lsNKJwPdpWDAWmfJ5URJFxnjvzYZL2r9cjkBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoGpFsKW7kw95nu3gvTUey58F/+/Q5idOsjxz48rCCxF70SvI4VaDyf5RmdLULw4z
	 Glc36u/pi01A/LMTzpJC9dMgIMy+jkMHbDpAgu09GcpPd1eT8/4nU30lOFCH3bKAFz
	 bVxlYG/9F/sZTG9ms00spPQed3JDtDYko00Kvu2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/341] rxrpc: Dont pick values out of the wire header when setting up security
Date: Tue, 27 Aug 2024 16:36:51 +0200
Message-ID: <20240827143850.263530780@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit a1c9af4d4467354132417c2d8db10d6e928a7f77 ]

Don't pick values out of the wire header in rxkad when setting up DATA
packet security, but rather use other sources.  This makes it easier to get
rid of txb->wire.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxkad.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 6b32d61d4cdc4..ad6c57a9f27c7 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -259,7 +259,7 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 
 	_enter("");
 
-	check = txb->seq ^ ntohl(txb->wire.callNumber);
+	check = txb->seq ^ call->call_id;
 	hdr->data_size = htonl((u32)check << 16 | txb->len);
 
 	txb->len += sizeof(struct rxkad_level1_hdr);
@@ -302,7 +302,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 
 	_enter("");
 
-	check = txb->seq ^ ntohl(txb->wire.callNumber);
+	check = txb->seq ^ call->call_id;
 
 	rxkhdr->data_size = htonl(txb->len | (u32)check << 16);
 	rxkhdr->checksum = 0;
@@ -362,9 +362,9 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	memcpy(&iv, call->conn->rxkad.csum_iv.x, sizeof(iv));
 
 	/* calculate the security checksum */
-	x = (ntohl(txb->wire.cid) & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
+	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
 	x |= txb->seq & 0x3fffffff;
-	crypto.buf[0] = txb->wire.callNumber;
+	crypto.buf[0] = htonl(call->call_id);
 	crypto.buf[1] = htonl(x);
 
 	sg_init_one(&sg, crypto.buf, 8);
-- 
2.43.0



