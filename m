Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022250;
	b=1Q1YP6ehjsuztVSPm/puChytVulIoQ/IIdumAJxT7ggcIgDLjRYAQUSy6HeAancEgqsw
	 Of4j5WfxKW1YM7CUQZosoK9JbAD7Wx65bkdnzbEBPHoCceEpb31Il5wNAjwisFpBrYQBH
	 8uMI6QFSrfjr5NrgGWvVWgCZdhPkRkBKR0qcu7pMEyp+8emI8pL0KSFjY5a7prlWY3+wi
	 m7Q3GRe1EX4MqkHYalRg4VhziVW2euEVz5YERCHwjvx7TA5K35pPRtqulEN+6J3pszmfo
	 LW6O8wUppaFzwIk6PxmJ9kUtxPV0TOTgqiQIfJ2Lwi0AoTv5tB/ZJFHpIbvwqvPFGGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=in7/q4khMWe62H10KJe9+6UDTpyUqbUy6X19eXsLlYk=;
	b=bRg8b8knyRoy/GDfFD8pCAtI8XiQ8OIUiZ6C/hhEXm9740p45ARrrwHfNuhhhQWNVdeq
	 46ghdRQnyZeRv8jTInA+yVx47EAZIbY88ToDlxyG2z2DwTj7JtsRgBAaM5q1A+a9h/MRN
	 zWSjq1IYR4kMSHmWKnyYud+A/6d8Go+uGxYmNubuHxS61WgfcFDKkU/efC9XTM9VeOXWX
	 umeOmJsEFyCmWt9ZeEe/CTfM1eg+mgzbzw5+fY/BDk2bk4YI3rQic35yQJ/HJSfGxhJ0J
	 w3yTbB9DLKkzCB1cqZjNnh3I4lgws5EFu9hIWVb0NkGQgYfuuFTsSdiUrw5gNJIlbmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdZMX+4X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39756606A320;
	Wed, 18 Nov 2026 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdZMX+4X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6571F000C4;
	Wed, 18 Nov 2026 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022250;
	bh=in7/q4khMWe62H10KJe9+6UDTpyUqbUy6X19eXsLlYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdZMX+4XPFfWzBkhPFGwHDjKjGlmep655f+K52la+ASzHaM0F5ewc9sKkmPPT6nDN
	 34G9sYx7FlIz4YWqmw/xUZqdEjAjPJjJHtJclNdTja2dzWNN7NNffWUMlu5SZWmjGW
	 eS8Or+x9FflL8aVXI94T8Ci+02bsZssRCDO6uuLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2596/2651] rnbd-srv: fix use-after-free on two CLOSE messages
Date: Wed, 18 Nov 2026 16:03:56 +0100
Message-ID: <20261118150417.715948398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1e3de82fd70b7..1cfa2c5807597 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -360,14 +360,15 @@ static void process_msg_close(struct rnbd_srv_session *srv_sess,
 
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



