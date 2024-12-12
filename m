Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C3C222D42;
	Thu, 12 Dec 2024 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020043; cv=none; b=VRKqMpLZruEZwW2qaVgFH4M9gzNaijug+yx93iyiX+cK6CrPC0LvDqu6ZRLYkOa8b5nzrUbwxQuAF6jTn6hw0EeYxSiyj7NexHh6NzzzDqgf7MUBJGJOSy8BMSPi9lYMSsJFdIaoOX/tH5a3Py/b0d36QlEgPyGswVMZx4Um6Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020043; c=relaxed/simple;
	bh=YANjzD71qaSvARY7FwoUPa3m6XrR8lYNgHYuVFlN1YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVeVOoxk9iDsgHLzIOEbDMsJYV5hL4i3LI2qu9BsboiNZDvVZOzHwl4xrNR/Qn89j+m8HNZ912hW3CXmmW+Sp9ysCHXDbJDhBtwnOMJ6z7XiyLbl/SpUcQW2SPKm9RsHyYv9GGC7uUzs0LcG0I5dlkX2acAdphA7wuYaSNRRT9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGl/Qk4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGl/Qk4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C90C4CECE;
	Thu, 12 Dec 2024 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020043;
	bh=YANjzD71qaSvARY7FwoUPa3m6XrR8lYNgHYuVFlN1YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGl/Qk4UPYBreYmwaGZdj4FifFnQNIiaxA4jTeAQnk8+BhFbk2OVgQ6jMiksT+fku
	 1CcO1i7YpFj5mZTTUQp5AtdVdJ+cGK3Bq1F+4zNpvUnb0CEk6bZJnAQR9P6ubI3u+s
	 QbhD+nY6DZxsXMCzzl90N0hwEBnOPHFra+BlxETQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <ancowi69@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 6.1 364/772] jfs: xattr: check invalid xattr size more strictly
Date: Thu, 12 Dec 2024 15:55:09 +0100
Message-ID: <20241212144404.955183132@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <ancowi69@gmail.com>

commit d9f9d96136cba8fedd647d2c024342ce090133c2 upstream.

Commit 7c55b78818cf ("jfs: xattr: fix buffer overflow for invalid xattr")
also addresses this issue but it only fixes it for positive values, while
ea_size is an integer type and can take negative values, e.g. in case of
a corrupted filesystem. This still breaks validation and would overflow
because of implicit conversion from int to size_t in print_hex_dump().

Fix this issue by clamping the ea_size value instead.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Signed-off-by: Artem Sadovnikov <ancowi69@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -559,7 +559,7 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
-		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+		int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
 
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,


