Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5753EDE42;
	Tue, 12 May 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608366; cv=none; b=YDIl6xM6HmR962tTsckarVsiI2GcKifZfmM8Kz8A5mSza9VkL2FEMlM/aIyplyDhZe3XCa69fpMqDkYmFNLn/BXHSsG/oWPX487NWlzz6Wfker6Q2no4jNVZrmuk4f5ayGXcodHjgK7UAG9Sa5SLcCh74EMWws8m/FQBvm77e4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608366; c=relaxed/simple;
	bh=bp0PXKOPnVOeEC5DXICSvWqUHuv/7Zizom+K8sy/nPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEG16KD/8UHv8P1DlrzPMG0wWjquKLcsOwPfmAl8YGSMHTkRwSWWJxfSodZiX3Jezr2cvlbmGajoBhDsQHxAvYqpdbiPzLxtxhFkrz5Xp/sp6LIUtWsNvFGYJqxrNPXJpDAbtHSCOGv7q0o0176ejyboYzD+9K8KPn7dFqNfvcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJeMlMqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJeMlMqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C4CC2BCB0;
	Tue, 12 May 2026 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608365;
	bh=bp0PXKOPnVOeEC5DXICSvWqUHuv/7Zizom+K8sy/nPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJeMlMqBdRLw6CK5Do+2GJq29ZwI/hLf43JRu/cfxvGeEQl276qBSo2uQWVFUPjtK
	 yRtliIbTZazO5QGJ2Z0+Md60bYrmxwzAzncUDyYPIZ2Yq+SqAVuMFoVhCvM3lZtlIi
	 bl7v8V5xUNlpytHVofVm+DZXwftXt6d/IZasKD54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 051/270] ALSA: firewire-tascam: Do not drop unread control events
Date: Tue, 12 May 2026 19:37:32 +0200
Message-ID: <20260512173939.526384134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


