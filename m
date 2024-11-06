Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A751922DB;
	Wed,  6 Nov 2024 12:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895353; cv=none; b=HDebIV+oMnFfPVSiV29WCwse3IA0TaEFXyY4/IWqOc6sEGHwD36c3BzqSWorTN05sPDo9ll9dfPzRKPPRypCkoLvkF3OEsgjl01bTqxaKtHbjniOkWMZveTi8Q+4uXVx/r2VbC7/eZvij4PVNIA51Lm6JnUgWSOo/rGD5X3/aIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895353; c=relaxed/simple;
	bh=AS81y26eVlgUsmw5W3S6/JDgeA5vsXbvMMD4+BQ8zig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idzNMokmYa5aTF2h32CsUnNrvkBqj5pnvnsFs8ICelVy6+Zs5XlubmL3r3/CGwT8ff59+wulEl3a8evhfOcYrBz1azI67c9iNNdgk2QeXdisMR6QVm5YwO4aZ1lOTsaKyWfuDoB2jsEHcxORajh5wEj0AN3Y+CMXzOWI6uqEoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOBpcdQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOBpcdQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBA0C4CECD;
	Wed,  6 Nov 2024 12:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895353;
	bh=AS81y26eVlgUsmw5W3S6/JDgeA5vsXbvMMD4+BQ8zig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOBpcdQw7w15S1O8dZf8zN+xBRUl3j+WstkHGwDTYf6dqeJaDLML2KDbmaKh5Wl9f
	 YtIvOwzm6RNqb6WinjlZL7HDz5o7HPwTF8Y076sw6qippjL8bAB73A7eHOquEIFZV+
	 23NaSTHJBnIkA9LeB4cmG3nnKEKGQsSj+ju/JtDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 189/350] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Wed,  6 Nov 2024 13:01:57 +0100
Message-ID: <20241106120325.626148095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

commit 369c944ed1d7c3fb7b35f24e4735761153afe7b3 upstream.

Even though ext4_find_extent() returns an error, ext4_insert_range() still
returns 0. This may confuse the user as to why fallocate returns success,
but the contents of the file are not as expected. So propagate the error
returned by ext4_find_extent() to avoid inconsistencies.

Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-11-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5731,6 +5731,7 @@ int ext4_insert_range(struct inode *inod
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


