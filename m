Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA1F3AA518;
	Mon, 23 Mar 2026 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277675; cv=none; b=QoHAVMDFxB2c5Z1xH7/qy7cB6sAebVJD95RHIjW9RWOCEqmNZibJBZTIb0bvy0Cy6y55+uW0NXjetcD9Qgesm12C//BtaR3SzUypsVjXh8dB2A7p9StAism9Li/NQT1wOuh0bkIxlIj11cDKi6PkNvRoKq81biWhWMLQLJmKKBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277675; c=relaxed/simple;
	bh=u2bmWsQ50Qp+KL1jlHs5At5tg63XhWc4wGTs9ZLItJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siHMY+NDu0+D1+PGKLDHM2y3F0/e4JyfFycdIXRG5hSs2KRDTJ75+GkV0+n/W6RJATefJypcst1j2wpNksUJc+odEKynx2/rnmHbDLhmLLi/S33F26ZH/qoBk43dxufCOfwr4nj2KcwqG6hgtiN9qYcSug+2GfNWFtW4No+zQf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cc7unCHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cc7unCHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8619C4CEF7;
	Mon, 23 Mar 2026 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277675;
	bh=u2bmWsQ50Qp+KL1jlHs5At5tg63XhWc4wGTs9ZLItJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc7unCHsLEbOudzxmDFUKnpF8iky8Pm0Hgmt7G5OIuFv2z80XqfXOtyenb6mtM2qc
	 ONvz9GmvRmGFWJB6KaiX1LUUHHG+oltD9MXhIAAcLHPSbbPpVX0X59JeroLJwyqst2
	 aP8DIOEpIA+2r2wI2gaDpaunj7/zRDnJPUoInvxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/567] ext4: delete redundant calculations in ext4_mb_get_buddy_page_lock()
Date: Mon, 23 Mar 2026 14:39:47 +0100
Message-ID: <20260323134535.478400614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit f2fec3e99a32d7c14dbf63c824f8286ebc94b18d ]

'blocks_per_page' is always 1 after 'if (blocks_per_page >= 2)',
'pnum' and 'block' are equal in this case.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231024035215.29474-1-gouhao@uniontech.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d095c4a218a3a..ade2090155c1c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1486,9 +1486,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 		return 0;
 	}
 
-	block++;
-	pnum = block / blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, gfp);
+	/* blocks_per_page == 1, hence we need another page for the buddy */
+	page = find_or_create_page(inode->i_mapping, block + 1, gfp);
 	if (!page)
 		return -ENOMEM;
 	BUG_ON(page->mapping != inode->i_mapping);
-- 
2.51.0



