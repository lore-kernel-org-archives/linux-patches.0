Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565652DEA6B;
	Mon, 13 Apr 2026 16:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096581; cv=none; b=Qh5/rx8d4D1z7OcLilXZaAag+1vR5IUdjp5Pn60SbplgsywrWraVOh9YFgptqz85nN2iuZTHj4WptN5GWUOTbtqPbOprW9RlNKjelIyKwrAiGO5TIo95FsfSdK1tHHAeFTrvaP2daae4aNywKex903DdtmYIV2sFo/h/Gt/chv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096581; c=relaxed/simple;
	bh=oxKZEX0OgjFnyKhE9B997rs+QfayqzJ/w4bIybw9M6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAjXu7PcjhzG0C/pUOFMtCZQ6VF7BI2lIYkHmd6OQuEe1ZOP/MjdmZKBRftl5nvjcpka0KRXSO8Yg0DDo1GaVR6me7//n/EY6Jlc4P8szmUqHsE6SBuDr7eizON2gN4SnqWmBNqHW11V/3JXOLZkeidQ2/ypUa0V4B99o4PM+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMMiSZmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMMiSZmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEC7C2BCAF;
	Mon, 13 Apr 2026 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096581;
	bh=oxKZEX0OgjFnyKhE9B997rs+QfayqzJ/w4bIybw9M6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMMiSZmWjqNbnfsPZy4WbfszwrPRqFqyYJfZ+3ZnmlpWpJMSPL21M00+QnDHRh7ms
	 GmqPP5W+okC1g2lT5i1nODNZ0AzG58ap+vSU24mOZBeWgjmFyUy/3KzWhX8JqSljfD
	 neup0CooT3LMMZ+sB4ThiiABdjTZ0FXHrP/HSQOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 66/83] rxrpc: Fix RxGK token loading to check bounds
Date: Mon, 13 Apr 2026 18:00:34 +0200
Message-ID: <20260413155733.470618621@linuxfoundation.org>
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

From: Oleh Konko <security@1seal.org>

commit d179a868dd755b0cfcf7582e00943d702b9943b8 upstream.

rxrpc_preparse_xdr_yfs_rxgk() reads the raw key length and ticket length
from the XDR token as u32 values and passes each through round_up(x, 4)
before using the rounded value for validation and allocation.  When the raw
length is >= 0xfffffffd, round_up() wraps to 0, so the bounds check and
kzalloc both use 0 while the subsequent memcpy still copies the original
~4 GiB value, producing a heap buffer overflow reachable from an
unprivileged add_key() call.

Fix this by:

 (1) Rejecting raw key lengths above AFSTOKEN_GK_KEY_MAX and raw ticket
     lengths above AFSTOKEN_GK_TOKEN_MAX before rounding, consistent with
     the caps that the RxKAD path already enforces via AFSTOKEN_RK_TIX_MAX.

 (2) Sizing the flexible-array allocation from the validated raw key
     length via struct_size_t() instead of the rounded value.

 (3) Caching the raw lengths so that the later field assignments and
     memcpy calls do not re-read from the token, eliminating a class of
     TOCTOU re-parse.

The control path (valid token with lengths within bounds) is unaffected.

Fixes: 0ca100ff4df6 ("rxrpc: Add YFS RxGK (GSSAPI) security class")
Signed-off-by: Oleh Konko <security@1seal.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-6-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/key.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 26d4336a4a02..77237a82be3b 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -13,6 +13,7 @@
 #include <crypto/skcipher.h>
 #include <linux/module.h>
 #include <linux/net.h>
+#include <linux/overflow.h>
 #include <linux/skbuff.h>
 #include <linux/key-type.h>
 #include <linux/ctype.h>
