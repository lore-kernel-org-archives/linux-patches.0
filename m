Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08CBFBE4;
	Sat,  3 Feb 2024 04:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933363; cv=none; b=ALrqLq5dwiRHTcPhGcPHf3UfaX4JwoT4EKvnMepbTuQeeaWF1qo8+X/jzrpSoANtDbGw7+VNDt4CystDsxNpAiMOKsgAPsWNaK29WbRkUMwl/duAvT+a/WUhN23wBd7/idXu07matKTUNIkaq6LiyGiDJgybagHRj7iFzWJ49HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933363; c=relaxed/simple;
	bh=FrV22SFLRiTlYGGHRUpEMjnbrkv5PFpxCQ7A9spMRe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8C0dxWOle9iiZCOeeMiSQ16EeRb0nYpkpC8VE28cvvl5DgjDtD5ff/sdOQSV1rbypCwHM6le/Dti/6lIFRJV/vAXbRJdb/Gq4qAe39uAblzcLmzGCkiEonq4RYP3AxTH7KUptha6+7bfbpw5uPOWteZII5A9asB1r80eJmmEAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E94C/U09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E94C/U09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86D1C433C7;
	Sat,  3 Feb 2024 04:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933362;
	bh=FrV22SFLRiTlYGGHRUpEMjnbrkv5PFpxCQ7A9spMRe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E94C/U090tgPgE0/HVG8x0AAKOL0wCs6BfUsaxaH6l41UqtB6bDSBoF6aNrxhCmZZ
	 O4FQh6SiwIV8FfyiTh7FUnAG1uG16ovCRNuw/EpZMghVW2qTYjXaWPAJssenmuRDjd
	 sulBmLN+GJ5DbBer4G5nehzfM2R4wtIRGxyYsY7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/219] ext4: remove unnecessary check from alloc_flex_gd()
Date: Fri,  2 Feb 2024 20:03:36 -0800
Message-ID: <20240203035322.620006333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 31f5da7f9f6c..e76270ee7fe5 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -249,10 +249,7 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned int flexbg_size)
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



