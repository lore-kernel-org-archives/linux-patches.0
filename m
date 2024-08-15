Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A961714AE;
	Thu, 15 Aug 2024 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728983; cv=none; b=qrPOf77PptWubuT/iic+tCMXCRBHm4B1MB3td7g1Qt+emvpcKsFSWaph4rdM/XpnwqPVndlUpydO1rzhX7Zp0Hto2dlo1VMLFgtY8m5ZagjFNLmGW11VweKdStAHQUmy2nt4HwpT3VQ7kPVazGKte2GEwrRfOJaiRVkiPVIz2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728983; c=relaxed/simple;
	bh=1BEZdnljWEHq8yGCf5JN5vFPM9EWqUM5In48GWHBF88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6vDdFar2h1nUNZw+uZSehCDRTawI80UUEb63odMJ1PqlsCUFD71kCHKIlawhYrWTtMhNtlyGCDEHvGO+bf7I8xrhirIRiXKEGfJq2HrJ9/sXrxCBqmg3A1kZlRrlhs6/yT1INxdoGSiSZimLlDgD+xvDsffHqvE309tcjpZqeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4rUuvh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4rUuvh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9C9C32786;
	Thu, 15 Aug 2024 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728983;
	bh=1BEZdnljWEHq8yGCf5JN5vFPM9EWqUM5In48GWHBF88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4rUuvh7hK3gOjOq7GHWeBeK6ZvmT5qBTS06WfRkd8XOX/lfxmkGTHA+yH6r5gNbp
	 /RpJaiIrvnbQPDdGBHpNZx46lCDQHzNQOyhvG864FySrl1pDvzH4EuFAR7HN+hSI7u
	 70J1m0orVm8hJm6vCdW7LmyQWUdcu0lV/2XP1IFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/196] ext4: fix wrong unit use in ext4_mb_find_by_goal
Date: Thu, 15 Aug 2024 15:24:23 +0200
Message-ID: <20240815131857.660175658@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5af5ad53e0ada..5dcc3cad5c7d3 100644
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



