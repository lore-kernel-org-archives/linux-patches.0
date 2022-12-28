Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48221863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566D8C433EF;
	Wed, 28 Dec 2022 15:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240900;
	bh=uDniHmXSBUzrvnEKTj8QBlPmhwTGemgZlim2KMDpL9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icrU65paPzlyUg2BTzjPgB8TXECqPYsPFbKZbIIcYGEnkoKxtmN8ya5d1/ZfKu8uz
	 N5N2H4m6DOlWmmjv5o/selGj+tJ/gTbDqierglM+rFQXVaNgb+z4N7UDognw0NTUIR
	 SSpH5M62ewt0M29RDggaANPoA74lNRV19gD9wmP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongdong Zhang <zhangdongdong1@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 379/731] f2fs: fix normal discard process
Date: Wed, 28 Dec 2022 15:38:06 +0100
Message-Id: <20221228144307.547165034@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongdong Zhang <zhangdongdong1@oppo.com>

[ Upstream commit b5f1a218ae5e4339130d6e733f0e63d623e09a2c ]

In the DPOLICY_BG mode, there is a conflict between
the two conditions "i + 1 < dpolicy->granularity" and
"i < DEFAULT_DISCARD_GRANULARITY". If i = 15, the first
condition is false, it will enter the second condition
and dispatch all small granularity discards in function
 __issue_discard_cmd_orderly. The restrictive effect
of the first condition to small discards will be
invalidated. These two conditions should align.

Fixes: 20ee4382322c ("f2fs: issue small discard by LBA order")
Signed-off-by: Dongdong Zhang <zhangdongdong1@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 28939e3573ea..194c0811fbdf 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1551,7 +1551,7 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 		if (i + 1 < dpolicy->granularity)
 			break;
 
-		if (i < DEFAULT_DISCARD_GRANULARITY && dpolicy->ordered)
+		if (i + 1 < DEFAULT_DISCARD_GRANULARITY && dpolicy->ordered)
 			return __issue_discard_cmd_orderly(sbi, dpolicy);
 
 		pend_list = &dcc->pend_list[i];
-- 
2.35.1



