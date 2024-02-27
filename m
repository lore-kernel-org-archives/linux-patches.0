Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22727145343;
	Tue, 27 Feb 2024 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043213; cv=none; b=gsX+aFJCqZ7QQmSTars0HT57vxscZa4ArUnGXENHUVXKm8Hq86qLQ2wjRcU495ZrjC0mrBGQ0tpcSDM2Hyr+ow+VbVF1UFk0Q1GFbseII6ul2dfEpNdxHJOt9KYPxcus3xr75suIIajDwKEme0vm8Ddzlh83xh4AM9Z1OoxDwgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043213; c=relaxed/simple;
	bh=G6cX4qHlcL3z3M+rzRryXPy8dzKNk/bBDmQs/NTNacA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfTZ4BC/RSjK2sKmcaTfNPTsLTHMwA648UJCu5tbkGF7yeSgEMQXBzZhtEkasvWaOGl8qnH1iqjL2pOUP9Cb5GjeVtL8o94uO664LrUt9n1tI+8Eg+qNSh8+X0WyEnQAAEZw4a4Y1z3H2l7n7/ubQKedo4ggy3Wa23g6k6xY+BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwjRfQYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwjRfQYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A461DC433C7;
	Tue, 27 Feb 2024 14:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043213;
	bh=G6cX4qHlcL3z3M+rzRryXPy8dzKNk/bBDmQs/NTNacA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwjRfQYQD820F0QoH8xBpRYqFtXhudEknEuliExkeaIqkC0ZmkcRnSOg/Zys9ye3X
	 qzprfUCp+D3+RKhfRFHmW1M3QgNoma+rtOlyF9qff2SEMcMxBDpUNR5xhL/Wu655of
	 grdTdhXep6IsW/mSkqG22yMO5iH/14OMrGQxTZJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/195] ext4: avoid dividing by 0 in mb_update_avg_fragment_size() when block bitmap corrupt
Date: Tue, 27 Feb 2024 14:24:47 +0100
Message-ID: <20240227131611.259364256@linuxfoundation.org>
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
index 1a310ee7d9e55..296185cbd1547 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -831,7 +831,7 @@ mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int new_order;
 
-	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_free == 0)
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_fragments == 0)
 		return;
 
 	new_order = mb_avg_fragment_size_order(sb,
-- 
2.43.0



