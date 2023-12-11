Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F984F212;
	Mon, 11 Dec 2023 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRn9zsAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA5CC433C8;
	Mon, 11 Dec 2023 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319102;
	bh=P36echdtyrAZuzeL4JXtYTOlrOHgG1UBY/96Yh6pL3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRn9zsAWmrafaKcDr3JkdmdFK6n7YgP7FU+cbwGaZsrVKPu/gWxsk0NWzz5N98hHf
	 XxQegbccLW0/nuVaLyI0uVZ1wR17PvbEeFLofBEvrqky3p0cQZO0WuoHETHVqq3oT6
	 +hGTHmq8BSlc4qT07G3RZZa8y3Q9hiax34Bixa2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Aladyshev <aladyshev22@gmail.com>
Subject: [PATCH 4.19 39/55] usb: gadget: f_hid: fix report descriptor allocation
Date: Mon, 11 Dec 2023 19:21:49 +0100
Message-ID: <20231211182013.701659023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Aladyshev <aladyshev22@gmail.com>

commit 61890dc28f7d9e9aac8a9471302613824c22fae4 upstream.

The commit 89ff3dfac604 ("usb: gadget: f_hid: fix f_hidg lifetime vs
cdev") has introduced a bug that leads to hid device corruption after
the replug operation.
Reverse device managed memory allocation for the report descriptor
to fix the issue.

Tested:
This change was tested on the AMD EthanolX CRB server with the BMC
based on the OpenBMC distribution. The BMC provides KVM functionality
via the USB gadget device:
- before: KVM page refresh results in a broken USB device,
- after: KVM page refresh works without any issues.

Fixes: 89ff3dfac604 ("usb: gadget: f_hid: fix f_hidg lifetime vs cdev")
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Aladyshev <aladyshev22@gmail.com>
Link: https://lore.kernel.org/r/20231206080744.253-2-aladyshev22@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -88,6 +88,7 @@ static void hidg_release(struct device *
 {
 	struct f_hidg *hidg = container_of(dev, struct f_hidg, dev);
 
+	kfree(hidg->report_desc);
 	kfree(hidg->set_report_buf);
 	kfree(hidg);
 }
@@ -1293,9 +1294,9 @@ static struct usb_function *hidg_alloc(s
 	hidg->report_length = opts->report_length;
 	hidg->report_desc_length = opts->report_desc_length;
 	if (opts->report_desc) {
-		hidg->report_desc = devm_kmemdup(&hidg->dev, opts->report_desc,
-						 opts->report_desc_length,
-						 GFP_KERNEL);
+		hidg->report_desc = kmemdup(opts->report_desc,
+					    opts->report_desc_length,
+					    GFP_KERNEL);
 		if (!hidg->report_desc) {
 			put_device(&hidg->dev);
 			--opts->refcnt;


