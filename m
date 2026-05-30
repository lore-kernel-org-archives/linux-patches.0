Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86E226738C;
	Sat, 30 May 2026 18:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165939; cv=none; b=D8VtxRSF8FKKdodtACCj46WR5ws0F6orKXobwr+SJKGlZBs0bWPPRz3EHpMLBo3lq5X/Dnfa9oHtXSLRr2MNuXSgXgjZY68gU6A5YjBXJxNQTb//8W7qSToJc7rxknYyd3Root0eLcDNZvVu3bTohrBvW+3xrnTJ+5hUfX0nMDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165939; c=relaxed/simple;
	bh=5sF7I7sre+T2fGlhRNTX1sBSUi9davGWB/kcpk6THgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNq0Az1mn2xe4qm/V7e4TLqtJa+U8KuKzq69XZ/+o2LCVaLgv/lbzCM0beoP8HHvRVv1/yO+aK/GpL6RuKKvJXtalm6boNd/IazrhkuxrUFv9TOfOtm/UhkGcUEHIRZBqZYAVdIRw7S3EHym0r9baHR4lM2PJvajx8PNw2hIoiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izr8nNop; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izr8nNop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA4B1F00893;
	Sat, 30 May 2026 18:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165938;
	bh=6wOjPhaAvDuNxScZj0bgimehltVr0VkjB/AqOTcV3Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izr8nNopwe4cVhRXKrfrtmzlnfRt6bJuw6u7cxKppMlMDYiNFJ3dskfd15bfjvb3N
	 Mn2lB8FoXcyxoRbaiZZA6po3UNzQN3Ka3wV8/fTypSVg6hns4g/icqGLuVAth1Vpci
	 cMpZJSc7dJlQwh4rks4iOCM3+jxeHxuuyl5DkIvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 227/589] ALSA: firewire-tascam: Do not drop unread control events
Date: Sat, 30 May 2026 18:01:48 +0200
Message-ID: <20260530160230.944862917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 0749daa8eb5ab90334aaad3b0671efd7150d43b1 upstream.

tscm_hwdep_read_queue() copies as many queued control events as fit in
the userspace buffer. When the buffer is smaller than the current
contiguous queue segment, length is rounded down to the number of bytes
that can be copied.

However, after copying that shortened length, the code advances pull_pos
to the original tail_pos, marking the whole contiguous segment as
consumed. Any events between the copied portion and tail_pos are lost.

Limit tail_pos to the position after the entries actually copied before
updating pull_pos. When the whole segment fits, this is equivalent to the
old tail_pos update; when the buffer is smaller, the remaining events
stay queued for the next read.

Fixes: a8c0d13267a4 ("ALSA: firewire-tascam: notify events of change of state for userspace applications")
Cc: stable@vger.kernel.org
Suggested-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Co-developed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260503-alsa-firewire-tascam-read-queue-v2-1-126c6efd7642@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/tascam/tascam-hwdep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/firewire/tascam/tascam-hwdep.c
+++ b/sound/firewire/tascam/tascam-hwdep.c
@@ -73,6 +73,7 @@ static long tscm_hwdep_read_queue(struct
 			length = rounddown(remained, sizeof(*entries));
 		if (length == 0)
 			break;
+		tail_pos = head_pos + length / sizeof(*entries);
 
 		spin_unlock_irq(&tscm->lock);
 		if (copy_to_user(pos, &entries[head_pos], length))


