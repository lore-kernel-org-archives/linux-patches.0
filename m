Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705413;
	b=2JwK1jMEQ2tKnutHXLSji0fENkXELUStzYa+NFJeknJS4NtbxZ+NXLItnNc34aft4fOk
	 OdrT5c8P6razd/UYJoxoKafAQQWkTxUwmQO+BWGEl2vaJeiMWP5jc0ICutBiG+F12ymoJ
	 zq2JavFkV59abVYGOp/nlQv0HX130ZavAvefT/IA5TTIUUJPRP4lo3YYzVBM9LgoNzSt7
	 FahQ8SRC8m3x3hBTLqZgFKy3t4+5OiVAUmqBz3A/Nhh6ozX4XHgbdFqVXfXCpciy4oFDi
	 /ybArfTub4rUUamSUIg7a9YYyP0zaUte6/23hekwC8S+QoWlsxa+7kyBx8a5yG9p5MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wIUy7Wg+N5k0c4lN0cPz2MgdapzgDTGp1jH6W+jFMg0=;
	b=ab6v3g8uGg7fq3RAwv5+9kRag6mTROlQLDbK3MEdATmvoa7guJlil72DzMNP6kuqpOE8
	 QKojXjCF+WE56G97fZ2txcYpdbV7jKNc5HkGdOJf0z63F6Z9YVZbK8A3peJWTuRAPNvoL
	 MGWKQtUj38vlb2xmIUh4K5TPqlGBEoYBq9dGAbmrga3N6zyjvIsWkmtDkSZltcRx0ig6W
	 omzLV21ZCLJi2uAPy4tb2kTAPmqPTkaEQA0oBl1OAZ23NoGGxLrD0dygaYNS8YaeWTPSG
	 BwHQo5gTxl9woxODIwuZp4X1VPmQNUdRuG81KXd8veiQSXuxMKlewUdWQd42qoOGqtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIG9+gPq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBD8606A323;
	Thu, 26 Nov 2026 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIG9+gPq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1E21F000D1;
	Thu, 26 Nov 2026 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705412;
	bh=wIUy7Wg+N5k0c4lN0cPz2MgdapzgDTGp1jH6W+jFMg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIG9+gPqBQfH5eNAzKD+PnD2GPBs7XTiqhu6SKloHTgVKBz0ymX1qgglvhohHcUVt
	 HX3Yr2B5Yi7Qd4r/RuL6Up7ryHfdB719z7O3agZryybDo2d/6qYGBX0K3R+Htd4fyI
	 iQaHJs8OQWVB7j/zFF1YRjuxbZXdYfbI8xb3san8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 190/319] tls: only install push_pending_record for a TX context
Date: Thu, 26 Nov 2026 15:39:18 +0100
Message-ID: <20261126144011.035000459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2567,7 +2567,8 @@ int tls_set_sw_offload(struct sock *sk,
 		}
 	}
 
-	ctx->push_pending_record = tls_sw_push_pending_record;
+	if (tx)
+		ctx->push_pending_record = tls_sw_push_pending_record;
 
 	rc = crypto_aead_setkey(*aead, key, keysize);
 


