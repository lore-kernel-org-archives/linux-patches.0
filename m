Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1499174F0
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636E6C433C8;
	Wed,  9 Aug 2023 10:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578326;
	bh=bFTHgUWNfETKxPox3TszkA8or4AZrJYY4e2J7v1ZDLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3KAS54NQJVeYPVL8jzr3Aq/ePsLcte1j47j3fPh78DY0jRAh6koxMr0ebWJm2KZ3
	 0xPxJ6SQLmeVUGICjIyrDkU66GzESd1A2eAooKLOZcwAXrl4YrGOnwWc5xxd+aG664
	 P9KQX7mXWHDE11iA2qhvn5FNsGEyckJs/uJxKk2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shijie Sun <sunshijie@xiaomi.com>,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/127] erofs: fix wrong primary bvec selection on deduplicated extents
Date: Wed,  9 Aug 2023 12:40:07 +0200
Message-ID: <20230809103637.320084458@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 94c43de73521d8ed7ebcfc6191d9dace1cbf7caa ]

When handling deduplicated compressed data, there can be multiple
decompressed extents pointing to the same compressed data in one shot.

In such cases, the bvecs which belong to the longest extent will be
selected as the primary bvecs for real decompressors to decode and the
other duplicated bvecs will be directly copied from the primary bvecs.

Previously, only relative offsets of the longest extent were checked to
decompress the primary bvecs.  On rare occasions, it can be incorrect
if there are several extents with the same start relative offset.
As a result, some short bvecs could be selected for decompression and
then cause data corruption.

For example, as Shijie Sun reported off-list, considering the following
extents of a file:
 117:   903345..  915250 |   11905 :     385024..    389120 |    4096
...
 119:   919729..  930323 |   10594 :     385024..    389120 |    4096
...
 124:   968881..  980786 |   11905 :     385024..    389120 |    4096

The start relative offset is the same: 2225, but extent 119 (919729..
930323) is shorter than the others.

Let's restrict the bvec length in addition to the start offset if bvecs
are not full.

Reported-by: Shijie Sun <sunshijie@xiaomi.com>
Fixes: 5c2a64252c5d ("erofs: introduce partial-referenced pclusters")
Tested-by Shijie Sun <sunshijie@xiaomi.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230719065459.60083-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 533e612b6a486..361f3c29897e8 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -989,10 +989,11 @@ static void z_erofs_do_decompressed_bvec(struct z_erofs_decompress_backend *be,
 					 struct z_erofs_bvec *bvec)
 {
 	struct z_erofs_bvec_item *item;
+	unsigned int pgnr;
 
-	if (!((bvec->offset + be->pcl->pageofs_out) & ~PAGE_MASK)) {
-		unsigned int pgnr;
-
+	if (!((bvec->offset + be->pcl->pageofs_out) & ~PAGE_MASK) &&
+	    (bvec->end == PAGE_SIZE ||
+	     bvec->offset + bvec->end == be->pcl->length)) {
 		pgnr = (bvec->offset + be->pcl->pageofs_out) >> PAGE_SHIFT;
 		DBG_BUGON(pgnr >= be->nr_pages);
 		if (!be->decompressed_pages[pgnr]) {
-- 
2.40.1



