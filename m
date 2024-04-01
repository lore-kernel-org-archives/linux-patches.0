Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F9838DE5;
	Mon,  1 Apr 2024 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989890; cv=none; b=jl0U2SvE1TgRDJz9s5Y+Pc/j/SIhq33Kk/NAtMKZTN/Kfxl2m/tKdsh96MYOBINHJl0fgQ/g//c/OZOgAQPLeGciaIrOUsWopRIF7Pukp6KhHPktpiq2FQ9IXd7UVCqH/xNXQhg6BeakL+2jjqnRq34dwfxj+6X9tSYRP9Wsr0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989890; c=relaxed/simple;
	bh=eVJSs0Hx9i1EGQ4oU7Hdw/G3OFmF2vRmeLjcqvmyp+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn2H6kVTnA1gK0Z+GpGVBFPzwZQT5YP20+bTyKONQte7OVe49NAHnspR2uLDgyZdrN5OwDVMNbmI8hAj546S+wuXVPOWqNzMjU+kvj7yAHVCilewAZJkyQXHKr/PdX0Msc/S1hfX6qEzvk7xrs1MZ9lMGtu5s60NANjzmFyvWtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRmjfzmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRmjfzmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D1DC433F1;
	Mon,  1 Apr 2024 16:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989890;
	bh=eVJSs0Hx9i1EGQ4oU7Hdw/G3OFmF2vRmeLjcqvmyp+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRmjfzmrtIXIDXSLzo7RQZs3n/ekAQb8HRm0Ivlsova4RkMdaAsVeOQasX78LC1gG
	 w3oGpnCZzxa9gFBSMOejCZuw4qC6H8k2Mu+XoCw83eS5uBWQ5ZFhS0iqOuynl7fIRn
	 gouEc0ja2sLLmCXm8rqgAEfts57FQJXr7SJV7r0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/396] nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Mon,  1 Apr 2024 17:43:24 +0200
Message-ID: <20240401152552.566325275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 269cdf353b5bdd15f1a079671b0f889113865f20 ]

Fix a bug where nilfs_get_block() returns a successful status when
searching and inserting the specified block both fail inconsistently.  If
this inconsistent behavior is not due to a previously fixed bug, then an
unexpected race is occurring, so return a temporary error -EAGAIN instead.

This prevents callers such as __block_write_begin_int() from requesting a
read into a buffer that is not mapped, which would cause the BUG_ON check
for the BH_Mapped flag in submit_bh_wbc() to fail.

Link: https://lkml.kernel.org/r/20240313105827.5296-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 1a8bd59934761..8e1afa39a62e1 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -112,7 +112,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 					   "%s (ino=%lu): a race condition while inserting a data block at offset=%llu",
 					   __func__, inode->i_ino,
 					   (unsigned long long)blkoff);
-				err = 0;
+				err = -EAGAIN;
 			}
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
-- 
2.43.0



