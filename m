Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B481F3C3425;
	Sat, 30 May 2026 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165691; cv=none; b=djjWJggWgJCi4SLAbOsmOJ9I6PYYFa8IxoGRCdheYoyiVrunL3T9EKwyz7ef2FwWAFzbIaz5KgORHUexRzSJ5SyHNMQk9V4qLksLIs2dGiw6T/zdYGa7Hrs/YNPyCisoGivFfmwodpCD7PeW12VhUp1ycRjzANhX5R/ZMLTv+hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165691; c=relaxed/simple;
	bh=darWRC4vbreeCrw7jKXqe6YD79VYHJQAiNenBleNpG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2UA8CDQpolhs/1079kgf6K7GgPQlgu3Oot6TQ63YYFCmGrETCLm606Top+b65u601alTjCRsNYgMjtx0QgGr7yuxMCxRiftOd5mlnjAIgf4/UyX5we57Ic8e48QJtlAxF/oWRHgByVYweHLNQd3echAn5voaswrefWBGV/9Dvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1KxqtDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1KxqtDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F421F00893;
	Sat, 30 May 2026 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165690;
	bh=pzhxrbqOV0YKWdTu9rSV08dIgE3B3b+fNe+Wq5DxD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1KxqtDALr9sBcwvfDXXK/XrI6fpdpEDhG90jFLVIdCeFAb5z8wxF9/npOJGnACJW
	 spxXO3UZk5LnYpws+LWnkw/PXNkpC+oLJjxcunG6eu8Y63S8ZN8DIKjQLvpceaP/Eo
	 gOhus4WfDHDCWxfVsWGIks2gBiUSWWb2k5XcQ79s=
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
Subject: [PATCH 5.10 136/589] rxrpc: Fix missing validation of ticket length in non-XDR key preparsing
Date: Sat, 30 May 2026 18:00:17 +0200
Message-ID: <20260530160228.355304139@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -755,6 +755,10 @@ static int rxrpc_preparse(struct key_pre
 	if (v1->security_index != RXRPC_SECURITY_RXKAD)
 		goto error;
 
+	ret = -EKEYREJECTED;
+	if (v1->ticket_length > AFSTOKEN_RK_TIX_MAX)
+		goto error;
+
 	plen = sizeof(*token->kad) + v1->ticket_length;
 	prep->quotalen += plen + sizeof(*token);
 


