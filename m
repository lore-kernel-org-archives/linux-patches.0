Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C764DC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4972FC433C8;
	Mon,  4 Sep 2023 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852323;
	bh=ReojBxNJla++5jTyvHd11HQfGMHhAFlCmDAgs6D0gjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7UFisLj8j1+e8TtSLMxELUkSWXHA+TOiWXcYrjRzUdxV/AT1UiNKxxvO0CuP9R9x
	 YERaa7rhxe1HHvXFpFlXxM+BEm/YGKLNrijK2I2a4FjV25IjsLAyw7FD2ZpludxN1I
	 e3PF/FatbGJBvNS859pTC4s8fyKnL0jHXyquagpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b08315e8cf5a78eed03c@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nam Cao <namcaov@gmail.com>
Subject: [PATCH 6.5 18/34] staging: rtl8712: fix race condition
Date: Mon,  4 Sep 2023 19:30:05 +0100
Message-ID: <20230904182949.433044728@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcaov@gmail.com>

commit 1422b526fba994cf05fd288a152106563b875fce upstream.

In probe function, request_firmware_nowait() is called to load firmware
asynchronously. At completion of firmware loading, register_netdev() is
called. However, a mutex needed by netdev is initialized after the call
to request_firmware_nowait(). Consequently, it can happen that
register_netdev() is called before the driver is ready.

Move the mutex initialization into r8712_init_drv_sw(), which is called
before request_firmware_nowait().

Reported-by: syzbot+b08315e8cf5a78eed03c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-staging/000000000000d9d4560601b8e0d7@google.com/T/#u
Fixes: 8c213fa59199 ("staging: r8712u: Use asynchronous firmware loading")
Cc: stable <stable@kernel.org>
Signed-off-by: Nam Cao <namcaov@gmail.com>
Link: https://lore.kernel.org/r/20230731110620.116562-1-namcaov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/os_intfs.c |    1 +
 drivers/staging/rtl8712/usb_intf.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -327,6 +327,7 @@ int r8712_init_drv_sw(struct _adapter *p
 	mp871xinit(padapter);
 	init_default_value(padapter);
 	r8712_InitSwLeds(padapter);
+	mutex_init(&padapter->mutex_start);
 
 	return 0;
 
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -567,7 +567,6 @@ static int r871xu_drv_init(struct usb_in
 	if (rtl871x_load_fw(padapter))
 		goto deinit_drv_sw;
 	init_completion(&padapter->rx_filter_ready);
-	mutex_init(&padapter->mutex_start);
 	return 0;
 
 deinit_drv_sw:


