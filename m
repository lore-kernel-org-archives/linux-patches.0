Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527CB208A7;
	Sun,  1 Sep 2024 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209817; cv=none; b=X7MFcqTyXl8fDyZ8BUpQM+7KUdgz8ojYxwylU+IbXDzJ9lfhmWTpzwxKiz03GQ/hmqjc31dcIA7hK68or4in6qmpip/A5yYvs6SmN0SSJTc5yrfwSOrrY2ICqlKGSmjWmF+R0cj8tzpOcpVbqiymG2wJ4ci/OquAYQ0P2EV9ipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209817; c=relaxed/simple;
	bh=IxyvVU8Ua8mA+wwl72xSTZ7E9OSSH9VtYJuvBzj149s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV1wCHeGOqBJUzh1EN2v5/fqvLYHqjNJ88FkiXb24vxcrj0veUnVj9expRm6Z8r+niFvWD9LaB+NCG2v43Y6azVcPegRvy3eyxxJuVzQicOGQKT7WsYJ7BS8k2AxcXL4B41jv1rM+7yCHT+ggamEYacHxE/4sHtgBFLXeBnKrQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4aFszDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4aFszDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D232C4CEC3;
	Sun,  1 Sep 2024 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209817;
	bh=IxyvVU8Ua8mA+wwl72xSTZ7E9OSSH9VtYJuvBzj149s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4aFszDaBnYVQCsLc5cfFoUEVWvb0AuQart+qCmVFqdnE0fqA6XKfJC7ugaTkd1TK
	 n5fHwr14ARgq5rRgn/3dT+eKWSz9ST3z8TNayAAAA4iEbHZ6isFuGyrxdAteuk0H36
	 MDQXvBGWJVJn/PWP90ibtmy5UbtGvJiwQo+wkEiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f9db6ff27b9bfdcfeca0@syzkaller.appspotmail.com,
	syzbot+dcd73ff9291e6d34b3ab@syzkaller.appspotmail.com,
	Allison Henderson <allison.henderson@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 133/151] net:rds: Fix possible deadlock in rds_message_put
Date: Sun,  1 Sep 2024 18:18:13 +0200
Message-ID: <20240901160819.109325002@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Allison Henderson <allison.henderson@oracle.com>

commit f1acf1ac84d2ae97b7889b87223c1064df850069 upstream.

Functions rds_still_queued and rds_clear_recv_queue lock a given socket
in order to safely iterate over the incoming rds messages. However
calling rds_inc_put while under this lock creates a potential deadlock.
rds_inc_put may eventually call rds_message_purge, which will lock
m_rs_lock. This is the incorrect locking order since m_rs_lock is
meant to be locked before the socket. To fix this, we move the message
item to a local list or variable that wont need rs_recv_lock protection.
Then we can safely call rds_inc_put on any item stored locally after
rs_recv_lock is released.

Fixes: bdbe6fbc6a2f ("RDS: recv.c")
Reported-by: syzbot+f9db6ff27b9bfdcfeca0@syzkaller.appspotmail.com
Reported-by: syzbot+dcd73ff9291e6d34b3ab@syzkaller.appspotmail.com
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Link: https://lore.kernel.org/r/20240209022854.200292-1-allison.henderson@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/recv.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -424,6 +424,7 @@ static int rds_still_queued(struct rds_s
 	struct sock *sk = rds_rs_to_sk(rs);
 	int ret = 0;
 	unsigned long flags;
+	struct rds_incoming *to_drop = NULL;
 
 	write_lock_irqsave(&rs->rs_recv_lock, flags);
 	if (!list_empty(&inc->i_item)) {
@@ -434,11 +435,14 @@ static int rds_still_queued(struct rds_s
 					      -be32_to_cpu(inc->i_hdr.h_len),
 					      inc->i_hdr.h_dport);
 			list_del_init(&inc->i_item);
-			rds_inc_put(inc);
+			to_drop = inc;
 		}
 	}
 	write_unlock_irqrestore(&rs->rs_recv_lock, flags);
 
+	if (to_drop)
+		rds_inc_put(to_drop);
+
 	rdsdebug("inc %p rs %p still %d dropped %d\n", inc, rs, ret, drop);
 	return ret;
 }
@@ -761,16 +765,21 @@ void rds_clear_recv_queue(struct rds_soc
 	struct sock *sk = rds_rs_to_sk(rs);
 	struct rds_incoming *inc, *tmp;
 	unsigned long flags;
+	LIST_HEAD(to_drop);
 
 	write_lock_irqsave(&rs->rs_recv_lock, flags);
 	list_for_each_entry_safe(inc, tmp, &rs->rs_recv_queue, i_item) {
 		rds_recv_rcvbuf_delta(rs, sk, inc->i_conn->c_lcong,
 				      -be32_to_cpu(inc->i_hdr.h_len),
 				      inc->i_hdr.h_dport);
+		list_move(&inc->i_item, &to_drop);
+	}
+	write_unlock_irqrestore(&rs->rs_recv_lock, flags);
+
+	list_for_each_entry_safe(inc, tmp, &to_drop, i_item) {
 		list_del_init(&inc->i_item);
 		rds_inc_put(inc);
 	}
-	write_unlock_irqrestore(&rs->rs_recv_lock, flags);
 }
 
 /*


