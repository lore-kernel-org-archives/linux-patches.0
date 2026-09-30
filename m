Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D643C1D66;
	Wed, 30 Sep 2026 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796815; cv=none; b=cbqbPbg3Lyc308TbZzUpmxdq1o/A/i8L5mweQZu+BogtlYuSe1ZrbBUAAq9n3190mFXMGbd9RYZfWE/lq/rJGm885QZ81TWTvxHH6tLxSxgkwXxKRrH5Xrt1pD7w2qjQRttCXY2VLknt+VVtiF544vGze+Zn3NFLu2UTvvB3BGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796815; c=relaxed/simple;
	bh=82wf9eM12lUXI7npT1tPfzp3fJPYDpZQ+2VvT5NQkXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFJdvegv57Ed9TQj9xO2fYnLFbym3YVRNXf+p6Sh6iI/CopKRx2vkcqu1raEmG3Vgq+5ZXx1b736YQB0l4jFvOeQsLGmysL0bkXMe+JICIfMHYJ8an5I04kN3o0tEciNsu3RDibYGROdyQRUAgHALisB40DShe6pYwd2FTIoHgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCT2GOxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCT2GOxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5C21F000FF;
	Wed, 30 Sep 2026 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796814;
	bh=heTajp2rsGcdCdYNUNP84E+U8igpRCBLovXTzIWaGDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCT2GOxJl/KauoYPVbUIXMalkJ2kJXSZCvAHNWAU8PpJZoTczc6u1Ysz/Uy/EPjsx
	 9HGCcIHbskyEeCeSRczL7yMNT+1CKguDE3zvJENyWvsb4FsBTP5oF1A+nzHap3L3mB
	 cKS6oy0dmtE5Hv9UIZs6Nn/o0UiUudct3OryyTRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Gellermann <christian.gellermann@codasip.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1044/1193] nfc: virtual_ncidev: Add missing ioctl compat handler
Date: Wed, 30 Sep 2026 17:28:48 +0200
Message-ID: <20260930152457.414500279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Gellermann <christian.gellermann@codasip.com>

[ Upstream commit 51814683e28fc64eceb415962376956c3cfc75a7 ]

The compat handler for ioctls to the virtual nci device is missing. So,
nci-specific ioctls of a compat task return with -1 and errno set to
ENOTTY. Add a handler.

The handling of an ioctl() call of a compat task to get the index of
virtual nci device (IOCTL_GET_NCIDEV_IDX) lands in the default case of
the ioctl compat handler (see fs/ioctl.c):

COMPAT_SYSCALL_DEFINE3(ioctl, ...)
{
	...
	default:
       		error = do_vfs_ioctl(fd_file(f), fd, cmd, ...);
		if (error != -ENOIOCTLCMD)
			break;

		if (fd_file(f)->f_op->compat_ioctl)
			error = fd_file(f)->f_op->compat_ioctl(fd_file(f), cmd, arg);
		if (error == -ENOIOCTLCMD)
			error = -ENOTTY;
	...
}

There, do_vfs_ioctl() returns -ENOIOCTLCMD and compat_ioctl is not
set for virtual_ncidev_fops, i.e. f_op->compat_ioctl == NULL. So, the
ioctl() syscall returns with -1 and errno set to ENOTTY to the compat
task.

To fix this, use the compat_ptr_ioctl helper for compat handling here.
It shall be used for ioctls that "either ignore the argument or pass a
pointer to a compatible data type". The driver's sole ioctl takes a user
void pointer and copies nfc_dev->idx to it, a 4-byte integer across all
ABIs.

This issue has been found by running the nci_dev kernel selftest as
rv64 binary on top of a CHERI kernel, where the ioctl() ends up in
the ioctl compat handler, similar to a 32-bit application on top of a
64-bit kernel.

Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260904164252.18351-1-christian.gellermann@codasip.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/virtual_ncidev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index 590b038e449e5..db15d26692666 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -195,7 +195,8 @@ static const struct file_operations virtual_ncidev_fops = {
 	.write = virtual_ncidev_write,
 	.open = virtual_ncidev_open,
 	.release = virtual_ncidev_close,
-	.unlocked_ioctl = virtual_ncidev_ioctl
+	.unlocked_ioctl = virtual_ncidev_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static struct miscdevice miscdev = {
-- 
2.53.0



