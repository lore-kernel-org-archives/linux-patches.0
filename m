Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3502C374192;
	Thu, 30 Jul 2026 15:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426222; cv=none; b=gYfZpYnJaxfk5uy5N8V0VQwByQqPIB3mWk24RpRDplijJNYmYqjTYqtAMmETR6HmtDryBUbNS3iikn10xZKr2ozeVUYf8fDevW2uvOUWuwKJBuGmN1A02zax+1dqpG1POivtKuVl11XH+rbcSblxXRs+1FikaSKX1SCmtDHJDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426222; c=relaxed/simple;
	bh=e/8VXtGZKQzz3KpeQ1rsoAEr3s3Z1yWyUy1heDvJTYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2RuQCG7tHUWx78RTd657MMWcG9T10D+b0T2nGyuJ8aVO4917nVrAFlLz+APZhER+tYiCh7c1o/UaWY9bTIHyz5HiZ115VZPGHjNdSzIO5fjb0oILwN38Ab6rjOnYJI1xRdofcMIkG2JCJ9wrpEhPu+4NVDFNMm0O9QFLMNiHFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJMpMvws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJMpMvws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AF11F000E9;
	Thu, 30 Jul 2026 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426221;
	bh=UJt3PyfCTbn/LduSsOy9hhgWvFsx9ZlDiC+J3OEUSwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJMpMvwsZL69hIv5dkeoNGAJL8ouBj2YzoQNPjKnZmGReTi7Y9ZGoR53HkYe+9PAy
	 OFWiyodRKC2IRwXFhdCXFowah8UG7j6vbmTz+E+JnnK/ZUZfV/OnNlgNTe1b3I3f1j
	 pHH3pbDPIEU4WH9ZHM52kKUJHB5XhGHbcnQUNbeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 344/602] ALSA: timer: drain a slaves callback before its master detaches it
Date: Thu, 30 Jul 2026 16:12:16 +0200
Message-ID: <20260730141443.188626977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit bdefe1346a8e6b8dc8593406dc2617e985fcbcab upstream.

snd_timer_close_locked() drains the closing instance's own in-flight
callback (IFLG_CALLBACK) before freeing it, but not its slaves'. When a
master instance is closed, remove_slave_links() clears each slave's
->timer; the slave's own close then reads timer == NULL and takes the
branch that skips the drain entirely (snd_timer_stop_slave() also no-ops
on a NULL timer). So a slave whose callback is still running when the
master is closed is freed underneath the live callback, leading to
use-after-free.

Drain the slaves too before remove_slave_links() severs them.
snd_timer_stop() has already taken this instance off the active list, so
no new slave callback can be queued. Take the slaves off the ack list so
a pending one can't fire either, then wait for any that is already in
flight.

Fixes: 37745918e0e7 ("ALSA: timer: Introduce virtual userspace-driven timers")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/D26598EB-DBF7-4D76-9F71-8E4BD59822D4@doyensec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -437,10 +437,20 @@ static void snd_timer_close_locked(struc
 	snd_timer_stop(timeri);
 
 	if (timer) {
+		struct snd_timer_instance *slave;
+		bool busy;
+
 		timer->num_instances--;
-		/* wait, until the active callback is finished */
+		/* unqueue then drain the slaves' callbacks before remove_slave_links() severs them */
 		spin_lock_irq(&timer->lock);
-		while (timeri->flags & SNDRV_TIMER_IFLG_CALLBACK) {
+		list_for_each_entry(slave, &timeri->slave_list_head, open_list)
+			list_del_init(&slave->ack_list);
+		for (;;) {
+			busy = timeri->flags & SNDRV_TIMER_IFLG_CALLBACK;
+			list_for_each_entry(slave, &timeri->slave_list_head, open_list)
+				busy |= slave->flags & SNDRV_TIMER_IFLG_CALLBACK;
+			if (!busy)
+				break;
 			spin_unlock_irq(&timer->lock);
 			udelay(10);
 			spin_lock_irq(&timer->lock);


