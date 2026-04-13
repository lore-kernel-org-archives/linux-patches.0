Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FA232ABC0;
	Mon, 13 Apr 2026 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099733; cv=none; b=FmlH6WG1/srT+1k8sA4zNg8GMLUhFL4qiJiyD9pU9XLLevApd9bSUkbZCiEcfz33u2qYxfNvposXkbV7wfeFId6oxrbdLrdRehmxDjn87fdf53RW1jt9pk8eCEl9T1DyOpl5kitlzIob2/QB89fnGSrW3L49Rbl8y9Wrw0RCjsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099733; c=relaxed/simple;
	bh=OQt2TxnjaFhJKnyXvOlM1+1Gmga7O2nFuLQGUy/gSGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaR66TMtuM+dyYJ7OCNLb2T8o2KnHI4gRC27nao38jzHau6R2ESRXLItLfbQT2VKybHmN+I2G/ayXXrgoPDIppBnrGzojHdFXYtJpJJqpR4EK+vm7wBIkq8oL54ccfrsOSmtIwxyk2/dg3T3bairjBc66S4NtXOLxUT7VSaafBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJnVxcXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJnVxcXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E153C2BCAF;
	Mon, 13 Apr 2026 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099733;
	bh=OQt2TxnjaFhJKnyXvOlM1+1Gmga7O2nFuLQGUy/gSGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJnVxcXp9aj6kX87wSSV/bI2dmQirWluffYb7DZuNH5RN6kWxoulmERO+XoKup3u4
	 I9/pHSt5d5GciUb7jWU0YH0uWP+15zI4BuHj5wMRgWtkqhcs7fnpOF0RvcABBXOqbO
	 w3YmVbul37uknWO6hDDjDCuBEVJOrVp+IKCJXe1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Anderson Nascimento <anderson@allelesecurity.com>,
	Luxiao Xu <rakukuip@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 452/491] rxrpc: Fix key/keyring checks in setsockopt(RXRPC_SECURITY_KEY/KEYRING)
Date: Mon, 13 Apr 2026 18:01:37 +0200
Message-ID: <20260413155835.958077507@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 2afd86ccbb2082a3c4258aea8c07e5bb6267bc2f upstream.

An AF_RXRPC socket can be both client and server at the same time.  When
sending new calls (ie. it's acting as a client), it uses rx->key to set the
security, and when accepting incoming calls (ie. it's acting as a server),
it uses rx->securities.

setsockopt(RXRPC_SECURITY_KEY) sets rx->key to point to an rxrpc-type key
and setsockopt(RXRPC_SECURITY_KEYRING) sets rx->securities to point to a
keyring of rxrpc_s-type keys.

Now, it should be possible to use both rx->key and rx->securities on the
same socket - but for userspace AF_RXRPC sockets rxrpc_setsockopt()
prevents that.

Fix this by:

 (1) Remove the incorrect check rxrpc_setsockopt(RXRPC_SECURITY_KEYRING)
     makes on rx->key.

 (2) Move the check that rxrpc_setsockopt(RXRPC_SECURITY_KEY) makes on
     rx->key down into rxrpc_request_key().

 (3) Remove rxrpc_request_key()'s check on rx->securities.

This (in combination with a previous patch) pushes the checks down into the
functions that set those pointers and removes the cross-checks that prevent
both key and keyring being set.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Closes: https://sashiko.dev/#/patchset/20260401105614.1696001-10-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Anderson Nascimento <anderson@allelesecurity.com>
cc: Luxiao Xu <rakukuip@gmail.com>
cc: Yuan Tan <yuantan098@gmail.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-16-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/af_rxrpc.c |    6 ------
 net/rxrpc/key.c      |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -614,9 +614,6 @@ static int rxrpc_setsockopt(struct socke
 			goto success;
 
 		case RXRPC_SECURITY_KEY:
-			ret = -EINVAL;
-			if (rx->key)
-				goto error;
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
@@ -624,9 +621,6 @@ static int rxrpc_setsockopt(struct socke
 			goto error;
 
 		case RXRPC_SECURITY_KEYRING:
-			ret = -EINVAL;
-			if (rx->key)
-				goto error;
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -903,7 +903,7 @@ int rxrpc_request_key(struct rxrpc_sock
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->key)
 		return -EINVAL;
 
 	description = memdup_sockptr_nul(optval, optlen);


