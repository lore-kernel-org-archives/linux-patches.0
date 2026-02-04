Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC500271A9A;
	Wed,  4 Feb 2026 14:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216356; cv=none; b=PBtCmNwIjwML4ssB/QvqOzys+4iUp9XlGYbo7i6DpvoD0i6aGBDPlDzKxPFZ8TnkByjIntMryQlQ4NUSmY9koulMaE+bKdEbt+VUqUfJOGAaWphl17RcVrSGw6TRfCav/Cbf9qiKVlf3Ot3U9kLE3TJoNEyadGGK1x3c6hzFS9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216356; c=relaxed/simple;
	bh=OVYMUJsWl0iKhMAQFPNBg7IT5PHkF4tjhhoGLT2fAXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIIruT07tmFPLcVmVJaCo2ZpG91Ad1/CdAuR7WmeMI5g5L7FaHSYa5t5nYnQrDjLuq+SmeCGMmK9CqLPWdVfFoWrd7iAMyM+bnBZuXHWynNEUpssK0DZtmPvi9GjsRz3typRYRYQNWKxDfP+0cxTEKveJ2EOvByZGWnwfE9IsGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rChSv89m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rChSv89m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1114EC4CEF7;
	Wed,  4 Feb 2026 14:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216355;
	bh=OVYMUJsWl0iKhMAQFPNBg7IT5PHkF4tjhhoGLT2fAXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rChSv89mBvyMHy0NjT9dYLqbvqC2h2mOK2EELRz/FJdZ0U4JUmHo6eFKQNr+krwiQ
	 4IHL9Kr0/MWBfvzBhHjsJn382IwmpcK/ZbM2CqJdDi/yIDY3gdoOJyo6tfvy6SrlvF
	 Q8wX40gpWb0xFbEVDXg1QUPaF0x5euwSWoseMRZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 029/161] ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref
Date: Wed,  4 Feb 2026 15:38:12 +0100
Message-ID: <20260204143852.809345602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -980,6 +980,7 @@ static int ext4_xattr_inode_update_ref(h
 		ext4_error_inode(ea_inode, __func__, __LINE__, 0,
 			"EA inode %lu ref wraparound: ref_count=%lld ref_change=%d",
 			ea_inode->i_ino, ref_count, ref_change);
+		brelse(iloc.bh);
 		ret = -EFSCORRUPTED;
 		goto out;
 	}


