Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831A84119F8;
	Thu, 30 Jul 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422885; cv=none; b=ADUtWwJFIuU9GMX7jKKfrgNqn+dcRjchwpCnQ60B8E5ZzzBYZaDeDbRcPkWTISqVus6oZnpYewCuJ8IamRwZuwwKOwUcV66JQiLjXIDJMoPk5c89atUnZiqlOoNPwY1bm/TQGZIALxAPx4vUNT/CI0WhdCfvYIosJKqcVk7AE0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422885; c=relaxed/simple;
	bh=MGtG70Ck1MNsqPMSTPZa0t1xbcsjWYOPeQZJlhVlWRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk8A/0mQv6poU0saljSpI9p0fpI1LU0VzKApurabELQEfNKxEZnscQvG7pA3zbEIkS0QsFFa72muNrBFDr3XoE46S59VOdg1dE4A7AedL5jKGIKQ3rZClpzdPMjplfKzp506ohpZDw6YhWBGDa/uaxRZNY5KZI8RCOOZ3qu/+/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gl8a7fH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gl8a7fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98311F000E9;
	Thu, 30 Jul 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422884;
	bh=VgBtfflqMvBgVUC0efMswSjczA5QDK+qJWoEcXtu8Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Gl8a7fHJsFpnjFeLzOQRa03REm9EgUkVjokYpLqyKpDrJ926oPSWSU9rfjT0I6BB
	 l82+bO3rvvaHzS3U6iIGfhLi5ixzZbzqzfAfy7P8w02IqgJ9Q3pxxjUKwIhDBiL7Db
	 DKCm2VKpFzF0ivWlFYaDxJU7Ja9EcOfQWsTGZPQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>
Subject: [PATCH 7.1 589/744] misc: nsm: pin the module while the device is open
Date: Thu, 30 Jul 2026 16:14:22 +0200
Message-ID: <20260730141456.801772598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 3b231f1e9990f4c21220d0a69733ce2105891ff9 upstream.

misc_open() installs a misc driver's file operations with fops_get(),
which pins file_operations::owner before replacing the file's f_op.  The
NSM misc device leaves nsm_dev_fops.owner unset, so opening /dev/nsm does
not take a module reference on the nsm driver.

If the driver is built as a module, an open file descriptor can therefore
survive rmmod of the module that provides its ioctl callbacks.  A later
ioctl through that descriptor can call into unloaded module text.

Set nsm_dev_fops.owner to THIS_MODULE so the misc core holds the module
while any /dev/nsm file descriptor is open, matching the lifetime
expectation for the installed file operations.

Fixes: b9873755a6c8 ("misc: Add Nitro Secure Module driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/BE6951D13B5E5513+20260713055523.3193089-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/nsm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -413,6 +413,7 @@ static int nsm_device_init_vq(struct vir
 }
 
 static const struct file_operations nsm_dev_fops = {
+	.owner = THIS_MODULE,
 	.unlocked_ioctl = nsm_dev_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 };


