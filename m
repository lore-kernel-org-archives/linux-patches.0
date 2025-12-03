Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793BE35F8B6;
	Wed,  3 Dec 2025 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779258; cv=none; b=l4ibyc849NyEh/D5Riku19+5UYeJR5KwCM0WIR4UOiFykgw6PkT4+sxyYuNDtpNyK9RmU93cd3Surz75dW25yUMpCx8HQSLzyMV+AYevENK7jSP1cpUfUW/45Ego5vFprAtf0J3YtlmfooHKquh2Md9GL1lf9nizrJwYc+N4Wxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779258; c=relaxed/simple;
	bh=P0iKRXJHJZ3uFn5Sg2Y71+9dL8OdoICPYmVJMPvjy9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+XvW+/U5Xwg6K3hiBlMPylSBH/R6gm+NOY7CdX0sV0KOuXNG1b9mH8QNHsAbVoBqlJ8yUHG/8iGoMqPLJ3sBxwkzoOjV3hE/9MJgaL6r92LOfZdAszUxejKDNiug86+3kSSn5bUgkozNNb7SzPNk6l7rein9cnc3y/rf+VjJHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhW2wTXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhW2wTXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E588C4CEF5;
	Wed,  3 Dec 2025 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779258;
	bh=P0iKRXJHJZ3uFn5Sg2Y71+9dL8OdoICPYmVJMPvjy9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhW2wTXe7iqLxCsZwp2wpJCiPPnSu40yEQz8R09enk5bmI6D4K/qd0wcHgX733euj
	 RKQ7UMYL7QIe05i7ok6ErO25ec5meFTxJ2rgzcZFx/nMg44RSYHw9ztFkZBDS+Slmx
	 /lLPoF8yUqJaa+Qe0/x870wY2Q3xETbYSdinEXB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/568] usb: gadget: f_hid: Fix zero length packet transfer
Date: Wed,  3 Dec 2025 16:23:24 +0100
Message-ID: <20251203152448.124415932@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 4cc8750e2a6fd..c20d3426571ec 100644
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



