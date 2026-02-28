Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CDB333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301830; cv=none; b=j84w9dd0A1B0CQJcllyP+p2h3rScgSsioXdUAaa4JPqaagQReBXbmF6lf+ueUz4E3nHhrk5WSGa8pLybHRRHZCdmftbcMQ4Xkrfazd7/GXghXYxwym7Q8fw4HsosX8rE1gj/RlmV512lGR8ucNbPFgviUDDjA76juzv6wVThkcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301830; c=relaxed/simple;
	bh=iLqwz4AKcFpCSGaJUD3Fyv2IbZBIUMxJBnmRbBRlzjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Srp2BVjvUIaUflTL7fQcvyzzOUMn66xKT29nzCeH6+CsQTD9BN9xDAPyBCkm8BV4B/l+d9TibgownxN7r+GS5de9wwJ52ZN9f1JC3ohfTuhNT2A9OD/VRiWnOijKKbOZXL2mwT1vPLeQtvYP3gV3QSFRxvkFR5IKiMv49aG9o4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oquW3XFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oquW3XFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823B9C116D0;
	Sat, 28 Feb 2026 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301830;
	bh=iLqwz4AKcFpCSGaJUD3Fyv2IbZBIUMxJBnmRbBRlzjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oquW3XFQiPcK+a6SAhQpyC209Tcd2uQtbHgSk3xcyYEEyjvz+Z4AmF+zVYyCVmVEH
	 1ie6uKXo2oorfSXCiSCv1ooM1Ia54dU8FV1wEm/AVOaclVedysfeR69EZiThKvqead
	 iIEsEAGgJMHhxmeb1sqeTuRf+7FBF3rfaSKDocsYlNNHVfFTP5TNNNY8m2K9OSZ907
	 3SCcSf8H46XRNEYY17eCd85t0jSbaYrhcWAGhoUUc+oAnbgUDPp1eBQNfWl/vBelgQ
	 sC6G5/WWvsGKMA0XpSZdUuZHFxJIHa6ETb97qJiO93rpz7PjstK4bR77CLHrj4YV/h
	 /aUYwCehk7dNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Etienne AUJAMES <eaujames@ddn.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/385] IB/cache: update gid cache on client reregister event
Date: Sat, 28 Feb 2026 12:57:48 -0500
Message-ID: <20260228180011.1568201-246-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index a1291f475466d..19851d05b4f88 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1566,7 +1566,8 @@ static void ib_cache_event_task(struct work_struct *_work)
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

