Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB95315785;
	Mon,  4 May 2026 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904548; cv=none; b=o88+Q6k31XnUFKZgn9GLezHXo6Dnipfpvc9IwGKb4xF+2pymy4qq6o5rHpoeiRzbh5X/D/Atw1TnVxcFm+jPQnl1WFdd+9oRTlD9+yf9hQVS6l7CQaOjyZIvEWY/Yt3H3jdr70ihAD463hP4VZtWhUZ7C7pk2HmWKiQ0nVF3G+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904548; c=relaxed/simple;
	bh=ONP5wEt3EGdx32MedifyZn8Tq3nR2w6WdPY3GjwE8JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obrDYRI+UaDJQHHe4N6PD4gulPakcs3q+gNar+K0GzVwy91Ipi9dnfg3OqtXq5qKRWQUJqhZMnOE/RjglRKfeffLN12ZOXzXOlQMmaDv6iav4IIjDiGTZrCgzeLXt9HNN2obzpc/XdeuOLlrBhV9RzWb5fuZay8j24GkqdOTtt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/bbjENh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/bbjENh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838F6C2BCB8;
	Mon,  4 May 2026 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904547;
	bh=ONP5wEt3EGdx32MedifyZn8Tq3nR2w6WdPY3GjwE8JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/bbjENhsN10LzyOgEe6wtBVrIh8sLCk3ScGLVJiEBNy8cX9Jj141t1y8sBSdcGj+
	 0WbBsHiLW2DxThH01H1bvi4LsX4q+YSnyCiHe1VIr+v6LgUXTPponiyqOWFN8pwP74
	 +uUHaH2fQ1KC5NbaydJVBVppdatLYhUmInuR6vOc=
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
Subject: [PATCH 6.12 082/215] rxrpc: Fix rxkad crypto unalignment handling
Date: Mon,  4 May 2026 15:51:41 +0200
Message-ID: <20260504135133.157365048@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

commit def304aae2edf321d2671fd6ca766a93c21f877e upstream.

Fix handling of a packet with a misaligned crypto length.  Also handle
non-ENOMEM errors from decryption by aborting.  Further, remove the
WARN_ON_ONCE() so that it can't be remotely triggered (a trace line can
still be emitted).

Fixes: f93af41b9f5f ("rxrpc: Fix missing error checks for rxkad encryption/decryption failure")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/rxkad.c            |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -36,6 +36,7 @@
 	EM(rxkad_abort_1_short_encdata,		"rxkad1-short-encdata")	\
 	EM(rxkad_abort_1_short_header,		"rxkad1-short-hdr")	\
 	EM(rxkad_abort_2_short_check,		"rxkad2-short-check")	\
+	EM(rxkad_abort_2_crypto_unaligned,	"rxkad2-crypto-unaligned") \
 	EM(rxkad_abort_2_short_data,		"rxkad2-short-data")	\
 	EM(rxkad_abort_2_short_header,		"rxkad2-short-hdr")	\
 	EM(rxkad_abort_2_short_len,		"rxkad2-short-len")	\
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -494,6 +494,9 @@ static int rxkad_verify_packet_2(struct
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_header);
 
+	/* Don't let the crypto algo see a misaligned length. */
+	sp->len = round_down(sp->len, 8);
+
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
@@ -527,8 +530,10 @@ static int rxkad_verify_packet_2(struct
 	if (sg != _sg)
 		kfree(sg);
 	if (ret < 0) {
-		WARN_ON_ONCE(ret != -ENOMEM);
-		return ret;
+		if (ret == -ENOMEM)
+			return ret;
+		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
+					  rxkad_abort_2_crypto_unaligned);
 	}
 
 	/* Extract the decrypted packet length */


