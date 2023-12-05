Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BCF6FAF;
	Tue,  5 Dec 2023 03:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMKnWhCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673C8C433C7;
	Tue,  5 Dec 2023 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746863;
	bh=z+4ftpoHOC1Yw/b6JkDmqW5QpxEWq6F7qOwU87+si8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMKnWhCWbqHM9Kl2DiRh3a+zsukf+05ymtUssCFfgli4TtAwyPigm2LFQfhsiAgSF
	 6FOGxfw/o5oeMx0DNITYa1eLAhz8YQ/cklYsHIORr9I/fFg+cPpE0CH7K47Qem5Uqt
	 3oGxgzTs0x5Hh8S80zoTcaCYxN4QoNpP/29u/RsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/71] dm-delay: fix a race between delay_presuspend and delay_bio
Date: Tue,  5 Dec 2023 12:16:22 +0900
Message-ID: <20231205031519.261897810@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6fc45b6ed921dc00dfb264dc08c7d67ee63d2656 ]

In delay_presuspend, we set the atomic variable may_delay and then stop
the timer and flush pending bios. The intention here is to prevent the
delay target from re-arming the timer again.

However, this test is racy. Suppose that one thread goes to delay_bio,
sees that dc->may_delay is one and proceeds; now, another thread executes
delay_presuspend, it sets dc->may_delay to zero, deletes the timer and
flushes pending bios. Then, the first thread continues and adds the bio to
delayed->list despite the fact that dc->may_delay is false.

Fix this bug by changing may_delay's type from atomic_t to bool and
only access it while holding the delayed_bios_lock mutex. Note that we
don't have to grab the mutex in delay_resume because there are no bios
in flight at this point.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-delay.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index f496213f8b675..7c0e7c662e07f 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -30,7 +30,7 @@ struct delay_c {
 	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
-	atomic_t may_delay;
+	bool may_delay;
 
 	struct delay_class read;
 	struct delay_class write;
@@ -191,7 +191,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
 	INIT_LIST_HEAD(&dc->delayed_bios);
 	mutex_init(&dc->timer_lock);
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 	dc->argc = argc;
 
 	ret = delay_class_ctr(ti, &dc->read, argv);
@@ -245,7 +245,7 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 	struct dm_delay_info *delayed;
 	unsigned long expires = 0;
 
-	if (!c->delay || !atomic_read(&dc->may_delay))
+	if (!c->delay)
 		return DM_MAPIO_REMAPPED;
 
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
@@ -254,6 +254,10 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
 	mutex_lock(&delayed_bios_lock);
+	if (unlikely(!dc->may_delay)) {
+		mutex_unlock(&delayed_bios_lock);
+		return DM_MAPIO_REMAPPED;
+	}
 	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
 	mutex_unlock(&delayed_bios_lock);
@@ -267,7 +271,10 @@ static void delay_presuspend(struct dm_target *ti)
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 0);
+	mutex_lock(&delayed_bios_lock);
+	dc->may_delay = false;
+	mutex_unlock(&delayed_bios_lock);
+
 	del_timer_sync(&dc->delay_timer);
 	flush_bios(flush_delayed_bios(dc, 1));
 }
@@ -276,7 +283,7 @@ static void delay_resume(struct dm_target *ti)
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 }
 
 static int delay_map(struct dm_target *ti, struct bio *bio)
-- 
2.42.0



