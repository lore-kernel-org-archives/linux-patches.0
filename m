Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26C7347FD1;
	Tue,  6 Jan 2026 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719878; cv=none; b=tbTiYMCuJcqkWu+nrAjPk/GzShI56Dmw2N/ybJmN9gMzvny/idp3jKjUEoms+7M41xnAZoHkZOPVcK3ly37JTqeA/rkaZlrPKYgy2qrXvurT4+LkRS7TeF52qQXLdE0CgptpAw2mPrno7obr8a+q2j5Voy096fQiUUjR33t9HTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719878; c=relaxed/simple;
	bh=4Yx0hI+ZMGaS/p9K12sk7E4W5UJMZE0Xu0EyuyaY95k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRDbb3gfWq9eWn7JFiy1at6C4DnADy9gGwmGjf0YOQs2W+W9WDjn2SXmmiBOnr1iP/o89jOfPjB7ZIDOgh4Ee+2+dzlx7DG3eXHCknQRDcZOTJoOyRL07v+qgmYP7aJ3r5l65QQBYeQL3BQoNd2KuAY6a4njQUcW4novoiGv9E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uGL/D4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uGL/D4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293EAC116C6;
	Tue,  6 Jan 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719878;
	bh=4Yx0hI+ZMGaS/p9K12sk7E4W5UJMZE0Xu0EyuyaY95k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uGL/D4ttfYdVJy9z7qM6L5IYcQPoubOLJhmWXrpPoIj6vpa4Pvxw8AAjhErQ4ogB
	 WKG6+Ln8BWn4lEPDpqZl9HTIS7SWgYhDFrQXuxzHftZEUWKgFeQIhFAUiA6TXvDsAO
	 vE9gjVM3TjzfYDfl7tGeeP3Px+Z9KF3qXSNEi9T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/567] gfs2: Fix "gfs2: Switch to wait_event in gfs2_quotad"
Date: Tue,  6 Jan 2026 17:56:57 +0100
Message-ID: <20260106170452.640634687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit dff1fb6d8b7abe5b1119fa060f5d6b3370bf10ac ]

Commit e4a8b5481c59a ("gfs2: Switch to wait_event in gfs2_quotad") broke
cyclic statfs syncing, so the numbers reported by "df" could easily get
completely out of sync with reality.  Fix this by reverting part of
commit e4a8b5481c59a for now.

A follow-up commit will clean this code up later.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 2e6bc77f4f81c..642584265a6f4 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1617,7 +1617,7 @@ int gfs2_quotad(void *data)
 
 		t = min(quotad_timeo, statfs_timeo);
 
-		t = wait_event_freezable_timeout(sdp->sd_quota_wait,
+		t -= wait_event_freezable_timeout(sdp->sd_quota_wait,
 				sdp->sd_statfs_force_sync ||
 				gfs2_withdrawing_or_withdrawn(sdp) ||
 				kthread_should_stop(),
-- 
2.51.0



