Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB531F03D2;
	Tue, 30 Sep 2025 14:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243941; cv=none; b=TGcJ4S+6dGcS4ecsNUEUV6gvP5HvfY3Kh4TMhAN65fLXA54f5e6STVHMqH2xBHawjahe7WA+juhHH4pG8GPahxoMRaKTOBCXmkWVx5wg+hFt92kxZFQ2FfXMtpFefkKhPeLkguPceWDYqmhOkwEswiT5ZbK2AB81VIHLcPJEKpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243941; c=relaxed/simple;
	bh=OZPjz+N/SalNquu++mvz9O4xl3pdHtP7nXT24vg+JLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rts8xfV2CB51I7dTXxE5R+eiademsjgn09C6oxQUEycEtP6CPWHRyYZKQBBHvlQg/YbgEgNmN8Xvslv4rL6+OF3yVfMl34z0IYDyf0YXlenufSIdCv6jDnr9AoWlxuabNmx8NYHYIPhRbs4sLn4yQJYwZ/cFyiDHK/uEasWnVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMzvAXvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMzvAXvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A66C4CEF0;
	Tue, 30 Sep 2025 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243940;
	bh=OZPjz+N/SalNquu++mvz9O4xl3pdHtP7nXT24vg+JLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMzvAXvu+XqOR0exa8Td+dhjI1+1/vXCRrR0+fhWB3XDPFyf+RwXno/UigsHhMUy9
	 +rhCpB5Y9aFbqO7eT0DMOutTNnSX95aHGxvdVoTxIkkpa6A1TE90wIQZLQEEPiDF2X
	 MYao6tcKyUDQ7bmPyVkyzC/tZ/KXIXgKhP1T7mg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/81] ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported
Date: Tue, 30 Sep 2025 16:46:33 +0200
Message-ID: <20250930143820.968714695@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit aea3493246c474bc917d124d6fb627663ab6bef0 ]

The ALSA HwDep character device of the firewire-motu driver incorrectly
returns EPOLLOUT in poll(2), even though the driver implements no operation
for write(2). This misleads userspace applications to believe write() is
allowed, potentially resulting in unnecessarily wakeups.

This issue dates back to the driver's initial code added by a commit
71c3797779d3 ("ALSA: firewire-motu: add hwdep interface"), and persisted
when POLLOUT was updated to EPOLLOUT by a commit a9a08845e9ac ('vfs: do
bulk POLL* -> EPOLL* replacement("").').

This commit fixes the bug.

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://patch.msgid.link/20250829233749.366222-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/motu/motu-hwdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/motu/motu-hwdep.c b/sound/firewire/motu/motu-hwdep.c
index 0764a477052a2..5e1254f106bf8 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -73,7 +73,7 @@ static __poll_t hwdep_poll(struct snd_hwdep *hwdep, struct file *file,
 		events = 0;
 	spin_unlock_irq(&motu->lock);
 
-	return events | EPOLLOUT;
+	return events;
 }
 
 static int hwdep_get_info(struct snd_motu *motu, void __user *arg)
-- 
2.51.0



