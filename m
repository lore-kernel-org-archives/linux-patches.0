Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB69C627E3;
	Tue, 23 Jan 2024 00:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971186; cv=none; b=sT8TajWcztALTEL/v4VktLuVEJF/gDrT63eqJBsFjsvXQSBid8PKvKqYTK8iLC25CeZEUBSN8ix8we4JRewVsfTR890bXI+NquaAAhB1XLu9b/zHfbXVKFrbqgiveKaQ5xQVlp2mTlNugkQBVkMMXXovdJvFwyjdQGL5iO0EjdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971186; c=relaxed/simple;
	bh=Gh4kLQs15xIFjoA+pGkvkFgnY6XdacilJpG4VwXndIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrrviUqF3mGahPPbeN8lIj6+hnVcYYZs0fPbf3XKmVC1lsnYGICHdYth47Rfk/B6UuN53fRf5HUhxNNPtgzXZgmBLPdUySfMNB0yfH53SqpeUa2Q5pZzEaUDovoHErRshrAJr3Dr3iugr4Z93DiWPcjwfySJh21eEx0rzGJUMSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bA75d6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bA75d6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB1EC433F1;
	Tue, 23 Jan 2024 00:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971186;
	bh=Gh4kLQs15xIFjoA+pGkvkFgnY6XdacilJpG4VwXndIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bA75d6NzhXjdr2UU11DBhkQtrBP7cbPurVJeTv1DIUU5xUzo6Lkl2egDT6oUXNcP
	 +48AVmwfeJO9MkZryLHu6D8mLbfTbpIjfVwI4M26shEDQerJdbanSjLmQfldVT1nPr
	 GV60mkl1FjBShppXWdUqkqOg2Scut5LTRaZGfNHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/417] f2fs: fix to update iostat correctly in f2fs_filemap_fault()
Date: Mon, 22 Jan 2024 15:56:08 -0800
Message-ID: <20240122235758.861062614@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 3f2c55b9aa8a..fd22854dbeae 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -42,7 +42,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 
 	ret = filemap_fault(vmf);
-	if (!ret)
+	if (ret & VM_FAULT_LOCKED)
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 					APP_MAPPED_READ_IO, F2FS_BLKSIZE);
 
-- 
2.43.0



