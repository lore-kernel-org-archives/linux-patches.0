Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C512335970B;
	Fri,  9 Jan 2026 11:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959425; cv=none; b=TLhGwesE6+cvEshx39odONnSvHgZoUdjR5VxWRQP2cD0JMGOzTBDHbzymju7fIzoTLuIDwCvoCEJ9hp4QRepvj+sgTc+FIy1jlmaHrnM/oRBq4ao24dgHd+l9pSDfLrdV6G2eEd+yBdyqsV4e93JdHG6kIBtKr1x7g2FpvujIjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959425; c=relaxed/simple;
	bh=gSnKq5KUiOccICC3xUGLZGeloV1CVU00lDIWk9OkcmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDBq2aDXIybn5tmBI13zoeSkKOt522samD0RoWwH3Xe1JUB+4eBlaDGu8uup0jL7viXqyXuxA9oqR18tQaM1FDD0oxlmcRGd5NAdx5fLHB5C5dNAPVfR0h6ha2AA/ExUodk4CGaVllTVJXLnMV+fBjt0UV07QMvdFVoYFPe84Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMkvFBiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMkvFBiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17EAC19422;
	Fri,  9 Jan 2026 11:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959425;
	bh=gSnKq5KUiOccICC3xUGLZGeloV1CVU00lDIWk9OkcmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMkvFBiZyKh3fAvBD+BmbwT1hYzoeVivF5bhb/ccu8D3XFGoIu54kXbqPaRmwzimo
	 vrJCOtD8M88GYnX1wZgOt00AO/kqcN01MF0Aemiu+zXt4/fpoJbqHzrXSgHY9I+IHq
	 eLLsH019RBgInhg3s5kHrFQij7mn7A7OUwio719s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mainak Sen <msen@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/737] gpu: host1x: Fix race in syncpt alloc/free
Date: Fri,  9 Jan 2026 12:33:07 +0100
Message-ID: <20260109112135.801750660@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mainak Sen <msen@nvidia.com>

[ Upstream commit c7d393267c497502fa737607f435f05dfe6e3d9b ]

Fix race condition between host1x_syncpt_alloc()
and host1x_syncpt_put() by using kref_put_mutex()
instead of kref_put() + manual mutex locking.

This ensures no thread can acquire the
syncpt_mutex after the refcount drops to zero
but before syncpt_release acquires it.
This prevents races where syncpoints could
be allocated while still being cleaned up
from a previous release.

Remove explicit mutex locking in syncpt_release
as kref_put_mutex() handles this atomically.

Signed-off-by: Mainak Sen <msen@nvidia.com>
Fixes: f5ba33fb9690 ("gpu: host1x: Reserve VBLANK syncpoints at initialization")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20250707-host1x-syncpt-race-fix-v1-1-28b0776e70bc@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/syncpt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index f63d14a57a1d9..acc7d82e0585e 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -345,8 +345,6 @@ static void syncpt_release(struct kref *ref)
 
 	sp->locked = false;
 
-	mutex_lock(&sp->host->syncpt_mutex);
-
 	host1x_syncpt_base_free(sp->base);
 	kfree(sp->name);
 	sp->base = NULL;
@@ -369,7 +367,7 @@ void host1x_syncpt_put(struct host1x_syncpt *sp)
 	if (!sp)
 		return;
 
-	kref_put(&sp->ref, syncpt_release);
+	kref_put_mutex(&sp->ref, syncpt_release, &sp->host->syncpt_mutex);
 }
 EXPORT_SYMBOL(host1x_syncpt_put);
 
-- 
2.51.0



