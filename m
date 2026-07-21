Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02CA46C4B1;
	Tue, 21 Jul 2026 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649525; cv=none; b=hWUafQlru0zhxMgpyHSOkldnbOeA76Orh+vo04MUCuszEjUYN2x51xllvvr6Pc8AoQUBXR/3g9ls2oLrCRw2AlSg/oUg2cP6ivTB0pkrCiUmN5yeKRF5H+VEOB3qBLDT7Un9XvVFUE+M9ZeuOYAqHuu0rsvmSuSui5V+gr9ZBi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649525; c=relaxed/simple;
	bh=GAqyCWVPAfYqj9HWQpXVtRpTx0yPZgU+6vVv7BhPdoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t66zwxeoUmGT2QZqJ2MnRDGv7dnZilLVyYxsiixJCN5b0DENSa7VbZPm/8mmpnHf2AY/UXeToGmUjYsojVIHLPP7KPQdyvqqRXNcz0rdkC/6/VFQFakNdceWiAK0Aoz9G3QizvHehnHSU6pIVOunSOVqhsfWF0X3iLPUZFmel1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uO41b5Gd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uO41b5Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E2F1F000E9;
	Tue, 21 Jul 2026 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649524;
	bh=LcOnss7LEtSb7qxmR0gcEayh1X5afoQcv9/5uh1Rhrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uO41b5GdR0Cp9iMJgBtV9E1tURusonTelaAYCEe0Gxo0eC7rw4PMSigyu4UWN7qx/
	 vqpZeasx8gA/SW9AvtueoA7moUafhiRDGTuUYQjHpGDLHIROwSwMuF+PoeXsYgcCTT
	 SL2DUo4eCLmFcIqm55xoy9vVlpQB/DM34+0wE7DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0612/2077] btrfs: annotate lockless read of defrag_bytes in should_nocow()
Date: Tue, 21 Jul 2026 17:04:45 +0200
Message-ID: <20260721152607.240840374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 89c0dc3de7a73e8aba5e9bfef543eee047a3d0d2 ]

should_nocow() reads inode->defrag_bytes without holding inode->lock,
while btrfs_set_delalloc_extent() and btrfs_clear_delalloc_extent()
update it under that spinlock.

This is a data race.  The read is a quick check used to decide whether
to fall back to COW for a NOCOW inode: if defrag_bytes is non-zero and
the range is tagged EXTENT_DEFRAG, we force COW so that defragmentation
can rewrite the extent.  Reading a stale value is harmless because:

  - A missed increment may skip COW once, but the defrag pass will
    redo the extent later.
  - A stale non-zero may force an unnecessary COW, which is a minor
    efficiency loss, not a correctness issue.

On 64-bit platforms an aligned u64 load is naturally atomic so tearing
cannot happen.  On 32-bit platforms u64 may tear, but we only test for
zero vs non-zero, so the heuristic stays correct regardless.  Use
data_race() annotation.

Fixes: 47059d930f0e ("Btrfs: make defragment work with nodatacow option")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
[ Use data_race() instead of READ_ONCXE() ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1f7ac8684735d..dc5148f176e77c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2317,7 +2317,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 static bool should_nocow(struct btrfs_inode *inode, u64 start, u64 end)
 {
 	if (inode->flags & (BTRFS_INODE_NODATACOW | BTRFS_INODE_PREALLOC)) {
-		if (inode->defrag_bytes &&
+		if (data_race(inode->defrag_bytes) &&
 		    btrfs_test_range_bit_exists(&inode->io_tree, start, end, EXTENT_DEFRAG))
 			return false;
 		return true;
-- 
2.53.0



