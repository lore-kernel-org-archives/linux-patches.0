Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACA716423;
	Tue, 27 Feb 2024 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042613; cv=none; b=lYHJ23QzIi43fE8uBjpMBcPIayB8PKPAKHRsUmezT6v03+agX/p1yDTef5JCYAkfVxa8lnxpktEjRo6bxV86S0HWrzvtFPchIFwXj7f8OAx1nwNrBplAMFmMTXj8Yb6MieFuPGnC0VS2YLd6qG/mBq1UAeDlT9C7ZXcrARUER+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042613; c=relaxed/simple;
	bh=91R0wLJJIcDhgK7LCSjGeV9KsSh+bYdmL30ijzTdl3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VG48C8HPU1je5wumpp0MzZQTk7tfmAeUrLcCsfPMND7DCkgiW1oBQDjn/DJXpeJsfGA+Y+vMfdlzLkSgNzI2tv6t8/nlfmOR1ICMpjz9vOo8qslaTZ3wjxRO1OfZqqQIlxtX2gR2SWXGOV17fGeF4IlHegyGmUncihN7NngxOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqLlcWPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqLlcWPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C8C433C7;
	Tue, 27 Feb 2024 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042613;
	bh=91R0wLJJIcDhgK7LCSjGeV9KsSh+bYdmL30ijzTdl3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqLlcWPm1BcgjnSgVD1GDeBl735g6dTguGYHndpIskw1/7xQa9YAUgZ+8DneNlQvQ
	 DGzK3449TaHjlTVfgh07oDUXD4QiR77AlUMEKqsdn4kH5+U6snB0/uATohpFW+3Am9
	 KNSkd/ttNBTVmMufY2Oz919eH5WQVuK0PBQo9GM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/245] ext4: avoid dividing by 0 in mb_update_avg_fragment_size() when block bitmap corrupt
Date: Tue, 27 Feb 2024 14:23:38 +0100
Message-ID: <20240227131616.096498593@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 993bf0f4c393b3667830918f9247438a8f6fdb5b ]

Determine if bb_fragments is 0 instead of determining bb_free to eliminate
the risk of dividing by zero when the block bitmap is corrupted.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-6-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 762c2f8b5b2a8..48930df9ae565 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -853,7 +853,7 @@ mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_free == 0)
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_fragments == 0)
 		return;
 
 	write_lock(&sbi->s_mb_rb_lock);
-- 
2.43.0



