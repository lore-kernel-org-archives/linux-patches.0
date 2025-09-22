Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C525725F780;
	Mon, 22 Sep 2025 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569819; cv=none; b=LJbV4LEW2iyT4AmtnCVH6gMlQIvwXwt2il9pii+e7KguEavqQ7FBSHg8LIAbR6Tk5zmsZ4pqJv7tMfVH05cejBsPK5ZZGmbhyXAyz+o+kunIrCntINc8fhOHw+Q1OIz3UNxa9rp66Lb6a+C6i10CJzmZf/X3cINLa60iVREpy5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569819; c=relaxed/simple;
	bh=K84La6NX5Qjl1UcBwp2yQvsf8MGLOMbinBBvBFtFZg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSYzJWW4FTE0SUI8/3MDdBkbwF9j2TsO7d3uHsYJ5XF82Y0S+CtcprnqqpMoEPSJjRqESat8gv7i3shdxQRrm7/g5csGfhgUnIgv6Ypkl/PBclFvlLlqEJZ3adRlX2jLg6dPe3wB4/zWRbdwn9FhadDbsnN5neW+hmpzTwoUZm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7ylkuIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7ylkuIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAA4C4CEF0;
	Mon, 22 Sep 2025 19:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569819;
	bh=K84La6NX5Qjl1UcBwp2yQvsf8MGLOMbinBBvBFtFZg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7ylkuIY5fGe/+7grogUCi58phAmHX5GwrPoRzXbTX7ObIc1NGXxYwYrItsXKRbKg
	 KXta10Bf3QuchwMv8qCBmjhn2FR6HFQdwSI9pbsNeqQtwdZpxmx9MJ3Hd+pLsh4akp
	 Bx5dP4M2XmaYuxJwsWhfRULuv58Cj+ZR6csRts98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/105] ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported
Date: Mon, 22 Sep 2025 21:28:46 +0200
Message-ID: <20250922192409.001124920@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
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
index 88d1f4b56e4be..a220ac0c8eb83 100644
--- a/sound/firewire/motu/motu-hwdep.c
+++ b/sound/firewire/motu/motu-hwdep.c
@@ -111,7 +111,7 @@ static __poll_t hwdep_poll(struct snd_hwdep *hwdep, struct file *file,
 		events = 0;
 	spin_unlock_irq(&motu->lock);
 
-	return events | EPOLLOUT;
+	return events;
 }
 
 static int hwdep_get_info(struct snd_motu *motu, void __user *arg)
-- 
2.51.0



