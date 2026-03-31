Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D574266B5;
	Tue, 31 Mar 2026 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976045; cv=none; b=Ap/LjrFlHuvjizuLMAwRMvwDzY5qEC32uudq3dJFpCF4pcDmd7x+csvZ0ZqtMQtGvw4exQEIv5Z1+AWGlJsaE1szNWqbps9w6jZ/Ibp9F8ACZ3yZGRD7ke3fV4Xu9EQDo2ecgPJDAuESwZT0FjkNYlmNyz7vouLNFIjYynarfv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976045; c=relaxed/simple;
	bh=K3gzMI6Kwi/hKT01hBT+JTdxNZSYHojnhL+wbUO0zA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtoZX5PeXmlKbHH6OsSL/QpGW5uk/HKqMdajwd3qFlhiJhKkok40YdxxKbjsW7xBZJrWZ8M6zNt073JCm9V7L4uQYq1kx0x2F+hXq6vSRbSZ5MqAMp4Ijiee3XtQym9geXeYCEBEsPCOgUYA5935c55YJQL6ZNG3ch0SRC20O58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTIOTNla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTIOTNla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761BBC19423;
	Tue, 31 Mar 2026 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976044;
	bh=K3gzMI6Kwi/hKT01hBT+JTdxNZSYHojnhL+wbUO0zA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTIOTNlaGtYuvmecXFpeTgizKisZXATACWSXD8Xa+fXKPIAbQsgBjOr3tEN88LU3I
	 j+KpFYfs06h6VZYoWxndO5R1WGbRMyR2wAJXqjhAUe0saGBOiiREZ+Oo1Eq+UTnUe9
	 tpxsYPIe7k8+UCHvu+UKhknTxpnPymC1iX/qLvZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Free Ekanayaka <free.ekanayaka@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 186/244] ext4: fix fsync(2) for nojournal mode
Date: Tue, 31 Mar 2026 18:22:16 +0200
Message-ID: <20260331161748.626231080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


