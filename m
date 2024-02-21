Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A6153816;
	Wed, 21 Feb 2024 13:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521267; cv=none; b=q3Y69dvJ3hisYbUMxle0hOyOC88ZdMk5COA9O5T+wibICCpS/JQHLJTGNFu6s1l+JrNpiMxqBgABjq2Q3MEGbHDjzkzZaPkMJEJ6G8n9PP9/CW4QQsJ5k6tXKE+tcyRtPM7sr3zKHzjQcTqVc3D0uMiS1fJ9btPZgYgA6cTroi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521267; c=relaxed/simple;
	bh=23KJecyOqZpNGqy1WWPhDY7N6cIJxa3D1uxMsIcfKzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhDAKBziHSTOhyYsTzc11k8i844P+cSYZ3IkmnGg74zQlgLSHMG7WylSLnt326YVAsOprEgoiLGLhd/pT8wrsCYgkKJHTK395Q6EBN7aac3pCYdRcahlqqgf/UoVzPL0Jp6bJI5IYHt2ue+iAfaLcMb/nvr4j6OddDwcR1YO6dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5i2rTSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5i2rTSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFA0C433F1;
	Wed, 21 Feb 2024 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521267;
	bh=23KJecyOqZpNGqy1WWPhDY7N6cIJxa3D1uxMsIcfKzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5i2rTSW1wJuIXTyRkLM5ZqnpMhhqa08xFqwr3ZZg3+uWdBNaljPXHHmKoF7OaFJx
	 aQVIhj5lMaJJXxDWBulIcUR6Yegv6bmTdg1yv43tF5T1iAyWHzw/H0Z4J88CNuZw5Q
	 bBU1YPN83wlzprGyS6ehDr11Ka3XhyfaIAYoD3l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/202] rxrpc_find_service_conn_rcu: fix the usage of read_seqbegin_or_lock()
Date: Wed, 21 Feb 2024 14:06:07 +0100
Message-ID: <20240221125933.964743421@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6da7c4bf15e8..4b1564824aed 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -29,7 +29,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *peer,
 	struct rxrpc_conn_proto k;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rb_node *p;
-	unsigned int seq = 0;
+	unsigned int seq = 1;
 
 	k.epoch	= sp->hdr.epoch;
 	k.cid	= sp->hdr.cid & RXRPC_CIDMASK;
@@ -39,6 +39,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *peer,
 		 * under just the RCU read lock, so we have to check for
 		 * changes.
 		 */
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&peer->service_conn_lock, &seq);
 
 		p = rcu_dereference_raw(peer->service_conns.rb_node);
-- 
2.43.0



