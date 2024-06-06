Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C45E19D069;
	Thu,  6 Jun 2024 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683449; cv=none; b=XAGTm5969cnY9fSiYJpQxHCUFy9z/VQF/mYvePDTEnFlk5KuOcDqjraSRMTIcppJidhVleHKFUagzLED1bX7zcW22xZ/wXZGCZ9HsJ1cuyQQyCVaB6ekhc3DbRxOKNb+iowZYb5zFP3NvRsLUZP3o3tNeby9yMplK37mvb5sD3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683449; c=relaxed/simple;
	bh=J/A3jgtqLDfYFIYyJZ3SRlWW27kXXCI+JN1YKP9nHc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSvoFEDD03L/EiK2zx10/KCAk1PD03Vjz5xtNwkJz1oY4Q1uDZad+CaasGsHXG0XvtZGqg9PGnoGi0JfM9Af6O4iy3NpCCz2uOWd8RV4i94LfzadsE6V1nVODOoxmlEwJg56ggjG5i1QsAl3fArmbN7rQuaHW8lQ8NkxecADqf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmHsxMMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmHsxMMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F30C2BD10;
	Thu,  6 Jun 2024 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683449;
	bh=J/A3jgtqLDfYFIYyJZ3SRlWW27kXXCI+JN1YKP9nHc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmHsxMMg0QwvT7Qy9Uzi8mbdEkm5VcXAY6Dy3ON9IN1Sjg6+yIhQkQbUp2rBnN59e
	 9iqRtMNfSYuoWJ9VX0mWf5ayc3XGDWlPSmJHwRfB+Cqy69fpOymeLGd/VYQLFbFaOQ
	 jYTJxxpiDuQWNJ1YNf9J7yeYTfBMV+mc2mik1HXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 366/744] ext4: remove the redundant folio_wait_stable()
Date: Thu,  6 Jun 2024 16:00:38 +0200
Message-ID: <20240606131744.222480102@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit df0b5afc62f3368d657a8fe4a8d393ac481474c2 ]

__filemap_get_folio() with FGP_WRITEBEGIN parameter has already wait
for stable folio, so remove the redundant folio_wait_stable() in
ext4_da_write_begin(), it was left over from the commit cc883236b792
("ext4: drop unnecessary journal handle in delalloc write") that
removed the retry getting page logic.

Fixes: cc883236b792 ("ext4: drop unnecessary journal handle in delalloc write")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240419023005.2719050-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d7732320431ac..abb49f6c6ff45 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2895,9 +2895,6 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	/* In case writeback began while the folio was unlocked */
-	folio_wait_stable(folio);
-
 #ifdef CONFIG_FS_ENCRYPTION
 	ret = ext4_block_write_begin(folio, pos, len, ext4_da_get_block_prep);
 #else
-- 
2.43.0



