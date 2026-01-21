Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27A5387359;
	Wed, 21 Jan 2026 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019710; cv=none; b=cxtA9D20PnZvK+ixNtObchdCsbueN0YrBTIGlzYji7n8j0IwjIfM1+oVHa7iJMhh0L5xAo2P80Hum4txtbLURDnh6x5PgB8La0ClKeWtw8The0Nli+wPDSWQwJYX2in6dDrtSKF2aGsxqueg24A06/f6NDaqXIczjtz7sJyuBuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019710; c=relaxed/simple;
	bh=czsyv4a9OQEBX085PrqqwU1NbJwoLoSiC9pY6XOzl64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Npw5/rvsVd9IrnyUHrbDTSgglmcCot2a8MFXL8iSDI9yNSgZUT5IfoEI4+6tT1gyKruIyx/70f3dQgtTmDfiFMF507xpa7IHNZN+w4fqH+9TAghlsELW6TLbBTYBhlbrmr5aBb4YyX9sQk+7gnCp7QYvdylvLK9qTQI1mz0s1Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7jAliR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7jAliR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06870C4CEF1;
	Wed, 21 Jan 2026 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019710;
	bh=czsyv4a9OQEBX085PrqqwU1NbJwoLoSiC9pY6XOzl64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7jAliR3Thc2du0EkaProHonxKq7OhOqBOOoUXuewYBazVe7sXGIW2ONJUhdF79Yd
	 okrxfLFRV12J1KSoRR02hrPRmTi612vHHvqXJuDMiC39OzXGyVIiHrAhjtgV/GNANK
	 GvSMuYcmzmDF4v06Osje5QWQtQHSsJQeB680DgkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 085/139] ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref
Date: Wed, 21 Jan 2026 19:15:33 +0100
Message-ID: <20260121181414.517944302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yang Erkun <yangerkun@huawei.com>

commit d250bdf531d9cd4096fedbb9f172bb2ca660c868 upstream.

The error branch for ext4_xattr_inode_update_ref forget to release the
refcount for iloc.bh. Find this when review code.

Fixes: 57295e835408 ("ext4: guard against EA inode refcount underflow in xattr update")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20251213055706.3417529-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1037,6 +1037,7 @@ static int ext4_xattr_inode_update_ref(h
 		ext4_error_inode(ea_inode, __func__, __LINE__, 0,
 			"EA inode %lu ref wraparound: ref_count=%lld ref_change=%d",
 			ea_inode->i_ino, ref_count, ref_change);
+		brelse(iloc.bh);
 		ret = -EFSCORRUPTED;
 		goto out;
 	}


