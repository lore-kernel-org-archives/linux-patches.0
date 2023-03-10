Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC78481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E67C433D2;
	Fri, 10 Mar 2023 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457639;
	bh=4BwReLaZ5wA1dlh0zI2K26R9S3JhYUDjXUIbnw+0Rtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5DOfmiCPRU1ameMd9uDpT/BRE7mCTo+Oj2PDl8Pjp6BmImwaxuKGSNfmaYW8aMeO
	 PAU7i/GfvAtIy5KvL+ozJsQe99PHcD2X5gajra42rZyxpOVEF1lnA1hBcUb/uZCAqQ
	 b3sp4GxJGGzZjVstydWaSpsyXZoM1oJAeLCszJ44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 6.1 200/200] usb: gadget: uvc: fix missing mutex_unlock() if kstrtou8() fails
Date: Fri, 10 Mar 2023 14:40:07 +0100
Message-Id: <20230310133723.219194041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit 7ebb605d2283fb2647b4fa82030307ce00bee436 upstream.

If kstrtou8() fails, the mutex_unlock() is missed, move kstrtou8()
before mutex_lock() to fix it up.

Fixes: 0525210c9840 ("usb: gadget: uvc: Allow definition of XUs in configfs")
Fixes: b3c839bd8a07 ("usb: gadget: uvc: Make bSourceID read/write")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230213070926.776447-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_configfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -524,6 +524,10 @@ static ssize_t uvcg_default_output_b_sou
 	int result;
 	u8 num;
 
+	result = kstrtou8(page, 0, &num);
+	if (result)
+		return result;
+
 	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
 
 	opts_item = group->cg_item.ci_parent->ci_parent->
@@ -531,10 +535,6 @@ static ssize_t uvcg_default_output_b_sou
 	opts = to_f_uvc_opts(opts_item);
 	cd = &opts->uvc_output_terminal;
 
-	result = kstrtou8(page, 0, &num);
-	if (result)
-		return result;
-
 	mutex_lock(&opts->lock);
 	cd->bSourceID = num;
 	mutex_unlock(&opts->lock);


