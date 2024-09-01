Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D0018132F;
	Sun,  1 Sep 2024 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207721; cv=none; b=Zuq2cESGKL/NeMLn5doO+DkZmxoT6kWd3PCVbFvvezNp1pnVPz/ve5FTeq8OI66mdPDwhk1hOTm86dyRRC7860YTqC5SOgEMwobf/jBDf232qmyF4yw4KKGDG1OG3tdDT0dbWpXjx1qbE01BA8Lab5JKWDXtbZgWnq+XUQrw3no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207721; c=relaxed/simple;
	bh=rY1jPElhtJF7uKuk6KtO4DbGjHHVUo2QVD3iM+bXhdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLpL6U85TZI+dMam+JkSY9VgsnCh7nwa4Ba/PoNet+XInd0B7ni4+cvRn7Jg88dd8Tv3dSfV3OgwtTP5KOIOjA3fOPMGK2E66Mml4o4tUvMIxQN6Su6Tax5dW6qRWHRhCawcehsu+wTJXYjkoQuRH0IJUt3t+dQOAhq5VJbwBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCwGaOzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCwGaOzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922F9C4CEC3;
	Sun,  1 Sep 2024 16:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207721;
	bh=rY1jPElhtJF7uKuk6KtO4DbGjHHVUo2QVD3iM+bXhdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCwGaOzLZCCGeufSgCuh4GlZ85K9tIlKP/57zqmwes9kIZJJuN/ID/eYo2sheNem+
	 OIBMj1eEIyrDxkJ6+uOtx4UyENH/C5+rDSs2wyA2wPCYV42xCsRT6+eHvahEspLxE5
	 1MoMtOr+eBKRYCnrzrwcoGuRRXj0dLFUndWRQWQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/98] ext4: do not trim the group with corrupted block bitmap
Date: Sun,  1 Sep 2024 18:15:56 +0200
Message-ID: <20240901160804.678846751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 172202152a125955367393956acf5f4ffd092e0d ]

Otherwise operating on an incorrupted block bitmap can lead to all sorts
of unknown problems.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5dcc3cad5c7d3..75dbe40ed8f72 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5219,6 +5219,9 @@ static int ext4_try_to_trim_range(struct super_block *sb,
 	bool set_trimmed = false;
 	void *bitmap;
 
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		return 0;
+
 	last = ext4_last_grp_cluster(sb, e4b->bd_group);
 	bitmap = e4b->bd_bitmap;
 	if (start == 0 && max >= last)
-- 
2.43.0



