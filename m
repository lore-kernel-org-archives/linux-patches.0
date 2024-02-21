Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CB34C62;
	Wed, 21 Feb 2024 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524139; cv=none; b=us4tr9E5VOMrGF6ViccfR78BwKPZALEeglWbH6GpSX+0orMZD7bcfiKpC475QSVSEzkiUxRbq4u8GkKgZAtAfqtL3Km3bFLumfywztxNyWdHOOW/flxGizrpRhDaNHPg9XFknYQwvgspIIBauXMF5kVkCrjxSp4FhYjEpdrD8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524139; c=relaxed/simple;
	bh=Nj5Rhs+DvfJUIFPC3uDB2lcpkyoe91pp8sjYr2YP7kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQ+xTOtLF+vvnlScTpkxRcNMKaIPTOZHm0g/3ZOz+OQvGw2mHvnJ5yam48LMZAPwG1WxZM4Kkck7bbkg2rGLX320Ooc9yO4bLZnGY0lpu71At9rMsGC/r+xXK4gu7uocHX/9EE28aObmU4Oc8GQT+pdRiFB61ic7ct6C0elrV9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW2RYWn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW2RYWn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503E1C433C7;
	Wed, 21 Feb 2024 14:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524139;
	bh=Nj5Rhs+DvfJUIFPC3uDB2lcpkyoe91pp8sjYr2YP7kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW2RYWn7Lk14zlcCr1rQLr+ZRdTVYFK9VsMGvvk3/D74a9i834sd5WPUHV/XY8OMz
	 Kn10NF6FpCJGJdsGI5ata68K3krd+n+ANuhqLWD9Qt2jqqCPBemHoCqi03CpeXrOH+
	 eTeeIXsHUY3Mq6FwOIs4UMzt+ZDzwMn5P0bvZglY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/379] rxrpc_find_service_conn_rcu: fix the usage of read_seqbegin_or_lock()
Date: Wed, 21 Feb 2024 14:05:06 +0100
Message-ID: <20240221125958.685564764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit bad1a11c0f061aa073bab785389fe04f19ba02e1 ]

rxrpc_find_service_conn_rcu() should make the "seq" counter odd on the
second pass, otherwise read_seqbegin_or_lock() never takes the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20231117164846.GA10410@redhat.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_service.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 68508166bbc0..af0e95ef992d 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -31,7 +31,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *peer,
 	struct rxrpc_conn_proto k;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rb_node *p;
-	unsigned int seq = 0;
+	unsigned int seq = 1;
 
 	k.epoch	= sp->hdr.epoch;
 	k.cid	= sp->hdr.cid & RXRPC_CIDMASK;
@@ -41,6 +41,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *peer,
 		 * under just the RCU read lock, so we have to check for
 		 * changes.
 		 */
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&peer->service_conn_lock, &seq);
 
 		p = rcu_dereference_raw(peer->service_conns.rb_node);
-- 
2.43.0



