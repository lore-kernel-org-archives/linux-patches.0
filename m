Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826915;
	b=0auO/5qe3EWcjgNCV/u6ZEgrdqDKRcnu7OYJGuPBMJGB5GC5vJq7YJTAD4+HAc+oY9NH
	 gLnfgu7Nm6qm8/lXdXk1qsPsuH5wIV8dFVcq1P+EpL8fKWt3vVLU2RZigUg3ZmI+J1NiR
	 8fCLReBJ3RC7lYu1dp8hiGWD0FL9lUZa3+HYLOZt9cpywwLiMNIKAstakTQrbqsHlOA5L
	 zDhYccr1x0VjUFoaSAsbQrM8MYL1ebdFp2LOczQH9DRLQcfpoQfFCFFv5tyXyo9ZOCUMy
	 jitt7Qm80om91L0WI88jQIbJ0KFfCW/t68GGBC1Ed2GObRHPdd8Ajrmg0DGmWsTzzIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HgpiXS0eC4HUE7F4Xtg2nmexrH/VNkyVwgp9UMPWtnU=;
	b=raNJKohliIIqHQpdRt44lb+JUKlieN0M288ULR9orRQAqd8kp6po7z6bDuUdpL+SCkBT
	 qkKDa541UrG8cSaMsyyMxb+raLVpmLVgjOs+nmldOkyf1MZfsq54VzcPUgIKoNVk4QejY
	 T0u7uYmswhRPG2ogz3meHrtA9e3Qxd0ZuK99+3xGs954P6RjaS2QfC8Jn0+w6838fU4G1
	 WPcPeGbFCeFHxcvZdd6GZF/Y2z9EPTh75XXuwtY4Z0VE7Q8GBwT4+6MD0NZuPQYRKez7W
	 pTPIp3uL4QERan9pdg7qWgaw3R+OGvo7FvgknjiAiX3j7xwULpA+87JnPTHj8ujWmvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBVQsNI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B376070308;
	Wed,  4 Nov 2026 21:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YBVQsNI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AAE1F000C1;
	Wed,  4 Nov 2026 21:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826914;
	bh=HgpiXS0eC4HUE7F4Xtg2nmexrH/VNkyVwgp9UMPWtnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBVQsNI+6ePPtbW/yLcMCyC/MVd6YQ9u/Bb0smJjUxqruOqGNFEZUWl6+JqkuUMP9
	 /fIkuzytAhZpwr+slZvEAQU5bwfs2D9qfm//DheaMgzPIlY6CfpKoEO0LsHz53ir9t
	 RQx79tSidw9h0spNrcj+z1r7ueW8W1qYNwh4DAdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+37a57a84893052ab6071@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 081/547] media: usbtv: fix null-pointer dereference on disconnect
Date: Wed,  4 Nov 2026 16:04:25 -0500
Message-ID: <20261104211040.546678395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

commit cb705f75d03e946a4514488beb9e3bac9bcdb2e6 upstream.

A null-pointer dereference can occur in usb_make_path() when called from
usbtv_querycap() (and other ioctl handlers) during device disconnection.

Oops: general protection fault, probably for non-canonical address
0xdffffc000000000a: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
RIP: 0010:usb_make_path include/linux/usb.h:985 [inline]
RIP: 0010:usbtv_querycap+0x9c/0x100
drivers/media/usb/usbtv/usbtv-video.c:612
...
Call Trace:
 <TASK>
 v4l_querycap+0x236/0x470 drivers/media/v4l2-core/v4l2-ioctl.c:1106
 __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
 video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
 v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94

This happens due to a race condition between the USB device disconnect
routine (usbtv_disconnect()) and V4L2 ioctls. When the device is
disconnected, usbtv_disconnect() sets usbtv->udev = NULL without holding
the usbtv->v4l2_lock mutex. Concurrently, an ioctl handler like
usbtv_querycap() can be executing under the v4l2_lock and attempt to use
usbtv->udev, leading to a crash.

To fix this, move the usbtv->udev = NULL assignment into usbtv_video_free()
and protect it with mutex_lock(&usbtv->v4l2_lock). This ensures that no
non-queue ioctl handler can run concurrently with the pointer being
nullified. If an ioctl is already running, the mutex will block the
disconnect path until the ioctl finishes. If an ioctl is blocked waiting
for the lock, it will acquire it after the disconnect routine releases it,
but will then check video_is_registered() (which was cleared by
vb2_video_unregister_device()) and safely return -ENODEV.

Acquiring v4l2_lock after vb2_video_unregister_device() avoids
reintroducing a historical deadlock issue, and usbtv_audio_free() remains
safe as it is called before usbtv_video_free().

Fixes: 65e6a2773d65 ("media: usbtv: Remove useless locks in usbtv_video_free()")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+37a57a84893052ab6071@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37a57a84893052ab6071
Link: https://syzkaller.appspot.com/ai_job?id=5abbe65a-5853-4bc2-9135-5c75f88d51ed
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-core.c  |    2 --
 drivers/media/usb/usbtv/usbtv-video.c |    4 ++++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -139,8 +139,6 @@ static void usbtv_disconnect(struct usb_
 	usbtv_audio_free(usbtv);
 	usbtv_video_free(usbtv);
 
-	usbtv->udev = NULL;
-
 	/* the usbtv structure will be deallocated when v4l2 will be
 	   done using it */
 	v4l2_device_put(&usbtv->v4l2_dev);
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -966,5 +966,9 @@ void usbtv_video_free(struct usbtv *usbt
 	vb2_video_unregister_device(&usbtv->vdev);
 	v4l2_device_disconnect(&usbtv->v4l2_dev);
 
+	mutex_lock(&usbtv->v4l2_lock);
+	usbtv->udev = NULL;
+	mutex_unlock(&usbtv->v4l2_lock);
+
 	v4l2_device_put(&usbtv->v4l2_dev);
 }


