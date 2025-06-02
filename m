Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82501DD543;
	Mon,  2 Jun 2025 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876091; cv=none; b=BFaimqpooTPaR9i3cyncIH7TyJWTqB9y/updrH+3TsLzlRmn4av5AXUE2QdO9agU3IaXFeYfE0qYEwFjV34AIp5xe6tkLJjyFqvHcL1hN3kRv0PHng90MBkpaWWZMyBw3k33CEKcxhSEZWfiwW8x4pfydJSPrQGvf4OKXumqtrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876091; c=relaxed/simple;
	bh=ctltIGmGp3xhYywtvw/PCKYOLlxa76GQy9YsgBt6EDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzS2ixOn7UF34YWHE9cUXKeGXEcvyLG6d2yio7DFA8f/Tvzj3qxBqgQ0N1dxhYdCZL1x0VO1iROVQZZKZsgm3rVPm/BsfwRwU9BO4flX2t7Y86pFHk+yrhwU8yWxwqurUZAz16medUaLud6vGAKTkpich3nOJfqyvhGk4yw4Sz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAsiwXTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAsiwXTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34132C4CEEE;
	Mon,  2 Jun 2025 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876091;
	bh=ctltIGmGp3xhYywtvw/PCKYOLlxa76GQy9YsgBt6EDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAsiwXTbXZJCtv9W/d0hM6OF8kycEphr5LMP3hiGgbFwte/nvcbDDQvftBwteyXGA
	 MPGiHq3yWTnA92ks4WIHFsMeDt0JxyfzOf5n/JsR2h+LM4ibgzA0G2BzqoQFoKh/bI
	 WrRrqfc3zGm1CKZQL+un0tnpn9LrnIUy/MxODWNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/207] orangefs: Do not truncate file size
Date: Mon,  2 Jun 2025 15:47:21 +0200
Message-ID: <20250602134301.440591728@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c1bb4c4b5d672..0cf3dcb76d2f4 100644
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
 
@@ -94,8 +94,7 @@ static int orangefs_writepages_work(struct orangefs_writepages *ow,
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