@@ -171,7 +172,7 @@ static int rxrpc_preparse_xdr_yfs_rxgk(struct key_preparsed_payload *prep,
 	size_t plen;
 	const __be32 *ticket, *key;
 	s64 tmp;
-	u32 tktlen, keylen;
+	size_t raw_keylen, raw_tktlen, keylen, tktlen;
 
 	_enter(",{%x,%x,%x,%x},%x",
 	       ntohl(xdr[0]), ntohl(xdr[1]), ntohl(xdr[2]), ntohl(xdr[3]),
@@ -181,18 +182,22 @@ static int rxrpc_preparse_xdr_yfs_rxgk(struct key_preparsed_payload *prep,
 		goto reject;
 
 	key = xdr + (6 * 2 + 1);
-	keylen = ntohl(key[-1]);
-	_debug("keylen: %x", keylen);
-	keylen = round_up(keylen, 4);
+	raw_keylen = ntohl(key[-1]);
+	_debug("keylen: %zx", raw_keylen);
+	if (raw_keylen > AFSTOKEN_GK_KEY_MAX)
+		goto reject;
+	keylen = round_up(raw_keylen, 4);
 	if ((6 * 2 + 2) * 4 + keylen > toklen)
 		goto reject;
 
 	ticket = xdr + (6 * 2 + 1 + (keylen / 4) + 1);
-	tktlen = ntohl(ticket[-1]);
-	_debug("tktlen: %x", tktlen);
-	tktlen = round_up(tktlen, 4);
+	raw_tktlen = ntohl(ticket[-1]);
+	_debug("tktlen: %zx", raw_tktlen);
+	if (raw_tktlen > AFSTOKEN_GK_TOKEN_MAX)
+		goto reject;
+	tktlen = round_up(raw_tktlen, 4);
 	if ((6 * 2 + 2) * 4 + keylen + tktlen != toklen) {
-		kleave(" = -EKEYREJECTED [%x!=%x, %x,%x]",
+		kleave(" = -EKEYREJECTED [%zx!=%x, %zx,%zx]",
 		       (6 * 2 + 2) * 4 + keylen + tktlen, toklen,
 		       keylen, tktlen);
 		goto reject;
@@ -206,7 +211,7 @@ static int rxrpc_preparse_xdr_yfs_rxgk(struct key_preparsed_payload *prep,
 	if (!token)
 		goto nomem;
 
-	token->rxgk = kzalloc(sizeof(*token->rxgk) + keylen, GFP_KERNEL);
+	token->rxgk = kzalloc(struct_size_t(struct rxgk_key, _key, raw_keylen), GFP_KERNEL);
 	if (!token->rxgk)
 		goto nomem_token;
 
@@ -221,9 +226,9 @@ static int rxrpc_preparse_xdr_yfs_rxgk(struct key_preparsed_payload *prep,
 	token->rxgk->enctype	= tmp = xdr_dec64(xdr + 5 * 2);
 	if (tmp < 0 || tmp > UINT_MAX)
 		goto reject_token;
-	token->rxgk->key.len	= ntohl(key[-1]);
+	token->rxgk->key.len	= raw_keylen;
 	token->rxgk->key.data	= token->rxgk->_key;
-	token->rxgk->ticket.len = ntohl(ticket[-1]);
+	token->rxgk->ticket.len = raw_tktlen;
 
 	if (token->rxgk->endtime != 0) {
 		expiry = rxrpc_s64_to_time64(token->rxgk->endtime);
@@ -236,8 +241,7 @@ static int rxrpc_preparse_xdr_yfs_rxgk(struct key_preparsed_payload *prep,
 	memcpy(token->rxgk->key.data, key, token->rxgk->key.len);
 
 	/* Pad the ticket so that we can use it directly in XDR */
-	token->rxgk->ticket.data = kzalloc(round_up(token->rxgk->ticket.len, 4),
-					   GFP_KERNEL);
+	token->rxgk->ticket.data = kzalloc(tktlen, GFP_KERNEL);
 	if (!token->rxgk->ticket.data)
 		goto nomem_yrxgk;
 	memcpy(token->rxgk->ticket.data, ticket, token->rxgk->ticket.len);
-- 
2.53.0



