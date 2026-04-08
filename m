Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3E83537FC;
	Wed,  8 Apr 2026 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672221; cv=none; b=M7jXqpSLFCgsGp843aP9M4EnhUkLkpOOxmTbvQWeBsKJyCz88MTmLRbj+sh2oQBe0VbN4r37ziR3jvIr9/Cw0EHq0fUjr/B479IzLa6gkhowvgjx9gBJLZAUMUSFnXcwnbdi/auaX2l9WFuA5DdfvAe+ZLAZrZPKUcIk1x91Omc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672221; c=relaxed/simple;
	bh=aroPpoii0ChkH4MdCqrRHp9zKlDHN7bwF6/MTPv0QCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6UwAPo5+H6pYn/8qaIIP5YcYNVKATpdxksPsaO5syHtM+b8eRVzbBkEa2kDJA+MXlsbJOjyqvhTyGtummSOtDUKf/pXGkgiLorYmPgTHoRgZKZZ7KtweNJA5EYW5DcWQARg6WFNCrRedUPyBzfGzaBbtdxKG2EZxEHNeQsFY5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhYLiT1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhYLiT1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33758C19421;
	Wed,  8 Apr 2026 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672221;
	bh=aroPpoii0ChkH4MdCqrRHp9zKlDHN7bwF6/MTPv0QCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhYLiT1s9cSc2mUF+lush597zz7wzaxVsDo213vZjBzn4KuYGGinlakGPrGcp/HWA
	 7jevlBJtoT43SWuXf6ARVJemyoVyRsp1vf18g0Op3jDcRUShWg2NTUlNZC74jvTRpq
	 umjkJx0oqYVutb/79uwvVheMD5IG1oaxT846iCJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 237/312] Revert "ext4: dont zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1"
Date: Wed,  8 Apr 2026 20:02:34 +0200
Message-ID: <20260408175942.603251014@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
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

This reverts commit ddf854e59166533b0f46ba32cd6cd9aca3197d1b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index da7414e84ead8..e2f9c27c7e161 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3298,15 +3298,6 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		}
 
 		if (!err) {
-			/*
-			 * The first half contains partially valid data, the
-			 * splitting of this extent has not been completed, fix
-			 * extent length and ext4_split_extent() split will the
-			 * first half again.
-			 */
-			if (split_flag & EXT4_EXT_DATA_PARTIAL_VALID1)
-				goto fix_extent_len;
-
 			/* update the extent length and mark as initialized */
 			ex->ee_len = cpu_to_le16(ee_len);
 			ext4_ext_try_to_merge(handle, inode, path, ex);
@@ -3382,9 +3373,7 @@ static int ext4_split_extent(handle_t *handle,
 			split_flag1 |= EXT4_EXT_MARK_UNWRIT1 |
 				       EXT4_EXT_MARK_UNWRIT2;
 		if (split_flag & EXT4_EXT_DATA_VALID2)
-			split_flag1 |= map->m_lblk > ee_block ?
-				       EXT4_EXT_DATA_PARTIAL_VALID1 :
-				       EXT4_EXT_DATA_ENTIRE_VALID1;
+			split_flag1 |= EXT4_EXT_DATA_ENTIRE_VALID1;
 		path = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (IS_ERR(path)) {
-- 
2.53.0



