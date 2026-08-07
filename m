Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9D2351C2F;
	Fri,  7 Aug 2026 14:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114146; cv=none; b=Vb818Y/ir+zDy0ALYGoyOtBcwVhzjSB/2irwrnG3wJfp8arZgld2rAJlvmiZdbs4+ZnZ3YcnXTRnWQWHBji+ChObnbfjMqo/sIWWv+fH8vNqhi35NJVzzVLTmfU2O0MffjuOYyWc6aBK7Fx0NNmpAdQxWyaXauvB+3rRaxZ5JXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114146; c=relaxed/simple;
	bh=foKWS86ikYHgmIDDXVV6JbMoORG0J2NYyVSj+fEJD4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjzaQfIjlH0GJMsmO4L7oqEY7UqlJY/jFb/ZqD7Qa+ke9gl8Rl+z7PiY9YlJsPTIsWLZ7r8u+WFph3nGVA7oZdHy+buGVva3crsF4dzTERfqSland84yYqJwNr3JQOhM09g97YyvcuIcr3PYeRJ+0H+ZqVngSDTb8yCeOM679ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPwswkfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPwswkfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2851F000E9;
	Fri,  7 Aug 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114144;
	bh=XPUT55AMMYMPnYDf2Cd1X30PKCiC9d4RDVy1mbU2AVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPwswkfWfV0nqu/QLS+YiseM+Do93CFiWYMh8eUg9xCzHLF3FhdtNVJuFErsCj9DO
	 QeDs+EUrdWWi3DEsIN7WCbok0ll4SwFxjIlDHjoMQDxXwvrzorL9981GImxmoHvAnP
	 kIWzu6oWm2iugmZTZ33spjk7fJTfbDsl1IUSe4fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 159/337] ALSA: timer: Clear SNDRV_TIMER_IFLG_DEAD once the close completes
Date: Fri,  7 Aug 2026 16:36:02 +0200
Message-ID: <20260807143421.998589991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

commit c2744d5f3aea474513fd2298daecb94a952ce441 upstream.

snd_timer_close_locked() marks an instance with SNDRV_TIMER_IFLG_DEAD
and returns early when the flag is already set, but the flag is never
cleared again.  A completed close ends in remove_slave_links(), which
leaves timeri->timer NULL, so a second close is already harmless through
the timer == NULL path; the early return can only be reached by an
instance that was opened again in between.  For such an instance the
close unlinks nothing, so snd_timer_instance_free() frees an object that
is still on timer->open_list_head, still on snd_timer_master_list if it
was opened with a slave key, still owns any adopted slaves, and still
holds its timer and module references.

snd_seq_timer_open() reopens an instance exactly like that: it retries
its fallback open on the same object after a failure that has already
run snd_timer_close_locked() internally.  An unprivileged user with
access to /dev/snd/timer and /dev/snd/seq can force that failure, since
snd_timer_check_master() returns -EBUSY when a pending slave matches the
new master's (slave_class, slave_id) key and the target timer has
reached max_instances, and SNDRV_TIMER_IOCTL_SELECT with dev_class =
SNDRV_TIMER_CLASS_SLAVE keeps the caller-supplied dev_sclass, so a
sequencer queue's key can be forged.  The freed instance is afterwards
dereferenced by any further snd_timer_open() on that timer, by
snd_timer_check_slave(), and by /proc/asound/timers, which faults on the
stale ti->owner pointer.

The flag only has to be visible while the close is in progress, which is
all its other users need.  Clear it in remove_slave_links(), under the
same timer->lock that sets it, once the instance is off every list.

Fixes: da3039e91d1f ("ALSA: timer: Forcibly close timer instances at closing")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/CA41AA48-75BF-45E9-A36D-3A5D2F124F60@doyensec.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -409,6 +409,8 @@ static void remove_slave_links(struct sn
 		list_del_init(&slave->ack_list);
 		list_del_init(&slave->active_list);
 	}
+	/* the close is done; a reopen must not see the mark */
+	timeri->flags &= ~SNDRV_TIMER_IFLG_DEAD;
 }
 
 /*


