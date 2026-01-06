Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75645227BA4;
	Tue,  6 Jan 2026 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720364; cv=none; b=FPM0C0WOs+e9tlQOLN8JDyVCRS2O44hVPROas4QLqiMIKgWde7x9MlwcNR+Vlg/3rMkFZMO3akEGiSys+HPZgp2du52cWIjahP7NMIzm6yL9hPg2qPKFMMc9McTtsnoBudI3bGvzdqt8g35R8kmFxIoL/YX8ymnUs9v5wcewfSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720364; c=relaxed/simple;
	bh=CrxYyJgPYm8674ummJ+x3pr8vj9Ft4lqS1JQ4SmlR3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkpLehEnhpKlGlqf46ETgrLxXD1QivvPrdVRxwQCZxedTBgu7JUll4CVZDEkwIsFZp1ImSAst7xSVTk2tSx8dmYI+NmzovHows5U67qRU/Kge2V19y5yl9+HyGkdv3+eIKCZMNRMEvqCPzkBVrMRfnZBBnAV/vPHMjJLk9RwNz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOY39vUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOY39vUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC34CC116C6;
	Tue,  6 Jan 2026 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720364;
	bh=CrxYyJgPYm8674ummJ+x3pr8vj9Ft4lqS1JQ4SmlR3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOY39vUeuGkXp0Mf9tXeHLs1xcm+qJz/rTYOZD5trWEzffULHJTLFRj14LqXi6pMe
	 r9SaBg2aid4MVZpvc4fnBWunARmzAdDK7Vb0lkjXBilF1xKsbivP4FxPyVa1Whg5vx
	 lC9nKyYRgNP1qsBzUXlJ+PRPsfC/Moi05vfAersQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 171/567] ext4: align max orphan file size with e2fsprogs limit
Date: Tue,  6 Jan 2026 17:59:13 +0100
Message-ID: <20260106170457.652110080@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 7c11c56eb32eae96893eebafdbe3decadefe88ad upstream.

Kernel commit 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
limits the maximum supported orphan file size to 8 << 20.

However, in e2fsprogs, the orphan file size is set to 32–512 filesystem
blocks when creating a filesystem.

With 64k block size, formatting an ext4 fs >32G gives an orphan file bigger
than the kernel allows, so mount prints an error and fails:

    EXT4-fs (vdb): orphan file too big: 8650752
    EXT4-fs (vdb): mount failed

To prevent this issue and allow previously created 64KB filesystems to
mount, we updates the maximum allowed orphan file size in the kernel to
512 filesystem blocks.

Fixes: 0a6ce20c1564 ("ext4: verify orphan file size is not too big")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251120134233.2994147-1-libaokun@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/orphan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -8,6 +8,8 @@
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
+#define EXT4_MAX_ORPHAN_FILE_BLOCKS 512
+
 static int ext4_orphan_file_add(handle_t *handle, struct inode *inode)
 {
 	int i, j, start;
@@ -589,7 +591,7 @@ int ext4_init_orphan_info(struct super_b
 	 * consuming absurd amounts of memory when pinning blocks of orphan
 	 * file in memory.
 	 */
-	if (inode->i_size > 8 << 20) {
+	if (inode->i_size > (EXT4_MAX_ORPHAN_FILE_BLOCKS << inode->i_blkbits)) {
 		ext4_msg(sb, KERN_ERR, "orphan file too big: %llu",
 			 (unsigned long long)inode->i_size);
 		ret = -EFSCORRUPTED;


