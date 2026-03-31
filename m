Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086AA262A6;
	Tue, 31 Mar 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975437; cv=none; b=FH89bgIC+e0Pi1BuEY0WfW4YNmUjEpFWbu76EiuT91dU/E8X36FR5jfZpArNbiWA7/xHaSgm1BxkEYaOY6pwULQ/RuBl9qek/jmZXCu/TJZsG1UqCC7dW4CPMZ7oi4uaY0WPmBloV/M4pXS4iU07yYDmfnAcSMU1aGl0Uzh5sY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975437; c=relaxed/simple;
	bh=radaiP4MUySj87U/BPcsF+JeGszWqUVfaGwzPdJ2hII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB/8fmIgCkCwvip2NYjejpLA5MNfJZDsgb6JUcR1T+W3j2FMhhmJM4fD6SUEe/fZ6kowSmyEYeVBghcLT6ZaAZ65BtZwzoR64Eiq7v8NKeJeuCLdt1S+llyj8T8pz76cVK+o7AkAmbb800Oo4o8Rs4lL7GpGskGdE3J9fvWq8C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgWWbn5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgWWbn5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971E1C19423;
	Tue, 31 Mar 2026 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975436;
	bh=radaiP4MUySj87U/BPcsF+JeGszWqUVfaGwzPdJ2hII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgWWbn5CPJjhqIvybSrAfOnYZouAKyR04oxKC2Zl3mWyZe0BcQReiZbjKvEgD685K
	 fn2pb3bEFsXZ0dwfVbs7zxRPrWLOSvHuonwk7qxjK/eaI/VYAHoy93nyFRUbd/icWb
	 AuHBqIlIj2mxjnUrjC89XeecSg3t52A15rzJoC7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Free Ekanayaka <free.ekanayaka@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.19 294/342] ext4: fix fsync(2) for nojournal mode
Date: Tue, 31 Mar 2026 18:22:07 +0200
Message-ID: <20260331161809.755947707@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1308255bbf8452762f89f44f7447ce137ecdbcff upstream.

When inode metadata is changed, we sometimes just call
ext4_mark_inode_dirty() to track modified metadata. This copies inode
metadata into block buffer which is enough when we are journalling
metadata. However when we are running in nojournal mode we currently
fail to write the dirtied inode buffer during fsync(2) because the inode
is not marked as dirty. Use explicit ext4_write_inode() call to make
sure the inode table buffer is written to the disk. This is a band aid
solution but proper solution requires a much larger rewrite including
changes in metadata bh tracking infrastructure.

Reported-by: Free Ekanayaka <free.ekanayaka@gmail.com>
Link: https://lore.kernel.org/all/87il8nhxdm.fsf@x1.mail-host-address-is-not-set/
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260216164848.3074-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fsync.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -83,11 +83,23 @@ static int ext4_fsync_nojournal(struct f
 				int datasync, bool *needs_barrier)
 {
 	struct inode *inode = file->f_inode;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0,
+	};
 	int ret;
 
 	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
-	if (!ret)
-		ret = ext4_sync_parent(inode);
+	if (ret)
+		return ret;
+
+	/* Force writeout of inode table buffer to disk */
+	ret = ext4_write_inode(inode, &wbc);
+	if (ret)
+		return ret;
+
+	ret = ext4_sync_parent(inode);
+
 	if (test_opt(inode->i_sb, BARRIER))
 		*needs_barrier = true;
 


