Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8CC268C73;
	Tue, 12 Aug 2025 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020388; cv=none; b=l6Z+eq/OGcKwyloQ0+a1TvOQGrTu3kSgKCuuu1+Z1qBQc7D1bnPGybAD/G8+5JxsQYkXxRyIwqtLMAgOcpgrfiNlHIufmJO1idQgeIZMF/UQVKlughbIyEt319fbLW6uY6hFMuGGSDgWVLeQ2CMFyereikszx3BKNyvs+QtDNRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020388; c=relaxed/simple;
	bh=7fkkL68pgk+hI7aTlFnFA9I47DrVDYUuevuMLxHEEjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9u3FUiPkwjSa0yvHv5h96We6Qub0BpiSIB++WWyzrLIdfw3kc0HHi9iGLD/RNTzQUZvPPt3Y9AdnMD6gCUUBTEgNvNn5YeZHP8eF39ZASzcR6gnNJoPObMEvmAS6kVQaaY6SkB/KTc+s21YjHbKLVDAy7UFILt29I1nJLbpZ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHnpsIuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHnpsIuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378EAC4CEF0;
	Tue, 12 Aug 2025 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020388;
	bh=7fkkL68pgk+hI7aTlFnFA9I47DrVDYUuevuMLxHEEjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHnpsIuR7U0i96yNuE23OvKnITNU9tcLpejcpej0OCOWJhqX6pPeFvDH45fGFMnxU
	 IjMu7MCAVzJllxtLtiNSWliaeF4+1O71s63HtZVT+RGwhdHlrxmPqlGQBm8908dEDj
	 aY9r0UwQiXxwdfraj877PTRYgVYq6wFV7fHCwUsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a91fcdbd2698f99db8f4@syzkaller.appspotmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/253] Revert "fs/ntfs3: Replace inode_trylock with inode_lock"
Date: Tue, 12 Aug 2025 19:27:35 +0200
Message-ID: <20250812172951.579638059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46eec986ec9c..6d9c1dfe9b1b 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -317,7 +317,10 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
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



