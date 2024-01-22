Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D0073178;
	Tue, 23 Jan 2024 02:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975436; cv=none; b=t6FjZ7YoN5Teavp6ndc/Q5HpY2L805NDLNx+eOwoUTDX0rLgC13Nx4OOUBDGAWIQLPUiuXKWf7pCOSFMWz3i4QtpEIhLQEZoqH5EuNo+JDQRQ7KSsV1wmLDSevbdCw7j4G0uNWheMnpDAHzhn2SRs3ijf5pNfgf1pQeuT/Pr6J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975436; c=relaxed/simple;
	bh=eg9/4ukqphh6o1+WKlaNbs4t+S7ByDmPg3ldDNu/qTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUg20/MwWXS8yG19tbiMQQ8I4C3r4cpGfyxu/mE9UeOMDHPfQPbl/hlZ86WRC0aRsPIL6C/NZj6Q8lvXinxBGrECb/16AhOMIeJpr1TB/x7kQcPeMwzT2yIpvOgYTvXjbVGdTWRdQKcGc+4sH5ic4fyoIoWXp4NFt7tmJMbOLfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDpBAaZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDpBAaZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EC1C433C7;
	Tue, 23 Jan 2024 02:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975436;
	bh=eg9/4ukqphh6o1+WKlaNbs4t+S7ByDmPg3ldDNu/qTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDpBAaZB9erRuouxekfnOijRTqQSOgpGEQnARYWLZLFcmDcAgPJ+2pMZ7kfbnyETv
	 WYYTLDOVxmCn/rzOPSWctxd05TQmsKKFt8bdXD3230piYVcbSvBlGHt8F0ME8CCJiW
	 bBN5V97plm47hZLZ6tfhNRMltbCxmo2xjev/nNyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Amir Goldstein <amir73il@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 395/583] scsi: target: core: add missing file_{start,end}_write()
Date: Mon, 22 Jan 2024 15:57:26 -0800
Message-ID: <20240122235824.071173632@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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


