Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE3743AA6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRFznVQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC23C433C7;
	Wed, 15 Nov 2023 20:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081052;
	bh=t6LAKxfYnfxge0l7MdF9EQLgN+08WJHaC/4X++RmunA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRFznVQfFWBci9wkxtKSdCFaf7dTAzNH9ytwPAHsNj2lG9IFeEzYa8Yq4aP7H460j
	 6hfIDgkIWgaP6jJaAV6VVH2K7rzfzM8XT28FW7ZA+hHCGVwULBfDZqmi4b6EnoApuU
	 /oage1ga4LaSS/jKHtoIyCfQWn27V/Xif/jEEuxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reuben Hawkins <reubenhwk@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/88] vfs: fix readahead(2) on block devices
Date: Wed, 15 Nov 2023 15:35:13 -0500
Message-ID: <20231115191426.291570066@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reuben Hawkins <reubenhwk@gmail.com>

[ Upstream commit 7116c0af4b8414b2f19fdb366eea213cbd9d91c2 ]

Readahead was factored to call generic_fadvise.  That refactor added an
S_ISREG restriction which broke readahead on block devices.

In addition to S_ISREG, this change checks S_ISBLK to fix block device
readahead.  There is no change in behavior with any file type besides block
devices in this change.

Fixes: 3d8f7615319b ("vfs: implement readahead(2) using POSIX_FADV_WILLNEED")
Signed-off-by: Reuben Hawkins <reubenhwk@gmail.com>
Link: https://lore.kernel.org/r/20231003015704.2415-1-reubenhwk@gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/readahead.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 4e630143a0ba8..96d0f652222a9 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -593,7 +593,8 @@ ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
 	 */
 	ret = -EINVAL;
 	if (!f.file->f_mapping || !f.file->f_mapping->a_ops ||
-	    !S_ISREG(file_inode(f.file)->i_mode))
+	    (!S_ISREG(file_inode(f.file)->i_mode) &&
+	    !S_ISBLK(file_inode(f.file)->i_mode)))
 		goto out;
 
 	ret = vfs_fadvise(f.file, offset, count, POSIX_FADV_WILLNEED);
-- 
2.42.0



