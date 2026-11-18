Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028274;
	b=eh8iENbkJmn57S37LSjwnqMVPwC9Luc90iiwpRqIhSaUkCznyozqyIXCyAKTO9yrf+Lm
	 J/fjaOg4t1UGuLsBI/+MzkR72X0i6AiZEcCDuHVZAlqMB/ZoINsNebeHpaI9N9HK6tsyF
	 3UKYkJn2IwgxmM90VQMASJTEIYmSPxg4t8X9xoVWIIv2PlnPqxD7zgI0DYmUToclodXGC
	 rZk1VZJPMSK9qV/LmO6Fjw7+0QeoTS3A5ikGs3VM5D7gA9PmqY3UBAVEejtoP8/5c16R4
	 qaB+fRKWXkU622/D5Op62Ynm7IMxuARKoRttGOOr5mROaTfUVE0NQjfL7mnOjC+h8rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UgXl+56OsFwEsMxOL8fLEsGcSY4SF1+pWJ2UTmIzdKA=;
	b=Y8eAoGlTc1qdg1CAhL1NDWdn9BvvDoAeRXhwkqGOm6lJizZSfpXtx+9KNX9KdQnz500Y
	 LoEoeYfHx6IGESEUXlNDEU0YLic7Gs3d9UlJthc1zQW320ebWfu6ybPBlO1WZGlc9Hix6
	 9xvHpErCzupNU2hSlHHZNVF/zRGh1r1M3TiQyp5RgHN1dt+9EfuHzXSlF+X/A51QOW7wJ
	 WB7yuOXvz+AZ9fS0j1mlebmSoWQ2cIQmn81/ACRlhVonCrYDQahn8xwi5qd/mLRmFkuSF
	 d/vxwGRq8LTMv5vTdjyNKfAfD+r0ctWn3tgeziGQfQ97NwFL5kUJQhbTk28ImbZfm+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEEkfTJA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF978606A320;
	Wed, 18 Nov 2026 18:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEEkfTJA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B741F000C4;
	Wed, 18 Nov 2026 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028274;
	bh=UgXl+56OsFwEsMxOL8fLEsGcSY4SF1+pWJ2UTmIzdKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEEkfTJA/oK52Yy4o0c/s2zXWdrmoaeU0258FCXG/KOyX0EBoZSjl5HQNZvfrfoZs
	 5WAg7JMN4NWGeBKfCRNVS8pyDc1uTbYagRa4/jmw/P659NFt/2E5HD1wa5xuuE+Gck
	 qCxjvNxO9mispcaZZwZav+LaOO9KFsEZPVY9i4Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2085/2151] rnbd-srv: fix use-after-free on two CLOSE messages
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150237.656742856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1f00286cde87e..1180e171cd468 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -359,14 +359,15 @@ static void process_msg_close(struct rnbd_srv_session *srv_sess,
 
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



