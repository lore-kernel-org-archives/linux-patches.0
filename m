Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4B2369D71;
	Tue, 21 Jul 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655529; cv=none; b=Sbx+VGVfhPdWLS+7sfzuwmGfe/s+PvfxZRNJmFdd8nIybaWguzCsjuYCZhgUETcs0BZTl20PSeFpb/HMrYwFXEUN45BFF6XNbyIQJQ56gai5n588UY3e7PJ5DR15HtS/yFD0L1v0SIHneIlfF5H6tWeIFuxlB5n/yP8LqtdKWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655529; c=relaxed/simple;
	bh=gsgLKAvGUn4TF4TregtiSrlLjhlUtXoveIth0yOBBCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLwH55pX7kR2jC15FZ5F8+yh2k4bNdR5WZiEFio1LawU8nx79/MTaPSgNey24UEMp77IFqmXHMw83jidX2+TVGSzZWyzcqg5+VDp3ijf6rq/q/EcfoXckhH3HqHNODebSwbgJbhB7gjkIahR9Yy0T5zeEgxsHeREorHK/dDVyIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHuQYY9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHuQYY9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D6F1F000E9;
	Tue, 21 Jul 2026 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655528;
	bh=VzVzT9NKr4IMB/QAEpju9v6rSoomYJ8Yb1WqG/HHXA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHuQYY9NqaLyaHm1xYbTqXi8hjjfjd+yqMjnftVvxALO3jyZxv7w2T5xpoU8/1BSC
	 L6N2XjQroUwyhZcwAHdyARvTjlzqS3EuFS4lsC+JQMR43m8VkVxiuCcFJ2nQzBWU0X
	 /45sCoZ4J3MkmQXv1R44xLq14ZO/LRR1Tj1UAFqo=
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
Subject: [PATCH 6.18 0042/1611] rxrpc: Fix leak of released call in recvmsg(MSG_PEEK)
Date: Tue, 21 Jul 2026 17:02:38 +0200
Message-ID: <20260721152515.769637383@linuxfoundation.org>
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
 


