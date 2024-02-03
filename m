Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A8C1426C;
	Sat,  3 Feb 2024 04:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933781; cv=none; b=BU4FzcuEgRfaE4L4HSevCmro8Q9YogL/VX0c57kPPZQwSe/KfMzHCmSfedUjo9zqeLx1Xjy8p4wtoKXz0IXsRasuv8I7EPqNcrXHM1qfyiblrVz7dySk9Yp3pd4THgWHc41yQcnDnsGGXKH5Xs15ymI5B2iyBR/31EW80lO9PZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933781; c=relaxed/simple;
	bh=g4OD4mT6Og/j4a0qCnK0hJXDLEvHO+H35b6matCVqp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZsnkB7XLzDI63G+qthAlZoa+2Kbj5iugK3b5mxk/svK6EW59H9CHDu8qE5ssoohEJQZ8UjcHwSyXpuBZGKEgD2XS0FApRiPL8wRCY9RDo8V2no3uxvbV37nxVobbzdpGAf6LJNhZTdd0bauYbxqKjWTWRnKfdEawFc01Y4NhQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWGlIU5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWGlIU5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A32BC43390;
	Sat,  3 Feb 2024 04:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933781;
	bh=g4OD4mT6Og/j4a0qCnK0hJXDLEvHO+H35b6matCVqp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWGlIU5MnatGdzv1zBb9SI+BSg/uCF4+Qgq0dzosvQkRw/I0XLp258ei8uerYTutZ
	 bqAs7uBOma4d/hFBC2wqTDiQyM4ooDhm9x7+lqaoIuPgfTlHFvDGMNgVx7k/QGZj67
	 Zk+2TPMjD75LJXyeOFbgCpD4vgYA/i5XSmu7uJ88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 061/353] ext4: remove unnecessary check from alloc_flex_gd()
Date: Fri,  2 Feb 2024 20:02:59 -0800
Message-ID: <20240203035405.730668368@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit b099eb87de105cf07cad731ded6fb40b2675108b ]

In commit 967ac8af4475 ("ext4: fix potential integer overflow in
alloc_flex_gd()"), an overflow check is added to alloc_flex_gd() to
prevent the allocated memory from being smaller than expected due to
the overflow. However, after kmalloc() is replaced with kmalloc_array()
in commit 6da2ec56059c ("treewide: kmalloc() -> kmalloc_array()"), the
kmalloc_array() function has an overflow check, so the above problem
will not occur. Therefore, the extra check is removed.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231023013057.2117948-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 5d1935ac02ca ("ext4: avoid online resizing failures due to oversized flex bg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index c6d4539d4c1f..0a57b199883c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -236,10 +236,7 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned int flexbg_size)
 	if (flex_gd == NULL)
 		goto out3;
 
-	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_group_data))
-		goto out2;
 	flex_gd->count = flexbg_size;
-
 	flex_gd->groups = kmalloc_array(flexbg_size,
 					sizeof(struct ext4_new_group_data),
 					GFP_NOFS);
-- 
2.43.0



