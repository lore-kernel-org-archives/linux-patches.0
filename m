Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0762633A712
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302170; cv=none; b=YLKkhhkm5y1aybO+l7brYsej0bK7DLAO3Xg6eIyJCr2ckq8LMv2Ye5+S2l1nVrg/obwlbMgfLf523YDOkR4DrIIR+DcAsKEchgzeomD+sDOTYeA/dl0ExcGRrqlsrxdZeEcyUDFJrgw/7aCIKLBBiWVlBM9lCE3oOeyzMnMrbuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302170; c=relaxed/simple;
	bh=ARYjcTcaRPH2V6xckTUSvS8nmWeoZojN0Gbp/7i8RgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=esMyXR/NH6SZ5kldkXNiNIryiAs+hhrQ3AG5KeDtmUmJVfmM68DImTFmIomygn4ey+UfH/s6iQdm2zr3/vTssoLXE9wOcwLvlc9lbu9P/9P+rBJwEZ/Wfd5lu3aUbyGBe3ppsMlkZE3C0ISLY4YCwrd/2kSKx5zC4bEqnHm08hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVFq8hyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVFq8hyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55420C116D0;
	Sat, 28 Feb 2026 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302169;
	bh=ARYjcTcaRPH2V6xckTUSvS8nmWeoZojN0Gbp/7i8RgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVFq8hyMWd7KEp675TsRTfB6CJNWI16fEEvg64TG3dOfpRgETy7b7VLpX5l5+lMSt
	 xZRT96cGF9xlYjzr8Yk0BC6f9GS6GteA+KHv4myL1mziJLEAzfUbFHTX5ME+iMy6mD
	 BH/wfXYQQWyHzvaewe/9Rgunt36s75Cz9sYSRZnEcUSwS8xGCmrMyz3/l3fWl4AyxC
	 zu3H8g7/zdxudu33cTQ7hqdSLM0vjVXis6HUPTyMRqZYUfaZJ70jm74X0mgP9vybIY
	 0BC1hqw+ZaaWvwxPq6Fr73a2nDbV0OsykixtDNySvAs2hllO+ksfb5pYKrDO6J8J+Z
	 ZKa+smOhqsJ3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Etienne AUJAMES <eaujames@ddn.com>,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/283] IB/cache: update gid cache on client reregister event
Date: Sat, 28 Feb 2026 13:05:09 -0500
Message-ID: <20260228180709.1583486-167-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 77c0b89259911..7ed9915f7893e 100644
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

