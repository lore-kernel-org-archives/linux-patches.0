Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E366033FE27;
	Sat, 28 Feb 2026 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301276; cv=none; b=EqozyVJ818cR2txfo1okzt7HzYrk8pcLUKkAkZM2Qx2VGc1YUP2rdALPLFJxkDLb6fhPJA7S4qXiAvfw5PzEgOQ5Sfn29paoxRDVFUAokTV440/v5287vHRJZzlnMJS13+L6WYx8MtRZTb19OJc0PHIDWf4aLN6fUsJdn9O4F44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301276; c=relaxed/simple;
	bh=b1lg3WartY+TK+45wchkbtQFWlQyFqFO9cZIFItyYqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow+xgBewgNN/DIAMNg00Iui4qxiZ9Z2fCeXbaqM8CyfpiMc3n20SmQVwJI8yeklIfxds02UyN0Vh0xKBmfrSo7vcNSzWPya0PQf/JXK2X3HgxTRTxzYRn3uK6Z3TBBd0PweMsQ8mZW/OV+SOc+7UxsyTBiDwV67kwuUMZrmell4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=As27s5so; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="As27s5so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142A8C116D0;
	Sat, 28 Feb 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301275;
	bh=b1lg3WartY+TK+45wchkbtQFWlQyFqFO9cZIFItyYqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As27s5sovgWIRtMSh+Q/GeRmHqN+82mi0CCLjojzvI4Gg2GZpKqqw6zHceCqYFc/8
	 ZvHjXTnJ7iruhWNN0ZRxKVEZ+J1/RJc3wvu+k7LZiJZxUlRsDtpT022Wvmh/6pUtDv
	 NkcPGAzL5zjmjw0sY7R90QHQlQcoBeJ1miwNUzWI9N4E5t7qWNzeJ76hSIi4uHyCZ8
	 paatGrJ7Qwxj3DaSPWIk5QLTYs932RT+7GO222jHbIV1XaB94o1TGjUNBhUKmIK+uh
	 j6XxWEcMMyinYdDb7wCJVq5P/SUXOh1MsJzYooVEVcmc+FnpxXU/oVvDXMC9qCCakS
	 ESWmiY+oY4h0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 460/752] drm/panthor: fix for dma-fence safe access rules
Date: Sat, 28 Feb 2026 12:42:51 -0500
Message-ID: <20260228174750.1542406-460-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit efe24898485c5c831e629d9c6fb9350c35cb576f ]

Commit 506aa8b02a8d6 ("dma-fence: Add safe access helpers and document
the rules") details the dma-fence safe access rules. The most common
culprit is that drm_sched_fence_get_timeline_name may race with
group_free_queue.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: stable@vger.kernel.org # v6.17+
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251204174545.399059-1-olvaffe@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index c7dd98936bd6b..6930053009d5c 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/rcupdate.h>
 
 #include "panthor_devfreq.h"
 #include "panthor_device.h"
@@ -926,6 +927,9 @@ static void group_release_work(struct work_struct *work)
 						   release_work);
 	u32 i;
 
+	/* dma-fences may still be accessing group->queues under rcu lock. */
+	synchronize_rcu();
+
 	for (i = 0; i < group->queue_count; i++)
 		group_free_queue(group, group->queues[i]);
 
-- 
2.51.0

