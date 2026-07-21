Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99932175A74;
	Tue, 21 Jul 2026 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655526; cv=none; b=WhYit39C/g9iZQR6+v1VWn9V5djG5a4j3Ui8gt6XBONiGU0sctA+egpNE8f93ON4w0nu2KMKobRgvrUbbtR+DAI02uy0LOS+WBA/sMSEGKRX+wSmjGCDFOTeK2gN8UUzrufpoQH9HHgmgYCT2wEMUhplKKza5B61t7qv915QKvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655526; c=relaxed/simple;
	bh=Heh/PWCURRLm3MVKEi3og6XVy4M6J4ULCwqGZjm5f3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3SQUQDxZh9yiVtq9dmZvuUzzpQ8UnNig9bhfaEX8WoI9y+WpjMPLj1TnwLbXFM4HS+NtNR45eM3ILIMr7GTlIUcxUz1tV1G3SowUvQ8fDh0+1H1gtMeP0DS11KZEZbtTs2c60kJ1q4y+nzfnLMAqqLHTCc4XD9J4zd5Rk+0cXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK8h5b+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK8h5b+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A781F000E9;
	Tue, 21 Jul 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655525;
	bh=1hlXYUqWiWI7a9cb5cNFmmcw95QAt0fleoQ6spFiN9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cK8h5b+zVxiYzwwo6IzeThgPXIuQSx+EeQrSkxnxP0S2ptDmf0/gPT0U1rYnbdCUf
	 ZRaMmjzKhj0g3+oX6CoC7SciEVajF8DgrZSbuaeaA3A86J4onqiqEEBueUpYCgnS+R
	 y9pX9Qw0RpEic9nqh6PRZv9WehSaPgsCPWNG+6rk=
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
Subject: [PATCH 6.18 0041/1611] rxrpc: Fix socket notification race
Date: Tue, 21 Jul 2026 17:02:37 +0200
Message-ID: <20260721152515.746523132@linuxfoundation.org>
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

commit e66f8f32f50116670dbbee5bc9e692cd2cd0c8f8 upstream.

There's a race between rxrpc_recvmsg() and rxrpc_notify_socket(), whereby
the latter's attempt to avoid disabling interrupts and taking the socket's
recvmsg_lock if the call is already queued may happen simultaneously with
the former's discarding of a call that has nothing queued.

Fix this by removing the shortcut.  Note that this only affects userspace's
use of AF_RXRPC; the AFS filesystem driver doesn't use the socket queue.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-10-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -27,8 +27,6 @@ void rxrpc_notify_socket(struct rxrpc_ca
 
 	_enter("%d", call->debug_id);
 
-	if (!list_empty(&call->recvmsg_link))
-		return;
 	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
 		rxrpc_see_call(call, rxrpc_call_see_notify_released);
 		return;


