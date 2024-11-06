Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61751DFE31;
	Wed,  6 Nov 2024 12:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897070; cv=none; b=JL350Rew9A+7m4mwckTX6GjpauaD6URN5TTebfQFGl1QmIarQn3ZZsEPp5VU6KV3xGB9bkFDT6aPfjXhHdvuXVY7VNjuHHqDcSu8FoewB0XIeL+/zZNDtdOFMCqfWLWAWxm5za1j0bjYNonP2GV9mReA8ViaBAV08IXDdkKYQuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897070; c=relaxed/simple;
	bh=VpQuu+3jnewdSLWg1rHweiJf4nCB9iL5ihBYBheBrbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c98TqHIRSxSFfIPB3Zf3oRSxtJ3aooddvuGpKv+4ZGSF4v1uzWr7Xfj+Vez3XuHH15wGG3yYF6HoNKUZg3IwnkjsfBuR15G8utiAmZq6VcDQFVxQ51B/uzvQvJrmfRS3q0Fa94Ed4IWWxhVl4XP5CS/ed+14a/iv/fayb3EFSNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5WeqK3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5WeqK3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5767CC4CED3;
	Wed,  6 Nov 2024 12:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897070;
	bh=VpQuu+3jnewdSLWg1rHweiJf4nCB9iL5ihBYBheBrbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5WeqK3Q2oF2cCgu6QtyN9Z9LzbfpYkV8wGEEZ405yWLqn8QXroVFXxB9C5H5kTRG
	 b/DWOpab2ZQIJoTrHG2SCRwLd9F6fJ4Ic6CvkpPfRgJUfE/Zcb+UdqfeOKG5RhtXei
	 53ZqR6Nn1hOqXSjMmfO3h54jNVPscG0q7Mt4TTMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/126] fs/ntfs3: Additional check in ni_clear()
Date: Wed,  6 Nov 2024 13:04:17 +0100
Message-ID: <20241106120307.611941278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d178944db36b3369b78a08ba520de109b89bf2a9 ]

Checking of NTFS_FLAGS_LOG_REPLAYING added to prevent access to
uninitialized bitmap during replay process.

Reported-by: syzbot+3bfd2cc059ab93efcdb4@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index e19510f977112..d41ddc06f2071 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -102,7 +102,9 @@ void ni_clear(struct ntfs_inode *ni)
 {
 	struct rb_node *node;
 
-	if (!ni->vfs_inode.i_nlink && ni->mi.mrec && is_rec_inuse(ni->mi.mrec))
+	if (!ni->vfs_inode.i_nlink && ni->mi.mrec &&
+	    is_rec_inuse(ni->mi.mrec) &&
+	    !(ni->mi.sbi->flags & NTFS_FLAGS_LOG_REPLAYING))
 		ni_delete_all(ni);
 
 	al_destroy(ni);
-- 
2.43.0



