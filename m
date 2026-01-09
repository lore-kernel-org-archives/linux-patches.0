Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0DD359701;
	Fri,  9 Jan 2026 12:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962098; cv=none; b=fYNnwO8n/E2itHnbPfG/wvtVhan3sHkfyySGVufGotjvKXq1edH/vJ+5QTjyEaNGfMY3/Tg+YUkxudPFX4bLw91CjJ8X6HxkGO02iKZGowKIXQ1w87ipmziWqZNFZk0yaIU1fgnYsywtqyEszlNnQf2Wo4zYNyC/rVBQjAgDq70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962098; c=relaxed/simple;
	bh=tDcAYe6FNxCsBmj+do8aGnBa/T/BYyfpzetRBIpqouU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPxarIPgGkvWoUyxUjkVEsvrDgJpsuLVCIR5DBbDbEJTtw6c7TwrFwB7OCMqZxRsuCnBI6pFaqYT/eBwYYjL7Ku6teFvio+GgB2VvuBYtLgrNlbMN3Y37eXuqK4QtLOHjDY/uSIMQrU0VNrbul8ivyMfKsRNU9xWHbVnkzSbZc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt1JKDIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt1JKDIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECB9C4CEF1;
	Fri,  9 Jan 2026 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962097;
	bh=tDcAYe6FNxCsBmj+do8aGnBa/T/BYyfpzetRBIpqouU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dt1JKDIO0PyBCXfnXfXnwboTtMVrfaSZA4p5yZk9/C/j3wpXVQYzP5CpNeUNM4RSd
	 vdORn9sify1E0wffOm8lzzdSha22kRCkWGd/ah7k7iz/JaPRjuebx3VUddcpyFU684
	 3w6Ccs2BJhPWPDp4vfhmilwpbOGU6DWEST3k6YzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/634] dm log-writes: Add missing set_freezable() for freezable kthread
Date: Fri,  9 Jan 2026 12:38:11 +0100
Message-ID: <20260109112125.450765220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit ab08f9c8b363297cafaf45475b08f78bf19b88ef ]

The log_writes_kthread() calls try_to_freeze() but lacks set_freezable(),
rendering the freeze attempt ineffective since kernel threads are
non-freezable by default. This prevents proper thread suspension during
system suspend/hibernate.

Add set_freezable() to explicitly mark the thread as freezable.

Fixes: 0e9cebe72459 ("dm: add log writes target")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-log-writes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index efdfb2e1868a4..4241f40f9ad26 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -431,6 +431,7 @@ static int log_writes_kthread(void *arg)
 	struct log_writes_c *lc = (struct log_writes_c *)arg;
 	sector_t sector = 0;
 
+	set_freezable();
 	while (!kthread_should_stop()) {
 		bool super = false;
 		bool logging_enabled;
-- 
2.51.0



