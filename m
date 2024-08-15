Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B27D17C9A9;
	Thu, 15 Aug 2024 13:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730385; cv=none; b=gdcalMTkncvGUpgbFdSyqohNPCPDwLsoRgrBn57qC8GG2qDz94wyrl5PrUFfhem4WNLwUAyCbqSftYjO9jIEaFBAaAXq8VeXD9qPb81slIaBofwas1PpdnR4RLW5C9el/o3vJt95eQUqGS6IVChJff4JD+piz4f6VWeoTSbRGYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730385; c=relaxed/simple;
	bh=fszcxlRCXMlTf4SNJdprPXYfopXXY9/X0BpVmXbqWd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmZfQmbImGqO9b4r+t0I8pz51hVuk/HxLixt/0kWJLup4xVqCJmuhfOBdCv1B5TXRq1m3p2YJjzmILkA8LRwDqPsx5hREy2JOZOOtttJKy5gpDZZvLdnC7NCwGDmYZ4WtHq76iw7LsaQ7jui/yE4Pf2IhSlT8PrZCcWjKiPnYNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDmMdo7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDmMdo7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59431C4AF10;
	Thu, 15 Aug 2024 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730384;
	bh=fszcxlRCXMlTf4SNJdprPXYfopXXY9/X0BpVmXbqWd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDmMdo7AV0Wyg0GteVLuCc1AhbtOab1XCT5+uI4b9ua3iUU47b9NTSEgdRMKcUIqL
	 Qd6AUPGWHZYLjOKJq8s7fXRMK0WqAMbCtptVauav2hGHKuxDg/wJSqp5kFr5Krr+FL
	 6/ms7okD/fJTCrXGUrwkuc6RxAkCHNMMeRqi/61M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/484] ext4: fix wrong unit use in ext4_mb_find_by_goal
Date: Thu, 15 Aug 2024 15:24:09 +0200
Message-ID: <20240815131956.549031842@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1145664a0bb71..630a5e5a380e2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2270,8 +2270,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
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



