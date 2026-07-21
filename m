Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F407388890;
	Tue, 21 Jul 2026 19:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663145; cv=none; b=UgcGEw8hjVl/GVOoDYz8KveNXZPbkLBsQ2AnmoVZRfQAeg8LLevsicvZWnGNKZfPqac9vV643KjL8RmkkE+EzJbO2K+fj1CtgVKYKSnoXtGPTDN4FDkKLAHj7wYZ4DR8uShE7cyy/o1wE18qe4UEQrnffR2XHVZ9vpZvKwKxtDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663145; c=relaxed/simple;
	bh=hLlcmONBepvBNiGSaZpFvmAf91nJI+bWdQckjwiMZxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOmlBt+edDzBU2C2IIfUc/OMchOfMMxd3Ly1THH9iYN/VwtQDgCiJQIPqFoftFDIx0n/wq1ElC6l/GUtkmIqY0i7ro3QSr3u3F6wYwRlPu47SIp5mQ/D0vJ2Sw+D46Ld9QYxq1j2T6r8GqZnEPgHRdL0p48x9ocAzZqstJBmr5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4EDvg07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4EDvg07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A91F000E9;
	Tue, 21 Jul 2026 19:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663144;
	bh=lsvJO7Z1P04ZLvdWTvh+j/cvq8qPBntvvd0eNbKN/E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4EDvg07ppavBZhCfaWRbiY21HyDf7ncdd6kn2LSEyMUCYXuLftX9ESYWRfwNxqWN
	 GjvUeixtgcVk2kjNc54hVQKBciupkl4jvJLEwhN+3UfEjByo4HMkx7J9YZG+q/WVSx
	 qXIIobowt9F4CAOmAvwMulaLTOsM4yyEwn6jc7wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0712/1276] drm/panthor: Fix a leak when a group is evicted before the tiler OOM is serviced
Date: Tue, 21 Jul 2026 17:19:15 +0200
Message-ID: <20260721152502.028057684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6efeb9ddb4fbf5ac30aff03e8f09ffbdf966abd0 ]

A group ref is tied to the pending tiler_oom_work, so we need to release
it if the cancel was effective.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260623-panthor-signal-from-irq-v3-0-2ece396f8ee0@collabora.com?part=7
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-9-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 0173f27b1a9261..2a1a6a04901d28 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -999,7 +999,8 @@ group_unbind_locked(struct panthor_group *group)
 
 	/* Tiler OOM events will be re-issued next time the group is scheduled. */
 	atomic_set(&group->tiler_oom, 0);
-	cancel_work(&group->tiler_oom_work);
+	if (cancel_work(&group->tiler_oom_work))
+		group_put(group);
 
 	for (u32 i = 0; i < group->queue_count; i++)
 		group->queues[i]->doorbell_id = -1;
-- 
2.53.0



