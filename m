Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403C3383;
	Thu, 30 Jan 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246598; cv=none; b=UOfU9AkCrStJ+IBzgb6i24hWU6pdEVgK2Khj6/ir+AsPde9o+QtARlK4uRr9C7mpVIhOkew0L7rn5XoTSyHvdTO7F/wXM4dUxKaPWD5kjETsIH2+CCT2/GJxc6mZZrUtjSzn020/SlgjpMnHRIIksdrOPknRehFepB0P0V1ixVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246598; c=relaxed/simple;
	bh=zP/JlQgZJkNPQHU7Lo6xJqVwbYRWM4BbhtqctEKQKf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O88pfhQXXypcn5VwcPOh3P6vBwcKcWeP/w+Yb36iI2JVNbboGMLYbKzSovV5zmikRJ8pLQuomj+Q+wrTYprtTb0xXex/spQKu6Fr8X1GgxeA9xGJlsPWlTvm8sWtd1+6zppiZ93zgnoqrZ9DYwGc1nOxClZqCcDEgm2xpF0HGOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXBboroA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXBboroA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDC0C4CED2;
	Thu, 30 Jan 2025 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246598;
	bh=zP/JlQgZJkNPQHU7Lo6xJqVwbYRWM4BbhtqctEKQKf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXBboroAUBu5oayxsCLD+fqHORPshG2SwG5Sn6CPwBA/IBMiGAs1hvZps4fPh4m8W
	 tdmGFgvpBONgGKtbO7QhVYXP5qAhDhDyxKqZFcusEsUEUQSHjOCOdozxBXPWQ9iykf
	 IKOJgpGkhC0mR0mhTKfhouuk/pjHHj3HxiT+6aEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 20/43] shmem: Fix shmem_rename2()
Date: Thu, 30 Jan 2025 14:59:27 +0100
Message-ID: <20250130133459.715321846@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ad191eb6d6942bb835a0b20b647f7c53c1d99ca4 ]

When renaming onto an existing directory entry, user space expects
the replacement entry to have the same directory offset as the
original one.

Link: https://gitlab.alpinelinux.org/alpine/aports/-/issues/15966
Fixes: a2e459555c5f ("shmem: stable directory offsets")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20240415152057.4605-4-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -365,6 +365,9 @@ int simple_offset_empty(struct dentry *d
  *
  * Caller provides appropriate serialization.
  *
+ * User space expects the directory offset value of the replaced
+ * (new) directory entry to be unchanged after a rename.
+ *
  * Returns zero on success, a negative errno value on failure.
  */
 int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
@@ -372,8 +375,14 @@ int simple_offset_rename(struct inode *o
 {
 	struct offset_ctx *old_ctx = old_dir->i_op->get_offset_ctx(old_dir);
 	struct offset_ctx *new_ctx = new_dir->i_op->get_offset_ctx(new_dir);
+	long new_offset = dentry2offset(new_dentry);
 
 	simple_offset_remove(old_ctx, old_dentry);
+
+	if (new_offset) {
+		offset_set(new_dentry, 0);
+		return simple_offset_replace(new_ctx, old_dentry, new_offset);
+	}
 	return simple_offset_add(new_ctx, old_dentry);
 }
 


