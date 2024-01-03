Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0D01BDEC;
	Wed,  3 Jan 2024 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUST4WDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5458BC433C7;
	Wed,  3 Jan 2024 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302118;
	bh=rgaEuJjgGt7y06EBrYABnXseaqKeVFMrNr6NAfYE47c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUST4WDfQ3ALEAjPksAMzx5ttmYktfV0Z4Mlic2JlAj8gcK62ONNTobVEElqX0a2n
	 JzKdVsQyOPzg7El1sWGEVtzdKCMtECMhzLk6BIneP3xODHSpO3foXiI9TlGUtRCGWt
	 gvv+xUwmktkFc7umE7ZfdRM//cMFDht5QLYX1CfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/49] fs: cifs: Fix atime update check
Date: Wed,  3 Jan 2024 17:55:42 +0100
Message-ID: <20240103164838.409977982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 01fe654f78fd1ea4df046ef76b07ba92a35f8dbe ]

Commit 9b9c5bea0b96 ("cifs: do not return atime less than mtime") indicates
that in cifs, if atime is less than mtime, some apps will break.
Therefore, it introduce a function to compare this two variables in two
places where atime is updated. If atime is less than mtime, update it to
mtime.

However, the patch was handled incorrectly, resulting in atime and mtime
being exactly equal. A previous commit 69738cfdfa70 ("fs: cifs: Fix atime
update check vs mtime") fixed one place and forgot to fix another. Fix it.

Fixes: 9b9c5bea0b96 ("cifs: do not return atime less than mtime")
Cc: stable@vger.kernel.org
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index cf17e3dd703e6..32a8525415d96 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4671,7 +4671,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	/* we do not want atime to be less than mtime, it broke some apps */
 	atime = inode_set_atime_to_ts(inode, current_time(inode));
 	mtime = inode_get_mtime(inode);
-	if (timespec64_compare(&atime, &mtime))
+	if (timespec64_compare(&atime, &mtime) < 0)
 		inode_set_atime_to_ts(inode, inode_get_mtime(inode));
 
 	if (PAGE_SIZE > rc)
-- 
2.43.0



