Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D5411C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9318C433C9;
	Thu, 24 Aug 2023 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888769;
	bh=q+M2VxV5hTxusaOXEQw54UzBrhNjzQ12mPsecwq7MUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBrML9C98mr+9ilHEv6R8xPLh9b/j/HA+Ag/MQqFqR4xyxgdg/pQ4wuI6MA3b7Q8C
	 WTjgCP/Zs+uYnHC70LJCQy9vfXMwH3gqiIRBIadGtho5fFeKOC1KGFXFXN/XcXUijM
	 Ol+hjw2ixbx4Bjvyu0WvCdLHcMw+aegek6/nBxAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Ju Bai <baijiaju@buaa.edu.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/139] fs: ntfs3: Fix possible null-pointer dereferences in mi_read()
Date: Thu, 24 Aug 2023 16:49:17 +0200
Message-ID: <20230824145025.090892044@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jia-Ju Bai <baijiaju@buaa.edu.cn>

[ Upstream commit 97498cd610c0d030a7bd49a7efad974790661162 ]

In a previous commit 2681631c2973 ("fs/ntfs3: Add null pointer check to
attr_load_runs_vcn"), ni can be NULL in attr_load_runs_vcn(), and thus it
should be checked before being used.

However, in the call stack of this commit, mft_ni in mi_read() is
aliased with ni in attr_load_runs_vcn(), and it is also used in
mi_read() at two places:

mi_read()
  rw_lock = &mft_ni->file.run_lock -> No check
  attr_load_runs_vcn(mft_ni, ...)
    ni (namely mft_ni) is checked in the previous commit
  attr_load_runs_vcn(..., &mft_ni->file.run) -> No check

Thus, to avoid possible null-pointer dereferences, the related checks
should be added.

These bugs are reported by a static analysis tool implemented by myself,
and they are found by extending a known bug fixed in the previous commit.
Thus, they could be theoretical bugs.

Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 41f6e578966b2..3d222b1c8f038 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -124,7 +124,7 @@ int mi_read(struct mft_inode *mi, bool is_mft)
 	struct rw_semaphore *rw_lock = NULL;
 
 	if (is_mounted(sbi)) {
-		if (!is_mft) {
+		if (!is_mft && mft_ni) {
 			rw_lock = &mft_ni->file.run_lock;
 			down_read(rw_lock);
 		}
@@ -148,7 +148,7 @@ int mi_read(struct mft_inode *mi, bool is_mft)
 		ni_lock(mft_ni);
 		down_write(rw_lock);
 	}
-	err = attr_load_runs_vcn(mft_ni, ATTR_DATA, NULL, 0, &mft_ni->file.run,
+	err = attr_load_runs_vcn(mft_ni, ATTR_DATA, NULL, 0, run,
 				 vbo >> sbi->cluster_bits);
 	if (rw_lock) {
 		up_write(rw_lock);
-- 
2.40.1



