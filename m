Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D6E367B67;
	Thu, 30 Jul 2026 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424604; cv=none; b=aSYa/Ut1dQ6Ng0s56aOx+AJg9SRTf3zWQOeePgRM0VloCIkV3/qXUbS8BTZ561HX6/PsXTt5MAo4K0dfKm4PdVl2lswyYJGS7n4dJKjV69T430tOWujIbIAHFrpffrGUmRI3ZyXhry5NQ7N8J/fg2BtktnoMejESBpvCPdjGdow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424604; c=relaxed/simple;
	bh=LPcuoLMeJesVUb+i/4/CDaO4hfPqQMHsLuy5g9AsTGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE/13Orkjy/uxNxv9tfdvwjcbOqsCoT1PNH7aRstu0tpc3SeRIbgGldY2Flxk9HELisiqa9gwrBCY1l9aJFjRVSfixBmSUgmPuxENubEPT9lsTXSqdaTcHx4OShQ2NCsIweQw25A/8jjBI3JS3PsmZjMeXrM8tCQjH756RJMo3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jAFsZl/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jAFsZl/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C11F000E9;
	Thu, 30 Jul 2026 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424603;
	bh=bdQ8MAfPbWNyIxM9DNALzHlfDkCpA5k5mKEkP2PJ8RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jAFsZl/ClYND8AzS7PmWg4M/sjHeddPz7D76eKMWfQ6Yqs0e39oor7S141mRkrKir
	 RMnRjQncobNqp9mZ5uFZCj3lsS93RLj+n8td2fvflmOZyVky/F0CqMZ/5h/cZcLHR2
	 OBzjSgRXZIcCjtx2hB/iFlIclXqt2FgMSjrEJv+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 450/675] ALSA: timer: drain a slaves callback before its master detaches it
Date: Thu, 30 Jul 2026 16:13:00 +0200
Message-ID: <20260730141454.702578320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


