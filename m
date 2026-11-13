Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591050;
	b=K44mUGypGx7nyhHC36/63qCD7uMMnDa6xZrA0F3lRSMBQ9Oa8HuEU0wczxzGIM0COjLG
	 rlz5FJjMUerPVfRn3ppCDuChAB099YRxDVckJxcz+mohk8s174xOCKGwwk2Qdjp1LnPl+
	 hDPaja7Q+nEbOoUtb8a/9QRf9OUl9FSLlQra68QIYKZQA5HxR5joI3QwrM0WeetdS9XuI
	 +2cXsWPPBuP0j+bGtGu4RzN+1LsO5RSgzFpxQWQY9/gpPTRYWBIuItXITMGqeDgF2n6Zg
	 LPVGftt40j6XzcZ1sahcXI8+YYz1l4AaWUHDHK0i5DZVcVIgeZxhtaOnaxTyu1J2nVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ypS1EiS3kSM1IMVgSYsZc65aoNUphSguqU4sqSl5rH8=;
	b=IjDG+LLinj9ErWBvuNE/uN1CmS8NaoiEFrnLsfZtilGCyrhslaGFDeUDrBVxI8YXqruM
	 JgAyQAaYVIEfqPVAG8RcnPOrVI+7JV3Xa1TAC1ZHVfXub5UsIhArRr1ZLptojmhENGK3N
	 9m67tgJc2Kzos6nLTSpiPsFg3SCHSrdMiXlUooBJBPQiennT9qov2mPeqh5UmSPLO2i1d
	 gl0+2WV5/7PhlAuOEhgYGdwor1LWPNLsLlrUuTu2wU8voNQLjA8jvL8ESpsgbQ940hZUu
	 RUjg70Vauq+ma59kiqL56BEnlZriyOCnZuaJY1V+m3oyZLkWKjOGa/zkPzHrE7TaKSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMObmspe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF55606B81B;
	Fri, 13 Nov 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMObmspe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4951F000C4;
	Fri, 13 Nov 2026 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591050;
	bh=ypS1EiS3kSM1IMVgSYsZc65aoNUphSguqU4sqSl5rH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMObmspe15A8XACt6gJXs/JikX16wy+EKkPmyI7Sb2e8THizoEQ4hk341WzUb0wjL
	 M/91Vdh1ZM7ib7179ZjRM5DNzM12tqqi10ENLkxb1ZsbalyEu4v5TDVSWoedZIzkYT
	 xDRfe5n2htR6CvZNHjyEcuafkDn2CvR2ZOpR/ulU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/670] ALSA: us122l: Fix NULL dereference at hwdep open and release
Date: Fri, 13 Nov 2026 10:46:17 -0500
Message-ID: <20261113153819.142502845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit 820e0050866942b5498488496462d12c6ce1c7a9 ]

usb_stream_hwdep_open() and usb_stream_hwdep_release() pass the result of
usb_ifnum_to_if() straight to usb_autopm_get_interface() and
usb_autopm_put_interface(), without checking it for NULL.

usb_ifnum_to_if() returns NULL once the device is gone, since
usb_disable_device() clears udev->actconfig on disconnect.  The hwdep file
can outlive the disconnect: the card is released with
snd_card_free_when_closed(), so a process that keeps the character device
open reaches the driver's release callback after the USB configuration has
been dropped, and interface_to_usbdev() then dereferences the NULL
interface at offsetof(struct device, parent).  The open callback has the
same problem when it races with the disconnect.

Check both lookups and fail the open with -ENODEV; in release, skip the
runtime PM put when the interface is already gone and still run the rest
of the per-file cleanup.  Move the us122l->first bookkeeping after the
checks so that a failed open no longer leaves a stale file pointer behind.

Fixes: 030a07e44129 ("ALSA: Add USB US122L driver")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261028074143.14440-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 1458dd16711fe..8880051927044 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -148,19 +148,26 @@ static const struct vm_operations_struct usb_stream_hwdep_vm_ops = {
 static int usb_stream_hwdep_open(struct snd_hwdep *hw, struct file *file)
 {
 	struct us122l	*us122l = hw->private_data;
-	struct usb_interface *iface;
+	struct usb_interface *iface, *iface0 = NULL;
 
 	if (hw->used >= 2)
 		return -EBUSY;
 
-	if (!us122l->first)
-		us122l->first = file;
-
 	if (us122l->is_us144) {
-		iface = usb_ifnum_to_if(us122l->dev, 0);
-		usb_autopm_get_interface(iface);
+		iface0 = usb_ifnum_to_if(us122l->dev, 0);
+		if (!iface0)
+			return -ENODEV;
 	}
+
 	iface = usb_ifnum_to_if(us122l->dev, 1);
+	if (!iface)
+		return -ENODEV;
+
+	if (!us122l->first)
+		us122l->first = file;
+
+	if (iface0)
+		usb_autopm_get_interface(iface0);
 	usb_autopm_get_interface(iface);
 	return 0;
 }
@@ -172,10 +179,12 @@ static int usb_stream_hwdep_release(struct snd_hwdep *hw, struct file *file)
 
 	if (us122l->is_us144) {
 		iface = usb_ifnum_to_if(us122l->dev, 0);
-		usb_autopm_put_interface(iface);
+		if (iface)
+			usb_autopm_put_interface(iface);
 	}
 	iface = usb_ifnum_to_if(us122l->dev, 1);
-	usb_autopm_put_interface(iface);
+	if (iface)
+		usb_autopm_put_interface(iface);
 	if (us122l->first == file)
 		us122l->first = NULL;
 	mutex_lock(&us122l->mutex);
-- 
2.53.0



