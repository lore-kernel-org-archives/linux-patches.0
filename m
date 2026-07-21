Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B56F46AA6A;
	Tue, 21 Jul 2026 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647974; cv=none; b=skkV/+E/bvO33JCTSe9P2loCykNf5SCibL9hgrrZwdoZS7BF0BbSFnch8wXH1DZedqpiHe6jor8uNrUSTm80wJXKQUrQ2IOa1a02XEmmpE8Z4P/z0ISaO9jisHY38eS6BRA1OriirSVCuUVBdvyrzAhYnaAoA2sgGXio6SMTgHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647974; c=relaxed/simple;
	bh=wIHtTDfH2/H9GE0cw03lQDGVpjnaoigXVbkxaZ1Cj5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaKjaYBsXU80Kv0Yf59J2/edYXlTaGOlNJHPc8kw3+Er6f+r9PiMD/a08ggMtHB3aGnCyWbKQedE/rDrFuKk67Fg+JIHzHnSF/RIgMWm3f7VL3FCjm9cpVdi11gaLQ1J9Mz3z5aXNqL29UgAeueu+1LcvSkzbqRSuP/pQpgb8U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw9EvzNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw9EvzNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0073A1F000E9;
	Tue, 21 Jul 2026 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647973;
	bh=Oa65vmMtlGZX11dOzrqS7qq1ojhv7FHiTH/ONWoEoCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dw9EvzNHkl9xy80jwaWmMixfTR+8EeQqKi5BrNcgZQfia5rg8+GPS4djEE65EJfgE
	 Z0Z7mUuOCdJuGIKQPS3jHLs4rNHVc808J9kfJT0r0ULF1oB8KaKY4uhjxtXJNxanVm
	 K6zUZRljfBaVWJbnmtjYhZJWV/xgRJWiIszUubd8=
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
Subject: [PATCH 7.1 0024/2077] rxrpc: Fix UAF in rxgk_issue_challenge()
Date: Tue, 21 Jul 2026 16:54:57 +0200
Message-ID: <20260721152553.241469555@linuxfoundation.org>
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
 net/rxrpc/rxgk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -687,16 +687,17 @@ static int rxgk_issue_challenge(struct r
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


