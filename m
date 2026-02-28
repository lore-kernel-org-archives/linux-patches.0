Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6569375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302583; cv=none; b=nxte768QIVYBBa6gNmFLvyHNrdfjNcYpxYOIo0J+B7BF9cEKDlz7szASEQoi8Cd4uevtNqLFqKyXNPpkfVrOdtXyAjyppt/z0m5kv8QRUHhV0QxAq67wvhWt463bHC3rrPV+KygihQw7fUFNLRm0fXmabutggUBYsSXJJkSDMvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302583; c=relaxed/simple;
	bh=kFHf55YhVI9c5MUVaZlFR7Em1pAZZ+JX3c9z8lIGZ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ode+/5od6p59WvSFkdEghT2gG4eMbHqFm7ad1ZVOYyCpmRDorOFgEea7K2dXd5Mt8CwBZYDqGku6fygs2bU+WhIbWYXtwrd8+oOfUQWoqVqvEYUEvSywdCduYDifluPCrywaznD4bIaSYkg5oeLQVo4xVxDuNHtnpZydSTT8BrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rY+m0E34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rY+m0E34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102D6C19423;
	Sat, 28 Feb 2026 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302583;
	bh=kFHf55YhVI9c5MUVaZlFR7Em1pAZZ+JX3c9z8lIGZ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rY+m0E34kLb74kG58Oo2q3Hhxk1H3pg4i7E/Ei37NCG8GwJENQzYQjuDUxwI5u8HJ
	 YsmAoFgkbnxes91kz0DQh0974SJo2d4hQjJLzbBwVroeIuuqI/Jz9HSiTO3AOL/zAD
	 P63iAFbbZVysANQS4GRYUz/vLyDzSzBsf47PoPiUu05kDx/ESJ5VuO/K9gV/EYnx58
	 N6CUFKO8n5GNKrveJIMxH/E2zH84UdgtTrRhaXSAmTy2aqNre+BcQGhtgheqG5qs/Q
	 3LEMD60VB6snQa0v1uO9+HZtRMY0KcUZTvwwIITg3j4TWszxCFA7jfik681FAxrsmb
	 F9Zn7hfa1NaKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Etienne AUJAMES <eaujames@ddn.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/164] IB/cache: update gid cache on client reregister event
Date: Sat, 28 Feb 2026 13:13:51 -0500
Message-ID: <20260228181505.1600663-92-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 91ee3e823a9fe..d43a005a18d37 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1549,7 +1549,8 @@ static void ib_cache_event_task(struct work_struct *_work)
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

