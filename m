Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFE9189BB5;
	Thu, 15 Aug 2024 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729639; cv=none; b=Mj5O64xBe/ZoJf40joulNTmaCzERhBZ79WcHQkZzKeVrfh5d84gi00/NfxEQMF87fOg+DHPyCh4X13c5aFVQMjGxA0w6DiS134dj//cKHjn2T5iv0xwwXATaBtGCfop1a9hxXTTRFGZpkm6ZGumJkFAUSbrSKoi+sl1TqJ5TQ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729639; c=relaxed/simple;
	bh=OdPN/IPtC1DIe/hG3GquMuyfHz4+k7LhdNF9MAefGgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUGK2kua0f0NZeluYr4yGwgKcpriii/GN0NltkD4edg6a9NTLWFGAjbXofe5VXGoQcVcNfWMdMqaB/BWHkiazCOgtZL0LOgh37eHLSO7oa1Q8t3n0EEHox/cBJVMueByenwKRPilNRS5B6dvJ/L3dPffI7wFY2bsXN1PXYJIu/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gm4Ad4id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm4Ad4id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B2FC4AF0A;
	Thu, 15 Aug 2024 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729638;
	bh=OdPN/IPtC1DIe/hG3GquMuyfHz4+k7LhdNF9MAefGgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm4Ad4idxxZetwNtwuOACQXkKAAjKHVu0x9OjRGytizgpQMFFw3UBJPaRXOHgsUHZ
	 3x8N98S60SKgp0Eq70B7cJagYMmQ+7DynVg/wLz8QxZi5bJVJO+lgwPQrUS6SlCoQq
	 IfanGurHnJ7TZpQeH+mkpa1xnLuJgdURL3iohs7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/484] fs/ntfs3: Replace inode_trylock with inode_lock
Date: Thu, 15 Aug 2024 15:20:18 +0200
Message-ID: <20240815131947.592753372@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 69505fe98f198ee813898cbcaf6770949636430b ]

The issue was detected due to xfstest 465 failing.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 6d4f3431bc75a..af7e138064624 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -398,10 +398,7 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		}
 
 		if (ni->i_valid < to) {
-			if (!inode_trylock(inode)) {
-				err = -EAGAIN;
-				goto out;
-			}
+			inode_lock(inode);
 			err = ntfs_extend_initialized_size(file, ni,
 							   ni->i_valid, to);
 			inode_unlock(inode);
-- 
2.43.0



