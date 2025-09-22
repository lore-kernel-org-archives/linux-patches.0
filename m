Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F91C8E6;
	Mon, 22 Sep 2025 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569481; cv=none; b=PN5bqMGp/lyNJtZmxJtNasfkM77UR4AEIEwuNNzqftssyUT1AEg8R/k64yaFin7ELoMieKloSHpDl43Xk2BuxrBT03Rie0DwW7d/qaxtQ0vk4fQdCHyadpmSoM0trapj0liT54ba0qmEZmIytvoqzQSh6NV3z7HQzKUBwzZXaOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569481; c=relaxed/simple;
	bh=tZdWqNXndI6M8qggNvAJ43tWo2JmdnpWjYh27A55GVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQSFOGUS3TsPogr0hDWGAg9zU6YpPkTiEpaNSwBGZiWFcet7OFuTfz856e0Zwd0mwCJ/jNCXFmBed0exYTVbnWSKLsyeMZhAQPYqcGeB/i6DAdZhvU0Q3HClHbIf7Cw7lE/MCYF8Yqil+he6dBW0/hdxn3euGpmrqUPavMSMWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rNsnEUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rNsnEUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09427C4CEF0;
	Mon, 22 Sep 2025 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569481;
	bh=tZdWqNXndI6M8qggNvAJ43tWo2JmdnpWjYh27A55GVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rNsnEUMW8q0zJeSH/LffzdfDz9ZIMx/tpm0KDejWgzSrzSIxi1WeBxT3ImjWSSdm
	 NmI8Iy7dspVjHRI5aIQe083j2+EB0EdEZM1SZ0WtxQiO5JiD0d1AODe7UjtBjmG6Ls
	 7TAvAE5euMW0tY69ABnXyzEWYSZkDQpJPu7xQgIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/61] ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported
Date: Mon, 22 Sep 2025 21:28:54 +0200
Message-ID: <20250922192403.573877035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



