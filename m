Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B87817A93F;
	Tue, 16 Jul 2024 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145153; cv=none; b=XYLHM3pBWtyDXJlDbXOtBpjaz8+0VZhuwNLdIW+LJZwGAZcx1WQvJqunBsXpE1Bvchg5jpghf4McmcEx585Edi7tejHIIFTOK/d7d8vjh94DhXH0kqZbWqFbk0hI/KzLpszqZNCNVTcywM0wf2niwUuyy5PhAuT2S+OsK5oe4EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145153; c=relaxed/simple;
	bh=tk+9Bg3QfQCH35igkL9hRfAJZpSR7ER3roRe5Af49jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEKv11Kye2ZWJ6NM64hcfqXdpJRboPGTuSEZJYKBFKpJgm5OavE4DolsPBuxvoVflJ3K8E9qeUDuZ0z4MDh7UiqlXUBXoHhGMNWC5jsamYB56PkGvhI8LtLPF26L98h3KqbSAxybUC/rk8wYN2HLRileqMckc17CpjbCn6K57i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+S3uQXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+S3uQXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66C1C4AF0B;
	Tue, 16 Jul 2024 15:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145153;
	bh=tk+9Bg3QfQCH35igkL9hRfAJZpSR7ER3roRe5Af49jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+S3uQXBzXMmqTLtGZanrvu/iBkPKcyiAUrNfAYFdGQVk2sUp9uvPvWYLYKY2ax5R
	 bakVpmCJfMQfrQaiEptXDeEkMMpPr3PM9ROqXqXPwBLnNfsOeCflj+6y+FM1xst1cX
	 G5Zkgw32HzDqpFxT8MdzM6M3ytdKm2tfRBZHbZF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 6.9 116/143] libceph: fix race between delayed_work() and ceph_monc_stop()
Date: Tue, 16 Jul 2024 17:31:52 +0200
Message-ID: <20240716152800.441353793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 69c7b2fe4c9cc1d3b1186d1c5606627ecf0de883 upstream.

The way the delayed work is handled in ceph_monc_stop() is prone to
races with mon_fault() and possibly also finish_hunting().  Both of
these can requeue the delayed work which wouldn't be canceled by any of
the following code in case that happens after cancel_delayed_work_sync()
runs -- __close_session() doesn't mess with the delayed work in order
to avoid interfering with the hunting interval logic.  This part was
missed in commit b5d91704f53e ("libceph: behave in mon_fault() if
cur_mon < 0") and use-after-free can still ensue on monc and objects
that hang off of it, with monc->auth and monc->monmap being
particularly susceptible to quickly being reused.

To fix this:

- clear monc->cur_mon and monc->hunting as part of closing the session
  in ceph_monc_stop()
- bail from delayed_work() if monc->cur_mon is cleared, similar to how
  it's done in mon_fault() and finish_hunting() (based on monc->hunting)
- call cancel_delayed_work_sync() after the session is closed

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/66857
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1085,13 +1085,19 @@ static void delayed_work(struct work_str
 	struct ceph_mon_client *monc =
 		container_of(work, struct ceph_mon_client, delayed_work.work);
 
-	dout("monc delayed_work\n");
 	mutex_lock(&monc->mutex);
+	dout("%s mon%d\n", __func__, monc->cur_mon);
+	if (monc->cur_mon < 0) {
+		goto out;
+	}
+
 	if (monc->hunting) {
 		dout("%s continuing hunt\n", __func__);
 		reopen_session(monc);
 	} else {
 		int is_auth = ceph_auth_is_authenticated(monc->auth);
+
+		dout("%s is_authed %d\n", __func__, is_auth);
 		if (ceph_con_keepalive_expired(&monc->con,
 					       CEPH_MONC_PING_TIMEOUT)) {
 			dout("monc keepalive timeout\n");
@@ -1116,6 +1122,8 @@ static void delayed_work(struct work_str
 		}
 	}
 	__schedule_delayed(monc);
+
+out:
 	mutex_unlock(&monc->mutex);
 }
 
@@ -1232,13 +1240,15 @@ EXPORT_SYMBOL(ceph_monc_init);
 void ceph_monc_stop(struct ceph_mon_client *monc)
 {
 	dout("stop\n");
-	cancel_delayed_work_sync(&monc->delayed_work);
 
 	mutex_lock(&monc->mutex);
 	__close_session(monc);
+	monc->hunting = false;
 	monc->cur_mon = -1;
 	mutex_unlock(&monc->mutex);
 
+	cancel_delayed_work_sync(&monc->delayed_work);
+
 	/*
 	 * flush msgr queue before we destroy ourselves to ensure that:
 	 *  - any work that references our embedded con is finished.


