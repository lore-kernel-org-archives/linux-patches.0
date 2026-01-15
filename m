Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8367927B340;
	Thu, 15 Jan 2026 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499155; cv=none; b=jAJIy8dsQ04VdopeYwvq33ToTz4i0rLgKe5jHRHI3RH0nC6d3ZWJp3mXNPDNZKBJ318F3S0lW9qKrYOEGBSYfgysKqNnC9gjheEl61hUP8qclp+kuAXMrJNLgGX2+mUMf1u4ZPVJK9XmOqsS3r1qWdMVMfaV2bop2oa/biS0O0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499155; c=relaxed/simple;
	bh=F6g0q5qRF8MrBnJZQ7msD2nkloLm3er+5d85d0BqM1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKcyehrmY70vY7yn59DtHvtJuW+hU93iAN/zwDkCUgfu2xt4fLSX0jbGeeRS0zlTNdPSBwymVf5BLv3ja0PhwN/RlLzCKICTU2RYN9gnPm+FWkkei7c6H4TBoWjLIrTiQVYE2lp9Lu/Rg5d1i6kxBcf2sdsMNcHjqt47rh5p+Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2swS26XJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2swS26XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107DAC116D0;
	Thu, 15 Jan 2026 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499155;
	bh=F6g0q5qRF8MrBnJZQ7msD2nkloLm3er+5d85d0BqM1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2swS26XJNnCV6uSkGQ8t9Po4AY18wlsUgG82RsnUw8kIOAGOn5nnvP3mpBnd09IJL
	 6B851ni1yyJW/+nB87aOPU1b2ALz9ta1KFe6UNx9EtnyGPquzj7GzQf0pdTYdogw9c
	 014IqtMluEKEN3Y9UYymyS0s5c9spS8n3qUo2K4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/451] usb: raw-gadget: cap raw_io transfer length to KMALLOC_MAX_SIZE
Date: Thu, 15 Jan 2026 17:44:55 +0100
Message-ID: <20260115164234.317488143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d9cbbde8ff59d..a82c6e19572b6 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -38,6 +38,7 @@ MODULE_LICENSE("GPL");
 
 static DEFINE_IDA(driver_id_numbers);
 #define DRIVER_DRIVER_NAME_LENGTH_MAX	32
+#define USB_RAW_IO_LENGTH_MAX KMALLOC_MAX_SIZE
 
 #define RAW_EVENT_QUEUE_SIZE	16
 
@@ -619,6 +620,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
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



