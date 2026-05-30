Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD3339863;
	Sat, 30 May 2026 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159445; cv=none; b=g32/bnWx64Ux+9wbJCPcn3LJvQa/9YtAOeRJ4TpTzLt8JGPCPhF2qHIq5ZWZFaMCUphxcJUq14v2fd3aCAzsi7Nzw5BxwVojI4Z9KS/j6/0LociAozSPC9dfIQH29eemUxVqxw9u+uBWsQvbY1+YWshtRIQAUuXWLi/MWol9/WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159445; c=relaxed/simple;
	bh=7FZgLsBS0ZKafVtffNTIZQ3Dc6Odq423UFi1eCagj6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4aeomDoQ9NAkjR7qGQrgxWyPlraWEiJMej+OotopjH1IXTw1tP+pYFClcVT84HEpBoOjdsDZxdilBwSDizIaZR0KuaLEqan0pBX8k2Er50y+R4Hxp1ewMXiytTkZp89dYqiRkvI9Cuzzv7sALicrxJ9cAsM+2lAkRxDUcrkCIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAyLCPHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAyLCPHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564CA1F00893;
	Sat, 30 May 2026 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159444;
	bh=8MJ4s+FBU06kuLYGdqvZkYYMY16M2czraux9QIq5Suk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAyLCPHvxpePB5bxjagxxeAQlffrv3wcEuToaOAFVaGRBesPv2kaPiIINDVC6QYhf
	 7CpLUmKw1tEFuiUHqqjS9ULw7h4syruKUsN78sdnqrCps2F+hy6hmrZPi8xHdPnR48
	 Cwzroy75xImOs8WSrP08UnuxS6Ng/ETOjySJUA70=
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
Subject: [PATCH 6.1 124/969] rxrpc: Fix key quota calculation for multitoken keys
Date: Sat, 30 May 2026 17:54:08 +0200
Message-ID: <20260530160303.942542524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


