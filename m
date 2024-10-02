Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68CB1D0DCB;
	Wed,  2 Oct 2024 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878328; cv=none; b=Y2n1rIbn1dYbU2ZEnDvQxEyWxW2FP3b5z3bXnYIRiiTMjGhvzKLVG1eiAkTHZrxW26K203mBo2Wc0rUUGcamh4QXrJK2kgSdC04i9Nu9UfKElG+lZFsr9LKefmS/awGNoZ1QsbaLDC5wnE+WNUAmv7dHoQ3VNfO2RhgqJEPjS80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878328; c=relaxed/simple;
	bh=98p8Qf0r2iH12SFzyREdY3Hp6ncnKSqX6u3Ix9J/WRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2w7yiioGzgfL+MpV7UN0U+CUKjBLymqhW1f+hilURYGLgl0p0jH0EO3fnNJ/YxvlV8Z0d6IwWAn7ETQuONk3T74mDsF7JOVTUNyprNQb/wyK9Mq9h96FS2Rj8vv6Ec64oFHJW5hCkdH9NBkHwCyBSBaWX/0TdTQSi6cisdHVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TV54YBwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV54YBwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D804C4CEC2;
	Wed,  2 Oct 2024 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878328;
	bh=98p8Qf0r2iH12SFzyREdY3Hp6ncnKSqX6u3Ix9J/WRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV54YBwGQ4ht6FZcmyL8gdO8vFukAD/2IwqCpiKNJwItSdI5eNa2Zi/vttrwlWf8l
	 rK6pdIlq1s1nwTU99f5vJLoXTis4VtJ8gDH2N3TOvFyzTupqZiafxX2iCCPU3LAVUJ
	 om9w5hCDG+GyFa3B8OqnAmFtFVF5yDlLG04JMgDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 369/634] RDMA/mlx5: Limit usage of over-sized mkeys from the MR cache
Date: Wed,  2 Oct 2024 14:57:49 +0200
Message-ID: <20241002125825.661691567@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit ee6d57a2e13d11ce9050cfc3e3b69ef707a44a63 ]

When searching the MR cache for suitable cache entries, don't use mkeys
larger than twice the size required for the MR.
This should ensure the usage of mkeys closer to the minimal required size
and reduce memory waste.

On driver init we create entries for mkeys with clear attributes and
powers of 2 sizes from 4 to the max supported size.
This solves the issue for anyone using mkeys that fit these
requirements.

In the use case where an MR is registered with different attributes,
like an access flag we can't UMR, we'll create a new cache entry to store
it upon dereg.
Without this fix, any later registration with same attributes and smaller
size will use the newly created cache entry and it's mkeys, disregarding
the memory waste of using mkeys larger than required.

For example, one worst-case scenario can be when registering and
deregistering a 1GB mkey with ATS enabled which will cause the creation of
a new cache entry to hold those type of mkeys. A user registering a 4k MR
with ATS will end up using the new cache entry and an mkey that can
support a 1GB MR, thus wasting x250k memory than actually needed in the HW.

Additionally, allow all small registration to use the smallest size
cache entry that is initialized on driver load even if size is larger
than twice the required size.

Fixes: 73d09b2fe833 ("RDMA/mlx5: Introduce mlx5r_cache_rb_key")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/8ba3a6e3748aace2026de8b83da03aba084f78f4.1725362530.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index a03557c8416e8..b3a8dc9465c04 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -48,6 +48,7 @@ enum {
 	MAX_PENDING_REG_MR = 8,
 };
 
+#define MLX5_MR_CACHE_PERSISTENT_ENTRY_MIN_DESCS 4
 #define MLX5_UMR_ALIGN 2048
 
 static void
@@ -659,6 +660,7 @@ mkey_cache_ent_from_rb_key(struct mlx5_ib_dev *dev,
 {
 	struct rb_node *node = dev->cache.rb_root.rb_node;
 	struct mlx5_cache_ent *cur, *smallest = NULL;
+	u64 ndescs_limit;
 	int cmp;
 
 	/*
@@ -677,10 +679,18 @@ mkey_cache_ent_from_rb_key(struct mlx5_ib_dev *dev,
 			return cur;
 	}
 
+	/*
+	 * Limit the usage of mkeys larger than twice the required size while
+	 * also allowing the usage of smallest cache entry for small MRs.
+	 */
+	ndescs_limit = max_t(u64, rb_key.ndescs * 2,
+			     MLX5_MR_CACHE_PERSISTENT_ENTRY_MIN_DESCS);
+
 	return (smallest &&
 		smallest->rb_key.access_mode == rb_key.access_mode &&
 		smallest->rb_key.access_flags == rb_key.access_flags &&
-		smallest->rb_key.ats == rb_key.ats) ?
+		smallest->rb_key.ats == rb_key.ats &&
+		smallest->rb_key.ndescs <= ndescs_limit) ?
 		       smallest :
 		       NULL;
 }
@@ -962,7 +972,7 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 	mlx5_mkey_cache_debugfs_init(dev);
 	mutex_lock(&cache->rb_lock);
 	for (i = 0; i <= mkey_cache_max_order(dev); i++) {
-		rb_key.ndescs = 1 << (i + 2);
+		rb_key.ndescs = MLX5_MR_CACHE_PERSISTENT_ENTRY_MIN_DESCS << i;
 		ent = mlx5r_cache_create_ent_locked(dev, rb_key, true);
 		if (IS_ERR(ent)) {
 			ret = PTR_ERR(ent);
-- 
2.43.0



