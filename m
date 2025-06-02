Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37055225416;
	Mon,  2 Jun 2025 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874735; cv=none; b=cKlzXGeqv3KFbJHjZYmTYEudmOwGxSFyFlgAHRV8TtbAFP6YNLnw41oCforzI/nB9UIG8n03k4vZVyqWleZakS5VEX9ROKX5jwITg4dEXiMpjGYjiEBF/Tgd76Z4zKdb2BvmBAaze2bDptCFr0JUFU9vrb2PalrBDEUoWqnSVbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874735; c=relaxed/simple;
	bh=f7AzeLY2JigMbDLREMYcQt/pkpicRVZ6DV1Y42OZqAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joyeShSi18PUOJlLgLoQStOr5a4XQRpjdFEanN4NP2r9PWfLZawBFAVPF8SDsdbnnmLGanJ1wkUBvhas051rOZVGlhT2m4i1jOvLzg6btIlnN0FBcvCiwwjLnjyxjNjkPqdak/cG0vKgi81xaIVRhmlrS6Dss6K73IxOIEhewkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1lOoCtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1lOoCtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92453C4CEEB;
	Mon,  2 Jun 2025 14:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874735;
	bh=f7AzeLY2JigMbDLREMYcQt/pkpicRVZ6DV1Y42OZqAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1lOoCtf4se9+kQgVurnNv+b0Jh0eaD5JJtLZ4p3GKNvugXANE5QG7wb+xgISc8Ak
	 TjMuY7Ut9Ei1RXAbAt7F5yIywoZ01zuXneqiSslW9+MwTRDu1dzip8sL+etI3CQ4CK
	 CvZzpYWoC0D9zb5pztzfeNYFnBchFTGbiQnxctXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/204] orangefs: Do not truncate file size
Date: Mon,  2 Jun 2025 15:47:33 +0200
Message-ID: <20250602134300.368710837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 636892ffec0ba..238773a508bac 100644
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
 
@@ -98,8 +98,7 @@ static int orangefs_writepages_work(struct orangefs_writepages *ow,
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



