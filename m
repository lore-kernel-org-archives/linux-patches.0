Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE56334392;
	Tue, 26 Aug 2025 11:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207134; cv=none; b=hL91UWYEJjeY/BmriyyHLLaTsQw6aRCQl9tu5T/uTpg7VK08fzvvSHZM19Tbnt5O/w4DtGMkbs1ifV3V6xYWt6lnjmdWUFkd/Og92g4G5OMRzJlBOb+BC91eNmbLZ5/o4oVT9SDlxgnze0A+55GgOsrdCJ7SCfI11cePt9RiyyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207134; c=relaxed/simple;
	bh=AmTCbfkbA49drqTDcg0YAKzrqrq4579xIpc+c/yp0dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIKZVK+noBuZlofaQuA3SVG5GRc1vpeKo57oCr+22c8T+pjhqEwDGv80gvpNo06wV5pg9bXBZ/OiQRaFBe0blw+qdjmYr9XlMO4cttjcu7FBk+WV7IQ/tVDSlKHsFoyH8Tp7lePsD4AXdMpL679W/aoaFvs/9RCUNjewrBKfHdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKyBOKbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKyBOKbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DCDC4CEF1;
	Tue, 26 Aug 2025 11:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207134;
	bh=AmTCbfkbA49drqTDcg0YAKzrqrq4579xIpc+c/yp0dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKyBOKbpT3WgtKMzaSVXp/qMg9rVgMY4wgSp4v05/TxNektOibRXA5WsG7gXOyvca
	 SQis3pXNolMsH4GWxI/D6dbWC7xWmHIToK3OyaV9tBEj8jWH4IjKxqLpj+XY0TM0vK
	 Q5ON9hDEJp/8sCCib3G/9llYpmv8RkX4qMpU3NY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kyoji Ogasawara <sawara04.o@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 046/457] btrfs: restore mount option info messages during mount
Date: Tue, 26 Aug 2025 13:05:30 +0200
Message-ID: <20250826110938.485504608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyoji Ogasawara <sawara04.o@gmail.com>

commit b435ab556bea875c088485f271ef2709ca1d75f5 upstream.

After the fsconfig migration in 6.8, mount option info messages are no
longer displayed during mount operations because btrfs_emit_options() is
only called during remount, not during initial mount.

Fix this by calling btrfs_emit_options() in btrfs_fill_super() after
open_ctree() succeeds. Additionally, prevent log duplication by ensuring
btrfs_check_options() handles validation with warn-level and err-level
messages, while btrfs_emit_options() provides info-level messages.

Fixes: eddb1a433f26 ("btrfs: add reconfigure callback for fs_context")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Kyoji Ogasawara <sawara04.o@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -88,6 +88,9 @@ struct btrfs_fs_context {
 	refcount_t refs;
 };
 
+static void btrfs_emit_options(struct btrfs_fs_info *info,
+			       struct btrfs_fs_context *old);
+
 enum {
 	Opt_acl,
 	Opt_clear_cache,
@@ -689,12 +692,9 @@ bool btrfs_check_options(const struct bt
 
 	if (!test_bit(BTRFS_FS_STATE_REMOUNTING, &info->fs_state)) {
 		if (btrfs_raw_test_opt(*mount_opt, SPACE_CACHE)) {
-			btrfs_info(info, "disk space caching is enabled");
 			btrfs_warn(info,
 "space cache v1 is being deprecated and will be removed in a future release, please use -o space_cache=v2");
 		}
-		if (btrfs_raw_test_opt(*mount_opt, FREE_SPACE_TREE))
-			btrfs_info(info, "using free-space-tree");
 	}
 
 	return ret;
@@ -971,6 +971,8 @@ static int btrfs_fill_super(struct super
 		return err;
 	}
 
+	btrfs_emit_options(fs_info, NULL);
+
 	inode = btrfs_iget(BTRFS_FIRST_FREE_OBJECTID, fs_info->fs_root);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);


