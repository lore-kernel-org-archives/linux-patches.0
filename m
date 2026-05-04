Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FD83DE43F;
	Mon,  4 May 2026 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903639; cv=none; b=QQ0grnCyRzYWK+P78ltysffFnZfbKCCMaJ8OMTQ+4DwdihyWR4mRalbnrhoQu9p39CdveHdhdyA0XbEZgze5tVZFDExlsQUMw+fYWUhpNAqjsMlMPCF7has8vyTReyDpJYLIB6mZv1QIyVv+T3mMNJNn5+MfJTnlq+GmAcZEswU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903639; c=relaxed/simple;
	bh=HWegSQt77CbCFkE/XFRumkKPkXTaJcGDn7ZMBURBFng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7M4q20/TDL06fX2MTAKY01vmzF5oVHRMkmT2iJT9ruPTGq0pyXvjD6Wtw4VuIJoFuuR10OgtRG0KBbRU6ZBfoMMDiE9zIVRRUZsTE0L+ud775cdViR0GglBCATWxVKWXv/YvEC7NAfwXp+Oxbr/q+fpo3R65fCH8BQ+XM3/goY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRGLvTLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRGLvTLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C883C2BCB8;
	Mon,  4 May 2026 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903639;
	bh=HWegSQt77CbCFkE/XFRumkKPkXTaJcGDn7ZMBURBFng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRGLvTLTg+OlhNZ/Is+ARdF6cEFTWe1EoFzxGP5PxnTCJ/O/KlqaSL6bH5s3whxMp
	 +GqURDxRlF326GaZkDUkYfdgE3CJFzTLcgm8p2sbCaFQ04XX5x4mzGZ97wkdl/x/mW
	 AfeLKmpnZzTHr5yEac+UycTCrFtUGVLUOQbBJU24=
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
Subject: [PATCH 7.0 281/307] rxgk: Fix potential integer overflow in length check
Date: Mon,  4 May 2026 15:52:46 +0200
Message-ID: <20260504135153.364123460@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 6929350080f4da292d111a3b33e53138fee51cec upstream.

Fix potential integer overflow in rxgk_extract_token() when checking the
length of the ticket.  Rather than rounding up the value to be tested
(which might overflow), round down the size of the available data.

Fixes: 2429a1976481 ("rxrpc: Fix untrusted unsigned subtract")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-6-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk_app.c    |    2 +-
 net/rxrpc/rxgk_common.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/rxgk_app.c
+++ b/net/rxrpc/rxgk_app.c
@@ -214,7 +214,7 @@ int rxgk_extract_token(struct rxrpc_conn
 	ticket_len	= ntohl(container.token_len);
 	ticket_offset	= token_offset + sizeof(container);
 
-	if (xdr_round_up(ticket_len) > token_len - sizeof(container))
+	if (ticket_len > xdr_round_down(token_len - sizeof(container)))
 		goto short_packet;
 
 	_debug("KVNO %u", kvno);
--- a/net/rxrpc/rxgk_common.h
+++ b/net/rxrpc/rxgk_common.h
@@ -34,6 +34,7 @@ struct rxgk_context {
 };
 
 #define xdr_round_up(x) (round_up((x), sizeof(__be32)))
+#define xdr_round_down(x) (round_down((x), sizeof(__be32)))
 #define xdr_object_len(x) (4 + xdr_round_up(x))
 
 /*


