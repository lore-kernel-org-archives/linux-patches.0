Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066A223339;
	Mon,  2 Jun 2025 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873540; cv=none; b=K4G3nQl1qdQ7wGTgnZkHmX+MJVjzU3k1M1A/Nv08greqBUbyQ6RI2ruN6GtZYNNjzdcPBMA2e4hZ4YkbpqvIOopBWWRubzEhek2YdcqYkWJPDz6kXlD7Ji44W1VV8JxhZYY5kOGTZ3ZwhCBAVf3ZliwwyYfaUalOwbfUxlnojAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873540; c=relaxed/simple;
	bh=zrPSQoeNILAm/+SOEKwYT6GG2iepbULEQtz7zZnM9JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF5iM432a3wdtRKng4OqqqnzMIRuG4P97HieR47yx9mo8ZxRLbgk/xmwVLBBwYtGiqEhAUS5vNJqhDl0TtuFbd7F2uW3PdSQktVOFkqu8WmMT17d5JpI75j4nfLdJmncBxnvDQgNDCN3WNDfIZabvk9ZJHOdd0p10XVygTcQYvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFJ8O+Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFJ8O+Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E92FC4CEEB;
	Mon,  2 Jun 2025 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873540;
	bh=zrPSQoeNILAm/+SOEKwYT6GG2iepbULEQtz7zZnM9JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFJ8O+YpkXDAaWGe44Ihc9Bt0g182h5u2ypN7dojQgA1kbB34xmrnQ00LIs+cUZaR
	 Vr3qFL+KRHEF+6uDieKeFKmFVNVaMhcpxHK8nhJvodis0VPIe6Nr3nKbroUUW/zbkq
	 nl8KhE5mOsqM5tOvz9C+DSmMuNAdmV4cz8xMNUYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/444] orangefs: Do not truncate file size
Date: Mon,  2 Jun 2025 15:43:27 +0200
Message-ID: <20250602134346.713795404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0859122684425..dd4dc70e4aaab 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -23,9 +23,9 @@ static int orangefs_writepage_locked(struct page *page,
 	struct orangefs_write_range *wr = NULL;
 	struct iov_iter iter;
 	struct bio_vec bv;
-	size_t len, wlen;
+	size_t wlen;
 	ssize_t ret;
-	loff_t off;
+	loff_t len, off;
 
 	set_page_writeback(page);
 
@@ -92,8 +92,7 @@ static int orangefs_writepages_work(struct orangefs_writepages *ow,
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



