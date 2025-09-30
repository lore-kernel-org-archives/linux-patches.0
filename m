Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50E51E9B1C;
	Tue, 30 Sep 2025 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244166; cv=none; b=LqUbDpvTMjVhGUkz7P/+uFZmTf7PVHPDpWknFJ4ky21ZrN/ila2r+0Uj2oDzRLBT/hX9EpriVi8DwKN7wlimcye+xqpggtNvJdJ6PHx0GIT50FLdAP+Wo4X82KTgkgmVgphSz/1/uE+72WaPlHJN4J2qZlbrEiWhnrkYxbH8rB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244166; c=relaxed/simple;
	bh=ik0LEaA7NbMnP7nMwGWGmPU2HhV7PXbXAmSyNChzVIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI7it66AsI7255iQWrRjXwbZWv+K0oJY07VBfWGqF58FDFIqTGmKYaq6JQYBnXQA4hjGL6nnve7JIpwNqZ+AHYwpimApAotwNfE+Yv4qDcq2o+Z167OMqtkW5liU0Bkpt8vgT9r8cEMhF8wV8CdeS9FQLd2JjgHu/92Ix2hQWq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWWRP88a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWWRP88a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F48C4CEF0;
	Tue, 30 Sep 2025 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244166;
	bh=ik0LEaA7NbMnP7nMwGWGmPU2HhV7PXbXAmSyNChzVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWWRP88ad+p127yfNhlIGOjTAIdNqf1Pe4HtW1JPHs9Y7ZTt08WoIi1TVrMx+Qj59
	 r/0VQZ8O7uAH2MC0TrQDpFJbTL0Q2GcqO3qHrKHWfAFSTZVJMZlGJpjf9fnshDxnqu
	 vuKxPuwW+H3tunZFxj6XEblersG3Uqr52Y44odN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/122] ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported
Date: Tue, 30 Sep 2025 16:46:17 +0200
Message-ID: <20250930143824.889838249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



