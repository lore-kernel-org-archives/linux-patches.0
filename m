Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363034DCF5;
	Wed,  3 Dec 2025 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777863; cv=none; b=EEp62o4pxThbD3+X54+KGxbpXELlrcJQvXQ9ZRTWrbdjXJEdd7F+nuGLbUj0zupLMEmBL7qFP2vxp1S7k22FH1Kcfzay2ISjOEDfcsJmSIyH+s5mjTefUk+NgRkk0J4KvGDJ/9WeLx/QMSr8oLs1tft1ukIJUgDOd/qrHiAVlBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777863; c=relaxed/simple;
	bh=QHzneY7e1xpTx4KhLDxIJuggfx8fZlhUuHCjVojyqV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K52mC3m/pbRsQWJOfcKqBLmX5D1mwvVWHyZ5Xen25QxbM9KrozMwZCAtY4yGNNcf4RATDJ1eSunxYNWnrQet+04KbeWt/VnxqsuYdI4rBRal206Z3tYn6z+5VXcomgAT52U92KqgNO6/2vnXA3htTlUnF1CZDmod+mwaVb9Ih40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHzm0KDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHzm0KDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3A2C4CEF5;
	Wed,  3 Dec 2025 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777862;
	bh=QHzneY7e1xpTx4KhLDxIJuggfx8fZlhUuHCjVojyqV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHzm0KDeiyir5nP0dw8/S+d3rvYXDCzncmpHUfETi6Gju8O+SK/uyjwzZNHZFhL8l
	 xHQYQIn2JdKcUu2QJbizuqz1ktI9LUg1/EzYDiXVk5zPlv57y31StxwzM0O6f+7kzJ
	 /TDmV+u8+Kd8El6uFlUhLq2UzA9nUyTx1bR/001k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/392] usb: gadget: f_hid: Fix zero length packet transfer
Date: Wed,  3 Dec 2025 16:24:47 +0100
Message-ID: <20251203152419.130758777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index b0efaab8678bd..1293bc9157087 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -490,7 +490,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -761,7 +761,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0



