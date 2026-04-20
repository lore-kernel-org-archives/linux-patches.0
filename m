Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67ED335BA7;
	Mon, 20 Apr 2026 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701577; cv=none; b=RDuKKbWe36b1Ye2jigCGSpYzxPNq7M2/KrrPQQGOEvCloDZlW1f8bEgiR59MGMWxO4+eTnT8baKMPQRTfa16P9QQL5PO4YSu2YkDjeWWjSyqy/BSSL4Xw8wpbkoTJZyxQdGWj5sOeV/wzGLV1Bep41i1wa8K5ELCCSvbbh3vuZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701577; c=relaxed/simple;
	bh=hWGqCTlihTpJ4ebxiQV46xpHdIKgfm+Z8JbbDI499G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRgIfdnfWVwt94TMi0WE16OGkot+RMPrml+fJHAYgQJwjkqTex+Boz44LXpVfZq9L9YW4O8K/l04qhmCvjZvnPI4tVmovtFnOTKqjljAeqN7PBwfqN6kxocIOgbbWPG5qQd+FrdaKeSUOfKC0sRNFHHtXOGC1BYYrlwk8Gm17eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH9sMe6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH9sMe6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353DBC19425;
	Mon, 20 Apr 2026 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701577;
	bh=hWGqCTlihTpJ4ebxiQV46xpHdIKgfm+Z8JbbDI499G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH9sMe6BpdWcwa7xnccJ7aYLw5NGqNX+UNo8VV4aLUSBgh0IPXD1OdGudnwy35Lsl
	 2N27kQnrd5DwW9fqikyb1DIiEKrPikSm6kGvzNBySws8NbLDMgCk8x3QIiHtxlK2M4
	 nfhSCz5KW1uY1BpvchcOk/YxypGWUHgJDr4ch2ZY=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/162] rxrpc: Fix key quota calculation for multitoken keys
Date: Mon, 20 Apr 2026 17:43:11 +0200
Message-ID: <20260420153932.814297792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit bdbfead6d38979475df0c2f4bad2b19394fe9bdc ]

In the rxrpc key preparsing, every token extracted sets the proposed quota
value, but for multitoken keys, this will overwrite the previous proposed
quota, losing it.

Fix this by adding to the proposed quota instead.

Fixes: 8a7a3eb4ddbe ("KEYS: RxRPC: Use key preparsing")
Closes: https://sashiko.dev/#/patchset/20260319150150.4189381-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ dropped hunk for rxrpc_preparse_xdr_yfs_rxgk() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/key.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -72,7 +72,7 @@ static int rxrpc_preparse_xdr_rxkad(stru
 		return -EKEYREJECTED;
 
 	plen = sizeof(*token) + sizeof(*token->kad) + tktlen;
-	prep->quotalen = datalen + plen;
+	prep->quotalen += datalen + plen;
 
 	plen -= sizeof(*token);
 	token = kzalloc(sizeof(*token), GFP_KERNEL);
@@ -303,6 +303,7 @@ static int rxrpc_preparse(struct key_pre
 	memcpy(&kver, prep->data, sizeof(kver));
 	prep->data += sizeof(kver);
 	prep->datalen -= sizeof(kver);
+	prep->quotalen = 0;
 
 	_debug("KEY I/F VERSION: %u", kver);
 
@@ -340,7 +341,7 @@ static int rxrpc_preparse(struct key_pre
 		goto error;
 
 	plen = sizeof(*token->kad) + v1->ticket_length;
-	prep->quotalen = plen + sizeof(*token);
+	prep->quotalen += plen + sizeof(*token);
 
 	ret = -ENOMEM;
 	token = kzalloc(sizeof(*token), GFP_KERNEL);


