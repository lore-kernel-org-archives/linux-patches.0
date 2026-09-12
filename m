Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E7429000;
	Sat, 12 Sep 2026 12:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216673; cv=none; b=R9S7pVX3rIHuX9/vdQpJXnaXDeP9qTB2dta270JfOtglOQKYgdROQlnXc/Go+4X1biTuziC7rUVed8Nych6B8pTJyis6DEvxkm6Wv7nmtScqfmAqnQ/e3w2l2pn0yaN5a8NtYXvBIJgpVQp/i+p3JybKpvTbpoPjB3aLGrB+8AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216673; c=relaxed/simple;
	bh=uNjYgEXpNgGSrTODTDcCJXo2vZKI3YP5vcBUy7Y/sFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSVm9MeaVPAmC26flVtny2rq9IRdT+XJ0ZaIw37teczhuIAKCz2kgIMFFIxm2kUsGmjU6O0WKis2tPNxvfwzwh9fdN1b0nocKLj0KgZMidfq4WirjeE9rILRo2yRsULmz3DMOE1rHjhucLx8bEOg7HDAHx8vJfsmvC3mnT4t/Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUkmKjLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUkmKjLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012801F000FF;
	Sat, 12 Sep 2026 12:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216672;
	bh=QmOZYJt+xWIO93pnkZVgsf3JJwqBlF7HWX2+ay8rSho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUkmKjLeDhnOoBLvbswdVXMaR6N9yhbLh0XafVtPyEg5uylUkiqBKpYqeUx3eREpr
	 WhVhAi3xHZEVS12KbIgbYsGg1IoMCFbPjmvO/BXlzve0ArbsoyO8zmPgucJZPBFsKn
	 tl6bmwlzUPLtvqntzFzYVsRAzqmwC4KWsz2R6q3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0782/1376] md/bitmap: resume array on backlog_store() error path
Date: Sat, 12 Sep 2026 08:53:28 +0200
Message-ID: <20260912065624.966967635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 2911cd0a0f4366a7e06832bc5f0a7fdcc138e4dc ]

backlog_store() suspends the array before checking whether a write-mostly
device exists. If no such device exists, the error path only unlocks
reconfig_mutex and leaves the array suspended, blocking subsequent I/O.

Use mddev_unlock_and_resume() to release both states.

Fixes: 58226942ad3d ("md: use new apis to suspend array before mddev_create/destroy_serial_pool")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260718034236.4119093-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 33b92b864f70c..67f1b716e2936 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2816,7 +2816,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!has_write_mostly) {
 		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
 				    mdname(mddev));
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



