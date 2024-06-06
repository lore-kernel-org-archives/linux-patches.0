Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B36F19DF79;
	Thu,  6 Jun 2024 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683507; cv=none; b=OYR1ffwKjza4xkXAHUrdQJV+yAFXss9ly5OWkZuyWY9PGf4mUSPdIDtlKNUGlV1GjCw4g6EFaVuZIZS3UoO183Miy79HM8/LbKSRFXcv8WxB/YBjqER8JGqnJveI6R6wHQ9LaMNyUHibFZzkrBR03e6xdWpGf5uEWhAzr8c/1yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683507; c=relaxed/simple;
	bh=ti69JSkSA9GJVKlN5bNswSsa22VdNh3vPml1F4kC3pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZxu9KZzdxssIdY3DSt3tazuBnGWNWU1LOKhWYl3lvEFouvK0JDQ+7JsaMYb+rvPe22XSHxln1VV+68IPj6sjpTwTIB12BM2KtQMdiaELe+OvIJQzM7AXjYdp9MmpeI0BqE+mNHniO1GBisci2ZPmk4u9s+NNIcW6DJ4DEVgNGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uL76zWac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uL76zWac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DD1C32781;
	Thu,  6 Jun 2024 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683507;
	bh=ti69JSkSA9GJVKlN5bNswSsa22VdNh3vPml1F4kC3pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL76zWaccnVRfVEKpSEfUw1gAQISba5EYQA4+Z7/00rHTvAqHYPJ5uGLICEviZ1DU
	 MaK3oXPiR/PGOV6BjWc2OL4PetRWfrQY1zqbhmKv40A+Lzb5g1l/eWVciJq8yTgL9i
	 17ZW3lH9u0SfCTyPem7sWdad74Q4+IUxkF80XZ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 396/473] nilfs2: make superblock data array index computation sparse friendly
Date: Thu,  6 Jun 2024 16:05:25 +0200
Message-ID: <20240606131712.920447805@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 91d743a9c8299de1fc1b47428d8bb4c85face00f ]

Upon running sparse, "warning: dubious: x & !y" is output at an array
index calculation within nilfs_load_super_block().

The calculation is not wrong, but to eliminate the sparse warning, replace
it with an equivalent calculation.

Also, add a comment to make it easier to understand what the unintuitive
array index calculation is doing and whether it's correct.

Link: https://lkml.kernel.org/r/20240430080019.4242-3-konishi.ryusuke@gmail.com
Fixes: e339ad31f599 ("nilfs2: introduce secondary super block")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/the_nilfs.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 71400496ed365..3e3c1d32da180 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -592,7 +592,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
 	u64 sb2off, devsize = bdev_nr_bytes(nilfs->ns_bdev);
-	int valid[2], swp = 0;
+	int valid[2], swp = 0, older;
 
 	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
 		nilfs_err(sb, "device size too small");
@@ -648,9 +648,25 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 	if (swp)
 		nilfs_swap_super_block(nilfs);
 
+	/*
+	 * Calculate the array index of the older superblock data.
+	 * If one has been dropped, set index 0 pointing to the remaining one,
+	 * otherwise set index 1 pointing to the old one (including if both
+	 * are the same).
+	 *
+	 *  Divided case             valid[0]  valid[1]  swp  ->  older
+	 *  -------------------------------------------------------------
+	 *  Both SBs are invalid        0         0       N/A (Error)
+	 *  SB1 is invalid              0         1       1         0
+	 *  SB2 is invalid              1         0       0         0
+	 *  SB2 is newer                1         1       1         0
+	 *  SB2 is older or the same    1         1       0         1
+	 */
+	older = valid[1] ^ swp;
+
 	nilfs->ns_sbwcount = 0;
 	nilfs->ns_sbwtime = le64_to_cpu(sbp[0]->s_wtime);
-	nilfs->ns_prot_seq = le64_to_cpu(sbp[valid[1] & !swp]->s_last_seq);
+	nilfs->ns_prot_seq = le64_to_cpu(sbp[older]->s_last_seq);
 	*sbpp = sbp[0];
 	return 0;
 }
-- 
2.43.0



