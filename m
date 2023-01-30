Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AFA28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CDBC433D2;
	Mon, 30 Jan 2023 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087948;
	bh=mc+OTWuGwfzyOcxH0JYaKp6QvwVnPFOODkCO/GHeWT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxFQr3nnF5Gmj6PzrUloJSOgtJPJRcSxNk8nnMkjLuAM6GDiY0ZzcqE+Fyxwc2qRd
	 90Tzp4s9B1SSG2l4pKPUUnR0iFgqRilQtI53syJDrNYDVtqh8mDOTvAOhKq8SSR0J6
	 zFi5rqh9CVQSXXPis1iVR4cVcLefeGIdPDCiIgNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/204] usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait
Date: Mon, 30 Jan 2023 14:50:28 +0100
Message-Id: <20230130134319.079038701@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit 6a19da111057f69214b97c62fb0ac59023970850 ]

While performing fast composition switch, there is a possibility that the
process of ffs_ep0_write/ffs_ep0_read get into a race condition
due to ep0req being freed up from functionfs_unbind.

Consider the scenario that the ffs_ep0_write calls the ffs_ep0_queue_wait
by taking a lock &ffs->ev.waitq.lock. However, the functionfs_unbind isn't
bounded so it can go ahead and mark the ep0req to NULL, and since there
is no NULL check in ffs_ep0_queue_wait we will end up in use-after-free.

Fix this by making a serialized execution between the two functions using
a mutex_lock(ffs->mutex).

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Tested-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Link: https://lore.kernel.org/r/20221215052906.8993-2-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index adc44a2685b5..54f36d5c42a7 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -279,6 +279,9 @@ static int __ffs_ep0_queue_wait(struct ffs_data *ffs, char *data, size_t len)
 	struct usb_request *req = ffs->ep0req;
 	int ret;
 
+	if (!req)
+		return -EINVAL;
+
 	req->zero     = len < le16_to_cpu(ffs->ev.setup.wLength);
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -1892,10 +1895,12 @@ static void functionfs_unbind(struct ffs_data *ffs)
 	ENTER();
 
 	if (!WARN_ON(!ffs->gadget)) {
+		mutex_lock(&ffs->mutex);
 		usb_ep_free_request(ffs->gadget->ep0, ffs->ep0req);
 		ffs->ep0req = NULL;
 		ffs->gadget = NULL;
 		clear_bit(FFS_FL_BOUND, &ffs->flags);
+		mutex_unlock(&ffs->mutex);
 		ffs_data_put(ffs);
 	}
 }
-- 
2.39.0



