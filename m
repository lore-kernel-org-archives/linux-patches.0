Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFAF1CFEB3;
	Wed,  2 Oct 2024 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878885; cv=none; b=P78NtYOLT8/3qhyaoc3tBB3mxKt533mldeuWooicLcp/y1m5LFUZ/LcV2BtxxjzZ3PetTYjZgWZFketyuesPtWSOkvejiHyVV0FOTvDQadeJcVHHcmuBySgVZQF8FKW2P7rwxpGbeAdJFw87EmxC5k+6LTvm7DijH1nnFnZTx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878885; c=relaxed/simple;
	bh=Lx/muTC264hC1OWk8xVExKOsLoKpb0R+tVdyVLikRa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRQI/OJ7jlMHm2djuYlXZBD5sa7y+ZXji1KKa5HVy3zMLqYj4Kl8XTAqry0Pytxz7TYJsv8vYjzVAVckep/JNxKdWA6Ua7vzzH85pTml9U+hupo8I5YMPTbuRzJ//FYfyNImCZxc2K2EentGRiqVmpOaEJ7EPlbRhKgrBxsJHeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeXkL+Xt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeXkL+Xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA2DC4CEC5;
	Wed,  2 Oct 2024 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878885;
	bh=Lx/muTC264hC1OWk8xVExKOsLoKpb0R+tVdyVLikRa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeXkL+XtCHnLZGdocyz4GyEYtOLu5mEzv1XNSt6dtTo4ySLvZfzTFINlXzQTMN5oc
	 syoxlmt2ZJI9OXTyAufbmaz1D+6FxeHM9qNskCPcOtQPxOcF9pINcV/Afx5s9W5aki
	 gvkAyZYaF7XW+W5bcamMeFSYljHDCAquItCB6Z8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.10 565/634] f2fs: fix to check atomic_file in f2fs ioctl interfaces
Date: Wed,  2 Oct 2024 15:01:05 +0200
Message-ID: <20241002125833.417519660@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2704,7 +2704,8 @@ static int f2fs_defragment_range(struct
 				(range->start + range->len) >> PAGE_SHIFT,
 				DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) ||
+		f2fs_is_atomic_file(inode)) {
 		err = -EINVAL;
 		goto unlock_out;
 	}
@@ -2937,6 +2938,11 @@ static int f2fs_move_file_range(struct f
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
@@ -3320,6 +3326,11 @@ static int f2fs_ioc_set_pin_file(struct
 
 	inode_lock(inode);
 
+	if (f2fs_is_atomic_file(inode)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!pin) {
 		clear_inode_flag(inode, FI_PIN_FILE);
 		f2fs_i_gc_failures_write(inode, 0);


