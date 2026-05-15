Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686263B6354;
	Fri, 15 May 2026 16:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861151; cv=none; b=U0wFxT2E+Vh1EiVIkH9sC1FJAU+inxZcXoif2h+SVOFwDPkGDseuE0C+bdHmhiSU2/6aJqxwDvjO/kU77lHNZKkSKc633xiLYQ6IbIDqZaumvjwd1gv12Dr5RUcRpbxpcxeK5x6ZPvRQibnigaShZfUxJNPtzcJ1crTpHZm5Mh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861151; c=relaxed/simple;
	bh=1jf7BdhdiH/HLG2AgVqWxlUuiBN5NeDOgz/Oc0hAvlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZrh6Qbe8K51y8HWF+dPcyQciOKcwJ4wdXZldcB3nn3AeIcxyLGS5b9QbWeZf2b0FZ+QrwMnxzCOfWh/cif9vNhcpOoNCiGAMOFURopSoW2S/KNPIz6fe9H10FAcQ8LthdZUYKXlF+67DMSdq5/xPe+heiOBGk+LeBSJUAXlpNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGvaLztv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGvaLztv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1763C2BCB0;
	Fri, 15 May 2026 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861151;
	bh=1jf7BdhdiH/HLG2AgVqWxlUuiBN5NeDOgz/Oc0hAvlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGvaLztvFE9upYl/TQb6FxaM/raE+9lMTQ4giRRYuaF4XfXX4X9KMf4d62ExlxAyq
	 81/TVXvKxPOf7EE4+rcjuxc83ueJgnTocEovqNcH1N6pOtJMWIaCPdGzFu49NTrFMC
	 hiDLSAYwJdryp8OCCqnj08DGr+//7wSj5xUOTC1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 201/474] ALSA: firewire-tascam: Do not drop unread control events
Date: Fri, 15 May 2026 17:45:10 +0200
Message-ID: <20260515154719.364665931@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


