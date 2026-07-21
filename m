Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C693346AA69;
	Tue, 21 Jul 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647979; cv=none; b=GyJ1b2omem+jhB5NgVEZukhs05F+sqcNBpU5xmYLCsuolYAX3cpIld5lFhcGAwJz3A/Y/w2H1NYrTeGF8qFcmDlTic+IPWG1uXreSoV5Ij1tGZsWXsqIVqvkJtqNsrHMsw+wS3Npxk7UYmld1CH/XRyk1cKEA0jfp7uNU4PivSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647979; c=relaxed/simple;
	bh=Z4xkQ+xjcyb02DYQCrz7f5bw4kRk6n/WS3iCOovJ/LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnyAltcZevesxC3KNnrAH08+xM9HPTd6ugPtA41czQP09lBahKyTgnq4NBnnTf1tk68rr7Pt3w/2fmFaaQRQPiaE4bvqsGwhgTE+sj9LDKQzPAQrnfvWWCxz3+zalfD7qaHvdq1Uks6lzjlBL9mqmc6AS18QUgZDEL8KtBzMrRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6ii6zeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6ii6zeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D77C1F000E9;
	Tue, 21 Jul 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647978;
	bh=WidZE20E0REpV4rFvGGeY5gDuF7IT5ANE+hWX99l0JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6ii6zeMSa75q17/B9LdjyCvXAdjGb6rpX8/UPevkrC9s6S86ZpIS7cU1+mITUPSW
	 UTxs5GZZG5lDn0LRpJyb3g2K+DK5tHgQFR1pjw5KVc00+KjLRTrWhjMBzL+zpkTOpA
	 mdvO2rDyIBKvSngZdSHamMa4ek33SnE+CMaxAwUw=
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
Subject: [PATCH 7.1 0026/2077] rxrpc: Fix leak of released call in recvmsg(MSG_PEEK)
Date: Tue, 21 Jul 2026 16:54:59 +0200
Message-ID: <20260721152553.291426900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 4bdb9e471f5b1ac9cbe4add5de7ff085a0ec303c upstream.

Fix rxrpc_recvmsg() to also drop the ref it holds on an already-released
call if MSG_PEEK is in force (the function holds a ref on the call
irrespective of whether MSG_PEEK is specified or not).

Fixes: 962fb1f651c2 ("rxrpc: Fix recv-recv race of completed call")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-11-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -528,8 +528,7 @@ try_again:
 	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
 		rxrpc_see_call(call, rxrpc_call_see_already_released);
 		mutex_unlock(&call->user_mutex);
-		if (!(flags & MSG_PEEK))
-			rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
 		goto try_again;
 	}
 


