Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED16B3EFFBA;
	Sat, 12 Sep 2026 07:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197461; cv=none; b=JJhzk3oGmra/U5w5ElCdEyaP5ui7dSCP9B+nHje/t85Oydz0JybM7CTVSuplLjOXLxLXeVA7X/1KQjehW2mUWZVDjGSiqnvQRS1sZWpvg7ipEv0Yb0dphxmtjXsAESMAb3yEon5uRTMNv4cQ5PDq4tIylbvkf2XM7D6ob8/26/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197461; c=relaxed/simple;
	bh=YGqkmxIiJFCSkVfLaq4482ZlJz1D7DaeLFbX2pUxKBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ovwiTIzj8SOJ/WEQPcih2kJIGw8fI8cajHqBph0m1v43XFeUUvYYSmyq9AvV1X5AL2uArQEl4k3zu6LyQoKWcoAQwi8xaii2FmqJVWBN0eh6Q7Nc01E0jduWu/B05Nft27SPD+MyoQuLOLhiv6tm70S6rNyB62UCqzXm+ZJz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYPhSrEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYPhSrEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2501F000FF;
	Sat, 12 Sep 2026 07:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197459;
	bh=4kCyxd08Aeq0A0AYQXSEyJ+Cl15Qv+lqRa9JuUvWMZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYPhSrEfuTm1PV1AzyfpwFIBLYhnvxBl0xeuO9QEtE5bVSDQYEs3d6kvxGeAwwrp7
	 SBRp+H6PtiZL1StAh38i+MYdvNyT+VjauGyXAXRUD2ZFxQoft8p+E3NBdqSymCWxJv
	 +zQWh+FGWi/E7yja0yB/oV14uWoCHgl0s8IM2vPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0177/1815] fanotify: initialize permission event watchdog state
Date: Sat, 12 Sep 2026 08:32:07 +0200
Message-ID: <20260912065653.162909083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b05b6d3abb870..a208a7ec1692a 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -599,6 +599,7 @@ static struct fanotify_event *fanotify_alloc_perm_event(const void *data,
 	pevent->hdr.pad = 0;
 	pevent->hdr.len = 0;
 	pevent->state = FAN_EVENT_INIT;
+	pevent->watchdog_cnt = 0;
 	pevent->path = *path;
 	pevent->pos = range ? range->pos : FANOTIFY_NO_RANGE;
 	pevent->count = range ? range->count : 0;
-- 
2.53.0



