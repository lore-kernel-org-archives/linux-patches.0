Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44F1EE00B;
	Tue,  3 Dec 2024 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242559; cv=none; b=nMldvcW21ML/rQKKLUlqrm+6IPYde43DyRcxs+Rvi6+XfX2iHb8XML3zzYZBQ18H5W+YpG5uWONZWwj/Bwr1SS7vmspZexeBKvA0q59b7cnuZ/sioFBtm/KmxRZYs3C2vbZg5VG+8PXoawhFCHkfG+ZPAGuxNhMtF1M34BrhjmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242559; c=relaxed/simple;
	bh=SHUuj6jTt+zgBvmhLtde+9Vqxci3RbgWNm0ehtP5fDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nChk7uRc2vvv1yemaozrp1lr5zT/DymvHxchYZJykGVEaK6Gfcu3JxO4LTf5MdWpafBpSseTb0M72NxK/ogPvb8dOFDb4Q9abwqpZC4jL8uKXOGvoHPevs4Yo53nwXfFpnJBKFpYCOIiYYxZb0g2xODWNgjDrpjTLJIomg+JxVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjT64Qkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjT64Qkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FDDC4CECF;
	Tue,  3 Dec 2024 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242559;
	bh=SHUuj6jTt+zgBvmhLtde+9Vqxci3RbgWNm0ehtP5fDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjT64QknYOYOd6EIn095yr1QISFmwft80axHyqpAZJvrK0KGR7fq2M3fIl63Sipir
	 69nanIIPakWOpGTUDu1v6kOigb4ysLXIacIFh+qKomLDbH4bF2IBcv8J9F3ZNmVpcH
	 kybZXjVG/zMFUViSyt0M4fEPfK2q393wZYK0bJP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+351f8764833934c68836@syzkaller.appspotmail.com,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 740/826] ALSA: rawmidi: Fix kvfree() call in spinlock
Date: Tue,  3 Dec 2024 15:47:47 +0100
Message-ID: <20241203144812.631770983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/core/rawmidi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -724,8 +724,9 @@ static int resize_runtime_buffer(struct
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
@@ -733,6 +734,7 @@ static int resize_runtime_buffer(struct
 		runtime->buffer = newbuf;
 		runtime->buffer_size = params->buffer_size;
 		__reset_runtime_ptrs(runtime, is_input);
+		spin_unlock_irq(&substream->lock);
 		kvfree(oldbuf);
 	}
 	runtime->avail_min = params->avail_min;


