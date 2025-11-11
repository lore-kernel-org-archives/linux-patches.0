Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7572D347BBD;
	Tue, 11 Nov 2025 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823744; cv=none; b=i1fcWYPtyUme/ZibywPeYACmuxJhTuR5GB24IYkoUyPbsTp9tJZEFSlT9J9SRS1XW0PmxeFu0K4xY9yQpbz2fp6RXVFZLLce0uWZl15WSyCAYLVQPzDKSaxySwnQSmc2PGW5DdpTWB4FQ+wASnFTisdxPuJIoWrV6VaAgaTchVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823744; c=relaxed/simple;
	bh=p3cMxlbCiTKv4R+/NE5zPhuanmpuO+PNfLz/49FsF58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usgl8OUyptu9ggnoccoRKLlzKfXaa3NOXU/b11CxQprQfng0+jKptWiKKDvH6HJOoVReQ5IKcxsPfqHDH+TOH/j6KPgYgtbPe7QwaZFgLOOz16VrVugwcU1Ze9YOeWzN9BOgT9kkzZWYdVCr5A6O+jr5whPO1/H4+W3Ghj6QbRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MYltP32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MYltP32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8606EC4CEF5;
	Tue, 11 Nov 2025 01:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823744;
	bh=p3cMxlbCiTKv4R+/NE5zPhuanmpuO+PNfLz/49FsF58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MYltP32bxwkz+Q/NwK/4pngx11Wv+z6v6HCrVZfG1FEc/PBWSf0zPL1Q6IPqNAEN
	 m4IDJHG2EiPqpvEq8ePD+IuU5BuJZWMOpDiCjCC/ICvNNfnAQJtCE0yN348oC+onm4
	 rIk0+brGa9dMqDDFBW7833D+Ufjo8O6LVnUX2HiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/565] usb: gadget: f_hid: Fix zero length packet transfer
Date: Tue, 11 Nov 2025 09:42:47 +0900
Message-ID: <20251111004533.880387911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Wu <william.wu@rock-chips.com>

[ Upstream commit ed6f727c575b1eb8136e744acfd5e7306c9548f6 ]

Set the hid req->zero flag of ep0/in_ep to true by default,
then the UDC drivers can transfer a zero length packet at
the end if the hid transfer with size divisible to EPs max
packet size according to the USB 2.0 spec.

Signed-off-by: William Wu <william.wu@rock-chips.com>
Link: https://lore.kernel.org/r/1756204087-26111-1-git-send-email-william.wu@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index ab4d170469f57..34d49d96def61 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -526,7 +526,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -982,7 +982,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0



