Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6B22F84F;
	Tue, 26 Aug 2025 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215650; cv=none; b=pV+V7ufreLVfn1FAjRXdb0K3bZGu0K+3V2KUmC9l4EWW/wNW8qxr1p0hcXvFmEL7mRW5jR34rSLHUAr9H2amxZjjkYJ814gkeKJbn/w0fga0az3w7PaCzUY54aXgCU08NUMFCdTCbhluDJR3tQvGxXY3RWDnZh8e/8Baz94JQsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215650; c=relaxed/simple;
	bh=D7lD6r7EUIU+H5en12Rwar2rK1pR2nLmvWl/C0k+1yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3hVe7pzZo913iYenFkr4LYDfcgCZ3JGuunO0MKp9kcWTr6s6tZS+Wlpge5Bk3ycACN9rIGNSO8K6ersYRIK0K3+GgmxVggMahrnpY4ur9JBQ1xjf4IC8zR3IRdvGL3XNOpS2xvlDmLeAXOtEgP0stVS71vdQhNZ+TH8uLAulCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRvFxCu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRvFxCu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC03C4CEF1;
	Tue, 26 Aug 2025 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215650;
	bh=D7lD6r7EUIU+H5en12Rwar2rK1pR2nLmvWl/C0k+1yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRvFxCu01tWYLLrfIa8YlTu7Oq/QkqiUkauX8BLNc0MNTvUlI+ucY7WtxW7lJ9a7t
	 gG3U4+HTMA4C/inNFprjgU63Lsk3gLkk38LHXBHlbJ7b6kUYIdXJDQjFw12gJKvtE0
	 DzygIGvFzIan5RLGBSCLezlH4KTTtgOnmh+Z1lGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a91fcdbd2698f99db8f4@syzkaller.appspotmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/644] Revert "fs/ntfs3: Replace inode_trylock with inode_lock"
Date: Tue, 26 Aug 2025 13:03:24 +0200
Message-ID: <20250826110949.329340392@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit a49f0abd8959048af18c6c690b065eb0d65b2d21 ]

This reverts commit 69505fe98f198ee813898cbcaf6770949636430b.

Initially, conditional lock acquisition was removed to fix an xfstest bug
that was observed during internal testing. The deadlock reported by syzbot
is resolved by reintroducing conditional acquisition. The xfstest bug no
longer occurs on kernel version 6.16-rc1 during internal testing. I
assume that changes in other modules may have contributed to this.

Fixes: 69505fe98f19 ("fs/ntfs3: Replace inode_trylock with inode_lock")
Reported-by: syzbot+a91fcdbd2698f99db8f4@syzkaller.appspotmail.com
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 74cf9c51e322..ffb31420085f 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -398,7 +398,10 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		}
 
 		if (ni->i_valid < to) {
-			inode_lock(inode);
+			if (!inode_trylock(inode)) {
+				err = -EAGAIN;
+				goto out;
+			}
 			err = ntfs_extend_initialized_size(file, ni,
 							   ni->i_valid, to);
 			inode_unlock(inode);
-- 
2.39.5



