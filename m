Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FF9141995;
	Tue, 27 Feb 2024 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041763; cv=none; b=Oye414MNO+ixLRIRbEGccdh56gONON5yggJyH75g3OxHWIXZl6IbEX4InX1pfIeT+UuSN6YSjABEbErl0QuTfzFnrDtItBoRs4+PMvS5MSzWXMlxrc37f6ffVmpIlgDfc4tfkraPxv3/dn3Nf7efZ54gV9udCN0kY9ZOXEAzX4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041763; c=relaxed/simple;
	bh=Ua/s5L4oxwf+G/YUx4GD6nFXwDQLS2r57qq4sh4Qyag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpnGQULc8Hc6Xb1NYOigPIJQLmMSB/iWhCvVR7ySA30s8a8F3098fyQ+bxdAlPYip9CCZ/RQZ6kQztJDV2jZXjEMhl7CFoy6ka8be1hrfbTdChAjLYe7W+twyyLurZsv914qrLrdudLeWExWCkcRIiLFAskHxDbmdtyp4TyS1rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XirP35BX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XirP35BX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAA0C433F1;
	Tue, 27 Feb 2024 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041763;
	bh=Ua/s5L4oxwf+G/YUx4GD6nFXwDQLS2r57qq4sh4Qyag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XirP35BXtEBVMG1ot4D9T8LaO5urMfWFSQbpzRMpiYM8HiexJxSmTBs8RUddHJrII
	 gEqeB8839ZzaUr5lBdHqtPiuii11pWGA44tDzzw1rLcX/vkmMJHRV5LocNBjoAIFmr
	 sVSVGUmnihl4Dc5/3MxoxZWEr7mak3G1PkcRzhtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/299] ext4: avoid dividing by 0 in mb_update_avg_fragment_size() when block bitmap corrupt
Date: Tue, 27 Feb 2024 14:22:24 +0100
Message-ID: <20240227131626.888900968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a2d42a84807a..9eac63e5a251c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -841,7 +841,7 @@ mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int new_order;
 
-	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_free == 0)
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_fragments == 0)
 		return;
 
 	new_order = mb_avg_fragment_size_order(sb,
-- 
2.43.0



