Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C728515DBA8;
	Tue, 23 Jan 2024 00:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969761; cv=none; b=hNCGCKFnklatZDMfKAQXMJq9zAfdcUd3ZJxXPBTrBSbh1mEDGamK6rrmmwYtI5Xx5W7KhZfy1uj3lpCVsCqyhX/VVgkzR2+eGRYmYI/gthQYPV21Fdu9JLlb+6ggzZIedNqnqkax3Fkh8uZQjlIsqpC3rb40mYehUnXlZhr0L10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969761; c=relaxed/simple;
	bh=LaiVwbY/cd38Jty7irit07LcmiIi+alv2i6jKCMVcqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7jWpqExlZUyMf4MYgNg5Qhp7EgCopBHppa0gX9XDiR9DHPXIHVXG1CJqX8iIEpYQ28PCDBioSCyBaYadjJyllg+/OBsZy/z/YpRVyg5iaat9+ybco/f6VEGwMgTMhcF8fPrENNmvCRqN4HNhdrfGcJQ12Xl9KfKnzAsg6TJ7yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRMsLWmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRMsLWmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9F9C433A6;
	Tue, 23 Jan 2024 00:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969761;
	bh=LaiVwbY/cd38Jty7irit07LcmiIi+alv2i6jKCMVcqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRMsLWmjBjXmFj+Xqb+5dAgBx4/LGrcYHaUOe4KNoAxCJSANCrJh5MqtOD34uRruq
	 ns+te69R/aGfUyUtdIfUgA31uQTRO02Od0vXv42xqsr03JG1B8cJ3AOpH0a792Qm5b
	 fxcetIHhgGkFK5ym5fZ1m7IPTLuzqT/OOBYrQJ70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Amir Goldstein <amir73il@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.7 434/641] scsi: target: core: add missing file_{start,end}_write()
Date: Mon, 22 Jan 2024 15:55:38 -0800
Message-ID: <20240122235831.568049787@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 0db1d53937fafa8bb96e077375691e16902f4899 upstream.

The callers of vfs_iter_write() are required to hold file_start_write().
file_start_write() is a no-op for the S_ISBLK() case, but it is really
needed when the backing file is a regular file.

We are going to move file_{start,end}_write() into vfs_iter_write(), but
we need to fix this first, so that the fix could be backported to stable
kernels.

Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/ZV8ETIpM+wZa33B5@infradead.org/
Cc:  <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20231123092000.2665902-1-amir73il@gmail.com
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_file.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -332,11 +332,13 @@ static int fd_do_rw(struct se_cmd *cmd,
 	}
 
 	iov_iter_bvec(&iter, is_write, bvec, sgl_nents, len);
-	if (is_write)
+	if (is_write) {
+		file_start_write(fd);
 		ret = vfs_iter_write(fd, &iter, &pos, 0);
-	else
+		file_end_write(fd);
+	} else {
 		ret = vfs_iter_read(fd, &iter, &pos, 0);
-
+	}
 	if (is_write) {
 		if (ret < 0 || ret != data_length) {
 			pr_err("%s() write returned %d\n", __func__, ret);
@@ -467,7 +469,9 @@ fd_execute_write_same(struct se_cmd *cmd
 	}
 
 	iov_iter_bvec(&iter, ITER_SOURCE, bvec, nolb, len);
+	file_start_write(fd_dev->fd_file);
 	ret = vfs_iter_write(fd_dev->fd_file, &iter, &pos, 0);
+	file_end_write(fd_dev->fd_file);
 
 	kfree(bvec);
 	if (ret < 0 || ret != len) {


