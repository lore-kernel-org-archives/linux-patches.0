Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8B747F60;
	Mon,  1 Apr 2024 16:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988407; cv=none; b=BQUZRDXqXsQlILP40RqpKq8IpDV2y5QkhZf5TbcJpsupt1StvThQpZfc0eMeo7sP/efB3IJ3/WytX1SQV7qV200t8yosRvvkgGg1MxDh72musrjMQ55LdLsDb/SQRn1ZPqupNc6i7zGlwU4xMHVa26e/9+XpCyy7cVnsdrlGeC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988407; c=relaxed/simple;
	bh=G9zgkfZjrUDiTrPOfFlklTuHli8niF3WPBYVCqL3zN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izQHNN7nt/o0kxSU4hVdcrQXzKKsiOT9KEJ+jyR/uZLP83sw8ealz9PXLdWga71i/Qvfg3xkWNEcZTqw0qPs+uyNe3up5+GvCWx+52En2d6l0f22Qk649vReVw6TRftuI7VIlwO1pFUxsmVj0FK7LeUHw/Uo6xSgHwrUTKtpK2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOy9frAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOy9frAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13C8C433C7;
	Mon,  1 Apr 2024 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988407;
	bh=G9zgkfZjrUDiTrPOfFlklTuHli8niF3WPBYVCqL3zN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOy9frAY6uIRNlQcn6KvKOSyEyvdcF16wXxU68UL3ZYXvACZ2N6Wu8ad5kFIveLqg
	 LIBvVRyctpphBrHLBK9VoDOqtqLY81JTfSLNVq8wL4ET0LyvMCzHyGNkFvWNUkfZ0R
	 vDkQKEmMu3ETlqKIJsgw7AmlFl6TnA2brbiC+4f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 176/432] nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Mon,  1 Apr 2024 17:42:43 +0200
Message-ID: <20240401152558.397061023@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index f861f3a0bf5cf..da97149f832f2 100644
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



