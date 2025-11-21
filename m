Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE8B2DCF55;
	Fri, 21 Nov 2025 13:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732664; cv=none; b=YxcJ2yZiPrb5QZXn4UfFLjESGwtVUlPPXl0uWmK7VzjbcLIYoOQ1WC8Tb3u+N9GLtbvrMBWszLlbvHVcCXOtENW7BReRYWSEINr1HlqLzApuSqanbCbk1SA8GPrY9viKxoglzYU6ME2gT3aWA1XbKxt3Ke9pJ5uiKNM07CcoWlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732664; c=relaxed/simple;
	bh=UWYlOnY10kvlg7WkfsAmeH4zt1kKLRpKSvBc3aluKew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PS50VS9X6qUK8a1l8jdwnPhV4nUvSmQpmnkMc7VyXMm4vbP8fZrMhCP99zKIJ70K6xG4D3z8k/sCYkfRtcG0uAzb6ddCd16va1+vsg2kDUOU9AtbiA1wy54AEC2ALJSBCrPaX6DqMjW5LPGzzQ+rCntKZ7dG9gOpPn3w3TezdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdzepUwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdzepUwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6366C4CEF1;
	Fri, 21 Nov 2025 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732664;
	bh=UWYlOnY10kvlg7WkfsAmeH4zt1kKLRpKSvBc3aluKew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdzepUwzjtYPXt/cdZ3nnkIYQzQKhXM3vLJEzKoQQWmteZJL9c4L65XxfVNQeYXQv
	 hrszgmPSWbjCnQf1mQu8L2/FFTHTnpMLquqoCFeN8+ECJoFHj9r4dsiwjx6kNTsEbL
	 92VfLiD9Aqg9bL01Kd2uCJhwueJfLQ6y2x8isCFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/529] usb: gadget: f_hid: Fix zero length packet transfer
Date: Fri, 21 Nov 2025 14:08:18 +0100
Message-ID: <20251121130238.097640009@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2f1ec03d17d6d..d8dafebeabea4 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -494,7 +494,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -765,7 +765,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0



