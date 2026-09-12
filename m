Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD2937F313;
	Sat, 12 Sep 2026 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199999; cv=none; b=trtl9pXy8Jp7ege/e6VRRRPNvP0R/wn0rfJWL5HDLDcBI/PVnzF8wG/+GO49murkMs74pSKe81afZw71E0yNeiX+BSr5y0kIgembzVSrE6MlqXGA824aCgAqvUDt3/T6BcEw63rgGHZ5g2GqpNaNmzSGbfxSl3IAQj1masQosAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199999; c=relaxed/simple;
	bh=ELIMzqRBbvS+y/HJHUogMVfmsCL2K6metK/oDWXsMZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ohp3/3MgJK5Uewc+3IVBWp54Fl5ZPwXfciZ+l3FpoYcw9jfg5nY3yJt1hPPb9ZFapBcKeqADWpgvQ1L0o+6Ct+nS++l/FjGTXobAATRFTKNs1G1NKlCvlUBpIiomLLEOqqrR/3Pjjyd74hD4PACJWVz8WH3LKcioBI9vH+cPS5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY7YvlN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY7YvlN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE021F000FF;
	Sat, 12 Sep 2026 07:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199998;
	bh=cmsrEx71mqQ5c+GFtqYzauADkoyLKZVq0WSnKGowhyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY7YvlN2WiTK+kZOZzVIVq/Ac9lhLB1XUI0vDquHMp8zPxW80kJa5HrL8YZDVZ+Eo
	 I/BqzEbpPYMtnokmyzYF5pQ6EDqx3RTwdHUz+nhiudl9GWBymc8Py410d7yTh+3/EP
	 +CNTqEdJuzGuOQ/UhQNUeo0JsBGo4TNt9tL3BWwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0701/1815] fs/ntfs3: reject restart table growth beyond U16_MAX entries
Date: Sat, 12 Sep 2026 08:40:51 +0200
Message-ID: <20260912065705.348366090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c759841b74309..1b96ee8208db5 100644
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



