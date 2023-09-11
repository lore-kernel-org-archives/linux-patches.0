Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825A4C433C7;
	Mon, 11 Sep 2023 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443661;
	bh=spQo77mKRvJnkc0HXOI0DAeRr3LcgdPb2Tugah1a4ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbpTdfc4098/sjgnZ2eKEhP4NUhTc4ERmY2s/ZmTY1kmpBCaYp/hPPOg82eKLdRki
	 udHqpqwVqaP3m++Mi6hkhhN2ekTOL30eyQt16uxab3ev4AqcTFSj0YkkGmTGmayMxL
	 iY14r5UQeOObAua+Vy3OAKaX011a07ZBsKal/YdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 427/737] ext4: avoid potential data overflow in next_linear_group
Date: Mon, 11 Sep 2023 15:44:46 +0200
Message-ID: <20230911134702.527403803@linuxfoundation.org>
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
index 98e12326b0d6a..333439b3ac146 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -966,8 +966,9 @@ static inline int should_optimize_scan(struct ext4_allocation_context *ac)
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



