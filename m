Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E73A187563;
	Mon, 12 Aug 2024 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479467; cv=none; b=IgSxrH3FdEtRzXodgHC7FttgtGSWY+lAV2KAPh4Koz23vB0qtAwMYvZQAk5rzlzweCSoeh1Iac0XkD7OEyg6o+1+14D0+e6DWXxTntnIC6ycupaI/DOkaGRiM7si5XuKk8vB1SQjDCjrzB4CmGC+ho4AbfBZz5BbH3DrL+RlVWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479467; c=relaxed/simple;
	bh=kEx+opdeWDHwzk32oOEaais05MOl6Zze3Leyh5a+R2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWn0CuiViraBHhlJYzinGAwyshNVjJxYBH7rbdFK9pckZ0fRhOkf3lbslwmFtBL4+ILCpA8GD/iNCILk13V/8x7jPHD4XPR49EvQUl2+Yz1BHT7S5TTBFD2WV8N3g2gIs6cFfgkGPnhTYeJ54/OgraqbcZeHyX1J0Q7WRGS9Gak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBafokKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBafokKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480E4C32782;
	Mon, 12 Aug 2024 16:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479466;
	bh=kEx+opdeWDHwzk32oOEaais05MOl6Zze3Leyh5a+R2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBafokKXVjiozTQVWPXhyqcgmKVZxFYvwH5EWUr3M0rjJIX/G8hyJFPwvudj3M3cL
	 2/l7/OSQoKQAR0U6hLyZKBuuqZwBzuoWJLbVcsrZn7vkYr4F3rWHwbj901pmzrmuZL
	 MCmgrt4GsTSl8RUcJjGmRL5FWwJvmvDh3DbfTFbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/189] jbd2: avoid memleak in jbd2_journal_write_metadata_buffer
Date: Mon, 12 Aug 2024 18:02:01 +0200
Message-ID: <20240812160134.645167320@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit cc102aa24638b90e04364d64e4f58a1fa91a1976 ]

The new_bh is from alloc_buffer_head, we should call free_buffer_head to
free it in error case.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240514112438.1269037-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0168d28427077..57264eb4d9da3 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -399,6 +399,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		if (!tmp) {
 			brelse(new_bh);
+			free_buffer_head(new_bh);
 			return -ENOMEM;
 		}
 		spin_lock(&jh_in->b_state_lock);
-- 
2.43.0



