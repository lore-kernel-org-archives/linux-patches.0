Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9AB3CFF66;
	Wed, 30 Sep 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794214; cv=none; b=OBqqtIalgV8j0qOBzvowRy06z2kwrB7UpYADVZMTXtcupAzTfC1STRZB/lRuH41nx4BxcbOxBojzObK4JlnPaTK9XxkV+JE1rpkvlAzcu8uOd2HBYmnIU6mpmLMU8a1Ti5oVLafGpkZT5nXy4eACrowVujG2iYHApU8UGtQuyhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794214; c=relaxed/simple;
	bh=iNq05gmP8ZIbfDjPE2myx/v84+Ppv8LQAOY+voUrUfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZj1TFBVbwYjIuNvRg8PfOm2oFHf4jTIcqrFGq9xS1DgsoyquoOrLoDeNaYJ2JZ9BwqyuYo9+VEjSzxT7Bh44jXDbjQA8LAMqC7/aY3j3p0/Ra6uG4CR6eytTawVq8H6QO/ratYy+gu6ppm/QrkzTCIC6WSxUVUmOn0XPiJg0eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYx6DQuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYx6DQuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD07F1F0089A;
	Wed, 30 Sep 2026 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794211;
	bh=mHh5qJgPMvLO8HkNKPI+MHlIAxzn0SnMHy6jEAlcfmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYx6DQufaHOpeKMeVBZ1agYhFGUcJvK7Y8IyKfQo6FRIfI8+R0oOPyDE/0dXqAH7j
	 /2J+boKHU32/ldX/amJMcXZdNZRWmDkRfl3X2Q4pxl/R0+t9aUib+uynr24Qm7Q/sf
	 xn89Hamre0SU4f4SD7m7iudjn2fwvicR4EgNw8aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fbf3648ae7f5bdb05c59@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0104/1193] rds: annotate data-race around rs_seen_congestion
Date: Wed, 30 Sep 2026 17:13:08 +0200
Message-ID: <20260930152436.542947035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 67636cab273ed0c0b0f2adab6c9369a471cb7966 ]

rs_seen_congestion is read in rds_poll() and written in rds_sendmsg()
and rds_poll() without any lock.  Use READ_ONCE()/WRITE_ONCE() to
annotate these lockless accesses and silence KCSAN.

Reported-by: syzbot+fbf3648ae7f5bdb05c59@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a0f8d94.050a0220.6b33c.0000.GAE@google.com/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Allison Henderson <achender@kernel.org> 
Tested-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260522011621.304470-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c | 4 ++--
 net/rds/send.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 528336ac1cb11..85f6471ee6543 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -217,7 +217,7 @@ static __poll_t rds_poll(struct file *file, struct socket *sock,
 
 	poll_wait(file, sk_sleep(sk), wait);
 
-	if (rs->rs_seen_congestion)
+	if (READ_ONCE(rs->rs_seen_congestion))
 		poll_wait(file, &rds_poll_waitq, wait);
 
 	read_lock_irqsave(&rs->rs_recv_lock, flags);
@@ -245,7 +245,7 @@ static __poll_t rds_poll(struct file *file, struct socket *sock,
 
 	/* clear state any time we wake a seen-congested socket */
 	if (mask)
-		rs->rs_seen_congestion = 0;
+		WRITE_ONCE(rs->rs_seen_congestion, 0);
 
 	return mask;
 }
diff --git a/net/rds/send.c b/net/rds/send.c
index 4a24ee9c22d7c..1fc84bd899534 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1339,7 +1339,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 
 	ret = rds_cong_wait(conn->c_fcong, dport, nonblock, rs);
 	if (ret) {
-		rs->rs_seen_congestion = 1;
+		WRITE_ONCE(rs->rs_seen_congestion, 1);
 		goto out;
 	}
 	while (!rds_send_queue_rm(rs, conn, cpath, rm, rs->rs_bound_port,
-- 
2.53.0



