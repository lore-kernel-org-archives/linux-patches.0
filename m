Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3630E156CA;
	Fri,  9 Jan 2026 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961646; cv=none; b=vGLmdhmTF3rik0xR3j5ysOAAzieWOpNgojcd4wHUpe9g5ub3Dmp/Hki5PdB7LJ+br6lounf1SYvMs/OJhcfyAzMk0AtBTDB19s88QmPgSxiMDg06R8XSdy632qW6n7LcCEi+0XYleKX7y2jaq9URBnj/pVKIkJjHDKhr3z29ie0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961646; c=relaxed/simple;
	bh=ukrWuhevP6XmMeIgU/1IeimDkaRR3X0zna277YwuQI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzXYZ2ATPgT1lMZD/xBcWg5qdnFXK4k1BQisHRq0n1N514OkyJBw1DIdet6UTen39YtBZqOgnXtjOh0XYZ1GAHa6mkqcy0E/tD7jKanPqlgMParV7aWdjPGrd6AY15uxAUr/QM5SBG1Y58gK6odilFLb0QD2Gd/e2O3vB6OLR0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peWyrhjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peWyrhjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B1BC19422;
	Fri,  9 Jan 2026 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961645;
	bh=ukrWuhevP6XmMeIgU/1IeimDkaRR3X0zna277YwuQI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peWyrhjZT1icIU9835fwjO1pwQA8g2R80Eaz8hlWIVpT9gEQrpZ4fn6OQlWhTruqb
	 zD/ypk9H6NU3UemFfOvuolN73aEkFPVGaHeO+POA4XJPltSMurqkRJskDVBhpnOFUV
	 Nsqz23PmTVi5UGabG8qI+/Jw4kQfm0sngvkLpKa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/634] ext4: correct the checking of quota files before moving extents
Date: Fri,  9 Jan 2026 12:36:04 +0100
Message-ID: <20260109112120.672724350@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit a2e5a3cea4b18f6e2575acc444a5e8cce1fc8260 ]

The move extent operation should return -EOPNOTSUPP if any of the inodes
is a quota inode, rather than requiring both to be quota inodes.

Fixes: 02749a4c2082 ("ext4: add ext4_is_quota_file()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251013015128.499308-2-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index e8ec213b21443..e01632462db9f 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -481,7 +481,7 @@ mext_check_arguments(struct inode *orig_inode,
 		return -ETXTBSY;
 	}
 
-	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
+	if (ext4_is_quota_file(orig_inode) || ext4_is_quota_file(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EOPNOTSUPP;
-- 
2.51.0



