Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E2318C00E;
	Wed,  6 Nov 2024 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896153; cv=none; b=RRW84dlI9ZlErw0B4aJFR3TVefLSNYjsUOU1hVK6TL2xdEoKiSSloeuGrwX5XiQKknn9Zyfw94d8+X8ctAg089LYWEJG+lJ27y1NG0UWPERBKGSGqsYnDD6TUMBDdjDvPocXZW6dqwQVnzKH25h6W94TQsTIrEeWrm+GB+f6Mng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896153; c=relaxed/simple;
	bh=/nUAC8kbBjJqJ6YMQMLg1uq2EZr0QDooti5ibdouA4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4eGKT8c5uTQdpX0224QS+SbOPH3lwDC4l+kaSZx4GLBXHlsqDBCIQSBOw+2PzDRVPR1bCsuXgZzAjA/iV50Ogdzwi7XH77tVF5XowfqqBNoWO5/fkLOKBgH+snlap0uU1GrNqXUYeUyk33DrouVVplIC11UmwWu4V3L6+IXFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1nff4Nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1nff4Nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0136C4CECD;
	Wed,  6 Nov 2024 12:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896153;
	bh=/nUAC8kbBjJqJ6YMQMLg1uq2EZr0QDooti5ibdouA4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1nff4Nch2QJ0FeE6EBvNdB4KqT091yd5SZSqZ7xtmQq3acFAfmH7pRSFRxbB+qwp
	 PFoMpKCH3H2PJCCxabJEIIEvxgxXG3C8jB673yTEqFDLPrj7O+HHtXlrlSIMPoebCA
	 0cgi+8e3nUHljpBtSphuB14DcG6gu7RhAlZgjcOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 080/245] drm/panthor: Fail job creation when the group is dead
Date: Wed,  6 Nov 2024 13:02:13 +0100
Message-ID: <20241106120321.174598431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 412a2a8fdd4eb89b263623c7a59b77dbfcf8f215 ]

Userspace can use GROUP_SUBMIT errors as a trigger to check the group
state and recreate the group if it became unusable. Make sure we
report an error when the group became unusable.

Changes in v3:
- None

Changes in v2:
- Add R-bs

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241029152912.270346-2-boris.brezillon@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 4d1d5a342a4a6..9b64c61caab64 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3409,6 +3409,11 @@ panthor_job_create(struct panthor_file *pfile,
 		goto err_put_job;
 	}
 
+	if (!group_can_run(job->group)) {
+		ret = -EINVAL;
+		goto err_put_job;
+	}
+
 	if (job->queue_idx >= job->group->queue_count ||
 	    !job->group->queues[job->queue_idx]) {
 		ret = -EINVAL;
-- 
2.43.0



