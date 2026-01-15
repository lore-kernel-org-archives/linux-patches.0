Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657AA3BFE3A;
	Thu, 15 Jan 2026 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497307; cv=none; b=VXZdlC1H0Zd4Zgun8mZvnSvO+0otig60XcI339d86oLjYWhS4pJkDt0eLT8hTh0XkRw1ZbdD6tLZXuQQmzV8INb5rdjiPoNXSLFGdXxFSrLIRPMLT6A2Nb711rlDKk3wYSmrGQGikW/aSq3fCY7kBxhtkhoQ7OfOwaoAwmnVH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497307; c=relaxed/simple;
	bh=FyWsh2EsSALa5iK2HjQYm6oFFfMF8qib4HqoWxB2TPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzGWh2SuS8iyReRNFhJD+OwDWAuVZ+SjCJH98CLLLJzdDmug3JiwNg0ocI98PglTpw6TDaJk1CY/l2WbNXvNgPMiWlFHgWbLG6D4Svqbcbsbg3XPsySft0UaFYN3bjJdHKw47fkwRyyVpueINJSyNCodLyGOpH87UtzT1s9jcLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuimOm4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuimOm4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACACDC116D0;
	Thu, 15 Jan 2026 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497307;
	bh=FyWsh2EsSALa5iK2HjQYm6oFFfMF8qib4HqoWxB2TPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuimOm4jPckc3j/8kr2mO5QjIT8fPR47URHeW9Hfbxz3bI0nfi/Q07BgFSXdKXGVd
	 vczdrG3qO0YgiDV9beNxe/CmlYaR260Nr12k97ZA0n/gWCknjLrUE4tYnV5Jdmj6Ke
	 Ydpl7jfCsQK5roSeyyTv5Fkv6Fg2v/swiLf8nmAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mainak Sen <msen@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/554] gpu: host1x: Fix race in syncpt alloc/free
Date: Thu, 15 Jan 2026 17:41:42 +0100
Message-ID: <20260115164247.547059415@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index a89a408182e60..c36197eab6fe4 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -394,8 +394,6 @@ static void syncpt_release(struct kref *ref)
 
 	sp->locked = false;
 
-	mutex_lock(&sp->host->syncpt_mutex);
-
 	host1x_syncpt_base_free(sp->base);
 	kfree(sp->name);
 	sp->base = NULL;
@@ -418,7 +416,7 @@ void host1x_syncpt_put(struct host1x_syncpt *sp)
 	if (!sp)
 		return;
 
-	kref_put(&sp->ref, syncpt_release);
+	kref_put_mutex(&sp->ref, syncpt_release, &sp->host->syncpt_mutex);
 }
 EXPORT_SYMBOL(host1x_syncpt_put);
 
-- 
2.51.0



