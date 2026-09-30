Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697D4E77FD;
	Wed, 30 Sep 2026 18:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792548; cv=none; b=nvHiLRRSf/zKtZHdYPi7W65wZxCKuyRCNqYtr/9PVAK4UX6JKpkL6wtBJQH4R88ki4s1SPa5vWhSwY43d/uJNiPhcgJPURwIIX0DfQiRYHSVNK53tKDCKu3X4ir/nluAOn0O/B5VB+PYRTR4NkXMDQa3Fa6mmh9lsD5wEyw9d+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792548; c=relaxed/simple;
	bh=jRGa+gt30i3gDgUHZKrfHBiuSRHErAxmWCnHjkL5PRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVH4fFTbYmw2X56DCrMCXYvclW8C9VWcsHdbTKwsM0usIampWll6EKXBMmzwR5YWYFeTy4l5eQ9tdflMVA4Mk4FJtT8moDpPKnrgtvGDyLcMY5BSaVdVI4oNRhAMJE+RkQ8XQ3awASVSGv2fUEoxVAXh9X7qk+e7AXzjLuZMPy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuyebYc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuyebYc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DC91F000FF;
	Wed, 30 Sep 2026 18:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792545;
	bh=xcY+wb7NSWxMllqA1H50mUtTj141QJTKoq+4s7WXABk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuyebYc+3amyOSQQ4yDkiGbriq1TDFaDSA6jqHmSC9VU4ajLQr2fDMwrpZ/EdLM67
	 hTt4wcGbM1dauDduNSnFuC8U6pY4ejMufeDtIiRcButI4/ZP67Zi3bKLzSnRznu0+D
	 uryq+ujQ5R5tSpgEt2XCx30+YMe5BqzZToZ8QQkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Gellermann <christian.gellermann@codasip.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 656/752] nfc: virtual_ncidev: Add missing ioctl compat handler
Date: Wed, 30 Sep 2026 17:28:46 +0200
Message-ID: <20260930152412.451538593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6317e8505aaad..443fa9bb52d4f 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -196,7 +196,8 @@ static const struct file_operations virtual_ncidev_fops = {
 	.write = virtual_ncidev_write,
 	.open = virtual_ncidev_open,
 	.release = virtual_ncidev_close,
-	.unlocked_ioctl = virtual_ncidev_ioctl
+	.unlocked_ioctl = virtual_ncidev_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static int __init virtual_ncidev_init(void)
-- 
2.53.0



