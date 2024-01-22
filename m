Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC79130E2B;
	Tue, 23 Jan 2024 00:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968090; cv=none; b=ISt/HeihVCrlaK854SyxTdLcaApBmGvbl6PEGpDfNzhDVhthZpVbspVk6uiEnrPVBBwqR5bmS+sl4F1p56mih9/dfbIYLO/w5OFxYyF0YQ93/1S9reYbSP4Y0FXMdOtibEYs9BOEc5xnPWixXpZTP+kpH/4Nn+Z5sKsxQUe5zOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968090; c=relaxed/simple;
	bh=FQ0Seh4IFclKNQIrt4jxR5RENdiZ+VGOIedcVhvHs1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlarWPgTXVT/P8vLjPRqXIco+njQ8gzyEwovU7cWlzMT5ku95qkO+B2Q4/Wp2zvQ9eQ+rI4pZW2oCs399s0MtNiL+wdBpQPlzRZhiKY1I5MGsqwG3mB3Rg4aZac32JZXPkOU+UUl9hhpBWCv5THqlr5Ze23Os3KjFmiyOtmK2Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgogFwXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgogFwXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3851DC433F1;
	Tue, 23 Jan 2024 00:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968090;
	bh=FQ0Seh4IFclKNQIrt4jxR5RENdiZ+VGOIedcVhvHs1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgogFwXXQ43rZhBxcX9I9pFeEA58c5GVRlSBhFhFU4QdwGrwczXC/zGIi+CG/8Uc/
	 vAje4ghYqBeDRY9zdV6OQoJtk4uoBS5d4Jx/YkfUT8UcNpPmuOLfgsli9yGtRYw9Gz
	 8OtfbbC1gTEI6SycmIdf0JeNxIeEYuysFsu06VzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.19 001/148] f2fs: explicitly null-terminate the xattr list
Date: Mon, 22 Jan 2024 15:55:57 -0800
Message-ID: <20240122235712.492047719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

commit e26b6d39270f5eab0087453d9b544189a38c8564 upstream.

When setting an xattr, explicitly null-terminate the xattr list.  This
eliminates the fragile assumption that the unused xattr space is always
zeroed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -717,6 +717,12 @@ static int __f2fs_setxattr(struct inode
 		memcpy(pval, value, size);
 		last->e_value_size = cpu_to_le16(size);
 		new_hsize += newsize;
+		/*
+		 * Explicitly add the null terminator.  The unused xattr space
+		 * is supposed to always be zeroed, which would make this
+		 * unnecessary, but don't depend on that.
+		 */
+		*(u32 *)((u8 *)last + newsize) = 0;
 	}
 
 	error = write_all_xattrs(inode, new_hsize, base_addr, ipage);


