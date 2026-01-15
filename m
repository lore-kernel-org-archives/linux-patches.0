Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8232C08AC;
	Thu, 15 Jan 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497578; cv=none; b=VQJJt6yyhfUk5k5BPXizRoyLcN5IKkjk5IF3K9z4N/CLcS23jG+Bti7668ZEWQnvO1fqgXnh8teEV6QYl8OgxiVSU5DnNdlNJyblh1Fmj2qVMq/OkFDBnWmXSxH+jr1GS54k2P8ecfyrFQWfFDP/PHhuOWFLfjv8XJHEwca67WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497578; c=relaxed/simple;
	bh=/Omww3LSWo3MnXMCTH38cmNAsrCaax38XxJicc2We+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKQ/qCywioYYKdlf+mItLAmBnBvhI8rsF0vnkxQDgCz40NPcJKZonBqofZ+Mx39VhmtyONYKjKmN2Qky6sDNzt5onSAO+BLzb+pWX0WJZMk64YoOAY0T3fXsM1zSKG/431je5/LIo1LMsEScNcX7XTwX5P8/LgC4crAZU1UkgS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTkuESXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTkuESXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B48C116D0;
	Thu, 15 Jan 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497577;
	bh=/Omww3LSWo3MnXMCTH38cmNAsrCaax38XxJicc2We+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTkuESXYwfdObe9RMwNWd1iY+elDDhfYsT8TNW21PEj/GsTGxIoq6sf7CaSni240k
	 9WqQgKaxsLhZXvkGtDHyqfeIND0p4Z1AoTg+rXwFz76wp478g5Urfus5TtATV56+l+
	 wy2JempKZOVLOPSlCLBb/4MNmEasA17Xg1SD8bMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/554] usb: raw-gadget: cap raw_io transfer length to KMALLOC_MAX_SIZE
Date: Thu, 15 Jan 2026 17:43:15 +0100
Message-ID: <20260115164250.916928921@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 17e39f3e908b2..db700db32eef2 100644
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



