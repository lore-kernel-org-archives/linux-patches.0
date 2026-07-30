Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4230C618;
	Thu, 30 Jul 2026 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423661; cv=none; b=dcDHvB4n0DLG323JGjqEc9+04P0YgDZmpG6G9UBsCTLOvUYcxdAca1v22pw1QOGytNbQHDuZGNQyHZ/OaanbMFSxT0TgguIZXkddVhDaCDX6megDoja425WMruV1cBQOVPpYiizZHGF1sR91Vm8rL6R21DwRjBMxL9ZMp5pfs/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423661; c=relaxed/simple;
	bh=BEWxCLLXlbCrhKaksknoIjxnbfuVsKLwwtqHYt9CLwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcgReiHai69S4Mo5i02/ZZKt1Y9RdDCXJaRP0VQBcwibk8LyGz+CS4MUQgPxLB4Vezs+M+xpyPek8gAkPIZR9aMCIMGzVxb0SKY6IiKomrCp+EkztMN7+Cs9/NTRqcP3ubb21kFOsyRiLeA/F2LRiKmbQy+o1I9XYVzKfFuDZ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLqJ+OTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLqJ+OTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C651F000E9;
	Thu, 30 Jul 2026 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423660;
	bh=0TzFkus9GCM0JHLPxBfLA/u21Z1FoIf1AjkLJLG4Udc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLqJ+OTSU5Z1pSF8WzQEuW5LrDScz5iD8hpdvHnyuOzdp/yl5IGXDUCCIemN/Oz7A
	 STbcdDtKrHHTfhYTPFOwdEJAXQnm1n3VVmc/ODDFDWvRtFujOTbupHTARD6Id7QZSI
	 C53pYP7z0F28cudgVE7cfWLdQVpkba/fQq631kIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/675] drm/panthor: Check debugfs GEM lock initialization
Date: Thu, 30 Jul 2026 16:07:30 +0200
Message-ID: <20260730141447.696510177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 022e901333c3054656a640794e842bab7af5a75c ]

drmm_mutex_init() can fail while registering the managed cleanup action.
When that happens, drmm_add_action_or_reset() destroys the mutex before
returning the error. Continuing initialization would therefore leave the
debugfs GEM object list with an unusable lock.

Propagate the error as is already done for the other managed mutexes in
panthor_device_init().

Fixes: a3707f53eb3f ("drm/panthor: show device-wide list of DRM GEM objects over DebugFS")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260713082912.321021-1-lilinmao@kylinos.cn
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 962a10e00848ef..cdf82d83de7abe 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -182,7 +182,10 @@ int panthor_device_init(struct panthor_device *ptdev)
 		return ret;
 
 #ifdef CONFIG_DEBUG_FS
-	drmm_mutex_init(&ptdev->base, &ptdev->gems.lock);
+	ret = drmm_mutex_init(&ptdev->base, &ptdev->gems.lock);
+	if (ret)
+		return ret;
+
 	INIT_LIST_HEAD(&ptdev->gems.node);
 #endif
 
-- 
2.53.0



