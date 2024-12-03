Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EED1EBFFC;
	Tue,  3 Dec 2024 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239800; cv=none; b=riLEkwNRy0060it7ylJqci9sgKB8OiNbEqcUxPQUFz+pL6qop8j3w6nLziiJDCPUh137n8fb9aC/SBb0vg1w3ugaqRDC+v4gu+JlqomzEkLvVL5hQroGpYc4ECtuS/7Jz3Z/Nbne3zDZaIKkOy27Ctqld3HH/gnt03HYq3xQX3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239800; c=relaxed/simple;
	bh=eKd1hK11HmNzoa/jHZFWOs4wdsPRdzmk0oc0b/QDFrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuJ6oM/0EKJ1BO8XQ2aA9gvzLSyrb9bV6/7h4xSxrTOioJ+tZ58N6F/xpqSPzvdxULE7akSsxqUFvsbipGnt2eRIx2k+WQ9cuuteNuuWgH5wnuCTB2e1D7OgCrUz3cpA0unMcNJDORBG1hkv6rAqZI38bKaTdJoCOMUNqobE4lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfHlcgzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfHlcgzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D6BC4CED6;
	Tue,  3 Dec 2024 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239800;
	bh=eKd1hK11HmNzoa/jHZFWOs4wdsPRdzmk0oc0b/QDFrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfHlcgzmHfHwRdSKLjzj6FEY5NaQ7DSAq8u5BnSOG4NBexhBbIyUfevJQ6nTyR6ZB
	 uxgO4AxK4RiEaEBzOvN/6NOVcZW3727QoY9Zh2lFULNZ7jFLaRMxoObb7JaCjjtsB4
	 kY9o7tckUJuXpvglCWYkzP3riw7fH7ce7EcW/WZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+351f8764833934c68836@syzkaller.appspotmail.com,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 738/817] ALSA: rawmidi: Fix kvfree() call in spinlock
Date: Tue,  3 Dec 2024 15:45:10 +0100
Message-ID: <20241203144024.805710120@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 20c0c49720dc4e205d4c1d64add56a5043c5ec5f upstream.

At the conversion of locking with guard(), I overlooked that kvfree()
must not be called inside the spinlock unlike kfree(), and this was
caught by syzkaller now.

This patch reverts the conversion partially for restoring the kvfree()
call outside the spinlock.  It's not trivial to use guard() in this
context, unfortunately.

Fixes: 84bb065b316e ("ALSA: rawmidi: Use guard() for locking")
Reported-by: syzbot+351f8764833934c68836@syzkaller.appspotmail.com
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Closes: https://lore.kernel.org/6744737b.050a0220.1cc393.007e.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241125142041.16578-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 03306be5fa02..348ce1b7725e 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -724,8 +724,9 @@ static int resize_runtime_buffer(struct snd_rawmidi_substream *substream,
 		newbuf = kvzalloc(params->buffer_size, GFP_KERNEL);
 		if (!newbuf)
 			return -ENOMEM;
-		guard(spinlock_irq)(&substream->lock);
+		spin_lock_irq(&substream->lock);
 		if (runtime->buffer_ref) {
+			spin_unlock_irq(&substream->lock);
 			kvfree(newbuf);
 			return -EBUSY;
 		}
@@ -733,6 +734,7 @@ static int resize_runtime_buffer(struct snd_rawmidi_substream *substream,
 		runtime->buffer = newbuf;
 		runtime->buffer_size = params->buffer_size;
 		__reset_runtime_ptrs(runtime, is_input);
+		spin_unlock_irq(&substream->lock);
 		kvfree(oldbuf);
 	}
 	runtime->avail_min = params->avail_min;
-- 
2.47.1



