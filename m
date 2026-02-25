Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF48D2F7478;
	Wed, 25 Feb 2026 06:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002779; cv=none; b=SeLtcRTeKLffi8HA8TN4fJwddGgJP7JDR95fa6w2AGFdxQMmih8kRR5YvBFUKrQLlFMgth73EtCb8kCQAMaOpzcgWi1rkgkgagbN0YsFZzFdK+ZEiTIxFUFcMMZPiVEyuZtJTTElaMIdYvQqXI3pxQ56MYAsBl2BnesNT4KmE/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002779; c=relaxed/simple;
	bh=GCVsxt0XYyQw+6IJ02gF0bHg805mT+4o4UTL532+B/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtuE4vnmuXMID+b4rgdesNqfwWB6LVtTG84NUbBNFSn362p7/Ev43q6zzUMwGFynFgb3uFtxh1TjNMMbyhvW5NPT+NUE7pTlEUZxSTZuDyeFK/naujqtRqJEzu3HNoBDx/HxJIb70CiTzQvz8diVSDbMM1YOZ027aPONfKJA88o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZebHeMSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZebHeMSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7417C116D0;
	Wed, 25 Feb 2026 06:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002778;
	bh=GCVsxt0XYyQw+6IJ02gF0bHg805mT+4o4UTL532+B/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZebHeMSgh4NnPiluINmsG6z+3VbszaKO2DU2JmfzSN5R/kKzFzZPYeT85NHS8QkUS
	 VvJwTpFcfjL6g7mrB5xv3Ct7t71laTjZRVOxbINuqLoAzyRnJpigYpMDxh4n4+DXlF
	 qqwOG3p5OwUII33uMomRGJ8sRHGuKSp9ZBlI8WXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 617/641] ext4: fix memory leak in ext4_ext_shift_extents()
Date: Tue, 24 Feb 2026 17:25:43 -0800
Message-ID: <20260225012403.459841436@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

commit ca81109d4a8f192dc1cbad4a1ee25246363c2833 upstream.

In ext4_ext_shift_extents(), if the extent is NULL in the while loop, the
function returns immediately without releasing the path obtained via
ext4_find_extent(), leading to a memory leak.

Fix this by jumping to the out label to ensure the path is properly
released.

Fixes: a18ed359bdddc ("ext4: always check ext4_ext_find_extent result")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20251225084800.905701-1-zilin@seu.edu.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5410,7 +5410,8 @@ again:
 		if (!extent) {
 			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
 					 (unsigned long) *iterator);
-			return -EFSCORRUPTED;
+			ret = -EFSCORRUPTED;
+			goto out;
 		}
 		if (SHIFT == SHIFT_LEFT && *iterator >
 		    le32_to_cpu(extent->ee_block)) {


