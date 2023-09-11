Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60404432
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B96C433C7;
	Mon, 11 Sep 2023 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441388;
	bh=pIdgnJZyTa7QG724ahtVNHOnIcrTyOKz4xg8OTeATm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCX27ehb3+30rN/+SJGD1xzeMohcwPF3KbxiJZNTTzsw0tLl8vVfsFtwXO64p6Ii0
	 0KxJrfmiN2zmJOJ3WM3NJRt4l4dUGmv8vVLPGCPFLr0yOJbiaG8Bhq6vG3pV/xBhkD
	 Gc3R7Wp+tIcpUd7ecpezHkUyL05IdJj2C7pildwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 395/739] ext4: avoid potential data overflow in next_linear_group
Date: Mon, 11 Sep 2023 15:43:14 +0200
Message-ID: <20230911134702.218104744@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 60c672b7f2d1e5dd1774f2399b355c9314e709f8 ]

ngroups is ext4_group_t (unsigned int) while next_linear_group treat it
in int. If ngroups is bigger than max number described by int, it will
be treat as a negative number. Then "return group + 1 >= ngroups ? 0 :
group + 1;" may keep returning 0.
Switch int to ext4_group_t in next_linear_group to fix the overflow.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230801143204.2284343-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b00b7adf1461d..a197ef71b7b02 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1080,8 +1080,9 @@ static inline int should_optimize_scan(struct ext4_allocation_context *ac)
  * Return next linear group for allocation. If linear traversal should not be
  * performed, this function just returns the same group
  */
-static int
-next_linear_group(struct ext4_allocation_context *ac, int group, int ngroups)
+static ext4_group_t
+next_linear_group(struct ext4_allocation_context *ac, ext4_group_t group,
+		  ext4_group_t ngroups)
 {
 	if (!should_optimize_scan(ac))
 		goto inc_and_return;
-- 
2.40.1



