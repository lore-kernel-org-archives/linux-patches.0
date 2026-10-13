Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CBE4EE84D;
	Tue, 13 Oct 2026 11:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892568; cv=none; b=PkR1SyJQnqj+ltxgjxJsAgK7eLawjf82f/gu9VJi4RfUjXcxH/ehylPYGepa8/nJ5IU/MgwbOu0fJ/urbu11Jx+Oabk+6Mn2NJugSZEy4lwK2i7IKgenXgMjQVUyhGbUnUC0ZWyjEFqhGJbig5Ek2SCXa6j/NIVH8eUaQMUb+pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892568; c=relaxed/simple;
	bh=5NczHcSdVkoupB+Q++tOo26l9vKFIQelimtosM7Bx6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJ7oR+l5Ue0VRwwGyqNOEC7+Z97tuJ9NxNHVQI/llMfoMecbiAH3v1a2PcU13T2gji8Pzd6sbaTYNf00zHk6X+JxuJSy2IBA+VdvZE5OtGxmTcbrKGRSOt7QPFt3gd9gw2UmZ2eHjYe32lb4lecVNCrBBF6TIZdTBqb0OglfiFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkjeGBTt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkjeGBTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023A81F00893;
	Tue, 13 Oct 2026 11:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892566;
	bh=1sZf4n8g8SYfe8iZ1uz47AdNx40Nwa/EnA3Hmb3TCNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkjeGBTtHK9qHNRN5KaDI2sOxWMtVH75Sh+vOKcxxw+I2ReisqpurGbVwk/fb1ALs
	 GnDq6sVCEAdknN6hgc7/3DCUMC1ByjThzMsBiQDW/rRYN/6Pvt4PLghLmeCKlesCkD
	 9siV0SXrbc0GhKGJ+OC5XE5nFxfQC2gZZqSJJ360=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 214/281] btrfs: dont stash io_uring encoded data across -EAGAIN
Date: Tue, 13 Oct 2026 13:38:50 +0200
Message-ID: <20261013112900.355510982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 51562a8cb11628d3a5e105b4c347ec5473e5745f ]

Returning -EAGAIN while leaving btrfs_uring_encoded_data in the cmd PDU
leaks if the request is cancelled or the ring exits before reissue.
io_uring does not free driver PDU allocations on cleanup.

Write: io_queue_sqe() always issues with IO_URING_F_NONBLOCK first, so
return -EAGAIN before allocating and free data on every exit.

Read: free on nowait -EAGAIN too; only -EIOCBQUEUED keeps the allocation
for btrfs_uring_read_finished().

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Fixes: e32dcdb0af9f ("btrfs: add io_uring interface for encoded writes")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c2e17bade5e5..833052306964b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4792,7 +4792,7 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
 	if (ret == -EAGAIN)
-		goto out_acct;
+		goto out_free;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 
@@ -4834,8 +4834,10 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 		add_rchar(current, ret);
 	inc_syscr(current);
 
-	if (ret != -EIOCBQUEUED && ret != -EAGAIN)
+	if (ret != -EIOCBQUEUED) {
 		kfree(data);
+		bc->data = NULL;
+	}
 
 	return ret;
 }
@@ -4864,6 +4866,11 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		goto out_acct;
 	}
 
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		ret = -EAGAIN;
+		goto out_acct;
+	}
+
 	if (!data) {
 		data = kzalloc_obj(*data, GFP_NOFS);
 		if (!data) {
@@ -4932,11 +4939,6 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		}
 	}
 
-	if (issue_flags & IO_URING_F_NONBLOCK) {
-		ret = -EAGAIN;
-		goto out_acct;
-	}
-
 	pos = data->args.offset;
 	ret = rw_verify_area(WRITE, file, &pos, data->args.len);
 	if (ret < 0)
@@ -4962,8 +4964,8 @@ static int btrfs_uring_encoded_write(struct io_uring_cmd *cmd, unsigned int issu
 		add_wchar(current, ret);
 	inc_syscw(current);
 
-	if (ret != -EAGAIN)
-		kfree(data);
+	kfree(data);
+	bc->data = NULL;
 	return ret;
 }
 
-- 
2.53.0



