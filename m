Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042703;
	b=gXLNpwTjT+xK4CPtz93RmXGtbhbaTKRFIiWNxG7dmjQvpRxOIm527YPiljmJsxIwisgI
	 m4wcCPcIVhe9UA0Dwmy3eycF2QfNLfX8mIuVn7dvnoRJhF8rPC7Lf0bMHmAYl9Zaa/a0K
	 lDFgjoGdAB8PoTUyOEZUqJDO4A80r7Og5yEz/zByIVy4hKORxtzgOj+Vgr1FSgCgnwlae
	 7sxHHEw+PF1oqDtp9LpACOCn6w7kh1IzuFIhBa6/E+KfWeJJ/PscfiThiO0mLj6WVwYve
	 TDc49o4Q312kjw1UNHbgbPRaddPEKZdwziesmVLnTPrW4xZOODIQ8IrLmdhTHex2DvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u3YxW43a3AkF1gLOdIJ65ATtlUh3HgqKtWNxodMGffs=;
	b=b0gDBGd5M6uuTPQfn7w/OZLqwjbp7I9Mw3zhO+Hvas1VGlGDTBOqwEMOxWrx9NmGUwH8
	 Mk2jgbj8aYdHkEMh/92DjwnRCE+rv4l0KKjpDa+oijIKn66uNMZgtQ7GdMe2Yx8YScBtN
	 HaeKyj+07WlWmyiBfQP9kZ14YNnQOr8Oslb+VaK6iKU5NPv4nHp3dJ1la6mC84YsM4oDc
	 n0VB6oXWkvKTYqPI6+IMW1XUyAYVOZZ+t/yiQPenCRugzoU9HUw3PAqtRXXbU4dPuwlwf
	 T+HMC/s+EPUs1AwsCmRZ4VXd/ext3o/Hz1LX5xYYtjaYRzHT5VWF25+dXVDCWnDGryA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDVvcTk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAE2606A320;
	Wed, 18 Nov 2026 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDVvcTk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3011F000C4;
	Wed, 18 Nov 2026 22:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042703;
	bh=u3YxW43a3AkF1gLOdIJ65ATtlUh3HgqKtWNxodMGffs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDVvcTk1x9rJccBvKjf6R1v2HHsa//HEvQFw6oyI0726rx2gqteJf0I2YQhZ0orkX
	 irSULSTdIYW/EA8EMtVKZ0kN++TYpm+h4sokbrHrDMuzjo4uTWGacVXyiN0PnfJOri
	 15YYqZyavpgtcdjWwJcOLIEURpT76L38BZ+mGFBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3265/3318] rnbd-srv: fix use-after-free on two CLOSE messages
Date: Wed, 18 Nov 2026 16:04:47 +0100
Message-ID: <20261118150457.568515834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 4912dab88baa5f7034dc9e38807804d470ae5438 ]

process_msg_close() looks the sess_dev up with a kref, drops it right
away, and only then takes the session mutex for the teardown. A session
has several connections handled by different workers, so two CLOSE
messages for the same ID both finish the lookup before either one tears
the sess_dev down, and the second one works on freed memory. Any host
that can open a device on the server can do that.

Take the mutex first and look the ID up with xa_load() under it. The
second CLOSE then finds nothing.

Fixes: 2de6c8de192b ("block/rnbd: server: main functionality")
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-40-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 40968b8d8b85b..cb475fc425d57 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -344,14 +344,15 @@ static void process_msg_close(struct rnbd_srv_session *srv_sess,
 
 	trace_process_msg_close(srv_sess, close_msg);
 
-	sess_dev = rnbd_get_sess_dev(le32_to_cpu(close_msg->device_id),
-				      srv_sess);
-	if (IS_ERR(sess_dev))
-		return;
-
-	rnbd_put_sess_dev(sess_dev);
+	/*
+	 * Each teardown of a sess_dev runs under srv_sess->lock and erases the
+	 * ID, so an entry that is found under the lock is alive.
+	 */
 	mutex_lock(&srv_sess->lock);
-	rnbd_srv_destroy_dev_session_sysfs(sess_dev);
+	sess_dev = xa_load(&srv_sess->index_idr,
+			   le32_to_cpu(close_msg->device_id));
+	if (sess_dev)
+		rnbd_srv_destroy_dev_session_sysfs(sess_dev);
 	mutex_unlock(&srv_sess->lock);
 }
 
-- 
2.53.0



