Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585443;
	b=A8U79/Gkt+IKHhP0E/Lpu+1wkH35mD0Utm502L1H66wtv2fWCDDW3HLqhtiISS4H86Pq
	 n/JDTSII4Sn2zpDS4qODTAcuhLp54r/Tnl4gCzZAiHW9ksGr4ELE3jcqvmF+BiAmA1gS8
	 cLDJy9b9KV8OTcbZ6xIqBjNVj6WJhk/aY65dtzdq8xtrq8a62yetvJmESuBP80olW/PkV
	 Zdjm1VuXen7TBy6zisDkhb/3d5+LD/GLLtKKj5kWd1xdBB8BARz0Rc1sM27B4kWL8CvGq
	 lWNtWa2mxNENlHwcEK4aXf0zJiAMbPVACLoX2NNZyuFV3Ixgyp1W9+p/3p+yhoZyGIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dRwGZuim3JNBIErYgE+9s6yRFH+UEJxhj6PrXtpP7MY=;
	b=Tf7z0FRthWEmSGPEDFJSKPWFH6LY4kb27BOZloyUdT9Grsg6Sz+Z18qK+75CodVt5LU8
	 k+5cDWW6CeOK6DnOBBrfJ8XTcnQPqkc4jMMrJSczVu0JytdHzEtz85Ra2nfmLx0WIg13S
	 qieGq0VYzIzspJWbQUjfy/bYSq1Xx1ca3sStRbj/coiwTUxw2OxyX6Rc5wmVYvltqNsOG
	 6fxYiqgI0MZvTMBJqSAw3idGplfQzRAr2NW7YEBAK7hm4TSWsu6qt8zcYzFA41ZcpN08n
	 qzihaosDys2gTqkrnDYiN0cRK7Xsro9/yFW9RvWhyOHO1GGqfvDVIIf+xZFkw+Ae6Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wYUKeqRR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0442F606A8A8;
	Fri, 13 Nov 2026 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wYUKeqRR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB97F1F000C5;
	Fri, 13 Nov 2026 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585442;
	bh=dRwGZuim3JNBIErYgE+9s6yRFH+UEJxhj6PrXtpP7MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYUKeqRR/zvsLQ3kIFL2ZgwTHBT6qPKEGB1KwWLUR8w8UkeRqE+Z2kDdtIZy/uugd
	 Dq7psHKiYZmSTq0JkpRZ1VQCLKKxzZZIqpvb/6hFENnlBCTIhz6oD27B07yTlyNBwT
	 1eVu5B+jb9BeQr8J4JCMtYUaQNETB9MGlhAUpTJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 050/507] net/9p/usbg: Fix use-after-free in disable_usb9pfs()
Date: Fri, 13 Nov 2026 10:45:54 -0500
Message-ID: <20261113153755.247005619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 6f401e350939442b2ac905f7e5ac952e3802a5d8 ]

disable_usb9pfs() frees the IN and OUT usb_request objects before it
disables the corresponding endpoints. If either request is still queued,
the later usb_ep_disable() call cancels the endpoint queue and the UDC
driver can still access the already freed request.

With dummy_hcd and KASAN, this is reproducible by queueing the OUT
request and then disconnecting the configfs gadget:

  BUG: KASAN: slab-use-after-free in dummy_disable+0x2b4/0x300
  Read of size 8 at addr ffff888009702400 by task sh/1
  usb_ep_disable+0x8e/0x1f0
  usb9pfs_func_unbind+0x193/0x350
  gadget_dev_desc_UDC_store+0x135/0x280

dummy_free_request() also warns because the request is freed while its
queue entry is still linked.

Disable both endpoints before freeing the request objects. This lets
usb_ep_disable() cancel any queued transfers and invoke the completion
callback while the request storage is still valid. The request objects
are then freed only after they have been removed from the endpoint
queues.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260607130118.16579-1-zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index f2619e8465d23..e2309500a8c74 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -278,6 +278,9 @@ static void disable_usb9pfs(struct f_usb9pfs *usb9pfs)
 	struct usb_composite_dev *cdev =
 		usb9pfs->function.config->cdev;
 
+	disable_ep(cdev, usb9pfs->in_ep);
+	disable_ep(cdev, usb9pfs->out_ep);
+
 	if (usb9pfs->in_req) {
 		usb_ep_free_request(usb9pfs->in_ep, usb9pfs->in_req);
 		usb9pfs->in_req = NULL;
@@ -287,9 +290,6 @@ static void disable_usb9pfs(struct f_usb9pfs *usb9pfs)
 		usb_ep_free_request(usb9pfs->out_ep, usb9pfs->out_req);
 		usb9pfs->out_req = NULL;
 	}
-
-	disable_ep(cdev, usb9pfs->in_ep);
-	disable_ep(cdev, usb9pfs->out_ep);
 	dev_dbg(&cdev->gadget->dev, "%s disabled\n",
 		usb9pfs->function.name);
 }
-- 
2.53.0



