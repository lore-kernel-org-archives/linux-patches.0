Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4A75BAC9;
	Tue, 23 Jan 2024 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970819; cv=none; b=nlYFSDrGwE24gzVnAYq3KirS3aD8Cn9dPpwGQSLapMKAzCscaqnCEAuCaMY/kpQxsGZgMHnKbqJQw148tUFAhZbpgp5O4KV/+A0jYrNFnnnDNBCW90ShYB6mSA199rxGkI5EdkZr0EOf+LTe0JzcUslmv0GuelRo6w5fcUv44kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970819; c=relaxed/simple;
	bh=DIp90eRzznl3IuZcjHdVWDEjfK38SGGMX83KfNg+CUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4TheaJzVVWR21PgoyDN29sH9eXCOenltZ7pj6UYVlgfScUsCSWP/sH83XuBmw4Yzg86QpfrJa0F/abzT3f2qIAxjgRePTkHsSjMuIc/rdYpbaw3Xhjh5KVQhnZ6F0pslsClcKjKmOvSCRUxQTj+r1r9xCygUs3WCtT9+fsTUcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7PugRyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7PugRyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AC3C433C7;
	Tue, 23 Jan 2024 00:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970819;
	bh=DIp90eRzznl3IuZcjHdVWDEjfK38SGGMX83KfNg+CUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7PugRyMSABITQNwdH6YbqLuOMU16HBVAYlwVXJRuREeVkms1taezcr6oBU6atL/z
	 +wnzUdryuSsgAgFiWmON3DbonaIWuYX3BJ0PfCcM4rejggizzx/tg4aWhQLTU83abU
	 ZrVuLYPFYFuJUpjlxkb0N5xxGSNEk525aU61U6uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 001/286] f2fs: explicitly null-terminate the xattr list
Date: Mon, 22 Jan 2024 15:55:07 -0800
Message-ID: <20240122235732.056543308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -741,6 +741,12 @@ static int __f2fs_setxattr(struct inode
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


