Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2EF2F8E90;
	Sat, 12 Sep 2026 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223973; cv=none; b=R9J0WNEJYO0uXvqow5kkBVCWLPv+3L62lLh39Hdo+F5U/wq9HVlFUnVILoE404Y4O7XzjZ0RViA71qpxdr3Svl16bHI9yke7bBOUv9DmYYEgt81XkabfoH5axzKhSmW/0yOofS9qL7Mt32hZh22fQjEvHw4x3WLPr0UyaqXNs9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223973; c=relaxed/simple;
	bh=HID6cn23eJaBOCHMT5HZ9azNc03S3zSjhSUKPPhyWJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slGxX2lYq3xQyiqniZlXSHc89CYWZCmNmk4DF39XB2GZoFqF/cSDcM8QIKVxuVdciOaJ8oJcsDhBJd1NLOxG+eXgwSa/TWzFweBrrcHv+zRQIxI4QCKgg1d1crX/DadWFid8S0xAeZQPRct1F135kurhcU3s0LeuS5KG6Qb8kmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXM7/dJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXM7/dJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DBF1F000FF;
	Sat, 12 Sep 2026 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223972;
	bh=3SS1UbK2uLe6bACSRyxfLBuBm+D9hz7t4bljXkSteMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXM7/dJHAJus9wUEdcyvz2LLUHb0KNkwK2/k0dY+Fap6QGG2mga/ey1vV2BLPELXt
	 C9nSZKTHRqktbd0SWlSz9HOvLoLGazldLWXgvgz3OMsZqAqe+LzqwHBi+X6scVTs4F
	 wkFpQBYcLy8oO7h+M+eFzGwsa12hjxiopLbFLTmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0897/1424] fs/ntfs3: reject restart table growth beyond U16_MAX entries
Date: Sat, 12 Sep 2026 08:55:29 +0200
Message-ID: <20260912065627.416644385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 111f8d74a19d85942ecbb3aba78f6f3c88e59391 ]

During $LogFile replay, log_replay() indexes the transaction table by the
transact_id taken from the log record header.  check_log_rec() only
verifies that transact_id is non-zero and properly aligned, not its
magnitude, so a crafted image can request an arbitrarily large index.

alloc_rsttbl_from_idx() grows the table to cover that index via
extend_rsttbl(), which passes the new entry count to init_rsttbl():

	rt = init_rsttbl(esize, used + add);

used + add is computed as u32 but init_rsttbl() takes a u16, and the
count is stored in struct RESTART_TABLE as a __le16.  When used + add
exceeds U16_MAX it is truncated, init_rsttbl() allocates a table far
smaller than the index requires, and alloc_rsttbl_from_idx() then
dereferences and writes at the original, untruncated offset -- an
out-of-bounds access past the allocation, reachable by mounting a
crafted NTFS image.

 BUG: KASAN: use-after-free in alloc_rsttbl_from_idx (fs/ntfs3/fslog.c:950)
 Read of size 4 at addr ffff8880327ffff8 by task exploit
  alloc_rsttbl_from_idx (fs/ntfs3/fslog.c:950)
  log_replay (fs/ntfs3/fslog.c:4562)
  ntfs_loadlog_and_replay (fs/ntfs3/fsntfs.c:324)
  ntfs_fill_super (fs/ntfs3/super.c:1393)
  get_tree_bdev_flags
  vfs_get_tree
  path_mount
  __x64_sys_mount

A restart table is limited to U16_MAX entries by its __le16 count, so a
larger growth request is invalid input.  Reject it in extend_rsttbl();
all callers already handle a NULL return.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index ab405d7f133e1..805f14461ab54 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -875,6 +875,9 @@ static inline struct RESTART_TABLE *extend_rsttbl(struct RESTART_TABLE *tbl,
 	u32 used = le16_to_cpu(tbl->used);
 	struct RESTART_TABLE *rt;
 
+	if (used + add > U16_MAX)
+		return NULL;
+
 	rt = init_rsttbl(esize, used + add);
 	if (!rt)
 		return NULL;
-- 
2.53.0



