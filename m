Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686641EB21;
	Wed,  2 Oct 2024 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880460; cv=none; b=HJkfbR2lhgrDfGyeW+9t0oocLNy0BwVpuc1C6283/A9QqIxF6xZCE6ZT6bOXL8SiVr2CE1n7/1oUF8/CqbBLu70rxrCtvfLBYqH39SZmvy4h9xvaeUk+DgBIB80XmL6HZ8IQA0Qz2yF388V5wb282BVMdzAbb++xdynnp6YCeoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880460; c=relaxed/simple;
	bh=XeFO4nsodZNKqGTqfwasz/CkKYVwXpwcKOkZHe2yp9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBRs7y9ltvX89OjjuCH5SCqNTTbMGSJpFK8eJyAEqUYgtwCRivHsXZnQQy2zFpV9K2MILimAHp3CgOfPeGwsSFOjNBKuCaQinQe1J6h5om5tCQP+Db3GcoQeqU28sSvYFCLj6TPoBY6nqyaZ/5xugeOkcDICvIae+yjG0Uj94BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAq2efyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAq2efyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B347AC4CEC2;
	Wed,  2 Oct 2024 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880460;
	bh=XeFO4nsodZNKqGTqfwasz/CkKYVwXpwcKOkZHe2yp9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAq2efyXhMpFO0GC0ByGUXAcuD9qDgxqHko5/wvzQKFFZuLiS4EKegn1hr/OnpESG
	 1xapvbGtG/Pnqxrkbp37jCAgKPy689dj3YtayD+/6+znRtLwAEd11NkDzV5lBw5FhC
	 NYZmkUXkrdvGs/iXpRHOvmo/QK6dntivywxsrxM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 465/538] f2fs: fix to check atomic_file in f2fs ioctl interfaces
Date: Wed,  2 Oct 2024 15:01:44 +0200
Message-ID: <20241002125810.799266210@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit bfe5c02654261bfb8bd9cb174a67f3279ea99e58 upstream.

Some f2fs ioctl interfaces like f2fs_ioc_set_pin_file(),
f2fs_move_file_range(), and f2fs_defragment_range() missed to
check atomic_write status, which may cause potential race issue,
fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2673,7 +2673,8 @@ static int f2fs_defragment_range(struct
 
 	inode_lock(inode);
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) ||
+		f2fs_is_atomic_file(inode)) {
 		err = -EINVAL;
 		goto unlock_out;
 	}
@@ -2904,6 +2905,11 @@ static int f2fs_move_file_range(struct f
 		goto out_unlock;
 	}
 
+	if (f2fs_is_atomic_file(src) || f2fs_is_atomic_file(dst)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	ret = -EINVAL;
 	if (pos_in + len > src->i_size || pos_in + len < pos_in)
 		goto out_unlock;
@@ -3288,6 +3294,11 @@ static int f2fs_ioc_set_pin_file(struct
 
 	inode_lock(inode);
 
+	if (f2fs_is_atomic_file(inode)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!pin) {
 		clear_inode_flag(inode, FI_PIN_FILE);
 		f2fs_i_gc_failures_write(inode, 0);


