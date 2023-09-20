Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA6230FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EECC433CB;
	Wed, 20 Sep 2023 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212764;
	bh=aD/kRnc4zWdJ26UhX2d5AmMlIGqQiwX3d2FJWUCtXXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxgDAjqMzfjJsJNgYNNDjPm4AvDn5ySbxjOABzQTFhIqT9KC82j07KYNAQ56W3b9h
	 zYMCiPiI+3Jmw+dulaIKq7TBuCoNIWNJNdusxfYYgfXF4F38++bKPQNGDvQOfRgAIs
	 8wdK7fx1pOvtcOw700qsGkviPnBLCrcJAV4kTQyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b08315e8cf5a78eed03c@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Nam Cao <namcaov@gmail.com>
Subject: [PATCH 5.4 010/367] staging: rtl8712: fix race condition
Date: Wed, 20 Sep 2023 13:26:27 +0200
Message-ID: <20230920112858.766740304@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -323,6 +323,7 @@ int r8712_init_drv_sw(struct _adapter *p
 	mp871xinit(padapter);
 	init_default_value(padapter);
 	r8712_InitSwLeds(padapter);
+	mutex_init(&padapter->mutex_start);
 	return ret;
 }
 
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -570,7 +570,6 @@ static int r871xu_drv_init(struct usb_in
 	if (rtl871x_load_fw(padapter))
 		goto error;
 	spin_lock_init(&padapter->lock_rx_ff0_filter);
-	mutex_init(&padapter->mutex_start);
 	return 0;
 error:
 	usb_put_dev(udev);


