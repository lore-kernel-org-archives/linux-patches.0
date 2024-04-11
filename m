Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D081A13DDDD;
	Thu, 11 Apr 2024 09:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829542; cv=none; b=QtHF1ZSLSWfCJiKV5tWRONreeP81v9070k8O5lizxebNH49w5Xs/xvsqjtXgyskeNESuhCAbp26J4WtaiY0tOn1Ha6Xzw6PVgVZHJDUxhM/SUHBqR/l6e4eP/MWZZzKhcKuCJfL9Npjm3oiGDtXJH02j+AwomxhzHA4blcGpstE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829542; c=relaxed/simple;
	bh=tftEwFBIOdjECajyx+HA5WIzx+k3LYoz25Ex8kvQxCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkRzM0xvLyzToAvjVkRTKC9KOs5IzrPi6bmGKSskWYNPGca0rupO9wBt43qOuH4upEv7lMOc1UaL4TvnspQQKNxWUMX589lYDhgZCUECfyTAEpYuHnLBGH6MUnn8vt6VO2lxIEgTdiOPok25Cr1XkPifLWS5EDrI30nTV/c3X70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScmznK1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScmznK1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5415DC433F1;
	Thu, 11 Apr 2024 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829542;
	bh=tftEwFBIOdjECajyx+HA5WIzx+k3LYoz25Ex8kvQxCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScmznK1uejOXNezJZ4LTpUIf7ZNb7pQi4+TFY6WJ3/pcqGrIz9cHTbTGAKGMIT5y1
	 L1u0issj6aOJIii3TqktGvWmbENT98SYg1rCKDlx1JJ3uZmqjYTHxvkRRwXHpGb251
	 J7q/fCzrf4KdHj0MdgMmoSx0OGThU4OgddMtCtXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/175] ubifs: Set page uptodate in the correct place
Date: Thu, 11 Apr 2024 11:54:05 +0200
Message-ID: <20240411095420.219793905@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 723012cab779eee8228376754e22c6594229bf8f ]

Page cache reads are lockless, so setting the freshly allocated page
uptodate before we've overwritten it with the data it's supposed to have
in it will allow a simultaneous reader to see old data.  Move the call
to SetPageUptodate into ubifs_write_end(), which is after we copied the
new data into the page.

Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/file.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index fca3b7f483c79..e373e5d057fd4 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -274,9 +274,6 @@ static int write_begin_slow(struct address_space *mapping,
 				return err;
 			}
 		}
-
-		SetPageUptodate(page);
-		ClearPageError(page);
 	}
 
 	if (PagePrivate(page))
@@ -475,9 +472,6 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
 				return err;
 			}
 		}
-
-		SetPageUptodate(page);
-		ClearPageError(page);
 	}
 
 	err = allocate_budget(c, page, ui, appending);
@@ -487,10 +481,8 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
 		 * If we skipped reading the page because we were going to
 		 * write all of it, then it is not up to date.
 		 */
-		if (skipped_read) {
+		if (skipped_read)
 			ClearPageChecked(page);
-			ClearPageUptodate(page);
-		}
 		/*
 		 * Budgeting failed which means it would have to force
 		 * write-back but didn't, because we set the @fast flag in the
@@ -581,6 +573,9 @@ static int ubifs_write_end(struct file *file, struct address_space *mapping,
 		goto out;
 	}
 
+	if (len == PAGE_SIZE)
+		SetPageUptodate(page);
+
 	if (!PagePrivate(page)) {
 		SetPagePrivate(page);
 		atomic_long_inc(&c->dirty_pg_cnt);
-- 
2.43.0



