Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0BD14D28E;
	Thu, 11 Apr 2024 10:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831504; cv=none; b=HgsjUDynKd3gW28IyCDUZkFIO7A1bZB6TqDSlHifD4o05wyvrjm57rEWhX1kpjiQQaEyzO1uyB8LhMyLl/l8OMkSdqW2B33taYmubevR5Jet0RCkeF+iGYIJIHD6Ek8aKK61VdPCqTmsvpBoIYvR+9mt1hp3vygAThk7s5e4nAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831504; c=relaxed/simple;
	bh=DhwAFheMtmgDfERwsk5kZgr/Eaf6dI6w5jiOpCT/K98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUGaJeMXTZs/3B5fS93qS+83cAe/Z3sQYAmjXs5BKgDRabbmI9mJrIw0CAa7PtVW6pha/1lAFo1z1FM5AJiUUjphxgrXKn1lRt2GQh0HeA3fNDU9RcDHRcMaEY5IjZ2UYDiZbiICV9oza7JnSAXQUNR4E94CM0fR1A3A8FJI6gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llT4y0CA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llT4y0CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63994C43390;
	Thu, 11 Apr 2024 10:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831503;
	bh=DhwAFheMtmgDfERwsk5kZgr/Eaf6dI6w5jiOpCT/K98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llT4y0CApxu2VvzlJAoVlT9AIPsM/X2Y8j8LEmq2hgmy/wJ+NQmyna8E51xCg3Ang
	 i7iFXgu/rVrWRKgcfsbW7/6SsMztskSr8NlVSdMPts9mSXcFLv25dmoPCJ78Z/AqzQ
	 w+80IyH6p6s2GutVktP88Gd7Vp8oOvcy3QSSTGOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/294] ubifs: Set page uptodate in the correct place
Date: Thu, 11 Apr 2024 11:53:14 +0200
Message-ID: <20240411095436.574497296@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19fdcda045890..18df7a82517fa 100644
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
 		attach_page_private(page, (void *)1);
 		atomic_long_inc(&c->dirty_pg_cnt);
-- 
2.43.0



