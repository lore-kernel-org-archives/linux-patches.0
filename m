Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17761482ED;
	Mon,  1 Apr 2024 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989436; cv=none; b=as/JAhudATIAC2peeYmQS8VHFJJveh0MKn6Txgh6FRTfMvfztS2dDd9J8cqfrXsmiA9CWEJTaCzBBYOpNUw5A3GJ2k1vTSs7CfzU+RtWEPCrKXochGq1XANT2s+4ZQDtS7BZUxHOH7ze28zMOv6L/wGK3dh7SwsE+Al6kT4QgSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989436; c=relaxed/simple;
	bh=KeV3pdwGieiuAMM8fN2oDPfQ6uQrrGguakBPbD9uqUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDA7ApjZM83nYXHTSIC1Gidbdn+nPPj5Tt+UbYCOncLxfacpoL87OmsGtil6roViwar06r3xOVG+Eiqr+gZBumQvTLJiBFjXzoyAmwaiKs/B+Ju992SwC0JJ9DTENrQjVzAFOChdFNEGR7SNA63CPFT/x78/2ACFFpNg5TjNuLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MV1PBYmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MV1PBYmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9046AC433C7;
	Mon,  1 Apr 2024 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989436;
	bh=KeV3pdwGieiuAMM8fN2oDPfQ6uQrrGguakBPbD9uqUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MV1PBYmvdkDZhFfEvSV4iCE1fan8K6+JkEAGQxP6UATracHq02tp+ZsDhV4jmsa3V
	 2FVNq/H2MdVwxvzyJIxXdxVSDcKo82q0ZelhtJgoCwrnhjyDvYQmGtI2+9LVkgen9D
	 3h46oEfLF94NFXbMOF+iV1MYMBEbX91qkX1QgnI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/396] ubifs: Set page uptodate in the correct place
Date: Mon,  1 Apr 2024 17:41:36 +0200
Message-ID: <20240401152549.330359816@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
index e5382f0b25878..781206d0ec845 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -261,9 +261,6 @@ static int write_begin_slow(struct address_space *mapping,
 				return err;
 			}
 		}
-
-		SetPageUptodate(page);
-		ClearPageError(page);
 	}
 
 	if (PagePrivate(page))
@@ -462,9 +459,6 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
 				return err;
 			}
 		}
-
-		SetPageUptodate(page);
-		ClearPageError(page);
 	}
 
 	err = allocate_budget(c, page, ui, appending);
@@ -474,10 +468,8 @@ static int ubifs_write_begin(struct file *file, struct address_space *mapping,
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
@@ -568,6 +560,9 @@ static int ubifs_write_end(struct file *file, struct address_space *mapping,
 		goto out;
 	}
 
+	if (len == PAGE_SIZE)
+		SetPageUptodate(page);
+
 	if (!PagePrivate(page)) {
 		attach_page_private(page, (void *)1);
 		atomic_long_inc(&c->dirty_pg_cnt);
-- 
2.43.0



