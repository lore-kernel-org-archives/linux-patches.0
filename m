Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E241271443;
	Mon, 13 Apr 2026 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096604; cv=none; b=EHSenRk2nLF3XpisyfD0ExtZFFbCBBehFwZ021pzpb4LWu+7hOhY4j1PiBjs8YCydR6NSocfhA1FkUV3gVwkNFLc2pqkG2d71SrIh/ocsSGZozUbFZXlOtUA3ag4RWIrrIfucUK8ZKY7ibCPZBqbSka/0c2SnBbUAk2qcTZje+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096604; c=relaxed/simple;
	bh=sIDkZwJcLE2C2+UtN1UkMljPsJFwQvMIxF6gkonzsmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK/1BvlF3uDWe2KwVfw/SGNE4RMP0dv3xueswNFhITjndIHJIZDassCcp+Bb6KrjaXuoj8BHIt6LvymUinwUQEenkYT+eoAIa5ICIgHG4MLZGyXjigeoES/Ya1Gipp7p1vjkTgFn0URIQLy6tIxju0JGpqi7DU8uowQMcDShj5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5uj8AiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5uj8AiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91FBC2BCAF;
	Mon, 13 Apr 2026 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096604;
	bh=sIDkZwJcLE2C2+UtN1UkMljPsJFwQvMIxF6gkonzsmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5uj8AiX5Lpfe2MIJP0kOukC90+zIR0s14Mu6H9TdJr1UW1sNfptTAz6tXBywEWvP
	 6WJiAP59RWEUX07APeknKxmG736JZkVZgh0/uIjf3OQbd6dO7NNzKZQFMg+V03mbIr
	 jcznFW/qqEMrlHixcm18siTCvwMrcyKYK+wt13zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	Willy Tarreau <w@1wt.eu>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 74/83] rxrpc: fix oversized RESPONSE authenticator length check
Date: Mon, 13 Apr 2026 18:00:42 +0200
Message-ID: <20260413155733.761065289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Keenan Dong <keenanat2000@gmail.com>

commit a2567217ade970ecc458144b6be469bc015b23e5 upstream.

rxgk_verify_response() decodes auth_len from the packet and is supposed
to verify that it fits in the remaining bytes. The existing check is
inverted, so oversized RESPONSE authenticators are accepted and passed
to rxgk_decrypt_skb(), which can later reach skb_to_sgvec() with an
impossible length and hit BUG_ON(len).

Decoded from the original latest-net reproduction logs with
scripts/decode_stacktrace.sh:

RIP: __skb_to_sgvec()
  [net/core/skbuff.c:5285 (discriminator 1)]
Call Trace:
 skb_to_sgvec() [net/core/skbuff.c:5305]
 rxgk_decrypt_skb() [net/rxrpc/rxgk_common.h:81]
 rxgk_verify_response() [net/rxrpc/rxgk.c:1268]
 rxrpc_process_connection()
   [net/rxrpc/conn_event.c:266 net/rxrpc/conn_event.c:364
    net/rxrpc/conn_event.c:386]
 process_one_work() [kernel/workqueue.c:3281]
 worker_thread()
   [kernel/workqueue.c:3353 kernel/workqueue.c:3440]
 kthread() [kernel/kthread.c:436]
 ret_from_fork() [arch/x86/kernel/process.c:164]

Reject authenticator lengths that exceed the remaining packet payload.

Fixes: 9d1d2b59341f ("rxrpc: rxgk: Implement the yfs-rxgk security class (GSSAPI)")
Signed-off-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: Willy Tarreau <w@1wt.eu>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-14-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxgk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/rxgk.c
+++ b/net/rxrpc/rxgk.c
@@ -1224,7 +1224,7 @@ static int rxgk_verify_response(struct r
 
 	auth_offset	= offset;
 	auth_len	= ntohl(xauth_len);
-	if (auth_len < len)
+	if (auth_len > len)
 		goto short_packet;
 	if (auth_len & 3)
 		goto inconsistent;


