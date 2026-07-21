Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA35363081;
	Tue, 21 Jul 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655524; cv=none; b=nNEgsStcoLJmpmiGPkEffr+lMLZgcQyguTZstyF65Av8FH7jwbk8xrdeonncS1Mfy8opFzxipvd0+4xFfMieDZCPERnLtHnjHYdROq2xFFAaZKzDkL5vMdv6u/4LjV7lbC8mU97zQE49sM5k+go5wKMt09hBiVjifmpUKKFlW2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655524; c=relaxed/simple;
	bh=iF9NIuORxCdWdIlW7+RbGuasJSBRVtEPA941tRe3DY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoeOcQgbst6sqepkA2TPCpQINbCfsh6pgmxhZRaUfdogtVme8bV7F7sqY9IaYnHBDPexGD9K62vwOrFBhnCqLRvOjtSbf0RdJ/DRPjqVfpKW1rgfry35xlINjmqieQMVaQfK+ViUMZJy9S/HKPgEi+n0nTHyaQhqVtE3SA+pV6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vw1uwn80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vw1uwn80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630801F000E9;
	Tue, 21 Jul 2026 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655522;
	bh=EPd0LtmrQ6l0nNIHWOEBNrBTCvfnIg6/C5cWD/BhGs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vw1uwn800q7g224edT8bBp/5U6cATcgTohXKe2TQgghUzLxU16N1IY7FYJB9EHtR2
	 vacMqOXZgzk+WEvQAEGxlR73z3jtp+DP+WFa7qoMcjdOJIJRayrZ7zQyblA3FB6ZNb
	 n9BmcdF6GItnhwKEdpnhAW1cLs4uiNxy9D3alPXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0040/1611] rxrpc: Fix UAF in rxgk_issue_challenge()
Date: Tue, 21 Jul 2026 17:02:36 +0200
Message-ID: <20260721152515.724762161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 107a4cb0d47e735830f852d83970d5c81f8e1e08 upstream.

Fix rxgk_issue_challenge() to free the page containing the challenge
content after invoking the tracepoint as the whdr passed to the tracepoint
points into the page just freed.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260609140911.838677-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/rxgk.c b/net/rxrpc/rxgk.c
index a1ee102abae1..77a67ace1d24 100644
--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -687,16 +687,17 @@ static int rxgk_issue_challenge(struct rxrpc_connection *conn)
 	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
 	if (ret > 0)
 		rxrpc_peer_mark_tx(conn->peer);
-	__free_page(page);
 
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
 				    rxrpc_tx_point_rxgk_challenge);
+		__free_page(page);
 		return -EAGAIN;
 	}
 
 	trace_rxrpc_tx_packet(conn->debug_id, whdr,
 			      rxrpc_tx_point_rxgk_challenge);
+	__free_page(page);
 	_leave(" = 0");
 	return 0;
 }
-- 
2.55.0



