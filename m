Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430803264DC;
	Sat, 30 May 2026 16:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159781; cv=none; b=WdErZ8Uf9GUjm9Ebnn6+j5mgBfiOrmLtI1PmyzTYN98E3oL8iBZ6MicV10SgIoXexdCkIYZtJY8ACAdl+wmrwId4fIyqhjaa7Hqeq2JDjoPsdKGpgwowtQObIfCkLLSjhmw5v4rAGpwHDhIQS/O88ts+layNXtQkVbzGY+RBAjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159781; c=relaxed/simple;
	bh=jSNMkmh7G6WB1tu4XPssbj4eF9/RATSLASVMmfZgPUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxC/bZWWwC03/odem3N3q3GGNruc5HsDfer4pRPH48Qwd8vRwEhfxTFiVEbQo/FKdJOYI4Z4kDf9cLUiYU/LO9JgKYW9MSNwd7glnmzAKon69oRw5+Ke4WNrfx9V4FXLQSr+lnsQez1CqSkaDFT4crEPcXG/k9PVJ3AD+oJepPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY3FzQjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY3FzQjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865E81F00893;
	Sat, 30 May 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159780;
	bh=CvNslfQQ/FYCk6XhK9Gf7NdpDqMt9LxDzr/+csKt4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY3FzQjIGCcgdu8nzsTCBdFiwX4hqxW388lRP0Ktcz6NLT6RvQ5+yKZTe3d94gH+C
	 Ov+DbPX1CTAfbTN2MAWnEvbH9h6pNs68xgNiHg1EO3wYfc9rm4U70XhmsNi7PhlqbZ
	 ckAqTSyYBkNoTYhChsR7ghsUDPsVo1f7FV1SbNsE=
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
Subject: [PATCH 6.1 158/969] rxrpc: Fix missing validation of ticket length in non-XDR key preparsing
Date: Sat, 30 May 2026 17:54:42 +0200
Message-ID: <20260530160304.897014487@linuxfoundation.org>
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
@@ -340,6 +340,10 @@ static int rxrpc_preparse(struct key_pre
 	if (v1->security_index != RXRPC_SECURITY_RXKAD)
 		goto error;
 
+	ret = -EKEYREJECTED;
+	if (v1->ticket_length > AFSTOKEN_RK_TIX_MAX)
+		goto error;
+
 	plen = sizeof(*token->kad) + v1->ticket_length;
 	prep->quotalen += plen + sizeof(*token);
 


