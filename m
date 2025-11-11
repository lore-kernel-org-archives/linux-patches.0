Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CF81D86FF;
	Tue, 11 Nov 2025 01:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824213; cv=none; b=QtnhFSJ1P9PQ+utofF6UgWC8sS/WAoPBlYfz/eh6QpV0NGvkAWfy1JpeGT3LHwRCQculJ6MZhWjIAT/ozCQd0boGnabjLXwuhL0lL/7EuSY1jPsoHGGY6WdncSR3hLgnW2ZDB423MtiM8q/Pup3JmRoq4HuSKMejsXeyk38sJJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824213; c=relaxed/simple;
	bh=omJjpcDGGgqO6+97A+NIWZkZ5uV69sWZJ1Rn2YyOI3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnGgGjSAwVOeNuw1WEcq6BSfal6Bv+noUCKFh9Orbq3hu1p2Vcdf57DBWcvO2kSZplxr6n8AAVIK7rOS0yEgA37rZQgF6YL7KHGSD/V1UNIOS5i3tNAWEpmkXhS/mPS1SiRtASvePalpvd9H6yFtmZErGR22izMohXwb9//M+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iuj3OmeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iuj3OmeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2917EC19422;
	Tue, 11 Nov 2025 01:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824212;
	bh=omJjpcDGGgqO6+97A+NIWZkZ5uV69sWZJ1Rn2YyOI3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iuj3OmeXjV6rc0qqwlukkMaFl5B7IjNlE1/+MplqFbBL56lhV6zdhtjSc7NaSDw0g
	 eNPVynPUeBHFWNl331E6mq+pAiwqEMpmr12NbIJNIc4rGUSwAbtKcI6L3NDbfVsb1T
	 OtL8mSOXCGVAui4kkMf0hfYRQFC1m4rqpMa6RHHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 463/849] usb: gadget: f_hid: Fix zero length packet transfer
Date: Tue, 11 Nov 2025 09:40:33 +0900
Message-ID: <20251111004547.622673197@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8e1d1e8840503..307ea563af95e 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -511,7 +511,7 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	}
 
 	req->status   = 0;
-	req->zero     = 0;
+	req->zero     = 1;
 	req->length   = count;
 	req->complete = f_hidg_req_complete;
 	req->context  = hidg;
@@ -967,7 +967,7 @@ static int hidg_setup(struct usb_function *f,
 	return -EOPNOTSUPP;
 
 respond:
-	req->zero = 0;
+	req->zero = 1;
 	req->length = length;
 	status = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 	if (status < 0)
-- 
2.51.0



