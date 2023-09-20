Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76BD2AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3A6C433CC;
	Wed, 20 Sep 2023 12:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211282;
	bh=HOZmDHy5ZqT6wFrjS1nTowMW/QTvO7d82jwRbjaWDz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je+79GxDvFpxGRohP78jsEwbX+itE2jhtyFf76CjmhyM4btl8UYKIC1bsYjPkait2
	 IUHsC27/dXFgLwr628S5Bk/2MYtLMQKIAzfSr0mROZ1ajtrmCuOfLieubv9DgD2mE7
	 ndO5bx0i+WZCKMEjA+blqawYTprfluqPNfoz5Olk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	butt3rflyh4ck <butterflyhuangxx@gmail.com>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 035/186] reiserfs: Check the return value from __getblk()
Date: Wed, 20 Sep 2023 13:28:58 +0200
Message-ID: <20230920112838.212573254@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox <willy@infradead.org>

[ Upstream commit ba38980add7ffc9e674ada5b4ded4e7d14e76581 ]

__getblk() can return a NULL pointer if we run out of memory or if we
try to access beyond the end of the device; check it and handle it
appropriately.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/lkml/CAFcO6XOacq3hscbXevPQP7sXRoYFz34ZdKPYjmd6k5sZuhGFDw@mail.gmail.com/
Tested-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") # probably introduced in 2002
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/journal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 1a6e6343fed36..53d2e397c123e 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2333,7 +2333,7 @@ static struct buffer_head *reiserfs_breada(struct block_device *dev,
 	int i, j;
 
 	bh = __getblk(dev, block, bufsize);
-	if (buffer_uptodate(bh))
+	if (!bh || buffer_uptodate(bh))
 		return (bh);
 
 	if (block + BUFNR > max_block) {
@@ -2343,6 +2343,8 @@ static struct buffer_head *reiserfs_breada(struct block_device *dev,
 	j = 1;
 	for (i = 1; i < blocks; i++) {
 		bh = __getblk(dev, block + i, bufsize);
+		if (!bh)
+			break;
 		if (buffer_uptodate(bh)) {
 			brelse(bh);
 			break;
-- 
2.40.1



