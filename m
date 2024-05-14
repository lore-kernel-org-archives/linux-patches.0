Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7255C3B;
	Tue, 14 May 2024 10:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682519; cv=none; b=jNFuDKQgkF0SpfNH0OoCkLl/vkHcO9Cto4/Cql3IBuSO9sZTQf0jQnX+D/dzjvD3nOYYDigrbH+AOk7LfUvzQg33Xv8gyeVbet7a1o3/zbB0KJc2i6gVz/+eO0ujsnzvACogu0OFTPohRNtQKeBMzY1yRJ6DldbZbZ32H+z1gus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682519; c=relaxed/simple;
	bh=UMZvd7fWUb1HJ7vQN0J9alq6fxHRqizvCWeENAwE8iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzhhJ4A7Cbalt8lY/CzjizapYqn7YjzZZzFX17uL40aDDAJS4d+0EJhgkWmhAV0r03I3zC7L1vPamnPLpOHFfRerAmPPvhHRUd7clt/sWYjdJ7NVAvHQRv0hjdlKoJDyW2FozG9G1cCDotDIgUcCEEWBx/4TJjVPgB2gvCDwz6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4kml1G2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4kml1G2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF27CC2BD10;
	Tue, 14 May 2024 10:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682518;
	bh=UMZvd7fWUb1HJ7vQN0J9alq6fxHRqizvCWeENAwE8iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4kml1G2Z9yxHoukiPG4mUXtPw+KzapR8VGvonBZ8nqunfmhtks0p77DzGPx5nRRa
	 XmuBiDIEkcvXtbo8K1J/LfDPZmXS9wodJZTUf3GAVvJzsqo/ykcsH2m7V+ai4GT4e8
	 X5d+QfgqU+gFQQMHGBtCbIiL10OOe+k8H/Kt+Ejs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 044/336] bna: ensure the copied buf is NUL terminated
Date: Tue, 14 May 2024 12:14:08 +0200
Message-ID: <20240514101040.272244997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 8c34096c7fdf272fd4c0c37fe411cd2e3ed0ee9f ]

Currently, we allocate a nbytes-sized kernel buffer and copy nbytes from
userspace to that buffer. Later, we use sscanf on this buffer but we don't
ensure that the string is terminated inside the buffer, this can lead to
OOB read when using sscanf. Fix this issue by using memdup_user_nul
instead of memdup_user.

Fixes: 7afc5dbde091 ("bna: Add debugfs interface.")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-2-f1f1b53a10f4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
index 7246e13dd559f..97291bfbeea58 100644
--- a/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
+++ b/drivers/net/ethernet/brocade/bna/bnad_debugfs.c
@@ -312,7 +312,7 @@ bnad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	void *kern_buf;
 
 	/* Copy the user space buf */
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
@@ -372,7 +372,7 @@ bnad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	void *kern_buf;
 
 	/* Copy the user space buf */
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



