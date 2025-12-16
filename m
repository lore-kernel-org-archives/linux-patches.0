Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5568635CB7A;
	Tue, 16 Dec 2025 12:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886778; cv=none; b=GwZ+gmkpBx48P2W0Yc9LowrZYbFQb9CKJ97HPJLW6+arJMG+A/tyE05xTs1Pwaphn3Lu6Y4iJF0xb22SPzrx4Hii8wRxe4XZRLe0fGgb7Z04QT/7MK+0AZDcAmbTJg1EWEO+4v7e/BAkfEkzrEbKgvcHIwGrbzIzuPGvFCah/T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886778; c=relaxed/simple;
	bh=LtNjQg4QKjf2rGDS2xKAIP7rtthKUMQtm8wLkzOYSlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT/0jQVCVUODh9yHFOEIkgRH5O0yio/mXn7qGEv6Wggp1nQ+QfpiOBzvtKEjXgfaqOgjF7SMgiwec6X56z9ruzL2OFljVSz8nv/FsmWSlYjcDt5dL3CuZ7FgG6OgixX8whrZTp/gYBqgkV2kyELmGxM/5ifjXwtjMqj+cDrCKFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs3s7MMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs3s7MMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B96EC4CEF1;
	Tue, 16 Dec 2025 12:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886777;
	bh=LtNjQg4QKjf2rGDS2xKAIP7rtthKUMQtm8wLkzOYSlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bs3s7MMY8NBy1HTG/Iiz4H35aFtNjNmkIzC2dmVgMigVpHqyPBetbolj0UXQ2gdj4
	 yVqsHwdpOyL7DBmD2MInlHNYex1bdJnu3DIR/VC8+7hV+E9d2Wl8mmId03ga73Ha39
	 uz3TYebSPZHQTm6n312cXAK8C30/F04PFS/nQlSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mainak Sen <msen@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/614] gpu: host1x: Fix race in syncpt alloc/free
Date: Tue, 16 Dec 2025 12:06:15 +0100
Message-ID: <20251216111401.597308768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



