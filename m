Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D9258FD29;
	Thu, 17 Sep 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658826; cv=none; b=ZgpD9RXgKGbBpbK8syneXPvyQcAxUWBbqYt5JCUNbPlINQ3YbT1Or+wN5CI2RcNTs4TBu5W3QbbE+arXrvzom/TjMDWZSSk4enf9DrSW2fgqrEcE/rEKBK9DHBjuN4xgAUAi0CuPL/mL9nxPLk+hqpdGmztfPqZf25v1IUgd8hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658826; c=relaxed/simple;
	bh=FKfkyDu+uqjkbpcMoyvUVceUL3VHHfwISFwTi89Yn10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwkdRIkxA73jnyjJzU241sBiscg02jeP3yBm/wDCxpB3E6cCJIqoajSW7aUxh3AJhbWbbwGNKSOQpSC7rhoboGowKpkZYqFt1hFM6aufU5QjQPyrkoVTI+7btERCogdJMCF1rMFbBvwz1G/6TYgDvdLuXtVnwD1Y7YEKe0jYFfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KD2mHP9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KD2mHP9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7511F00899;
	Thu, 17 Sep 2026 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658817;
	bh=bkOPYbReJ0A4GsNP4gz4HMYBPnYq7ge0HSRjg1O9imc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KD2mHP9iTGwEee+g2gIT5/mA/F0I5UsJzHSqBf5AFwr7CsCHakMlxj/y3IspXApEf
	 0vuH6IS5Nn2zO0dT1ro9iJBWusHU7L/IxAXLoNeK23t2zIBoTHiEJpzvUY21JfuZto
	 9FHhBzeUVILlHazKq/Xg0SiHXP1QxaLpDkd8edLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 050/733] ntfs: leave HasEA flag untouched on setxattr failure
Date: Thu, 17 Sep 2026 16:05:58 +0100
Message-ID: <20260917151352.027227821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit ac727d86fb84bdc9626ba9c756c26767459f3083 ]

In ntfs_set_ea(), the exit path unconditionally updates the HasEA
flag based on ea_info_qsize. When an error occurs before
ea_info_qsize is updated, NInoClearHasEA() hides existing on-disk
EAs until the inode is evicted.

Only update the flag on success.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/ea.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index 08c35f9751114..75a251ec4ebcb 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -390,10 +390,12 @@ static int ntfs_set_ea(struct inode *inode, const char *name, size_t name_len,
 		*packed_ea_size = p_ea_info->ea_length;
 	mark_mft_record_dirty(ni);
 out:
-	if (ea_info_qsize > 0)
-		NInoSetHasEA(ni);
-	else
-		NInoClearHasEA(ni);
+	if (!err) {
+		if (ea_info_qsize > 0)
+			NInoSetHasEA(ni);
+		else
+			NInoClearHasEA(ni);
+	}
 
 	kvfree(ea_buf);
 	kvfree(old_ea_buf);
-- 
2.53.0



