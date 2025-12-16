Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE192459D7;
	Tue, 16 Dec 2025 11:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883903; cv=none; b=UAD4LYzOcqXGbgc7b5AkPhRbk+R8VRMEFTVjARZqG7tT0Gj0Zvix6ukSrFmbg8KAajlmLyI0RNWSwalqo4F7T4d6la40CE84e/h+VXbhjEHXsqtv4HsQIwkDk08gbD5yCuilwpy19jWKOXkmMadsGrfIrkduniH9e2dxK5ImaQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883903; c=relaxed/simple;
	bh=walC798u8t73ZlOBW1Od45heY4+NKLndeLIc0wDH6e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRiUzR/QM7BhzC8cYkRlDuVby3qxjLgo1HeD8hsCVBRQcmRC9Et3Lxb0KmFYcfYcVQV4mXqXvNy2ZvQDf8FxjaT6cKYxSgwPyr320nryVYPkd3Bz6CuvJ61Rv+I0qAIaoArDjGawwmGX7oCAHBqiv4mZhaud4A2j0+CZmwTBzug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+/OF1/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+/OF1/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E50BC4CEF1;
	Tue, 16 Dec 2025 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883903;
	bh=walC798u8t73ZlOBW1Od45heY4+NKLndeLIc0wDH6e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+/OF1/7usCEDsVtmsv6RaaIq3vWWw4ZlmY+b/ziDXsXwc8fKlw991T4qxORm/WEN
	 HuB37S/PHTfP5qCy4SgmQAxw3eh3OFpjfU2Vp1bO+acyzrsnHodgtqITEgLt7VtDrI
	 6vqDR8a5QvhwsvHQUZW6fcEooXIylabxA4GfGwks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mainak Sen <msen@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/354] gpu: host1x: Fix race in syncpt alloc/free
Date: Tue, 16 Dec 2025 12:09:35 +0100
Message-ID: <20251216111321.209171481@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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



