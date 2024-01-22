Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4964CF1;
	Tue, 23 Jan 2024 00:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971534; cv=none; b=FMg2HQkllO7C5aujcuLoOCXXfTX2jr8OdNXJg8EGD1R4zQIL+Zy2VyqM6atxj+SzrGetSxDs61ryTMgwNShXKXui1RuFzEt7oJ3s99V1L/Y+cbCwZy741m//3+0I8FAZBdFSOzMT4ySwT0uNfLWVpHxTO20DX1AKk9DoSlO42zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971534; c=relaxed/simple;
	bh=dOAD9QLRp5fdLaJzgsPiOuKe+bHNIPk1Nvq9lhn/AE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJDoHrAfDv/MC9hCuWk5d0geyBDRUBM22EIYhacLoJ7jmvOIq8kmEFV5jk4SwHz364nhMJ5URt1gC93jrVcF4+F9TgLtRmZJqx52znkxo/DQ0MWX+NurFjyez9HFiI7vmzYcqTSfJuUswTYLQ2M+jrnuKgOePyrCO8qJH1f3Yfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/VXNMCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/VXNMCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E38C43390;
	Tue, 23 Jan 2024 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971534;
	bh=dOAD9QLRp5fdLaJzgsPiOuKe+bHNIPk1Nvq9lhn/AE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/VXNMCc9A4HZUXPbeTKBZ9qoqaRsJy+OdTW0RCOrP8X1jh3G6JF+Ldwv9jXRVZR8
	 hJ8ac+x/BQUefUiv6aQEwjBf8K0Ib3xPvmjiiiIcSDRq3GDFMeBYS72w3sRkUYu3be
	 jDnz0vIQ8T6EG690WI5O+IVnwGO17dm5jPLnJQ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/286] f2fs: fix to update iostat correctly in f2fs_filemap_fault()
Date: Mon, 22 Jan 2024 15:57:54 -0800
Message-ID: <20240122235738.641951467@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bb34cc6ca87ff78f9fb5913d7619dc1389554da6 ]

In f2fs_filemap_fault(), it fixes to update iostat info only if
VM_FAULT_LOCKED is tagged in return value of filemap_fault().

Fixes: 8b83ac81f428 ("f2fs: support read iostat")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 98960c8d72c0..55818bd510fb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -42,7 +42,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 	ret = filemap_fault(vmf);
 	up_read(&F2FS_I(inode)->i_mmap_sem);
 
-	if (!ret)
+	if (ret & VM_FAULT_LOCKED)
 		f2fs_update_iostat(F2FS_I_SB(inode), APP_MAPPED_READ_IO,
 							F2FS_BLKSIZE);
 
-- 
2.43.0



