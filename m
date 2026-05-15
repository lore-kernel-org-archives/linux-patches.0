Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D76739734B;
	Fri, 15 May 2026 16:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861748; cv=none; b=MjxijIsxNsqVxLPKnZzeDU2y+aHghtS3lEA3EEumLY5amMUK+bb2hNNrOPTlblKXPPR4HVtos6kun8oemuBeL2X7OMK1UGcR4PPvs623rCuVzaZ6ppGEbApH6iN99nZDVarsSte/xEBSX27PV3gHdel+Q1iNi2uPmoeKIikrnx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861748; c=relaxed/simple;
	bh=0MHDFAamYLudCQg9B9vP5UF0wk7ckX8qcQ5xThuAdBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtk5jNL0gCR0qsigE/j3mJQC8DWOAmQOcnrIKEitaoWhYLLvQBN7jmtUmW/YBxDNLTPwIbbC2xomtWcvH/rx0ny2zfSk5p5SOCWwjY97eUrjg6GjZYsuP+1ZWmKZOAMvcq+eloXSmkrGjCA0B4TNt6FUN5aLL7tSfF4TUKVUmWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+BIcRvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+BIcRvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28D1C2BCFA;
	Fri, 15 May 2026 16:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861748;
	bh=0MHDFAamYLudCQg9B9vP5UF0wk7ckX8qcQ5xThuAdBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+BIcRvWWCXo8dl4OdQw/8wcjgJ0gXotChlFn1xeaNbYoHH8AQ1c+lsjnGpCGiX/U
	 NGOi3vS4CoL0597mVhreBocmawCAQw5A0hH/yIhvU+t9kIsdRPTK+74IpcZXrKGD8K
	 8c+laNRmzuGwL7ee1G/olO2QNoD04AGgvnIQVawc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 448/474] rxrpc: Also unshare DATA/RESPONSE packets when paged frags are present
Date: Fri, 15 May 2026 17:49:17 +0200
Message-ID: <20260515154724.784448172@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit aa54b1d27fe0c2b78e664a34fd0fdf7cd1960d71 upstream.

The DATA-packet handler in rxrpc_input_call_event() and the RESPONSE
handler in rxrpc_verify_response() copy the skb to a linear one before
calling into the security ops only when skb_cloned() is true.  An skb
that is not cloned but still carries externally-owned paged fragments
(e.g. SKBFL_SHARED_FRAG set by splice() into a UDP socket via
__ip_append_data, or a chained skb_has_frag_list()) falls through to
the in-place decryption path, which binds the frag pages directly into
the AEAD/skcipher SGL via skb_to_sgvec().

Extend the gate to also unshare when skb_has_frag_list() or
skb_has_shared_frag() is true.  This catches the splice-loopback vector
and other externally-shared frag sources while preserving the
zero-copy fast path for skbs whose frags are kernel-private (e.g. NIC
page_pool RX, GRO).  The OOM/trace handling already in place is reused.

Fixes: d0d5c0cd1e71 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_event.c |    4 +++-
 net/rxrpc/conn_event.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -461,7 +461,9 @@ bool rxrpc_input_call_event(struct rxrpc
 
 		if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
 		    sp->hdr.securityIndex != 0 &&
-		    skb_cloned(skb)) {
+		    (skb_cloned(skb) ||
+		     skb_has_frag_list(skb) ||
+		     skb_has_shared_frag(skb))) {
 			/* Unshare the packet so that it can be modified by
 			 * in-place decryption.
 			 */
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -231,7 +231,8 @@ static int rxrpc_verify_response(struct
 {
 	int ret;
 
-	if (skb_cloned(skb)) {
+	if (skb_cloned(skb) || skb_has_frag_list(skb) ||
+	    skb_has_shared_frag(skb)) {
 		/* Copy the packet if shared so that we can do in-place
 		 * decryption.
 		 */


