Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704533;
	b=IHJ93AXfifOe+S2ELyqugoMJkAt6kxjCdiG8L8lrz7jjOAD3gGmzqRH8IO1iclyRSGlG
	 yrofLtf6tBTUHobnV+imlZurk2px3coFpIT3AdXW2jglpyzQdnatcjyJYAawAMYkCyHNW
	 jKf7VknI8ur0ruFo8qGQVsCgTMEhk7OkckyapqtceUPS0FnuMWL266PcILD4VDCuuLuZd
	 VzXIGFVVvNP3W2FWSp8ueK1LOTP3B3MmtvyMCknsMF+UxihU1Yo4ic8Z/DRBgQH5mm4QL
	 jggJ8haaJNLXcpFy7EvzZdP7XXVOHeNOMdfU0jAGlAOVBDVRC5S0f1ZuLn4mbVaTfSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRmeYFhhxIaS62HLSYHgJzNzED0FHPk2NE2g/otCqKI=;
	b=mMN+bX6ySAOsDKrdxrYieK6s7azq56wFj4bRPJEvRVQ4VmJceeZnNb40rQOuAuVregIV
	 CQfYzSkeb43qBWZEiLqb+tDaijZfcupmtZEo1LJuyEe4RU8DSRGOXPXhG09ulYfvQgieR
	 jzUrUUoXotCRgK0Jtdy2c2UZ4dHKS8IBhl9R2rCIWKkMJ9sR4sFwn9jU55ATQnpao40CI
	 NV3S0Eaw6F0mcYhBOAFsjy/JB4ZOlJz2F29vnDth8xUt1b27VYGxbzm6NMAaNvyLAgUI/
	 Lk+HLmnDEyeBuDdrZ3UeOp+CebeSZlBm5r45B1r3LQQs4r6Y8pm9YO48rFkLzWDCiZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gM9+8fIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44448606A31C;
	Thu, 26 Nov 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gM9+8fIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E7D1F000CF;
	Thu, 26 Nov 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704532;
	bh=fRmeYFhhxIaS62HLSYHgJzNzED0FHPk2NE2g/otCqKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM9+8fILM0HkBZIOnuIwkMARLIIRhc8RYkfTpFrOwT7DUyi/wx/oRbwuEWyJDQ9tO
	 zfM9PKzvlyz2jCcvX5eDxwYCIxnqt7uBamke7c5VM85BT4QWH+iJk8JdwYBehJbI8u
	 CjbKTX6LhV6F72QM9otEuFF0B4evdcozfEs1sPBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 158/265] tls: only install push_pending_record for a TX context
Date: Thu, 26 Nov 2026 15:38:08 +0100
Message-ID: <20261126143616.184690978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rishikesh Jethwani <rjethwani@purestorage.com>

commit c47e766c5307c06a78304582b2b5b5ab01ee1358 upstream.

tls_set_sw_offload() assigns ctx->push_pending_record for both
directions, but the hook is a TX-side dispatcher. On a socket whose TX
side is HW offloaded, tls_set_device_offload() installs
tls_device_push_pending_record(); any later TLS_RX setsockopt
overwrites it with tls_sw_push_pending_record(), because
tls_set_device_offload_rx() itself calls tls_set_sw_offload(sk, 0, NULL)
for the software half of a successful HW RX offload, and so does the
fallback when the RX offload is declined (NIC with TX-only offload,
tls_dev_add() failure).

>From then on tls_handle_open_record() (a TLS_SET_RECORD_TYPE cmsg after
a MSG_MORE send, or the close path with a pending writer) runs
tls_sw_push_pending_record() against priv_ctx_tx, which is a
struct tls_offload_context_tx, not a struct tls_sw_context_tx, and
reads open_rec from inside the offload context. On x86_64 without lock
debugging that field overlays sg_tx_data[2].dma_address, which is never
set, so the push is silently skipped and the data buffered by the
MSG_MORE send is later sent under the cmsg's record type, e.g.
application data in a handshake or alert record. Enabling
CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_LOCK_ALLOC and CONFIG_LOCKDEP, but
not CONFIG_LOCK_STAT, in the tested x86_64 configuration moves open_rec
over sg_tx_data[5].page_link. Once populated, its page pointer and
scatterlist flags are interpreted as a tls_rec pointer and dereferenced
while reading msg_plaintext.sg.size.

Only set the hook when initialising the TX side.

Found by code review while developing TLS 1.3 HW offload rekey support.

Tested with HW TLS TX and RX offload on Mellanox ConnectX-6 Dx (Crypto
Enabled): after setting TLS_RX, send() "AAAA" with MSG_MORE, then
sendmsg() "BBBB" with a TLS_SET_RECORD_TYPE cmsg for a handshake
record. Without this patch the peer receives a single handshake record
"AAAABBBB"; with it, an application data record "AAAA" followed by a
handshake record "BBBB".

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Rishikesh Jethwani <rjethwani@purestorage.com>
Link: https://patch.msgid.link/20261102213011.4191020-1-rjethwani@purestorage.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2539,7 +2539,8 @@ int tls_set_sw_offload(struct sock *sk,
 		}
 	}
 
-	ctx->push_pending_record = tls_sw_push_pending_record;
+	if (tx)
+		ctx->push_pending_record = tls_sw_push_pending_record;
 
 	rc = crypto_aead_setkey(*aead, key, keysize);
 


