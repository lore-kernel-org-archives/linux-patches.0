Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C463B223DD0;
	Mon, 23 Jun 2025 22:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716793; cv=none; b=ZJi/bjX1TjdjtTQ5F9vJvQGhRaxuYALDhBeV0w0Kv1r0G+rNJJSz9bffH6/bvp16D/xHGlHRTb6Cl2/LOK9FUtJJfjqOFNFGaYPxDKOP3wFGgRk8sIldwCAW0yKgl6WvCQF/Vp6gitxifYQ89YEFCw0FWUwPca9YU85R+VMRIP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716793; c=relaxed/simple;
	bh=RjrSo28YDP9qwvrzZO2G1KAzm2VtaJcxaL97Yyvruic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNPOwzcypF7K57xgoO7jgjJcbBtYmAipIaAN0my1MvevF9F6nkk5P4vtFH1rw1GzG1AXRPiJ4iDXjzVQ5xFJgVVVKLplAycZzc31GoNUf7ZNDEJ1E9yJsKiZPa7xkxjWAsVcp2aMw5tLwLDk8XSieesy9McVRYHCgPGyXFIhE8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Snvc0ET4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Snvc0ET4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB3C4CEED;
	Mon, 23 Jun 2025 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716793;
	bh=RjrSo28YDP9qwvrzZO2G1KAzm2VtaJcxaL97Yyvruic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snvc0ET4emm/V3ilT/1qDhQH9hff0ujO4Sot7UTUXrZZUM2Q1xSY2q0I72gAH/p6y
	 aHJHVGzYEVSvBmE/VfCBcVTLlMzjDg0M0kolq55jIuXEH1j17RMQmZUsiIZ4ZmSNmT
	 1d1vmW3wS9Xm9zPF0j8b/JQL27iSsLbwoyiqw+r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 337/508] ext4: ensure i_size is smaller than maxbytes
Date: Mon, 23 Jun 2025 15:06:22 +0200
Message-ID: <20250623130653.624616797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 1a77a028a392fab66dd637cdfac3f888450d00af upstream.

The inode i_size cannot be larger than maxbytes, check it while loading
inode from the disk.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250506012009.3896990-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4968,7 +4968,8 @@ struct inode *__ext4_iget(struct super_b
 		ei->i_file_acl |=
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(sb, raw_inode);
-	if ((size = i_size_read(inode)) < 0) {
+	size = i_size_read(inode);
+	if (size < 0 || size > ext4_get_maxbytes(inode)) {
 		ext4_error_inode(inode, function, line, 0,
 				 "iget: bad i_size value: %lld", size);
 		ret = -EFSCORRUPTED;


