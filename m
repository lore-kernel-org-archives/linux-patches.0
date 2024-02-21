Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473907CF32;
	Wed, 21 Feb 2024 14:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525173; cv=none; b=Wqp+s8RL9N04W4p0Em15UofiViAvEHlz3b291dNnwyfXG11D8I8gmDUbRg0O4UFgD4Ik0RtVYyK9yHqcvjg9s2HxCusasznTKe6a/HGGGAVJRYraiWBM5f6SJcGGxo9KR5T5HtNOzETWxVBQrzT93CE5n5fSH9E+AXAdrwE5d1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525173; c=relaxed/simple;
	bh=XBxgJjzyNjc5gK+n+KJlVltN8YFbenOUdw5E0QxHWPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXJs2qCzzDZYRv/esdc1hAQDygqliaZpnjBhVFtj63XLesA5TpgzgrimoB0/KkbO0M7FKcy1EIkPvql1qNGwiIxMpABCyJrYl/hCJwQu8am5c8KrU/r2dhUG4cEKH3r1F1VeAuH/O7j7FslWIMA5hpXEN9C7ctsKDJMis3j+voE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDtiewiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDtiewiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CA1C43394;
	Wed, 21 Feb 2024 14:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525173;
	bh=XBxgJjzyNjc5gK+n+KJlVltN8YFbenOUdw5E0QxHWPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDtiewizDmC4oMPBXyl+Zu5625RmPM17oaOJfudERP7WVijLTbXQah+7SyAvqJvFw
	 Vb9/dahhSfaSWBr1wagO23m0sJ1wAqHV+qqflzGBl+6Ov0UaeLwPelP1k4lfP+wBCM
	 jnA3XbdC/gJP1ONHUXkL7fLEs5GoSEMiXVsEE+MQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/267] rxrpc_find_service_conn_rcu: fix the usage of read_seqbegin_or_lock()
Date: Wed, 21 Feb 2024 14:07:02 +0100
Message-ID: <20240221125942.517058090@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 21da48e3d2e5..7ad4b4e9341e 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -25,7 +25,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *peer,
 	struct rxrpc_conn_proto k;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rb_node *p;
-	unsigned int seq = 0;
+	unsigned int seq = 1;
 
 	k.epoch	= sp->hdr.epoch;
 	k.cid	= sp->hdr.cid & RXRPC_CIDMASK;
@@ -35,6 +35,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *peer,
 		 * under just the RCU read lock, so we have to check for
 		 * changes.
 		 */
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&peer->service_conn_lock, &seq);
 
 		p = rcu_dereference_raw(peer->service_conns.rb_node);
-- 
2.43.0



