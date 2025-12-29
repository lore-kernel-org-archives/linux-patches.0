Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C7433344D;
	Mon, 29 Dec 2025 16:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025979; cv=none; b=uyhKoZe3v0XJbCWHizLvnQtzkrPMjd7zhQNX/wgSlDrQz7gNt5As2tnq5jucNFBkiVoR/WBC7jmmMmwXsk9p8BvG1cu0rDIch07JHaqwtYUZSS4E5AyVOPU2DS+sH/t4QY7HqLbr1mXflV3RNJB2tWVt1wivtFio6LjNS3tYyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025979; c=relaxed/simple;
	bh=C7wuZVi5VCs4QXsF1et9JnN5ef8qvbnRu24lnsED6Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Om3g8kp7lQhze+7SiswbHIULruiIDe279t0l0fMjpoGn4VXnrDZxQMo5GDTYnIZ6VOMxcBIUB8uk4TM40LBmxskcWm7jGDuRNJsW0tFVfiPKD9YyE1hquaObLDhIDgfLMl1/2rQUQULZTa31BON5mdOmcG3PzPtMgzLBZzrr5lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nRYtQaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nRYtQaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17DEC4CEF7;
	Mon, 29 Dec 2025 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025979;
	bh=C7wuZVi5VCs4QXsF1et9JnN5ef8qvbnRu24lnsED6Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nRYtQaZqO6soVVnf9oDfR+CNDDcxyOQgKB83TYjizIqVV2++8wJiuYBScvLwSZBw
	 U34pY8lw9ZXT8s919Id+guQI2UaGZTKr18W6sYF0j+sfWNXZOn8m+Ad2bpCyfwo8/7
	 lyGg3T0vLLQPSlQEnsjAPCaWb9McEA4VvRgQEXfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.18 404/430] vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()
Date: Mon, 29 Dec 2025 17:13:26 +0100
Message-ID: <20251229160739.180367619@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raghavendra Rao Ananta <rananta@google.com>

commit 2f03f21fe7516902283b135de272d3c7b10672de upstream.

For the cases where user includes a non-zero value in 'token_uuid_ptr'
field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' passed,
copy_struct_from_user() expects the newly introduced field to be zero-ed,
which would be incorrect in this case.

Fix this by passing the actual size of the kernel struct. If working
with a newer userspace, copy_struct_from_user() would copy the
'token_uuid_ptr' field, and if working with an old userspace, it would
zero out this field, thus still retaining backward compatibility.

Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
Cc: stable@vger.kernel.org
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20251031170603.2260022-2-rananta@google.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/device_cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -99,7 +99,7 @@ long vfio_df_ioctl_bind_iommufd(struct v
 		return ret;
 	if (user_size < minsz)
 		return -EINVAL;
-	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
+	ret = copy_struct_from_user(&bind, sizeof(bind), arg, user_size);
 	if (ret)
 		return ret;
 


