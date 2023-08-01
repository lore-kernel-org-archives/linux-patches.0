Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB321F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE1CC433C8;
	Tue,  1 Aug 2023 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882832;
	bh=8aDQGPdI60fhVkFH25qrsMT41gnch0JeShILs06iHms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QI/OF/8vrFLgkauCcHL9Wxld6OjPX8POZh5Fno0pQ/pseTiRY92CzYqotrtnbY2Lh
	 nrmPWqjX9sEDifKJepTxLLddTKGOqoIMikCAQvLgnAP5aocFiWACeZKdLcJ3ir+hhr
	 EGmn0aJVXWlEFtz6oFJ0OspXpCrv9zQd4fbhP5eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 019/239] btrfs: fix fsverify read error handling in end_page_read
Date: Tue,  1 Aug 2023 11:18:03 +0200
Message-ID: <20230801091926.331382169@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2c14f0ffdd30bd3d321ad5fe76fcf701746e1df6 ]

Also clear the uptodate bit to make sure the page isn't seen as uptodate
in the page cache if fsverity verification fails.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 496c2c9920fc6..82b9779deaa88 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -494,12 +494,8 @@ static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 	ASSERT(page_offset(page) <= start &&
 	       start + len <= page_offset(page) + PAGE_SIZE);
 
-	if (uptodate) {
-		if (!btrfs_verify_page(page, start)) {
-			btrfs_page_set_error(fs_info, page, start, len);
-		} else {
-			btrfs_page_set_uptodate(fs_info, page, start, len);
-		}
+	if (uptodate && btrfs_verify_page(page, start)) {
+		btrfs_page_set_uptodate(fs_info, page, start, len);
 	} else {
 		btrfs_page_clear_uptodate(fs_info, page, start, len);
 		btrfs_page_set_error(fs_info, page, start, len);
-- 
2.39.2



