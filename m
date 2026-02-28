Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75A1421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301175; cv=none; b=diB36ymo6f1c1YD3vQmgRw0VuRfS0eWpQdsMm8E4qPXnxAzUnpjiC1SZ7F/W8y058ApipuRniWKiFbZJeR1/HPQPqVUcANhGYqwZHPtusOlMd/22Y4wNGl6SJk1nNIr0JkVQXaKtTs82LvzArGXUo0hSvkWMO5wngkQnHeSPneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301175; c=relaxed/simple;
	bh=ogZY1342n+KvLp52aU8vu0lm4CRSujrZufrTcjp1jls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdI9UUu1s+ShqG9FRDWmNhQQytlveTC5RK1WpQlxkpDfY5LdMQZmHOBMI8XxfcZmjpjCMjLn/xeUGg259sZATXoQc6WeTQdaZtDax7vsZ/afvTC4bE2Ye1Ilx6gfRq7LqI+hS3XBPnANqUIl5L598Lbv2LcrTarBZqFOZI99klM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HDdHsem1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HDdHsem1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55561C116D0;
	Sat, 28 Feb 2026 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301174;
	bh=ogZY1342n+KvLp52aU8vu0lm4CRSujrZufrTcjp1jls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDdHsem16eEijbWvZpFg3bgu0ov5Z6LNcPm5ejN4adp1A+EWwWFpl5tGHVoLz+AMz
	 dJuI5H4PAXMN8DbPaR89xFwMxWkH1C+Ac+LuquCeofl3b4c6czzj2P60iuZ1nBKoU5
	 icoyJ7QEGFxC8RDSIuhAFMVF73NFuXePsH3XejiT2inwJSe//lmo/XCrEI7xaSY4Fc
	 upkfE1r1uDFfTiH+B6UtnHxpHKWRCgqCUX32xW0T6u54u5ZbfSNnOAs+dBqMqLOuVz
	 TyP+o+JPw89ykURjDAGd4QBbcpyZ4l5o/QDQGKpZfW0zsqKdp7t3A7q8qLL1x1cYTO
	 h1jTSG0qZyEaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sam Day <me@samcday.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 342/752] usb: gadget: f_fs: Fix ioctl error handling
Date: Sat, 28 Feb 2026 12:40:53 -0500
Message-ID: <20260228174750.1542406-342-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sam Day <me@samcday.com>

[ Upstream commit 8e4c1d06183c25022f6b0002a5cab84979ca6337 ]

When ffs_epfile_ioctl handles FUNCTIONFS_DMABUF_* ioctls, it's currently
falling through when copy_from_user fails.

However, this fallthrough isn't being checked properly, so the handler
continues executing further than it should. It then tries the secondary
dispatch where it ultimately gives up and returns -ENOTTY.

The end result is invalid ioctl invocations will yield a -ENOTTY rather
than an -EFAULT.

It's a common pattern elsewhere in the kernel code to directly return
-EFAULT when copy_from_user fails. So we update ffs_epfile_ioctl to do
the same and fix this issue.

Signed-off-by: Sam Day <me@samcday.com>
Link: https://patch.msgid.link/20260108-ffs-dmabuf-ioctl-fix-v1-1-e51633891a81@samcday.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 2061c38d772ca..497d20260b040 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1724,10 +1724,8 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	{
 		int fd;
 
-		if (copy_from_user(&fd, (void __user *)value, sizeof(fd))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&fd, (void __user *)value, sizeof(fd)))
+			return -EFAULT;
 
 		return ffs_dmabuf_attach(file, fd);
 	}
@@ -1735,10 +1733,8 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	{
 		int fd;
 
-		if (copy_from_user(&fd, (void __user *)value, sizeof(fd))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&fd, (void __user *)value, sizeof(fd)))
+			return -EFAULT;
 
 		return ffs_dmabuf_detach(file, fd);
 	}
@@ -1746,10 +1742,8 @@ static long ffs_epfile_ioctl(struct file *file, unsigned code,
 	{
 		struct usb_ffs_dmabuf_transfer_req req;
 
-		if (copy_from_user(&req, (void __user *)value, sizeof(req))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&req, (void __user *)value, sizeof(req)))
+			return -EFAULT;
 
 		return ffs_dmabuf_transfer(file, &req);
 	}
-- 
2.51.0

