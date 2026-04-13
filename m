Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E524DCF6;
	Mon, 13 Apr 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096635; cv=none; b=Et6RCpFA2HbANaQHIS4Rn5jK/sXdQaDuzQlWYerVKTTr0uKCyfNDtCCC10ZMAWmAogcp4C4TGNzJB6jfUn9Z3UDKn5KcsyPoSe/0ufiVesnq3neiI/TC9zRDpmEKzvBTgMk83KgRhh0QCEfydWdTg5EWScjpR8ABXifZ3TRlPr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096635; c=relaxed/simple;
	bh=/AuKbfnlcbIFeRZoJ0oGf24eLbnRV81TKQ0al8qzFEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSc2JFaDiWlJ8jnMC2I4u0dYnhGCQopNc8zilV4zvVFpUCNFK7gFbnXaswgkMLH8NTIFSslZpOAqCkx92as8MB8s/aJ+EyqySLcAQO3WrCRFnDjwhCLdSxz1sw7KJbdfXhWFQlCiwP7Jap26WhsNnJ9cNKgRgDXmqpsfkMFhFXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVTCuC5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVTCuC5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BD7C2BCAF;
	Mon, 13 Apr 2026 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096635;
	bh=/AuKbfnlcbIFeRZoJ0oGf24eLbnRV81TKQ0al8qzFEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVTCuC5STUti3Ob17QGFOBrFBE3m4xI7bCh8Z7f02+zRq5AAXDEdWBmAmp+R0Fi9Q
	 HybMTPDqQesyRbnj0NLLOqIZ4HKOc5cbcvD1u8UTw16UVBVt91ZMrP7Qekv48wApY0
	 uiMv/BCKX64bDm6pbnTwP3Dy7b7B048GrK7dvZuM=
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
Subject: [PATCH 6.18 80/83] rxrpc: Fix buffer overread in rxgk_do_verify_authenticator()
Date: Mon, 13 Apr 2026 18:00:48 +0200
Message-ID: <20260413155733.978757968@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

commit f564af387c8c28238f8ebc13314c589d7ba8475d upstream.

Fix rxgk_do_verify_authenticator() to check the buffer size before checking
the nonce.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Closes: https://sashiko.dev/#/patchset/20260401105614.1696001-10-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-20-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1085,6 +1085,9 @@ static int rxgk_do_verify_authenticator(
 
 	_enter("");
 
+	if ((end - p) * sizeof(__be32) < 24)
+		return rxrpc_abort_conn(conn, skb, RXGK_NOTAUTH, -EPROTO,
+					rxgk_abort_resp_short_auth);
 	if (memcmp(p, conn->rxgk.nonce, 20) != 0)
 		return rxrpc_abort_conn(conn, skb, RXGK_NOTAUTH, -EPROTO,
 					rxgk_abort_resp_bad_nonce);
@@ -1098,7 +1101,7 @@ static int rxgk_do_verify_authenticator(
 	p += xdr_round_up(app_len) / sizeof(__be32);
 	if (end - p < 4)
 		return rxrpc_abort_conn(conn, skb, RXGK_NOTAUTH, -EPROTO,
-					rxgk_abort_resp_short_applen);
+					rxgk_abort_resp_short_auth);
 
 	level	= ntohl(*p++);
 	epoch	= ntohl(*p++);


