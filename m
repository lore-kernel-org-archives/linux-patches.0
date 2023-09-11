Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADAE4C8A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCA1C433C8;
	Mon, 11 Sep 2023 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443659;
	bh=1q7ke/bssDpzHTvqtCYqwO5H/Hn8lKRoIkFVglTdPgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zT9c8bSRZn3mMB350xxTJnJ5OBzs3VOWP23IW5xyIDzZvy62jv5o7WqC1jtlu4nmp
	 gCk4BgJzkQxyY9oofUyzZsakmnYY/iyqDRKWQ9gu4pHf6KoLv81LXFzt1v6j2LEhVp
	 Htn2fJyahSi8u2UugwFdjxCRyY9Y0uW7gpM7daog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 426/737] ext4: correct grp validation in ext4_mb_good_group
Date: Mon, 11 Sep 2023 15:44:45 +0200
Message-ID: <20230911134702.499500279@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit a9ce5993a0f5c0887c8a1b4ffa3b8046fbcfdc93 ]

Group corruption check will access memory of grp and will trigger kernel
crash if grp is NULL. So do NULL check before corruption check.

Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230801143204.2284343-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3fa5de892d89d..98e12326b0d6a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2414,7 +2414,7 @@ static bool ext4_mb_good_group(struct ext4_allocation_context *ac,
 
 	BUG_ON(cr < 0 || cr >= 4);
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(grp) || !grp))
+	if (unlikely(!grp || EXT4_MB_GRP_BBITMAP_CORRUPT(grp)))
 		return false;
 
 	free = grp->bb_free;
-- 
2.40.1



