Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A7169D09;
	Wed, 21 Feb 2024 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521290; cv=none; b=UwKDqq9YZsBO2EPwuo+ARGpQ5XSpimk0Z18TwYHNI+es6I7WJ0FHbenATVVWgP3Xoddz91ZqjrXWkdHRyOPoe9sEUh6cQGYtOITMeuLbB4h2KyvqBDohZ7/Ip1kQ1Vmd7Y9SnT/PvxEqS52oHPj65uR2rkrE98RlH1Wk5Ze3RRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521290; c=relaxed/simple;
	bh=qOzdr7xwOGJw+lbDjlvkbhn4y6BmSaL/MeH+8W5qeb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjRL2ICna5uezxA47VWpkenuWp0DHzwdoUVwCdD2ROST/SGWtG2m8AVAidlGLB3cy8FaloKkDC1d688gDqwkSCaUxhwYEKiglU+MA2ncullqK8HOmEk9c8nCpsWe6ve7vV05zRJQMRopwwAUDe9Fk0elrl3EnCLBoOQ13mwf8u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCk6uOMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCk6uOMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F6C433F1;
	Wed, 21 Feb 2024 13:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521290;
	bh=qOzdr7xwOGJw+lbDjlvkbhn4y6BmSaL/MeH+8W5qeb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCk6uOMcKl2OMgKiciRl4AbPCa4EoUkZ+9bhN3zBebf97na9iKyH2IyciCbisecDu
	 N3h3GdGBbzonVNpf1Emh8p20cKgA4UBNOH7rxyAO7TQP+GvUMDXn+vit2G5Ci4uUnu
	 UhyRSpf26xGSLBtO8nTgmA3k1HC90skvA3QlnxP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/202] ext4: remove unnecessary check from alloc_flex_gd()
Date: Wed, 21 Feb 2024 14:06:14 +0100
Message-ID: <20240221125934.174464720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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
index 2d27d4e06f7b..d9a8742873c9 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -245,10 +245,7 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned int flexbg_size)
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



