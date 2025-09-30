Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880111EE02F;
	Tue, 30 Sep 2025 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245088; cv=none; b=eu6sQulbeOB5iOeIyCFQXn8NSZd+gXbnYnPCRzdqgnJ05uX0EhJ0JIdyWO7r738RUoJpYJ/buM2S0FZW/bKjPJTyMCnl6FvQCSSji96sLcpBEC5x6rNoeAICNjfNiXAlA5tE3bk6urQ2H2Zf0Hp8dmegFx6HI4a3QI+oSxZMP74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245088; c=relaxed/simple;
	bh=ZDGvTmtT2CypzGnX8AaGWAhl+F45ZiSTGIV1JoDsVkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPillc5veIuEBe+JNMj/zUjP8oUafKYWguef5DOeWB4mwZ8HbqltYGNyfrfvvt3IpEoCrFEWNJrriE7nfGDWzBdbgWvc1gEC2UNNQ+bxMCsZ3+Jc9DMlrxz33uX/OQ8nU7tAOeIXkPf2Lz9JjYhTKudsSUa/3DW+/37mOE/PUAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY233k00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY233k00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF4AC4CEF0;
	Tue, 30 Sep 2025 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245088;
	bh=ZDGvTmtT2CypzGnX8AaGWAhl+F45ZiSTGIV1JoDsVkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zY233k00CmQqqsMjuz8C9miLAUP/l/NINh3RdsfwoBNalCI5KKifGKCWtRGt1YXN3
	 pO6+x6jw1lsNKqMTriwA+JJq4cOYkEOg7iZeBAcm5gghk6E+3svBe+q/fK5ciMr48d
	 UTI4FnHP5bp/D++EpePoSKRZN1OiZ2vHckgVNGh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/151] ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported
Date: Tue, 30 Sep 2025 16:46:35 +0200
Message-ID: <20250930143830.190089067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5ced5d27758b..364fecf8d2867 100644
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



