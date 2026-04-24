Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26C72DCF52;
	Fri, 24 Apr 2026 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037600; cv=none; b=OmA6FfYAJPxQgTGZprw05i4QDej/JyFc29LUBvbHJHLl8DC6KeObP3iylGJC6HO78zf8poCY31b09U8tStwGnTh/QDiVXE2MkivKkhiYM0KUlwSJA8uAO8iZoG5Yqp5LqxM+EqoTE1lPtAzBAYZz8tCP9860+Zi8cY6LAA99ZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037600; c=relaxed/simple;
	bh=h6apT4mkNFf858xAgYxp9bha/8tqtvQjIJNJNWlLvEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gtpzoz5QbYOha8oGw3qCKzPAn3kDcpLjxU5aG59iMR1iM5QZVkwDPHC9awLfcposOvdVyo0nHcjSCHN+TitmWjmLzhqlsX0aIn9iYpnHD8MkDpxhMDS8E/LP0zMAST3FsTyt36fWaXao6UGMslylagzM52HrfV/MbcpU9uGWRKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJhl2plP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJhl2plP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2CBC19425;
	Fri, 24 Apr 2026 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037600;
	bh=h6apT4mkNFf858xAgYxp9bha/8tqtvQjIJNJNWlLvEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJhl2plPNGa+mN4uRfWYIdz19JkUwi4UbR02E9r1pNe5be+NHrIrU4WSge4fTjFz7
	 wn3aanUccARrFMXvUvQwe7RCbvobo9x1qdNa7KXga71yhMouuZouhmYoQ9sOm/blmq
	 mVjWMjCkeO2gfa+EiS5w38HrfiHnxzsPyo8fnjB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 41/42] rxrpc: Fix missing validation of ticket length in non-XDR key preparsing
Date: Fri, 24 Apr 2026 15:31:06 +0200
Message-ID: <20260424132429.137518447@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

From: Anderson Nascimento <anderson@allelesecurity.com>

commit ac33733b10b484d666f97688561670afd5861383 upstream.

In rxrpc_preparse(), there are two paths for parsing key payloads: the
XDR path (for large payloads) and the non-XDR path (for payloads <= 28
bytes). While the XDR path (rxrpc_preparse_xdr_rxkad()) correctly
validates the ticket length against AFSTOKEN_RK_TIX_MAX, the non-XDR
path fails to do so.

This allows an unprivileged user to provide a very large ticket length.
When this key is later read via rxrpc_read(), the total
token size (toksize) calculation results in a value that exceeds
AFSTOKEN_LENGTH_MAX, triggering a WARN_ON().

[ 2001.302904] WARNING: CPU: 2 PID: 2108 at net/rxrpc/key.c:778 rxrpc_read+0x109/0x5c0 [rxrpc]

Fix this by adding a check in the non-XDR parsing path of rxrpc_preparse()
to ensure the ticket length does not exceed AFSTOKEN_RK_TIX_MAX,
bringing it into parity with the XDR parsing logic.

Fixes: 8a7a3eb4ddbe ("KEYS: RxRPC: Use key preparsing")
Fixes: 84924aac08a4 ("rxrpc: Fix checker warning")
Reported-by: Anderson Nascimento <anderson@allelesecurity.com>
Signed-off-by: Anderson Nascimento <anderson@allelesecurity.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-7-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/key.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -502,6 +502,10 @@ static int rxrpc_preparse(struct key_pre
 	if (v1->security_index != RXRPC_SECURITY_RXKAD)
 		goto error;
 
+	ret = -EKEYREJECTED;
+	if (v1->ticket_length > AFSTOKEN_RK_TIX_MAX)
+		goto error;
+
 	plen = sizeof(*token->kad) + v1->ticket_length;
 	prep->quotalen += plen + sizeof(*token);
 


