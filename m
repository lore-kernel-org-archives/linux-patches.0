Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E553817E01C;
	Sun,  1 Sep 2024 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207811; cv=none; b=cUECtToeOkq/sFNP4tukwJpwDkg2tuxTcSqVCL0npNPe6jhh8ChFRHwwU6oYIDAoGOeYvtiA+SNRoWFd6n+hTSsk5ltXLh1u45h6RiWKm5fJXoTML3oXEkrygsmQGrohwxLPKHNbI6DGAx2m6z205GdMxLPfRn49VDHs7g/h+ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207811; c=relaxed/simple;
	bh=23I0cd51dko+ggd89i2uv+4AmOdTxIW9jNB57Oy/FvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXPos1eu4pHXXTvTkg5VjWkw3478iMqgeztRx6frTbTPDRc6Syw4sOgUS9tLH2zW65qRqVi876ydjeK7AZzEQpH7VbuXqRHsDoY/dkNkhAwkMj8gqMf1qMJFcpxYOWKowsQlDh+jl5guFnFUOjP4XNZ4WqfMGBtUvxh9fvYytbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgyZ6NW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgyZ6NW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFCAC4CEC3;
	Sun,  1 Sep 2024 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207810;
	bh=23I0cd51dko+ggd89i2uv+4AmOdTxIW9jNB57Oy/FvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgyZ6NW8rouxWnRCtUp1cu7JeR3/uJsGU1cVmVfIwgw7hOC8uQVWpVcUXdGGEN+2q
	 6w3+FSOQiOl6sac1u6mCRaJZO7JMbHRJf6PtmZAg36ryZ3bGyLpVm5rVcoMfQwjf/+
	 ErNAuPpohAXWYT74zcAH+9UbcECNx+HUN+Cu0VEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f9db6ff27b9bfdcfeca0@syzkaller.appspotmail.com,
	syzbot+dcd73ff9291e6d34b3ab@syzkaller.appspotmail.com,
	Allison Henderson <allison.henderson@oracle.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 4.19 84/98] net:rds: Fix possible deadlock in rds_message_put
Date: Sun,  1 Sep 2024 18:16:54 +0200
Message-ID: <20240901160806.866182551@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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
@@ -429,6 +429,7 @@ static int rds_still_queued(struct rds_s
 	struct sock *sk = rds_rs_to_sk(rs);
 	int ret = 0;
 	unsigned long flags;
+	struct rds_incoming *to_drop = NULL;
 
 	write_lock_irqsave(&rs->rs_recv_lock, flags);
 	if (!list_empty(&inc->i_item)) {
@@ -439,11 +440,14 @@ static int rds_still_queued(struct rds_s
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
@@ -752,16 +756,21 @@ void rds_clear_recv_queue(struct rds_soc
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


