Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228DE8837;
	Mon, 28 Oct 2024 06:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098350; cv=none; b=IsuYqniUx+o+lIeFfI2flQmVosAQcaVVV8uiU9YlN63Mc2eml/0/TQdk9cRD/vvkv4aqEn/8QDrAzg7Qh8ynBStXBjoIviyD29/jGqlNlwSlXwCzxkMNuPZSDJBywQwrniIBVWRHqcTXTpiJEvHdRzFS3roI3lW1oSoBdgtnurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098350; c=relaxed/simple;
	bh=GpRBEA1O2vf3ENXSk+nCz75FcHCZToOlB0TF3Llb/Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+HI4k6VBluhlOBk1Icy0b8mYLSUwuVo8bKLiGCi+pMJQiwraxFp451KBrQhHaBje3He3YoEjZjog8kYadBFjQi8nhU/x7Ia3+4dHQoNg32d0uFTijqCM4gPmML8qoYRkfL43dF5Z/KjXIAXqaqS8pk2R2txuPXauM8ZKQlDzGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuJVdlWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuJVdlWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42B8C4CEC3;
	Mon, 28 Oct 2024 06:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098350;
	bh=GpRBEA1O2vf3ENXSk+nCz75FcHCZToOlB0TF3Llb/Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuJVdlWU+vXy0/4xG6TzcGn50Kcdmao8stR1LQ6izQx0/ItnjgbRlWMBcgVb3hhUl
	 YiIQ7udoPiKDMrqd9B1iJ/eaI7fBANOaBrocXhNNW/vOuaof60yYkCrth1Zu1UqWir
	 tiIOhSicaTJ1ahypU1eSkmDMrIUVPH5RFEzh81ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangyun <yangyun50@huawei.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 189/261] fuse: update inode size after extending passthrough write
Date: Mon, 28 Oct 2024 07:25:31 +0100
Message-ID: <20241028062316.757921708@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 20121d3f58f06e977ca43eb6efe1fb23b1d2f6d9 ]

yangyun reported that libfuse test test_copy_file_range() copies zero
bytes from a newly written file when fuse passthrough is enabled.

The reason is that extending passthrough write is not updating the fuse
inode size and when vfs_copy_file_range() observes a zero size inode,
it returns without calling the filesystem copy_file_range() method.

Fix this by adjusting the fuse inode size after an extending passthrough
write.

This does not provide cache coherency of fuse inode attributes and
backing inode attributes, but it should prevent situations where fuse
inode size is too small, causing read/copy to be wrongly shortened.

Reported-by: yangyun <yangyun50@huawei.com>
Closes: https://github.com/libfuse/libfuse/issues/1048
Fixes: 57e1176e6086 ("fuse: implement read/write passthrough")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/passthrough.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index f0f87d1c9a945..d1b570d39501c 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -22,7 +22,7 @@ static void fuse_passthrough_end_write(struct file *file, loff_t pos, ssize_t re
 {
 	struct inode *inode = file_inode(file);
 
-	fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
+	fuse_write_update_attr(inode, pos, ret);
 }
 
 ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *iter)
-- 
2.43.0



