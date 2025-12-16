Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCC1341069;
	Tue, 16 Dec 2025 11:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884166; cv=none; b=oyTLUjFY+4DqRGIDsNryy7BHyqxJPzbmpmx7q3wvPzaUgwyQRoepoBCGjHhDfvFLYTAT9mDqnmv+xyNLKInaQy7ALExVIpcwCVq5z8K5XLFKl9WgB3VhbiQYWmjTp5dMi+tNgVwdIqrTpluvGyqe8mg+FuTpCoYWciCc4vofytU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884166; c=relaxed/simple;
	bh=ZOSqU2k5HFR6g0izBl6glJqW+f0ZQy0NlAmj5JLwdE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxupJ7tIgJY7gAe9l3+9P3MGF03BukDZ9igRAQSstWhqQps7nAOsg+4/5C/fCzRlqtwZkqTGlC8QCQOZmeT6cb79qZPemrui9s7mvv7ajJMbDP1Am/M9kt4TvLqK1WiqfEXaOdMBPCWaBLL/Ehl9GkhR923TRtk6C2ADg6ELlF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAIa8Tgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAIa8Tgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A71C4CEF1;
	Tue, 16 Dec 2025 11:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884165;
	bh=ZOSqU2k5HFR6g0izBl6glJqW+f0ZQy0NlAmj5JLwdE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAIa8Tgv+ieI4uoZRlhiOzDcvqf/bJRMGZiONxkuMYVlVOsEXbIv9dRcpNXDsovXI
	 DU7h7+NnGccaJpRj3JPSvL0IsSDjdrXK+3AMjnZ1BFsbg9tEmURriC4pUNFBomG4O0
	 fkcUkKdqnxeND/DpCtKYvXEGZhGdHAKiQM1ZBTK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/354] drm/panthor: Handle errors returned by drm_sched_entity_init()
Date: Tue, 16 Dec 2025 12:11:19 +0100
Message-ID: <20251216111324.980211465@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit bb7939e332c64c4ef33974a0eae4f3841acfa8eb ]

In practice it's not going to fail because we're passing the current
sanity checks done by drm_sched_entity_init(), and that's the only
reason it would return an error, but better safe than sorry.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251031160318.832427-1-boris.brezillon@collabora.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 0bc5b69ec636b..875b9a78d34bc 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3307,6 +3307,8 @@ group_create_queue(struct panthor_group *group,
 
 	drm_sched = &queue->scheduler;
 	ret = drm_sched_entity_init(&queue->entity, 0, &drm_sched, 1, NULL);
+	if (ret)
+		goto err_free_queue;
 
 	return queue;
 
-- 
2.51.0



