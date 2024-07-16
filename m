Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE75E19AD93;
	Tue, 16 Jul 2024 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145544; cv=none; b=ahQwBZB3n50zatndoBQeSR3dTJlmxym+lrvK9KrJE2Lyo94WCjDy2fmNuSW3mnxZz5lPAkk9f3n8krlq5uTmpjyW7FpGQYo3D2Yw4wvQT9q8y7SnxUP19W/ZFp/2EHQOnRnqFz64iuFiBy1XozL0GObPU5754d8nYCPazagWyLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145544; c=relaxed/simple;
	bh=MBWrmQlftKxNkSqhe0VJOOIIaT6MKdU56lRTQLt0O/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWrQwhas/7oG7USBjMmr7aFD8bcTDwAUC4lCUXimvsKH0GSBjoh0ZStMmYgTWLdIz4AUEs+QhRo9jyn1q9GddPCRhb/s4Z2EuaCo3zhGgARl9l7ADuDHf8Rjuolbl0K5MK/JnZEFSkCd28RrtpyPnwTveSq+Nw8F5SllGd8L7Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7kQDT02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7kQDT02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C7FC116B1;
	Tue, 16 Jul 2024 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145543;
	bh=MBWrmQlftKxNkSqhe0VJOOIIaT6MKdU56lRTQLt0O/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7kQDT02S2dWfidSmYJSieiOPngOZHPOWcSZHcqJ695f4xicm94FCNVYaUZC/JiCe
	 G7YK8rD9Mi10Xe0xgqK2wtOISgrYZB682Q/1CnPzn2+N90tMrIY5KVZ4YEt0NN3Bii
	 x97idmU4Ndk6Ulo4XtM7SmeqUl+b2o60R6pSDI30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 6.1 71/96] libceph: fix race between delayed_work() and ceph_monc_stop()
Date: Tue, 16 Jul 2024 17:32:22 +0200
Message-ID: <20240716152749.242132107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


