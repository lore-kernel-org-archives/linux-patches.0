Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6275E3624BF;
	Wed, 30 Sep 2026 16:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787278; cv=none; b=WxOkW7rEYJ6iMV6O5bCWHt5fGvoKKCqyLSvpdFbGzSSTg2m82GNy68m3R0Ipo94EJT0JmmyhY+M5TSNja0BjKzcdA4U5uc2AiEwCz2apuAnBVAgYJaJmbjOec2qg2yB/d5Qwy7zAguIFK1ptdNkTXeVX/6IObfn6cYQFft1y6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787278; c=relaxed/simple;
	bh=jWYNI3nNL7snlmSzjMZ/UX6QOliVjbD/vd2rsROlNac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DranAwPcGRUtPAAP1HIG9Pt45EvhhJrw64JXmasSP1gT8YuO9/kWbn1wEjk4RewDVacgJJYQt+VLY5sEeYSpoYerAvTN2r6CSskcV02kbOGiJNPZXowtaRBR9LFyxEoRig18qjB6YLnh9/OYGt8qB68bqSlHClsViOOPcGZ2DDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M08ERdPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M08ERdPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DFA1F000FF;
	Wed, 30 Sep 2026 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787277;
	bh=C8rCXMqWuqhnfHFmsMuaGKWhcXSMYv46oduihpI9Tco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M08ERdPhe8i8RoiPjaIBcfhhw2/1eVE4hMbY9jLwQ232FvSkaAc8IZL+dnH/Zsdzo
	 tmmX9z1KoPw5qqBCeohjukD2zL6usvAPEs0aUToR7BN+wHxBQGeCiKXAsK6mmVTSBf
	 3aQc+Tr5qyFWZMmLUEQ+fpMlYI1GZcvDWVvb5u3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Gellermann <christian.gellermann@codasip.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 174/457] nfc: virtual_ncidev: Add missing ioctl compat handler
Date: Wed, 30 Sep 2026 17:24:39 +0200
Message-ID: <20260930152349.808273125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index 8eeb447ac96e9..e51c647b27ebe 100644
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



