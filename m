Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AFF3112C0;
	Mon, 13 Apr 2026 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098481; cv=none; b=THK56Xzo39Su0lzmYK9tHBoOonYTypMhWEwywwrzfyg3NBv2IjRyri0pP+qTmfPwCDAExowNm7qvsiVZHLmIIQV8YsLQ82y1/SoAj0YzXqXxU1JkaQee3009a42yBI6ntE4dFIGUBM72hdnOzsfSaFVCVBPUUaqRHZQ7UfETdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098481; c=relaxed/simple;
	bh=aUQlTrquwWMTvYtYADs/7301wj90NeKxT3u/taOE7x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DruJZvuj9XHxUJ7UV0ZHjQlVViq0dRvLYH1Ayf+9RwrpsdlFDFbdWCu/mqJMXa41CUXQZxZvSjPa+p83fKVZXKJK8+BOCKMxW/AdJh4qhRTmHxA2cunE1DfB6VX8tCVJHLXv56c8RZZmTPW0BSKnIwuFKfIR53iiDkheA2iZCwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3P8XnKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3P8XnKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3C6C2BCAF;
	Mon, 13 Apr 2026 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098481;
	bh=aUQlTrquwWMTvYtYADs/7301wj90NeKxT3u/taOE7x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3P8XnKpqCydp3T/Z8eYvcOhvPc+k71bgLklNUjneFcd8w7dX2cqjo3Lgc0lWBk5W
	 XWwDLHNxH43Y2FBldfiUaejh+sTgcMn/0wqeNLCZEI9vf5TOnr15pRLgzcV+0g8GJD
	 3FOxZzsSg0BEd/syUSeChP0x+SrQSMFH40Nuw6fQ=
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
Subject: [PATCH 5.15 540/570] rxrpc: Fix key/keyring checks in setsockopt(RXRPC_SECURITY_KEY/KEYRING)
Date: Mon, 13 Apr 2026 18:01:11 +0200
Message-ID: <20260413155850.673355098@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -615,9 +615,6 @@ static int rxrpc_setsockopt(struct socke
 			goto success;
 
 		case RXRPC_SECURITY_KEY:
-			ret = -EINVAL;
-			if (rx->key)
-				goto error;
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
@@ -625,9 +622,6 @@ static int rxrpc_setsockopt(struct socke
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
@@ -452,7 +452,7 @@ int rxrpc_request_key(struct rxrpc_sock
 
 	_enter("");
 
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->securities)
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1 || rx->key)
 		return -EINVAL;
 
 	description = memdup_sockptr_nul(optval, optlen);


