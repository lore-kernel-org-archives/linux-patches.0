Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F24AEE4;
	Mon,  1 Apr 2024 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990704; cv=none; b=jQmJLkfkZVfgnLtniR8NO9zdckhP90SAYZPrMeLEMw2xZQhzo7Mi+HK339fbEac6hMeDIEZdyNyM6G0MAIGmra4jfsYkM3uhdzeXccBVVZayx+rFIeuxoWb9dHq6emfJZM+hcRuM9o2hqHXlHKEqck3c1HrCHfsrUf2Qtd19Gyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990704; c=relaxed/simple;
	bh=xlVmjqReFt4bOAHGuDsILbEFJHOl6aCBB/c5V77KnSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RikluoPMF988f7lmk5QIsI2t4cS1SLXrmuaTXHgvOj/ZvKjDRdBO4vauOOIKbolqZvwmfw3OACnvLZ4wXvh0rv91A5HoOHcBaR/bA9IPGY/3VpgZvCW9yTE9oijhbQ1pbCGV/SD/0AYT61N/AJCbUyRQDI8gvt5Yo0ia/QrOnMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1VYPjpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1VYPjpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC61C433C7;
	Mon,  1 Apr 2024 16:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990704;
	bh=xlVmjqReFt4bOAHGuDsILbEFJHOl6aCBB/c5V77KnSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1VYPjpwh7im2tb81itAZbBCzL9gCl57Ka7iaSm/goyAAA/pcfh5ZRqqVjZ68bhyv
	 JQTTN+r8JBokrGO5xfeKjNw98OCs9DB//F8PILW6CFCi7YfQB/WtFIYx2EYVeKhRYi
	 LLhmii/Fr/2oZN+2QkyWejA7L27dVyZG4M1pWdBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/272] ubifs: Set page uptodate in the correct place
Date: Mon,  1 Apr 2024 17:43:50 +0200
Message-ID: <20240401152531.631330284@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10c1779af9c51..f7b1f9ece1364 100644
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



