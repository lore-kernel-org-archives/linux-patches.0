Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117C822F772;
	Mon,  2 Jun 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875624; cv=none; b=M1VFLYY6H+pF4Sl092Vrp4OkxgXFQXDj7nKrh3bEOpxyIG/5uTi1oSsT6zhrLROckuyAk0efo8VYC5sQFQkWavpCBSqljrenNxYw+SJ3KnA2AP/6U+NU38Rm5J6AdzsVZpHIKZ0A2/ocDzNiFWRpLbcPuNSLdKbZqaSG0P7L76k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875624; c=relaxed/simple;
	bh=c2hbu2NttbuIqryBT6sCalUHnTW+ccIFdJP1s016X7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUHKa+WWXLB7BBdqwLYKUrpmu7cgVuXJo0Q2jbSXec9P35FJTBGf+zN04a/Q1j+vR3ZvZNi5umSTmSY8lxvynkXL4awNypcx/QCG7WdICIeo16Wx8m96Xnzk2FUiA9WS/okzpfBrv72o3GR0IOcMivD3JMoeZ/q/zDAYnZJiZZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOaQbKcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOaQbKcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C486C4CEEB;
	Mon,  2 Jun 2025 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875623;
	bh=c2hbu2NttbuIqryBT6sCalUHnTW+ccIFdJP1s016X7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOaQbKcSByhb0RpoIU0ETtPU5vLJ1JF/yqLsICOHGycRDFlBtrGjz5lev0sgNcoIh
	 dm5qXb+zsZWhIOOBuHHmkYUILKFufYyPEWVCMcwi3Y5lVsDU1BVCv25ZeYXhcPeMkN
	 gumQFoFOF8PCuwrNfocpZRh/djWITg2cCYMp53GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/270] orangefs: Do not truncate file size
Date: Mon,  2 Jun 2025 15:47:27 +0200
Message-ID: <20250602134313.844143119@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 062e8093592fb866b8e016641a8b27feb6ac509d ]

'len' is used to store the result of i_size_read(), so making 'len'
a size_t results in truncation to 4GiB on 32-bit systems.

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250305204734.1475264-2-willy@infradead.org
Tested-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 48f0547d4850e..cd70ded309e47 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -22,9 +22,9 @@ static int orangefs_writepage_locked(struct page *page,
 	struct orangefs_write_range *wr = NULL;
 	struct iov_iter iter;
 	struct bio_vec bv;
-	size_t len, wlen;
+	size_t wlen;
 	ssize_t ret;
-	loff_t off;
+	loff_t len, off;
 
 	set_page_writeback(page);
 
@@ -93,8 +93,7 @@ static int orangefs_writepages_work(struct orangefs_writepages *ow,
 	struct orangefs_write_range *wrp, wr;
 	struct iov_iter iter;
 	ssize_t ret;
-	size_t len;
-	loff_t off;
+	loff_t len, off;
 	int i;
 
 	len = i_size_read(inode);
-- 
2.39.5



