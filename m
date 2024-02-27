Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA7513B78A;
	Tue, 27 Feb 2024 13:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040581; cv=none; b=MvBZ5oa6osg8HXQUC4H4FVcuRMEQGPnOL/R/6S3oAHdIfk+L7zfQeZZZ0zaJzkBSzZNbRJR8T0xlo53yjYc2odjn+idcrpQ1KQDShpJyUg4bSsDf7P67iA/G+pkk1sPZvZEn1V0XXW2eRZAWoTb9vNTGHvar/hOeoJDonCUjbVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040581; c=relaxed/simple;
	bh=rDPWJWJfCEMS6QOskFKvC4b0se/xGZDy4c6wYbFFtdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxYwJ/oDc5k6kuqdiGJYX2vJeXf9ZyLtdrNRRBXzjXdT1liS/UoLKDXoxUZ/6Y/lw1IHpPmfG0K8/PLJpRJZawD/EyQTv1Fkdu+abgE5sNGZ5af32n+cgrCAS/2ka3xOsKPQj2WlOcN9hTLpQ1ljMfIlUzHvlUvXdW/fFZ+qUk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbNBe7P5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbNBe7P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA2EC433C7;
	Tue, 27 Feb 2024 13:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040581;
	bh=rDPWJWJfCEMS6QOskFKvC4b0se/xGZDy4c6wYbFFtdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbNBe7P5mcADAsjkaZocWRaFn1Ua75NVHKZ3kg6P5981d1gIydC+lkhFkiIS/GI+i
	 8BEtIhh1xpo3VXDq3f43bfNCbYds2zwvbgskekQy8XIo+ikssa4vTuThvOL5hIrEKW
	 5+iFLWm/szvDaYELhQIpMe13WmxjiJiaCrI0zzc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 036/334] ext4: avoid allocating blocks from corrupted group in ext4_mb_find_by_goal()
Date: Tue, 27 Feb 2024 14:18:14 +0100
Message-ID: <20240227131631.761649947@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 832698373a25950942c04a512daa652c18a9b513 ]

Places the logic for checking if the group's block bitmap is corrupt under
the protection of the group lock to avoid allocating blocks from the group
with a corrupted block bitmap.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-8-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1bc615d621917..7497a789d002e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2342,12 +2342,10 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (err)
 		return err;
 
-	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) {
-		ext4_mb_unload_buddy(e4b);
-		return 0;
-	}
-
 	ext4_lock_group(ac->ac_sb, group);
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		goto out;
+
 	max = mb_find_extent(e4b, ac->ac_g_ex.fe_start,
 			     ac->ac_g_ex.fe_len, &ex);
 	ex.fe_logical = 0xDEADFA11; /* debug value */
@@ -2380,6 +2378,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 		ac->ac_b_ex = ex;
 		ext4_mb_use_best_found(ac, e4b);
 	}
+out:
 	ext4_unlock_group(ac->ac_sb, group);
 	ext4_mb_unload_buddy(e4b);
 
-- 
2.43.0



