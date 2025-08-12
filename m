Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9822DCF46;
	Tue, 12 Aug 2025 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021963; cv=none; b=qXvzPtnSy7aoht1CtTQPqgqXOu3+yS2HkXVrmamJ6XCuIRB6nlE/djgiizMWufbe5cR2MtHIzDn67hx5jfwI7In3mGntJTqlMu0WAKxiE5Lo+MpJ2204ULs/HpF1u5LssTpMgJi/FuniPatT5/edLO8uDxEgzEH7zDMbaBlRJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021963; c=relaxed/simple;
	bh=Qb2psTkQ0zwNviEP8a1e73ULydlZuNjJx4iwJH26faU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFXW1mMbcRcNV6avR/+AhTUBq1XWEIQtZtTSx86serbYt92ibqNWwNSk40kI6UBx02bpaYhP31ib7eBfbC7AyuDDmITvrqcXxB9lGQ0hW4PJD+3D+rV9uXu8BachlDwaTRW+d17RegtmtHD6A4ibegL7JE8Gp3NL6y4vp46q59I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2BCgebQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2BCgebQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034CAC4CEF0;
	Tue, 12 Aug 2025 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021963;
	bh=Qb2psTkQ0zwNviEP8a1e73ULydlZuNjJx4iwJH26faU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2BCgebQMYzN5/QOWP0vqPLL4ew5/33fhVCT5Ys5iiCo6Fh6CoAMSpG2OHjd/2AGv
	 dbd5nefT15DTltENpinW2leHBmXIDc+OxS2NORqIwS3/lvIdJPA/FRHAXSRNRkSaPK
	 hoL8I4ppg9w5qIFfdYk9Ez1n62SYv29lyVQMujKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a91fcdbd2698f99db8f4@syzkaller.appspotmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/369] Revert "fs/ntfs3: Replace inode_trylock with inode_lock"
Date: Tue, 12 Aug 2025 19:25:12 +0200
Message-ID: <20250812173015.314756218@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 748c4be912db..902dc8ba878e 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -392,7 +392,10 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
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



