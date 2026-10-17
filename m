Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C8A3B058A;
	Sat, 17 Oct 2026 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256023; cv=none; b=qhYtnwLmRPOFzdSBA0S59Qx3OZtHOxYbdJxvHuuUsd85Az+ecxWIVsjs8EMOPHPmD6NAUprfFOmjVYpl7KMKNTouwtQNx+jUInN/4VDjF0FFejaFrqOMH7LbbW/fjU8YY1Qn0UBnLh/gAf5odOt0Tg0i9uN1OWOJvgNa0DwRwuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256023; c=relaxed/simple;
	bh=eQYGkWZNF4rIAM+OYNENvc1yUXQUKofP3nfUnA39hmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJQKehFytJMmwNzyEqhUZ3Bg1NtBYD9Khnp0AOJ/QWl8z/1P+xjZlKos0n3XOzFKmkeArOEMaUvJ/Ya2VrMaPg0CiSIlVm41KdFIO7L9jDjiNzBVS1K2jTuakRbcKClkBczdmZe6XcPM3VHAE4DhxGrn7A3khJNETTWFxZw243Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dl66bPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dl66bPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDFB1F000C4;
	Sat, 17 Oct 2026 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256022;
	bh=Vuw01iAa5Arz1p8x/+btnRfiIvw2NZH3Ln0zOkQ+y4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dl66bPqsbtoI+5YSNhTaLSD9LvZM1BkjN0y1405oWntdBmXDlT4Wi3Ayiy5ZCb5u
	 AsReuG7Oz2iVV0ixvRlA6A6/Zv9Tq1Kk1vpnyUITrr0tmYB4LR+nunzbtyGu2IOtxx
	 HThZJoQMul84SK5ECOlUUdULG4V6HP0t7Y0tW0RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Guanghui Yang <3497809730@qq.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0098/1674] f2fs: fix dentry folio leak in find_in_level
Date: Sat, 17 Oct 2026 17:39:30 +0200
Message-ID: <20261017160433.659961431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit cca7d3e30bf30333314e31bc70b9a739f1342167 ]

find_in_level() gets a dentry folio with f2fs_find_data_folio() before
calling find_in_block().  If find_in_block() returns an error, the
function stores the error in res_folio and breaks out of the loop without
dropping the dentry folio.

This leaks the folio reference on the find_in_block() error path.  Drop
the dentry folio before returning the error to the caller.

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Replaced f2fs_folio_put(dentry_folio, false) with f2fs_put_page(dentry_page, 0) for the page-based API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 13268d1f8c75a..570f79fa65a52 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -341,6 +341,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 
 		de = find_in_block(dir, dentry_page, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
+			f2fs_put_page(dentry_page, 0);
 			*res_page = ERR_CAST(de);
 			de = NULL;
 			break;
-- 
2.53.0



