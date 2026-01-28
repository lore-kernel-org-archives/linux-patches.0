Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292BF356A37;
	Wed, 28 Jan 2026 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614191; cv=none; b=ce9XJ7TghxKNHYYJNwpg7H/d51EHX9qgjXgDal1JN1MtFMrjjo50p5MXg5zGOUo0jPoRzeUJF7qrgl+GM2J/vp3c41+/uSe+G3D+mWrtu09IknyXM03q8oWKCrZK7neD10e2rvQ7tTSsWk+qNtzIjlMFyU9itoMh8coyoz75vtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614191; c=relaxed/simple;
	bh=SViMBG0rL85SURIlplZSb96BatWYzBQIeBiZfWbKnjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQo+TPxi4K+prk0qi4ZpCpwDeZU5Xj3VxndPmw5B1SffByuCRjGJxXPmKSDZerfDTmcDT/3mnVrKVPzK7XcSHr6XhNuUTChrJ4SYs5E20yeAm9lZ0pZNwyXsW5dXv/XZwfOy0MZvtEOIlOZfbCTyylOSI2wXZMvI7LHUmi9VYVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROVnQ6yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROVnQ6yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932ACC116C6;
	Wed, 28 Jan 2026 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614191;
	bh=SViMBG0rL85SURIlplZSb96BatWYzBQIeBiZfWbKnjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROVnQ6ycIu4XeJxvdkMECv8hCWXolz1c4wHK7fydk9R0WIkNsTE71tTJu7UFXLHNX
	 NUsQKcLefZBOdrvob4AglOdN7AeRDo3/vcNbXCa90uTMcxPkGSst8mRPR7yUkHNZLt
	 qR180rhe4JlDKFBFVSPXv5D2q+n2/TChjifqahvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 062/254] ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref
Date: Wed, 28 Jan 2026 16:20:38 +0100
Message-ID: <20260128145346.932319028@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


