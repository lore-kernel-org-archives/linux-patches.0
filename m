Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74B359A6B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302400; cv=none; b=sgHeywsHrdHCaahink96z1Pl0YvJ3ndgtgMrvufcGO7KjHfsRav7p4aLT8oz3W1tHP4p8kkc1vQKWXnQuiuzs1RluRkOoh7TQXWxs01+pPbYt5hOnrHrweiCMz/2+wkziphuf2VNkqkZqisFP4/J8smOsx/iKJ+z6+mr4eIQp2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302400; c=relaxed/simple;
	bh=7C+wcDeyjgR7GRw+fFWz7LB4wNiZqX+J1OPHQGpU82c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYIdtmqG8hI64DrWeE+bpdu2wjJrtdBBXD4YgKG2v5g0zZPfF5exJPIjvGcmSS6ZH257w7pdMOuNKt+2/PvDV2ehBYNITBDK1cA0Qb++RKlvP8TLhTspJF0xWMNkM6mk+t0IkDgZXzPWqJe9/0s94Q9QQebXx0pbI8LTwA8MmOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6XD6IYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6XD6IYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1877CC116D0;
	Sat, 28 Feb 2026 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302400;
	bh=7C+wcDeyjgR7GRw+fFWz7LB4wNiZqX+J1OPHQGpU82c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6XD6IYZBFb7X5PE+mWm/H1LHYmvxg6/5vU16+sBFSXScgZBSsoPvk7N16x9SYsWF
	 mozOZfYZFe277TD6hT7DuA6i1Jdx/CddgZGztxOiHlVAYqB/DCxmOTCDTN2VB36QZX
	 +u3poDyod4LPizG5Njpd13QowpwAPP/aZFaCf8y9LwYZ0RQGflvzHsY7Zxk9MoY/lQ
	 R1WZjPlJUwqQySeR11cKBYIUl7W/w16SuV1ng3ByhSX81HAq+Q8AKMXoyUwCH/tR1w
	 WJWzgAHJ/McNDPS8ro+4HD//skB6lClFKrKk2VdJYVEaTSTFJ03SOOdfO0mMdJ/zdD
	 pW16vFh8TDYlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Etienne AUJAMES <eaujames@ddn.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/232] IB/cache: update gid cache on client reregister event
Date: Sat, 28 Feb 2026 13:09:44 -0500
Message-ID: <20260228181127.1592657-131-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Etienne AUJAMES <eaujames@ddn.com>

[ Upstream commit ddd6c8c873e912cb1ead79def54de5e24ff71c80 ]

Some HCAs (e.g: ConnectX4) do not trigger a IB_EVENT_GID_CHANGE on
subnet prefix update from SM (PortInfo).

Since the commit d58c23c92548 ("IB/core: Only update PKEY and GID caches
on respective events"), the GID cache is updated exclusively on
IB_EVENT_GID_CHANGE. If this event is not emitted, the subnet prefix in the
IPoIB interface’s hardware address remains set to its default value
(0xfe80000000000000).

Then rdma_bind_addr() failed because it relies on hardware address to
find the port GID (subnet_prefix + port GUID).

This patch fixes this issue by updating the GID cache on
IB_EVENT_CLIENT_REREGISTER event (emitted on PortInfo::ClientReregister=1).

Fixes: d58c23c92548 ("IB/core: Only update PKEY and GID caches on respective events")
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Link: https://patch.msgid.link/aVUfsO58QIDn5bGX@eaujamesFR0130
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0023aad0e7e43..6d980ac2488a9 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1555,7 +1555,8 @@ static void ib_cache_event_task(struct work_struct *_work)
 	 * the cache.
 	 */
 	ret = ib_cache_update(work->event.device, work->event.element.port_num,
-			      work->event.event == IB_EVENT_GID_CHANGE,
+			      work->event.event == IB_EVENT_GID_CHANGE ||
+			      work->event.event == IB_EVENT_CLIENT_REREGISTER,
 			      work->event.event == IB_EVENT_PKEY_CHANGE,
 			      work->enforce_security);
 
-- 
2.51.0

