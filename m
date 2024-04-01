Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440DD1C0DE7;
	Mon,  1 Apr 2024 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990975; cv=none; b=fW5jfSLv0TvH8hUVk380h4fIxCoyicyxXlgaGUClnT591VBISwWZ3x59/d15A/idG7/6XiqLopqD0pgLgByi1ItL07td0XMrQUJfjX0HZmwD5FhqjI9FX3CJKTgC8v7GSoHfSMxf62ka1cXLAkSTUaPSaJ76Ysw5rcv5ttm/ehs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990975; c=relaxed/simple;
	bh=5riP3Of43dAhmghPZwb3Q8+ygQ4RnLkY5+Ly0DtiPy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaBvKE+PMtBVDrwA01LpU7qQ/ktEvpda+dSo9bAHkxCxovjxEk4AzKkP/kVefEsyEE2RMH+ZSiQ9r1ybEhzMtuCDShnU6a3u1B5zuje4xPwk/PXjtMawAtcdoKTZxVpJEnY6h/e9L18deiCWoWMOknfJOYqxqJMapkbiiXSt7Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRCRMqHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRCRMqHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C13C433F1;
	Mon,  1 Apr 2024 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990975;
	bh=5riP3Of43dAhmghPZwb3Q8+ygQ4RnLkY5+Ly0DtiPy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRCRMqHK0iSRD6aLIuuCr40FI0xB6X4LvMS6iectRI3tHtGwfQgUw/xLLmXg4ekTu
	 iMuhTjdqbOH9Iy2db1OPq/lF90hxx3JGWfN4Jfzo1yYLs+MA74rJX6T47oC5nPAtOA
	 e5lVlt9edDFMyEiHIUz27LAyl5BQMahLtgnIX5wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/272] nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Mon,  1 Apr 2024 17:45:15 +0200
Message-ID: <20240401152534.567911997@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index f625872321cca..8eb4288d46fe0 100644
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



