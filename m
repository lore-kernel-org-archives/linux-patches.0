Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9668D34F483;
	Mon,  4 May 2026 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903169; cv=none; b=bguwzt5LEOmWkYLkWrt9onJ4StRWkvqNXlNL1p3x/28EwmT1oHKIeR43TP96Ihmi4j0wB2LuDMinGswm8nhac9RrJzTUVQOUaCSmAIEQj1zFlt1FcK2HfdnrrinNAvgkixPW22u+t/tNT8ai3QRE0CE15+b6vEkHD/RDERrHNDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903169; c=relaxed/simple;
	bh=5nQ15gfxv2sLvCn5beSGlsl4BCid57GEJVUodAndDgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzuAlAnonzpE3xdkM6p89jJ+g/mqFE8pQp2yPU6qJR0XymejjRwBugwahm15diGDC8VL1yI6yDC8V0QtDIbDO8eWm/F3WU3fvIHVLRbhelX11YcnEf+B411RxpvDXBxXqs9xZATutHJSattKeIHx32o33u3KVanNumAb5d8bdWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKy0n58f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKy0n58f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE73C2BCB8;
	Mon,  4 May 2026 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903169;
	bh=5nQ15gfxv2sLvCn5beSGlsl4BCid57GEJVUodAndDgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKy0n58fd5k3cIf2QqxazazSfVZ7hRrZZSdFG/7xypvxuviUeBvAJH/aXV4wENprh
	 goaoP5km9V60wJEgK+hZRJY0TdrcUIv13UEXonviNTAxGhdGSv+mCyq2ltVCWKT4qN
	 P45OEOfp/cehNqVlVPUECK2/FdsuaB8WpR5Ma3Cg=
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
Subject: [PATCH 7.0 129/307] rxrpc: Fix rxkad crypto unalignment handling
Date: Mon,  4 May 2026 15:50:14 +0200
Message-ID: <20260504135147.646330000@linuxfoundation.org>
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
@@ -37,6 +37,7 @@
 	EM(rxkad_abort_1_short_encdata,		"rxkad1-short-encdata")	\
 	EM(rxkad_abort_1_short_header,		"rxkad1-short-hdr")	\
 	EM(rxkad_abort_2_short_check,		"rxkad2-short-check")	\
+	EM(rxkad_abort_2_crypto_unaligned,	"rxkad2-crypto-unaligned") \
 	EM(rxkad_abort_2_short_data,		"rxkad2-short-data")	\
 	EM(rxkad_abort_2_short_header,		"rxkad2-short-hdr")	\
 	EM(rxkad_abort_2_short_len,		"rxkad2-short-len")	\
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -510,6 +510,9 @@ static int rxkad_verify_packet_2(struct
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_header);
 
+	/* Don't let the crypto algo see a misaligned length. */
+	sp->len = round_down(sp->len, 8);
+
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
@@ -543,8 +546,10 @@ static int rxkad_verify_packet_2(struct
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


