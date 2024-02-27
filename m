Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DEE1420D0;
	Tue, 27 Feb 2024 14:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043215; cv=none; b=jZjPc0JcP6YtYJ8LsXXG0BXrjDmdjn8TmIiYCoKnslfghMyPGH+Ow2es/ZakYIGEmKgN3fl7LbbPriCAwu/fRaxTzoqFzMlEiC8MWi4uhtCFzQuoK8ga4vtZwfEPeBhmRdOeCEJ5lT1mEG8zbUiYFumbuqjoWAnayl0YLwJChCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043215; c=relaxed/simple;
	bh=eUVenfA9rKR5M2Xe/LVD3Oq2HFs7+tzm2XCrie6payo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qgvo67OMvcgDzPwMtgjnHYiCeWAhEEVkZlS2mFnl/FKz+0VC/gVB3A40k6dI3sq4Dq+VpTn7Vw9mkSUlfaSdzFQbXDXVoT6exXpHhqRoFlfe6CpHj1Bumtl5om3z9eB/Gu5ZCSdm3RObqkBSHSqcaF8BdmneB2eHw+pMQUdpz2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvSlPwLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvSlPwLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7F0C43394;
	Tue, 27 Feb 2024 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043215;
	bh=eUVenfA9rKR5M2Xe/LVD3Oq2HFs7+tzm2XCrie6payo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvSlPwLwqS1hjaKTpdpQBFL1ls7dpnaNllmsalbPpIKNgJzzgPs+hFEcMVIiRTjv4
	 bu00BkXfoQCplpgmhXIE5ABB+XJ5sHFAzl+jY/W/CqQq81TIonOWG3JqWpWUqoSFQx
	 gPxBvUo36rreHiAaoHdumout/tfYyadvXfzPIQ0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/195] ext4: avoid allocating blocks from corrupted group in ext4_mb_try_best_found()
Date: Tue, 27 Feb 2024 14:24:48 +0100
Message-ID: <20240227131611.291229561@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 4530b3660d396a646aad91a787b6ab37cf604b53 ]

Determine if the group block bitmap is corrupted before using ac_b_ex in
ext4_mb_try_best_found() to avoid allocating blocks from a group with a
corrupted block bitmap in the following concurrency and making the
situation worse.

ext4_mb_regular_allocator
  ext4_lock_group(sb, group)
  ext4_mb_good_group
   // check if the group bbitmap is corrupted
  ext4_mb_complex_scan_group
   // Scan group gets ac_b_ex but doesn't use it
  ext4_unlock_group(sb, group)
                           ext4_mark_group_bitmap_corrupted(group)
                           // The block bitmap was corrupted during
                           // the group unlock gap.
  ext4_mb_try_best_found
    ext4_lock_group(ac->ac_sb, group)
    ext4_mb_use_best_found
      mb_mark_used
      // Allocating blocks in block bitmap corrupted group

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-7-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 296185cbd1547..744472c0b6fa5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2176,6 +2176,9 @@ int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		return err;
 
 	ext4_lock_group(ac->ac_sb, group);
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		goto out;
+
 	max = mb_find_extent(e4b, ex.fe_start, ex.fe_len, &ex);
 
 	if (max > 0) {
@@ -2183,6 +2186,7 @@ int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 		ext4_mb_use_best_found(ac, e4b);
 	}
 
+out:
 	ext4_unlock_group(ac->ac_sb, group);
 	ext4_mb_unload_buddy(e4b);
 
-- 
2.43.0



