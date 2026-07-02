Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874C5349AF5;
	Thu,  2 Jul 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010683; cv=none; b=sWtgQLVQV+irPpAlRhNkzWI3xCTrJnmIrbrH8bZvXBDEDIlj0uhBQS+3YTh2las0HQorbzMLybBAW0a2H3yHJtdjeZySg/DEXOQwB52s+yEaAB8d4gtWXOijjry0yMyRdtyPB5ocfOkawqIfVg6bWS7kUDzOHunSEQPXeGoBldI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010683; c=relaxed/simple;
	bh=yGccLPnugoLSZExTHXq8bu4PJR3DSRVdSl37DKm49hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlEGk6HTy+aiXxg5JGQWBp5Tr/i6XpthCbh6sZWr8QejeSG+FMUSUe6ouj+e3gKDN2Wrqi5tXr2AurPCcHB2CpIXInQFNuxksLsYtAqDk5vEljEj4tfOXX07jiuCJucycT00VkvHuPNINNgTjIsmV8Uke4tJP4lhgzATIdJFLjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwxBIJEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwxBIJEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F6F1F000E9;
	Thu,  2 Jul 2026 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010682;
	bh=Ge6zidX8PcmCNPZDaFgo5i1U8Wgj4Cb6PPpTusJ4WbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwxBIJEwVjDOD80zQS6Ofs5KXhAa1o7PQeskoByjy1meRprVUCDrcsJFf4NUxkaBz
	 JUi2DdHrYMdRldaX1tokd18TmUapBeUGRBqPTBn8czxLtH1imOqUUFTG7m8zSoKtix
	 PN3N4yDyF6ZGjvAaBjCgELqEI2RNBeRrlbFEZnKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 200/204] net/tcp-ao: fix use-after-free of key in del_async path
Date: Thu,  2 Jul 2026 18:20:57 +0200
Message-ID: <20260702155122.854608923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: HanQuan <eilaimemedsnaimel@gmail.com>

commit 5ba9950bc9078e19b69cca1e56d1553b125c6857 upstream.

In tcp_ao_delete_key(), the del_async path skips the current_key
and rnext_key validity checks present in the synchronous path,
assuming these pointers are always NULL on LISTEN sockets.  However,
if a key was added with set_current=1/set_rnext=1 while the socket
was in CLOSE state, current_key and rnext_key will be non-NULL
after listen() transitions the socket to LISTEN.

When such a key is deleted with del_async=1, hlist_del_rcu() and
call_rcu() free the key without clearing the dangling pointers.
After the RCU grace period, getsockopt(TCP_AO_INFO) dereferences
current_key->sndid and rnext_key->rcvid from freed slab memory.

Clear current_key and rnext_key in the del_async path when they
reference the key being deleted.

Fixes: d6732b95b6fb ("net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)")
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260623015208.1191687-1-eilaimemedsnaimel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1777,6 +1777,10 @@ static int tcp_ao_delete_key(struct sock
 	 * them and we can just free all resources in RCU fashion.
 	 */
 	if (del_async) {
+		if (ao_info->current_key == key)
+			WRITE_ONCE(ao_info->current_key, NULL);
+		if (ao_info->rnext_key == key)
+			WRITE_ONCE(ao_info->rnext_key, NULL);
 		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
 		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
 		return 0;


