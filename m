Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD933E355;
	Fri,  7 Aug 2026 15:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116104; cv=none; b=uNxtZpMsr9qWUzqjPWzhI3eZ/PAYJ/1l4cGXUtQR4bdXeGcbOdHjDMD+OqJhSYJkugHeY8O9sVML7qspseNXSBPB1O09fJzN9+ngJp9Jnyz07HML+UPGs6mIXYW3003ebDh16AaX53LW4UhrlbVeDUDPbOz0zevMs8qmBTqjsZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116104; c=relaxed/simple;
	bh=RfY6j5dItyH691QAJwr5sGM4gHxJd5E/tQcTUyq6CZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDOxunyaW8ETZJXE4rBFLj33PiY4Iqxyi8ETw+yPosuaXU/nIpBTGtsUpXBT1uvlD5y/IeJfLAfdPyTD764GhJeEFb2Pk15kALB5fT7sUCbsmBqq2Yb2Dj3+un8rBc3nu04nAoVRclvagMTgGljFbaZjg71d/i+kEzNH6a0A5u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akiCoN96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akiCoN96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AEC1F00A3A;
	Fri,  7 Aug 2026 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116102;
	bh=3iDw/7YX6MkMoLBvUYcx06vv7pVh6j51iKoqHhD03uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akiCoN96EjqGdQM/z/1nEmcsXI2doLvFS7VYUzOpqDe1Itvyj98OKO1vCWWaDW7oE
	 gyLR0qL6C3hduw1ds18yKTy9amr9U9RqWjwt6TlJbK/2BWgwU0n9uqGd664y46Z9Gd
	 6BMvz+IDz9aO9uKg3OUVNcBv1N7hdOTabE3Uj8OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 111/261] ALSA: pcm: wake linked drain waiters on unlink
Date: Fri,  7 Aug 2026 16:37:48 +0200
Message-ID: <20260807143417.772998522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit f495b6c4c8594122918552c9be2b51eb71647cd9 upstream.

snd_pcm_drain() on a linked stream parks an on-stack wait entry on the
drained peer's runtime->sleep, and after schedule_timeout() removes it
only if that peer is still found in the caller's group.  If group
membership changes during the wait and the sleep ends by signal or
timeout (so autoremove_wake_function() does not run), finish_wait() is
skipped and snd_pcm_drain() returns with the entry still queued on that
stream's sleep list; a later wake_up() then walks a freed stack frame.
This is reachable by unlinking either the drained or the draining stream.

Unlike the close path (snd_pcm_drop() -> snd_pcm_post_stop()),
snd_pcm_unlink() never wakes the sleep queues.  Wake every group member
under the group lock before the membership change, so a linked drainer is
released and drops its entry while the streams are still grouped.

The window was opened when snd_pcm_link_rwsem stopped being held across
the wait and the removal became conditional on group membership (see
Fixes). The later switch to finish_wait() kept that conditional removal,
so the signal/timeout case remained.

Fixes: f57f3df03a8e ("ALSA: pcm: More fine-grained PCM link locking")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/A0705100-D10B-4286-9980-0142ABEEAD51@doyensec.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/pcm_native.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2354,6 +2354,7 @@ static void relink_to_local(struct snd_p
 
 static int snd_pcm_unlink(struct snd_pcm_substream *substream)
 {
+	struct snd_pcm_substream *s;
 	struct snd_pcm_group *group;
 	bool nonatomic = substream->pcm->nonatomic;
 	bool do_free = false;
@@ -2369,6 +2370,12 @@ static int snd_pcm_unlink(struct snd_pcm
 	group = substream->group;
 	snd_pcm_group_lock_irq(group, nonatomic);
 
+	/* release drain waiters before changing membership, else snd_pcm_drain()
+	 * leaves its on-stack wait entry queued on a member's sleep list
+	 */
+	snd_pcm_group_for_each_entry(s, substream)
+		wake_up(&s->runtime->sleep);
+
 	relink_to_local(substream);
 	refcount_dec(&group->refs);
 


