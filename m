Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF1B148848;
	Tue, 30 Jul 2024 16:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357014; cv=none; b=CnlcZsXyBBuGVJdK79M4AMlr/fZaXm9iR7uMdGIm2VSbr18wYk3ZE//RZFygfETcZRBbUOxKwd2uvWIoGPyX2d1MiZclYLKdzfs4KPzBCxT0TvMT7q3mTayu76tIIMPB2bxI9DWSjDJp0QqI6FeC8zsNbQ2A6Fzr+oeayQqYRew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357014; c=relaxed/simple;
	bh=qMKCBbNj5JTtcwSX5jHFyPTcWMP+FKOAQKx7G3TJEDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da6DTNlJTYdpv3/rXtj5WPs72Rxisb0UNAY6mc2lA1i7JAirGD5crmfrcxbUnRRlA8GSMHgZE7PpVJ6xn31PPBQlPzz/vIpD70UvSOGb9TkxiV4cnWGBKo1fWcuyt26DdjrehUeM0Wu+nV2OHifdBOAfzxj45S+GBUzwfoaC/pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqs/xOHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqs/xOHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66915C32782;
	Tue, 30 Jul 2024 16:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357013;
	bh=qMKCBbNj5JTtcwSX5jHFyPTcWMP+FKOAQKx7G3TJEDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqs/xOHKsTBe+2ErE7f0pGGQY0xX0T6ef4E5MutrPYrnbsbRZdx0xo813+PZyXJ+6
	 fLVQLSWYE4F1HAnsVg1IYLdaPiiWiRbuDEk6u6CIYVegcB3X4uxzBLyNoPo1jSKQwG
	 gPD1O1PApkCIatQRNnZBdgfl6F35ZJfre+oT7UaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/440] fs/ntfs3: Replace inode_trylock with inode_lock
Date: Tue, 30 Jul 2024 17:48:03 +0200
Message-ID: <20240730151625.614549256@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

[ Upstream commit 69505fe98f198ee813898cbcaf6770949636430b ]

The issue was detected due to xfstest 465 failing.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 14efe46df91ef..6f03de747e375 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -396,10 +396,7 @@ static int ntfs_file_mmap(struct file *file, struct vm_area_struct *vma)
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



