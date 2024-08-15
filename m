Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF30E1A00F5;
	Thu, 15 Aug 2024 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731688; cv=none; b=siQdsDQFVYjH47gLEq78TjGr3mFmgeFrBPcgZ3ksy98eC1Mx+X0+KqdO5t427SsvjgalYgPMnJk8ZW/2+eO/PrEm5b0PW5hhbc5cmc1GMVPeaeVXThY2AaNbPdJECv6gPB3Sv1ie1BsrPAoGDG+6DwdAizf0BtqJJuUSWoK1cxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731688; c=relaxed/simple;
	bh=QQLffAxN1xoFKx1qAICYipIHRF2T2P05XZLOcHfiZYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiJs62WSwpjMRkjWm02CHGqR58PFdC42O5wz6daWTYCK5TxeCR28jbQynDK0Uv3aYzmwoXasUcZSGSae0d+7ZBk5KOsGWeDtNG9MgkTEcUUbpzI9d+nwCjGHQYm5lxomychT9rwoIDLfaCyDvwenWek+Rxf97YNSEqKINsUdt3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrZtMa84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrZtMa84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BAFC32786;
	Thu, 15 Aug 2024 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731687;
	bh=QQLffAxN1xoFKx1qAICYipIHRF2T2P05XZLOcHfiZYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrZtMa84MTyW4bMnYwM8U5HRjbIiVRah6IqVyq1piabw6c35BYcb5tULzpYYI56Je
	 x+NAGETnpS8iKrVCD4WyOfM+pcPlu/vNGLDEzITYrGXrmu4vUDBlLlhEwFCBP6bXtG
	 riM1kXleSxbXA3VFI+t91yzjTs6x4+z4a2KnbZi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/259] ext4: fix wrong unit use in ext4_mb_find_by_goal
Date: Thu, 15 Aug 2024 15:25:40 +0200
Message-ID: <20240815131910.765117427@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 99c515e3a860576ba90c11acbc1d6488dfca6463 ]

We need start in block unit while fe_start is in cluster unit. Use
ext4_grp_offs_to_block helper to convert fe_start to get start in
block unit.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-4-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b2e7b1907d410..9bc590564ea1f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1850,8 +1850,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (max >= ac->ac_g_ex.fe_len && ac->ac_g_ex.fe_len == sbi->s_stripe) {
 		ext4_fsblk_t start;
 
-		start = ext4_group_first_block_no(ac->ac_sb, e4b->bd_group) +
-			ex.fe_start;
+		start = ext4_grp_offs_to_block(ac->ac_sb, &ex);
 		/* use do_div to get remainder (would be 64-bit modulo) */
 		if (do_div(start, sbi->s_stripe) == 0) {
 			ac->ac_found++;
-- 
2.43.0



