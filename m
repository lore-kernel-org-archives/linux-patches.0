Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC7436492C;
	Sat, 12 Sep 2026 09:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206364; cv=none; b=SsNT9JxApBsPmcs8inXKQCPzW6VPr8UQN8yAogVD/R2yDY2YIEqQzMu1XGKi0JZzDPQjGqvFOR2e5hjWC6q+8Ap2GGLf47MT0sxime/DgQbSP8TgOIbVtxNvxPr+d84DMWSB9SdgB9lEDfIir67Ruvr6XKYhswmhSetLXIxPBpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206364; c=relaxed/simple;
	bh=/c9J6r7aczh0ZsGdb4J28jFXcinzu18CMM6SiFA8HvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLqQWhOrbhqaTpM4J+Ndr9RutglTQhbYN1/PpjmGhVURCDyUNrerusUP1eRQI+KCsITV/2V5f+aB1JXmvoZ++j5kFipziyt2Mc1i2BiuFiRnL6ChLtmhiLPDkBsfJBUx/v/p6eLrk4fWNTtOpN6qQDPBCYQZT9H51Vb1Aq13BnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHF58oKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHF58oKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7631F000FF;
	Sat, 12 Sep 2026 09:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206362;
	bh=OzTy/LCIh7RnpfcZ3o3FbeSuOwG/o67TL2NUWihx/PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHF58oKbRGnCEcwf6TiYPDA/pLtQeuUu4WJnFC8hMRHdOfiZBmSFrXnqhK9IEYn4S
	 OpZnhfjaQnSxSsw5HB94wM3tbvQgYKwL6qkntyaoc1VJ6TZbe07DM7vjNp0y1pYZ21
	 uNsGzgcYZ2CukX9CjQyiyr6G7RZBRKatn2npxurQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0193/1518] fanotify: initialize permission event watchdog state
Date: Sat, 12 Sep 2026 08:39:22 +0200
Message-ID: <20260912065627.856114600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit a3aa899823dda059ab88a58254f9a605e03ec275 ]

fanotify permission events are allocated with kmem_cache_alloc(), but
fanotify_alloc_perm_event() does not initialize watchdog_cnt.

The watchdog reads watchdog_cnt after the event is moved to access_list.
A stale value can make it warn too early or skip the warning.

Initialize watchdog_cnt when allocating a permission event.

Fixes: b8cf8fda522d ("fanotify: add watchdog for permission events")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260703031345.9354-1-xuanqiang.luo@linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index cf57eabfed456..cdb69c23e2e6c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -601,6 +601,7 @@ static struct fanotify_event *fanotify_alloc_perm_event(const void *data,
 	pevent->hdr.pad = 0;
 	pevent->hdr.len = 0;
 	pevent->state = FAN_EVENT_INIT;
+	pevent->watchdog_cnt = 0;
 	pevent->path = *path;
 	pevent->pos = range ? range->pos : FANOTIFY_NO_RANGE;
 	pevent->count = range ? range->count : 0;
-- 
2.53.0



