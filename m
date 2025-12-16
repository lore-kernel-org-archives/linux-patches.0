Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59634676F;
	Tue, 16 Dec 2025 11:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885074; cv=none; b=j4jvLKQS7UuJGpsvtTknUo3DMaQ75X9AC6a7FJXBW8IfOsrISz3NvAgJhAXBHYLhU8bVojZMIu3c8mu1UU76w53HX1vmlufPvZYVwmemBMKdtSfBOJhw7A9rZX2MTKqdoLPEPJ+Gx+wzTONVbn/J55hj3mC97JsZeyZ9o47Qjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885074; c=relaxed/simple;
	bh=IVwxq48WTfdUruZhWOae14bIFcotCzSak1tJq4q7xxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkA1iPm8dE9F2fscwMqBI3csggWTZuU44zqOQmCSAwnhV0CBn5xbl1Dt6R2j0lA9NmJiP808K6xbC6P+QxtP39/8XU/fVvFslxvvBKYW0CJ1008YKhU3a4zalLVK19+Gyu99QrMdTPSVy/vR6bNQ2JuV4C3999L1jUVqPeuaxkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHGynU/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHGynU/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3323C4CEF1;
	Tue, 16 Dec 2025 11:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885074;
	bh=IVwxq48WTfdUruZhWOae14bIFcotCzSak1tJq4q7xxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHGynU/0nRihWsm1zSJRjcfningjUUo0Y0P1SSw9NLLXA0qS7aztrjZKtbe+J5e/H
	 Kynd897IKSkWBzEYRro9oYHs5BUOBSfux1Q0hPXTkdaPJMaFnlmWc8NDXPa0gUR3Hz
	 x7pFuHIvPfYzKq8rsB9dCVnl+31iaXFbpHPkxfxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mainak Sen <msen@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 008/507] gpu: host1x: Fix race in syncpt alloc/free
Date: Tue, 16 Dec 2025 12:07:29 +0100
Message-ID: <20251216111345.832832364@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



