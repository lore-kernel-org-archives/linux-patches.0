Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467091AAE1D;
	Mon, 14 Oct 2024 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918578; cv=none; b=afJzuD9yLUTfh68YDr32jh6zak3LgUPZnGrx6B3xHaLQc4DbRw2HoVFgQbJ+men8ulecnXE3EqFY4bMOJ6g7PLszv3hncXL6XlNbo+RgBNeg2rvXmt+QYnHtDTJk3uFc+JsFS0ETtf7Rxce/WClK71QqgpYyiqsueYsVILJRy24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918578; c=relaxed/simple;
	bh=ptd83lK5PUtWxxA7iHNNsh2E/mqMn22dWvdN+BTdisM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3fMTSHuSt7LIwBUvBidrvmDi02V1TSc3d0WeXQaY9rigOCR9VxDgvXaPEOu1IYAbubye97pLz0PVLXbA+HI2AC6zDM7J6Ui4bxQY0oWVQMmGh+mFukOaStQ1oRQC/VPKTCQ7HkpZXQx/+xqvB1pSYxusvzq6yg6WH3W3hLKkGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu4A7nVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu4A7nVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B673C4CEC7;
	Mon, 14 Oct 2024 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918577;
	bh=ptd83lK5PUtWxxA7iHNNsh2E/mqMn22dWvdN+BTdisM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hu4A7nVwHOWohBxHa+gh02NxA8BphCgVez/ucQhIyni9tLseVWJrMYr4VNxcNXqnG
	 8Wfv5jEyB8MuvjK1KIp8D+h1f2R7SnOG4PdalXoFqnnAEw2oKVQg/5JKXZM2xNvKtV
	 s7t3bnPYsU5Gd5CVKv7jsit8+lbujcrp32ZrP0bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 330/798] f2fs: fix to check atomic_file in f2fs ioctl interfaces
Date: Mon, 14 Oct 2024 16:14:44 +0200
Message-ID: <20241014141230.915581870@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -2648,7 +2648,8 @@ static int f2fs_defragment_range(struct
 
 	inode_lock(inode);
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) ||
+		f2fs_is_atomic_file(inode)) {
 		err = -EINVAL;
 		goto unlock_out;
 	}
@@ -2878,6 +2879,11 @@ static int f2fs_move_file_range(struct f
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
@@ -3249,6 +3255,11 @@ static int f2fs_ioc_set_pin_file(struct
 
 	inode_lock(inode);
 
+	if (f2fs_is_atomic_file(inode)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!pin) {
 		clear_inode_flag(inode, FI_PIN_FILE);
 		f2fs_i_gc_failures_write(inode, 0);


