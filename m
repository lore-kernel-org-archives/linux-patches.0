Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C3217B421;
	Wed,  2 Oct 2024 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877012; cv=none; b=ZX7reehbHxUPFrg7ej41XSG1sLRalB6nKNTvDC8yRkp/gX2QLOxUmjl7twcEGoQZj+5Fsz+AvN6ZMGefqBUwI3+z71j2uullzRnLIkjzbFMMed97qChfZLz1MYihbDGbmSiACjsKIm/yfUAImSpsooNALkHuBG72xj/oIBx/o74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877012; c=relaxed/simple;
	bh=8GYFYpKeVzxLpinNGQzlr/g1vYD+KpWfM2zJBClV9BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/HphuR4Xz21WqKe8svtpYRg+8xn5AYCwjWgpgrG03HcWBxUWYKkmB//Rn8ijYsNugvwR4BaUtE/GCWBNIsZy30+aq0dpuet000KVFsiU98psFr10eIeH6Aq1gMAFDrJILQIviPYpcVmVD/se+bO7hYLLvSVGps7pBasMrW67zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIm37ju1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIm37ju1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E05DC4CEC2;
	Wed,  2 Oct 2024 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877012;
	bh=8GYFYpKeVzxLpinNGQzlr/g1vYD+KpWfM2zJBClV9BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIm37ju1zBld6h/FCilu6rltHxTNVt8f59hdNr6an/R/g3bH1gnVECUZwsXWBK2Im
	 8g2vM774EsSz3KgsNZc+wp9Y5hzXozq1BhN+rs7Ak2n4qz/JC80j8qmDupRxWqPRzX
	 AJvrSeBoT5MkGnfZNfLVG/zwAuMlGDQx8kxUsS+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 635/695] f2fs: fix to check atomic_file in f2fs ioctl interfaces
Date: Wed,  2 Oct 2024 15:00:33 +0200
Message-ID: <20241002125847.862699771@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
@@ -2716,7 +2716,8 @@ static int f2fs_defragment_range(struct
 				(range->start + range->len) >> PAGE_SHIFT,
 				DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) ||
+		f2fs_is_atomic_file(inode)) {
 		err = -EINVAL;
 		goto unlock_out;
 	}
@@ -2949,6 +2950,11 @@ static int f2fs_move_file_range(struct f
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
@@ -3332,6 +3338,11 @@ static int f2fs_ioc_set_pin_file(struct
 
 	inode_lock(inode);
 
+	if (f2fs_is_atomic_file(inode)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!pin) {
 		clear_inode_flag(inode, FI_PIN_FILE);
 		f2fs_i_gc_failures_write(inode, 0);


