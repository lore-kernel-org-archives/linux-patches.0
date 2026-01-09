Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0FF336EDA;
	Fri,  9 Jan 2026 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961888; cv=none; b=ghiYKj2Mn4hVsxGTjx+Nr5N5IcPAoenTudHOjPNijw5Agq2v3hqSNoafmedu5F/dMOEqA4rEI42E04uCUsUzCL5M7IZkaoVTQCoqQv8E2nAkMM++p8RupeMiHgMAcqD80RW/HHnOgXBVHu8ZFL97Ll7o9ONjKbVOEvqIWUZScck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961888; c=relaxed/simple;
	bh=bOJy2FdXY1sMZtPQqxPl2RMAczJ8DtdmdWUKiIwBfuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj8pKcQlJ2WU6DX9wk8+fLcr1Hjs+jDb932++/HBsle5k3/hcxLCLEzsxoptvHflonjIeEHW7uDmc2weFXA1E8so69ENwgwE29WONPE/agxmQnpa85NxIqBSnGxN/vp0aM4FNz5CvmiqMQ1ijh+123KBf/mg6xzwOezbGkgz2w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7cY7NXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7cY7NXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3F3C4CEF1;
	Fri,  9 Jan 2026 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961888;
	bh=bOJy2FdXY1sMZtPQqxPl2RMAczJ8DtdmdWUKiIwBfuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7cY7NXm7u8qyFBxsnZJhXVK5zrPUH03R2BBRxjk5SyvtDWJ+H+2GlSuwZppV19jz
	 vKvv5K+BxUX5AshGxBQdMeB+BCQBquSbIrtQYxoIDNLDTD+5NvYUujOcMTRA0b+vsD
	 YwkyXpD1D87SyjV1PbEbMbyBhOwUbMbKPyX+LDYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/634] usb: raw-gadget: cap raw_io transfer length to KMALLOC_MAX_SIZE
Date: Fri,  9 Jan 2026 12:36:57 +0100
Message-ID: <20260109112122.685909628@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gopi Krishna Menon <krishnagopi487@gmail.com>

[ Upstream commit a5160af78be7fcf3ade6caab0a14e349560c96d7 ]

The previous commit removed the PAGE_SIZE limit on transfer length of
raw_io buffer in order to avoid any problems with emulating USB devices
whose full configuration descriptor exceeds PAGE_SIZE in length. However
this also removes the upperbound on user supplied length, allowing very
large values to be passed to the allocator.

syzbot on fuzzing the transfer length with very large value (1.81GB)
results in kmalloc() to fall back to the page allocator, which triggers
a kernel warning as the page allocator cannot handle allocations more
than MAX_PAGE_ORDER/KMALLOC_MAX_SIZE.

Since there is no limit imposed on the size of buffer for both control
and non control transfers, cap the raw_io transfer length to
KMALLOC_MAX_SIZE and return -EINVAL for larger transfer length to
prevent any warnings from the page allocator.

Fixes: 37b9dd0d114a ("usb: raw-gadget: do not limit transfer length")
Tested-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com/
Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://patch.msgid.link/20251028165659.50962-1-krishnagopi487@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index 2deab4a6030d7..8aa1a8408ae33 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -39,6 +39,7 @@ MODULE_LICENSE("GPL");
 
 static DEFINE_IDA(driver_id_numbers);
 #define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+#define USB_RAW_IO_LENGTH_MAX KMALLOC_MAX_SIZE
 
 #define RAW_EVENT_QUEUE_SIZE	16
 
@@ -620,6 +621,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
+	if (io->length > USB_RAW_IO_LENGTH_MAX)
+		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {
-- 
2.51.0



