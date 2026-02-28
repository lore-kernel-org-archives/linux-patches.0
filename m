Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263B04ADDA5;
	Sat, 28 Feb 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301319; cv=none; b=cD3QjNL25ZhQ13nQysorkSnlZ4I1CRIt8gSdfeZB9oQBc7jtx3KUPfBNhUlWV781mkZ/wDDglMSQwPfuIwYpyqp0KKT+K6pMlpRiqNRy+bMmKyb55/B1EcV2EYIDlhQUFu3KCa/SSdmYRmJSuurIZojuC0cOtnQLwxYorjgrb5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301319; c=relaxed/simple;
	bh=iW6Mqnj2eeJVSp+rCQOlEztnLwHLtcLDzH6xZSd9D9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKRlHm8nHuN/PMXnyqUEy185NwrVbOdXuUHn4t+swub75GcwxsU4fXSZFwfeJe3R0Bs+3B+x10B4aohDHyVH7AONrj9kxIixLxbT1MS59g8CeMDI4fjaWDbpcRn8MmGpLEBuW1jc6WUv/WB59eaET90B8hCY28ZDZd2ENn0XEAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVz1Sawp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVz1Sawp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73794C116D0;
	Sat, 28 Feb 2026 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301319;
	bh=iW6Mqnj2eeJVSp+rCQOlEztnLwHLtcLDzH6xZSd9D9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVz1SawptCdTALBMurek/2ejiXmtsCrCQDP1DQ2RJ1uXxW64yOM0G2N8S/3mdTAyq
	 uzPwRqlV2CaL4hyigzuB0M9MYJyHyi9DYPOMEghBFM/XEQP1z3AZswBvmSIuOJEZhf
	 KizdXlpPuR5OjZ20oBSc9pfnkYNakw4MlYFr5hcoANcxiuYnQOiO+g6IMonrEQqwuU
	 DtUKNjx0uZX24voj5ccrGzrLN4aaBqpLh0AWISvtmJWpdoxUT+k3nyQiYFCBd6jPtH
	 dkuTa7g4uq7EZUxs+h5RAj90lNnizF8GyEfItBqIVzL242eCEpT8K2PpWs72roL4UC
	 6KKJqCqQHAZYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 505/752] fs: ensure that internal tmpfs mount gets mount id zero
Date: Sat, 28 Feb 2026 12:43:36 -0500
Message-ID: <20260228174750.1542406-505-sashal@kernel.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a2062463e894039a6fdc2334b96afd91d44b64a8 ]

and the rootfs get mount id one as it always has. Before we actually
mount the rootfs we create an internal tmpfs mount which has mount id
zero but is never exposed anywhere. Continue that "tradition".

Link: https://patch.msgid.link/20260112-work-immutable-rootfs-v2-1-88dd1c34a204@kernel.org
Fixes: 7f9bfafc5f49 ("fs: use xarray for old mount id")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5b31682db450e..b312905c2be5b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -221,7 +221,7 @@ static int mnt_alloc_id(struct mount *mnt)
 	int res;
 
 	xa_lock(&mnt_id_xa);
-	res = __xa_alloc(&mnt_id_xa, &mnt->mnt_id, mnt, XA_LIMIT(1, INT_MAX), GFP_KERNEL);
+	res = __xa_alloc(&mnt_id_xa, &mnt->mnt_id, mnt, xa_limit_31b, GFP_KERNEL);
 	if (!res)
 		mnt->mnt_id_unique = ++mnt_id_ctr;
 	xa_unlock(&mnt_id_xa);
-- 
2.51.0

