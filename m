Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623496;
	b=F/7GHVXiKJ5t0Aec46BRzKSiTIk3/7UTRlzbMWrwH+46rUikOP0E1xUuwdQwDvZxGBje
	 rvldJNZAs5hmi42dSG6FIS6mgQiEgYV3lEA/TG/MhXH4BLOw85pT2itR63CD43y3bD2BP
	 9a++9tIieK2vEbkZc/9XCvejjyuiwZWT+I1Ywz9HRWDj+WyzdPGHSLljia2lXFWqrbXPe
	 mZ/xXslZof5SQP7EV3CyTC7lR6O9CeaS46duHZgex7cBsdUz7QeaVAPnvQ3hu7mOkAJ6O
	 Jlsaw0nPKMqI5t7Bsa+5eGeCuh2rWT1+ZS7LCPLyDRn6ahdl2/E5Ft+QJYpD6g0quow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qVYQsWIENs8Prkn4O82Rwdr2wdU0rYD2Swlj85mxgz8=;
	b=AL0U8JM3kRxeFScocANfLf9/MR2YrhkIIHAhssc8weI/NsriqLfiL0i8ofphklhcCgoy
	 zL32JaDPF5Gfv23hIf6jgifJoVwLR1/GE0DF0Y0olYcZ9lQl5KXnPafFTLkcFJEzSflRr
	 /acPvUe2Ea+xfaDxl7GywPOrtN6qBdxnLcQIgR+lukjcbgU7u9Z+UKklTrZ3vCu3sIFvn
	 2mrRa7ciwz8Nr07S9bbiC7UduFPhksinvO7o1RUkkS7dzskooCM2zMPtBZZVHvZm/zqVB
	 v6lguWPHbohovdGaKbAzjzTjMhKgAMQUF8OZJ5U8lu0uQ/lxAFzW/l2VeUkEIRHwmQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USVg6tpv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD16E606A321;
	Wed, 25 Nov 2026 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USVg6tpv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3063F1F000F4;
	Wed, 25 Nov 2026 16:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623496;
	bh=qVYQsWIENs8Prkn4O82Rwdr2wdU0rYD2Swlj85mxgz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USVg6tpv/QFoQ7DpLUkcFuB/+02tnBoLDiXLeOhzywJZK0TjSKlF1U1O96TFnJTRm
	 sRzS+medDD4jusEBcCVb/2slV+G3G4w/dyDV8mCRkDGQCK7y8YfrOfuhVHlFEOLRuE
	 kZxBS8OHn93IziStdAb1X7GSXk9D9IB7k9SOa0xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 877/990] dm-raid: fix use-after-free in raid_dtr()
Date: Wed, 25 Nov 2026 15:37:24 +0100
Message-ID: <20261125143842.560436891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Li Youhong <liyouhong@kylinos.cn>

commit 46af2c975958119290ddcd984a98491966123a7b upstream.

raid_dtr() currently flushes event_work only if work_pending() is true.
This is insufficient because once a worker has dequeued the work, the
PENDING bit is cleared while do_table_event() is still running. In that
window raid_set_free() can free the raid_set, leading to a
use-after-free when do_table_event() accesses rs->ti->table.

Flush event_work whenever it has been initialized, so raid_set is not
freed while the event handler is still running. The .func guard skips the
flush for mddev instances where INIT_WORK has not run yet.

Fixes: db29d79b34d9 ("dm-raid: delay flushing event_work() after reconfig_mutex is released")
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3334,7 +3334,7 @@ static void raid_dtr(struct dm_target *t
 	rs->md.dm_gendisk = NULL;
 	mddev_unlock(&rs->md);
 
-	if (work_pending(&rs->md.event_work))
+	if (rs->md.event_work.func)
 		flush_work(&rs->md.event_work);
 	raid_set_free(rs);
 }


