Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DA46C4D9;
	Tue, 21 Jul 2026 19:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661401; cv=none; b=CQ9LNz4EWVnXU7xF8DJk3QAHlDBa3kSB25OTzQlbjY9HvuoA1N+1iQ67+KVzZEiJN3lPi55GwiENbGK8Xnywl/QCYkvXC/vT5wf5ZuD4RO8cx0vQdIju00Z5bCR8T/a8L7wlS2HF3bk0lWuLEIteQwV+7KRw8Wmy/vbGyeSVz0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661401; c=relaxed/simple;
	bh=N3JUzwBuTsRc34ZGwUvIE9AZSoSM4GUHklTVrSReuKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccPQfua67p8yvJ/mVl6XHKxme0j5PyDydZkqoT1PfSAO4+E2Ttyq0+EQ2pJVUBTbAwhi0/D6zFuhrG5vN5dh7AutlvlxfZVOc8MdIdhyUnfUxURsewt8Y3EhS2trdfAfQjtUN/8fjA6ze0aL36YjvGh0fRIL4D6A2FDCZ78w+2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REmgySJm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REmgySJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9621F00A3A;
	Tue, 21 Jul 2026 19:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661399;
	bh=DluTClKnw6y7HjKmJ4g/o4QJqwitgp9j0e2VrH9r2gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REmgySJmkcsEu+doCgOxTlMuZUvmfnvjAC+x/Xb6BukCe3iTPInVSEBANp4yhd4sP
	 PrHIKI5rorRwagWsA9zoGeBitc+BSeuaP/Tiw369u22CGZOtmDGIQ8PVw4cIIDunyo
	 iqFXsAHGwNoMSFUp+RTI7YZ7JdbFRjzPKkYjbmV8=
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
Subject: [PATCH 6.12 0053/1276] rxrpc: Fix leak of released call in recvmsg(MSG_PEEK)
Date: Tue, 21 Jul 2026 17:08:16 +0200
Message-ID: <20260721152447.271872353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -429,8 +429,7 @@ try_again:
 	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
 		rxrpc_see_call(call, rxrpc_call_see_already_released);
 		mutex_unlock(&call->user_mutex);
-		if (!(flags & MSG_PEEK))
-			rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
 		goto try_again;
 	}
 


