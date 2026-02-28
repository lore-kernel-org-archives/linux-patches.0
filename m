Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583BC37146B;
	Sat, 28 Feb 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301468; cv=none; b=Ivv2+IAiOUR3oRBlE1lpUtRpaYOMHAQukg/DmMNknZfmfrcqYZuQZsVR8xqtlS1dl4QNYyOjE63ADJVKc1DIFTLNSLfNj6/DSe3PJW7i0B9XtgeMG5QHeXeqt0ruQ4kTMU8caRK8fT9rAjYx6DQNCYXfCe9QfrGqP/oVGCoGWJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301468; c=relaxed/simple;
	bh=iIB71QcApIUL3Te+qXuukI272ASZ4hwFXGGE4fJ6sK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeBigu733Oms1X1J50aKR64p+Sb2Dk6YNX6sXpapcIR9MIt6fAuZkKKDTy9ynvQWKdu8FkRGy9awVREJLdEooZerTCgX4sSct6QAX6zwf6stB4wc7J7USmfw9dRQTGVTvcTcNeD4TRVy2zcwGuRiDZqsrVWUCrOX40NAm6ycNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYIRg94z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYIRg94z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9289AC19423;
	Sat, 28 Feb 2026 17:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301468;
	bh=iIB71QcApIUL3Te+qXuukI272ASZ4hwFXGGE4fJ6sK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYIRg94zAi+oHyJXsq9GsP3Nm0k7ltN4tpYY2IgJfApXgQiXw64qPveC22eWxI5Aj
	 Vupn/zIYlzrhWRJ/hkudsH8kQDclaHdJuO2cpeRqxsSnF4acx8GP/YPJpQMZKTmvJT
	 kVlVjDF/uffZmdl7kpZ3FE1+FJkPzB2QntlfzDd3SlJ5iv1GEPGZ2U7nT4WjWU+UP0
	 3HD/BPw6qiGFQ4B8Kv2H6f/34tQ0h3IvZb1HJKekBDbshmfeqPqeqOna6yBkBvILr9
	 DkRAb8OJp5DNRvzrdRLMdUZmlSjq9w8U9dopmYQL9YY0UlIZuWnR4XLESdJ6DKhyOC
	 pBDub8Tz/jYJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
	stable@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 653/752] btrfs: zoned: fixup last alloc pointer after extent removal for RAID1
Date: Sat, 28 Feb 2026 12:46:04 -0500
Message-ID: <20260228174750.1542406-653-sashal@kernel.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit dda3ec9ee6b3e120603bff1b798f25b51e54ac5d ]

When a block group is composed of a sequential write zone and a
conventional zone, we recover the (pseudo) write pointer of the
conventional zone using the end of the last allocated position.

However, if the last extent in a block group is removed, the last extent
position will be smaller than the other real write pointer position.
Then, that will cause an error due to mismatch of the write pointers.

We can fixup this case by moving the alloc_offset to the corresponding
write pointer position.

Fixes: 568220fa9657 ("btrfs: zoned: support RAID0/1/10 on top of raid stripe tree")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3afc9c0c22287..8e6e96660fa66 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1483,6 +1483,21 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
 	/* In case a device is missing we have a cap of 0, so don't use it. */
 	bg->zone_capacity = min_not_zero(zone_info[0].capacity, zone_info[1].capacity);
 
+	/*
+	 * When the last extent is removed, last_alloc can be smaller than the other write
+	 * pointer. In that case, last_alloc should be moved to the corresponding write
+	 * pointer position.
+	 */
+	for (i = 0; i < map->num_stripes; i++) {
+		if (zone_info[i].alloc_offset == WP_MISSING_DEV ||
+		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
+			continue;
+		if (last_alloc <= zone_info[i].alloc_offset) {
+			last_alloc = zone_info[i].alloc_offset;
+			break;
+		}
+	}
+
 	for (i = 0; i < map->num_stripes; i++) {
 		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
 			continue;
-- 
2.51.0

