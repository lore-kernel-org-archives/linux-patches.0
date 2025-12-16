Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B04934D92F;
	Tue, 16 Dec 2025 11:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885586; cv=none; b=R3K1/zAbLXYBXWHapP3WccTyRCiFmaSZ0yM6rbGVumSbs/OO53ntMSBKZwFCOSAefkDG5ijR9l18o1iAN+IZqDMkX6s5xrpwez09DVQrY3OG+cY2piPPruOONPdIdfhASZ4eWzE1rX7+84H0X1Oa4bTnpX0eGZJQItsxiYqS4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885586; c=relaxed/simple;
	bh=9bB8AJeeOlYUvfW+dXNQT2Sm5yLa/0ftoSFaIP7/NIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFqogaaT7LoRVZGiV89RgawmgWfZ5B+g9MoDvV+29Ji5QrjZidLhMpz2oWKWdYH4HHF/MHQLRMYM4o8/46E0upIa/C21JxOFjSVrgGjOMBQtugrME4CC0Ilo9ki/wSSps4XvxRraySDOSUm6Xz2gtuTpsMZamATsMNFdfDtc/qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRUKzBdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRUKzBdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6BDC4CEF5;
	Tue, 16 Dec 2025 11:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885586;
	bh=9bB8AJeeOlYUvfW+dXNQT2Sm5yLa/0ftoSFaIP7/NIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uRUKzBdBtoBfJUddo2xRJfS2Stexqr2jmuZVSFc/2O057JqxwmqjcwDR+S66xzhXq
	 NzzLMfotTrwcOt20rmG7nibYZQMiMcQwCu6Q488qFfFCETgxwUKLCTAE84js3n4sD7
	 ePlF8ytbmM8gywMe8Ok2f14utSvQ6Br8xAfnvLeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 184/507] ext4: correct the checking of quota files before moving extents
Date: Tue, 16 Dec 2025 12:10:25 +0100
Message-ID: <20251216111352.180962319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit a2e5a3cea4b18f6e2575acc444a5e8cce1fc8260 ]

The move extent operation should return -EOPNOTSUPP if any of the inodes
is a quota inode, rather than requiring both to be quota inodes.

Fixes: 02749a4c2082 ("ext4: add ext4_is_quota_file()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251013015128.499308-2-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 4b091c21908fd..0f4b7c89edd39 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -485,7 +485,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -ETXTBSY;
 	}
 
-	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) || ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EOPNOTSUPP;
-- 
2.51.0



