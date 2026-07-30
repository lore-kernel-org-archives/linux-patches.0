Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED6C34DCE4;
	Thu, 30 Jul 2026 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422746; cv=none; b=uSmpy6ERgdxvFVJeZiw6U3ydXCp2VJzOt//fVh6K9BKkEhNqO9ErcAltxOX7vtNe0BX8+YGpqM26j5bGRddw24LSD0u+pVKojt4TAbEQhFLgimfkO5qOGGQ9QKxjd3C0s8JL6ucwrYJXzTS2Fc7R63txYVnG4IjPuZvgkGnwQ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422746; c=relaxed/simple;
	bh=6GU+lZJscxvhxxWWaqH/hbBOCp7MALk+miC2AHdgZ/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9mHepMY9ibkh2TVkas5hnW+BimEIzSu1dmADI+50icBvdFF818/TZrOD2KHz4ovRZLmymYfMKKzsHF03hFx/w2XGU5XWT83Vm61HhmL9MhpKMt+/pLRMo/mjoYvOC3+iZkef+PS7UZ5aCO4Flf5NQk/IzkPYKkfGREvfjYFKFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMNk+9Po; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMNk+9Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E681F000E9;
	Thu, 30 Jul 2026 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422744;
	bh=/y2dA1k1FYmDHdC8GK+ECku1cNFVbzL8eWw0HUC2Yqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMNk+9PoDJRskGpAaOxPEmq8O+OpA7EDen0M6JU4jcq/WJB2fIg1+Ef5rmY9O8j4X
	 DbvLsmf6h3YGEwudU7I48ABo2Q78MgdkiqW6miv+kvcR/yCLyEw4J5In8RYieaM650
	 CH+nHBdjsAds7wHKIUsd9CC3/ibP5zjsjZMZoQDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 541/744] ALSA: timer: drain a slaves callback before its master detaches it
Date: Thu, 30 Jul 2026 16:13:34 +0200
Message-ID: <20260730141455.774547597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -448,10 +448,20 @@ static void snd_timer_close_locked(struc
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


