Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4222D8DA8;
	Wed,  4 Feb 2026 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217678; cv=none; b=QimZ73p0wDCcT5CVgF0WmquRVxagtVIxBj6Y/P3QlLHTCF67YJ/VmsqxohfKpShBIuj8jw/QQeeAFiPiD1shnjDv21O11LXhZxnQGCPZdLq7WKAEbg2xXowlLD9H+2Ymvlseu/JjnpVLEu2+9ww3mh+9YG0fF/0vyK/QAJrq/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217678; c=relaxed/simple;
	bh=sFr4lyX/xfgij5bWUEEwMVq2Bq6LnDCqNFx+BTaZHFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYHgG/KRxRkGm6t7yxYgYg2RBKhPzwgLTNiiHhCQHPe1z2thKvqcIM2aGsoyfZw12QptShZTZRIg+swYLA+XkNATUnxDapmXBlpccUFfbZqV6hVviudeD8nMVd9jPWrhlXhaws180kLL5EnIf0Wg/i383ixCAQVHgrFZkzXD24w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUSdcCDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUSdcCDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537F9C4CEF7;
	Wed,  4 Feb 2026 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217678;
	bh=sFr4lyX/xfgij5bWUEEwMVq2Bq6LnDCqNFx+BTaZHFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUSdcCDMlB5e55NJLhTtW1JyqmE3W/rmGiCTnymBlWmBhIOY1KK/JWtJq0pda/Yhf
	 XLLFhwuasFTTf+aNlsneGYAcrfx/5AvUZoG3463lOuYk5TvLWCSVgyoEExFU355480
	 0X2gmTNbiBxpho+EdWbV34lBEQkIJwzcGHGU4eew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 053/280] ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref
Date: Wed,  4 Feb 2026 15:37:07 +0100
Message-ID: <20260204143911.557469088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -984,6 +984,7 @@ static int ext4_xattr_inode_update_ref(h
 		ext4_error_inode(ea_inode, __func__, __LINE__, 0,
 			"EA inode %lu ref wraparound: ref_count=%lld ref_change=%d",
 			ea_inode->i_ino, ref_count, ref_change);
+		brelse(iloc.bh);
 		ret = -EFSCORRUPTED;
 		goto out;
 	}


