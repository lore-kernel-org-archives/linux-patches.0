Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7222561AB;
	Mon,  1 Dec 2025 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588529; cv=none; b=C7RmpeNTMNQ6K0Bw3FDr+yv5SlcpNQaxPpwBB1G1WJsKQRlxj3CvCUaRVsCaxJl2Il/SyVtLAkjmJIs6OJthVxc0B560ESLdhtoHqM7W2jGOzW5RBUvcBJd6UOjoOulAyY1jx2cIglQxHFzrOLtEKY3HwfBINHbYI0hS7zAsElM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588529; c=relaxed/simple;
	bh=XUKLFntLzf93Wbe4uRRmLjo+EZPGEsZXMM2hmjlPGKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2Aofw+VXsKJzF3mESfOYk7YlSljGaPVKCrbyax/ll8v88geX7ECtVs/LCya2jWMFs1w3ee2GfUKrTN+5mupve5YISz0qDQV5jSDDwHzyPUi5jdYevlsph/GYUY6OEOENNXBEwkmUyAE3dDM1cQcqUXva4pf11lculllrU30tr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txJLK9i+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txJLK9i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC73C4CEF1;
	Mon,  1 Dec 2025 11:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588529;
	bh=XUKLFntLzf93Wbe4uRRmLjo+EZPGEsZXMM2hmjlPGKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txJLK9i+5r0l6wk5LvYGH8n5WhhuhLAvoa45z0wf0bHAAVj8cYR5MIbM97yJJXbei
	 y43xoZUdprMY3MXrN+P5P1fpo94T6WEK3rON0CfetoRVooesKs0AZFCifBd+9egTGk
	 C9otF2a9+qH2iOUaFMFbPRXD9MItFN+q2yX6ca5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/187] usb: gadget: f_hid: Fix zero length packet transfer
Date: Mon,  1 Dec 2025 12:23:07 +0100
Message-ID: <20251201112244.084806789@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 77354626252cd..cea9157ea2b42 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -496,7 +496,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -767,7 +767,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0



