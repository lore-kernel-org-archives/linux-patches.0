Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DAE3FE67B;
	Tue, 21 Jul 2026 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655519; cv=none; b=Uck5fu+FNa8RlQkAC0R+z+l4YND6mKf7MeFU46uUTsrF+Lll8VUFqd6srj+P4E3nIZbezCZ3tKB6W1rjFD8AwoIE4bzjFt4cw6nEvClX7OPolcUW9WWn0dFTu6+uh4MFmUpdVyfTIQvkrRERT0wjp/qiy7sM3VtUbiWA+xWVPyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655519; c=relaxed/simple;
	bh=Y5B4+vz2tsI5BFiQAKPtg2mTj0uxLVPegjJA7UWjFIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO7Tgp5c1OWWrRKu12f+ksjCBLmDFKbi4mIy6M36JiOJMtg8CeMmUxJEljchX1wJOSK0gVgT6xhK3haIXcjdAoudNFtA28TF93bpna12RlN+IECkHu8maYO7ue0FfGavrhcPEjP5cWT2PdZDBbz94JmtgB7QqvWrONq08uiXfo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl8XIcaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl8XIcaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7691F000E9;
	Tue, 21 Jul 2026 17:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655517;
	bh=Ms6e9DjdzJi34tM54VhfDy9pykKs8a0hNYUPqeRBFYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bl8XIcaU/TJgA/yWSiqgXebXrs9NDS8A11Tnxnfb6HpkZUmOe/Y1oeLhV3W06W75p
	 QeLC1NLBeIfOdmX+3cqjcAVW3NusYd/BD6CbXKr1LB/2CbPFPUUeMJ+g+ntZ+JAUtH
	 LRqXaWfKHcGl1ZRikE2R40k25O5XaHrQ1RiRaft0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0038/1611] rxrpc: rxrpc_verify_data ensure rx_dec_buffer alloc
Date: Tue, 21 Jul 2026 17:02:34 +0200
Message-ID: <20260721152515.676974601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jeffrey Altman <jaltman@auristor.com>

commit 16c8ae9735c5bd7e54dd7478d6348e0fc860842d upstream.

rxrpc_recvmsg_data() calls rxrpc_verify_data() whenever the
rxrpc_call.rx_dec_buffer is unallocated and assumes that upon
successful return that rx_dec_buffer must be allocated.
However, rxrpc_verify_data() does not request an allocation if
the rxrpc_skb_priv.len is zero.

In addition, failure to allocate rx_dec_buffer will result in a
call to skb_copy_bits() with a NULL destination which can
trigger a NULL pointer dereference.

To prevent these issues rxrpc_verify_data() is modified to
always attempt to allocate the rxrpc_call.rx_dec_buffer if it
is NULL.

This issue was identified with assistance of a private
sashiko instance.

Fixes: d2bc90cf6c75cb ("rxrpc: Fix DATA decrypt vs splice() by copying data to buffer in recvmsg")
Reported-by: Simon Horman <simon.horman@redhat.com>
Signed-off-by: Jeffrey Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jiayuan Chen <jiayuan.chen@linux.dev>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260609140911.838677-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -161,7 +161,7 @@ static int rxrpc_verify_data(struct rxrp
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	int ret;
 
-	if (sp->len > call->rx_dec_bsize) {
+	if (sp->len > call->rx_dec_bsize || !call->rx_dec_buffer) {
 		/* Make sure we can hold a 1412-byte jumbo subpacket and make
 		 * sure that the buffer size is aligned to a crypto blocksize.
 		 */


