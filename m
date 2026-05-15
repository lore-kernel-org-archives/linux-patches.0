Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC568305663;
	Fri, 15 May 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860771; cv=none; b=K4W0rh3igf8C/uswsv3vq6KLrw79ixauglVW7g/46OaJXHSf4IbjtqdTccVokEabiqrYBaH93E3LriDmPYeNf5biKu5xk8eCbc9sYELH7mTr2BT4KWMc3dPcGBLL1enEuGLhPm234iPLFo/K3mYr/3nn2Buq4XwLaVDQFmnZUiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860771; c=relaxed/simple;
	bh=sHl4Rvk/tvk419R89X6CXRUBCKjDwjwlrf6RT6AhlGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFpspYGB79MXUmUo4SbIsNad7zXrvdMFKyWcBUPTBkpQ5VzOZZ4Jnc4PEud1W2YuHaOY5fVq46VubvSO9Qr+tMNeFtvhVliRp4Oz+Id3Qe/5+82YDYTYxHl4FdEOC2vli5GxSRq5aYp8VsZ5e2oshh0+WM3aRWqMnVqIMaPIh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGOWr/fx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGOWr/fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62691C2BCB0;
	Fri, 15 May 2026 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860771;
	bh=sHl4Rvk/tvk419R89X6CXRUBCKjDwjwlrf6RT6AhlGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGOWr/fxoEx9Mh1Rw4DjpddKcKfhXPcP1uitaGJQytlGpa1+ZtxBR9GMu40kOaZWU
	 XkVevCF+R9RdAIoYLIdN++sxby1jJkLeCgIqcQMyQEE1r5TkinWikp8Gpu1rK4zBCY
	 fn4yxjzJlFQlFxV5EKkn+D8l9Kfk3Mefii3KWnPQ=
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
Subject: [PATCH 6.6 066/474] rxrpc: Fix rxkad crypto unalignment handling
Date: Fri, 15 May 2026 17:42:55 +0200
Message-ID: <20260515154716.470575017@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -492,6 +492,9 @@ static int rxkad_verify_packet_2(struct
 		return rxrpc_abort_eproto(call, skb, RXKADSEALEDINCON,
 					  rxkad_abort_2_short_header);
 
+	/* Don't let the crypto algo see a misaligned length. */
+	sp->len = round_down(sp->len, 8);
+
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
@@ -525,8 +528,10 @@ static int rxkad_verify_packet_2(struct
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


