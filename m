Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063E113F452;
	Thu, 11 Apr 2024 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830561; cv=none; b=IRq4T8QU1aJcg56rzQfoqsVrWSNeNeg4GCy3PdfgwDSxwe8+dNXo/Gfn45tga0xoyptZuYAEpitRdQmqABlCr4SbZ73b28sRenklYh0SknEVDS7XIeYWAihBhrpCkyyYaGaNrLNYP5qWE1yjX6bsIHgsFGF1uS7DGgn9xQmZvt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830561; c=relaxed/simple;
	bh=NAHsbSmmY/2CnazJC3p+LokPxCU+NMU/bIi7iC/haY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esglB9/VLPnofZsDc3BxuMlT77JnSQ3/0QnACoFyisbcIrcvM0NZwKpMCpqiYRS63plT37fts9DtpFOlSAWPrnSwLVN7S+tHiYjP802bBHUPg5ft8u/neEe+o6pyLBe8d2dfItjKxbwULYRpvRwAey/HO0QuDu8h7UcfkYQYdjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEF1czgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEF1czgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30918C433F1;
	Thu, 11 Apr 2024 10:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830560;
	bh=NAHsbSmmY/2CnazJC3p+LokPxCU+NMU/bIi7iC/haY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEF1czgLwZmHIifZy7dyRzG4ADl+tgNR7w0f42R9xCAL1PU3FpdtChXjRAhYKPX5v
	 6gRYWVFo+7FRHr4qjD7bTpiLYkWcTkmEvA9Pe9tUFgE96qkuNqw9FqAPOybFEV9lY3
	 M87deocKN3DBX3KoExDbPxiYB1OUxXKwRMp/XKSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/215] ubifs: Set page uptodate in the correct place
Date: Thu, 11 Apr 2024 11:53:53 +0200
Message-ID: <20240411095425.610253484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4d3a5cb6e9b03..ebad140f8d056 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -262,9 +262,6 @@ static int write_begin_slow(struct address_space *mapping,
 				return err;
 			}
 		}
-
-		SetPageUptodate(page);
-		ClearPageError(page);
 	}
 
 	if (PagePrivate(page))
@@ -463,9 +460,6 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
 				return err;
 			}
 		}
-
-		SetPageUptodate(page);
-		ClearPageError(page);
 	}
 
 	err = allocate_budget(c, page, ui, appending);
@@ -475,10 +469,8 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
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
@@ -569,6 +561,9 @@ static int ubifs_write_end(struct file *file, struct address_space *mapping,
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



