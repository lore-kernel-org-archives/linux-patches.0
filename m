Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A991C6886;
	Tue, 27 Aug 2024 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769736; cv=none; b=VW30jZyXunxdmEpA1oMwjwbmZjkS5WN+wwAamWXJ4tBm4pVIeCYkWsXNv7S3+KG/VBFouPlD8rAhmBrcWH3XHHsez3+9jztshBJG+M9vwj5gNjelnlzVjt94G6UV3VAmaqhzW/SZoEx1sBFO70vKaUMU7p8fYtKOlBl7c337abg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769736; c=relaxed/simple;
	bh=vpbZEwx8qSwOvWT7l7EPxDie+Fy8lnCfS2DVMpti4MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfO8P9xWsxsokpPbvuWuIfCQuXc3wrOGXhbqhqjAJLMSmGQV8wwqjaRGchZrStg6Ufmvo+6FgxWOQXuMZD4WaDX/tCth7ArcExnEjJJNdYVHusAc/JmyOZP+fXaxiyYucIwugrDuJLvL5LmXKgnbXe95nv5Xzj7hgqBcfn/yP0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zikOdB14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zikOdB14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED10C4AF4D;
	Tue, 27 Aug 2024 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769735;
	bh=vpbZEwx8qSwOvWT7l7EPxDie+Fy8lnCfS2DVMpti4MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zikOdB146Jh7uQvooqgF2qiCEdsdO3/kOfBM7sbIEY/l/cwQJPeTYau+JQHuXIQyM
	 /K+FOTn5Z2m+xV7OPZtb7sDpeZIEVcInbq/3dppIMJtok6MOIikK6AxX0KBgwyIFe1
	 eJSWakOQ3bpojud4oIDhmXWKrlJuDX1ctaOFQGPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 6.6 009/341] char: xillybus: Refine workqueue handling
Date: Tue, 27 Aug 2024 16:34:00 +0200
Message-ID: <20240827143843.759532245@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eli Billauer <eli.billauer@gmail.com>

commit ad899c301c880766cc709aad277991b3ab671b66 upstream.

As the wakeup work item now runs on a separate workqueue, it needs to be
flushed separately along with flushing the device's workqueue.

Also, move the destroy_workqueue() call to the end of the exit method,
so that deinitialization is done in the opposite order of
initialization.

Fixes: ccbde4b128ef ("char: xillybus: Don't destroy workqueue from work item running on it")
Cc: stable <stable@kernel.org>
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20240816070200.50695-1-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -2093,9 +2093,11 @@ static int xillyusb_discovery(struct usb
 	 * just after responding with the IDT, there is no reason for any
 	 * work item to be running now. To be sure that xdev->channels
 	 * is updated on anything that might run in parallel, flush the
-	 * workqueue, which rarely does anything.
+	 * device's workqueue and the wakeup work item. This rarely
+	 * does anything.
 	 */
 	flush_workqueue(xdev->workq);
+	flush_work(&xdev->wakeup_workitem);
 
 	xdev->num_channels = num_channels;
 
@@ -2274,9 +2276,9 @@ static int __init xillyusb_init(void)
 
 static void __exit xillyusb_exit(void)
 {
-	destroy_workqueue(wakeup_wq);
-
 	usb_deregister(&xillyusb_driver);
+
+	destroy_workqueue(wakeup_wq);
 }
 
 module_init(xillyusb_init);


