Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF3C45C713;
	Fri,  9 Oct 2026 14:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555853; cv=none; b=thdrrGoilQHItnyYEEiV5rUs2HTyYSB0ILLKYEAHPZ2I3pMRdTfkzuzjgrCmmm+6X6DeFP+Lq7885hW5UmsCEQ6UC3/8OkZJBg0LLor+VnDvOGaLPLnpJDLxmxkDOvhCjhVeqcFfJ/aaGNQy782LcB5b4e4hwEJ6ORWbF6pdxXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555853; c=relaxed/simple;
	bh=CYSKxn44pN6AafVkGWWAXhwtSpid9KnLy1cbeIZCFEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltkrgil2+zOACGD+Lw8CkSHr4B3OufvujEYdl+QKo3TqJu6o/gewTzw+aZSIxCdbrpLWwYS9wct0tgzkVjGdYFcdzYvbLWd4ynrZ+6HVsKBTGBSgezgFy8T3QWXMWLTzM5mOmEEODObGKk8y5np4LzPD65pcEW2+VVjFZaUJ+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckqP4Q7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckqP4Q7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5146C1F000FF;
	Fri,  9 Oct 2026 14:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555851;
	bh=1v5Nf4hdC1N+uQjJxQ6M7xM6Cwij7IvE+fsi83Tl4fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckqP4Q7PxaRNmltC3kYbO6QAcP+xj0s/qD6mebyHWK7Pc9o3uCxzv+eigf5bN5Hwn
	 xnTKriAZqYLdAJvnEA7l9O+v0UOz3Ic2GX7dgoP4Gc/qJqo8YqPeI6YWfRyXEPYpl4
	 bgFj4DT++2F736RqQe8N+rGvjK5MnpcnpkbNPHIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 062/428] ALSA: caiaq: unregister the input device when probe fails
Date: Fri,  9 Oct 2026 16:06:39 +0200
Message-ID: <20261009140947.503216890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

commit 0b7bd20f6379bc5e431fd74d866390f5b5b63f3c upstream.

setup_card() registers the input device, whose name and phys point into
struct snd_usb_caiaqdev, and then goes on to snd_card_register() and
snd_usb_caiaq_control_init(). If either fails, snd_probe() calls
snd_card_free(), which frees the device state but leaves the input
device registered: card_free() only clears the pointer, and the input
device is unregistered from snd_disconnect() alone. Reading its "uevent"
attribute afterwards dereferences freed memory:

  BUG: KASAN: slab-use-after-free in string+0x4a9/0x4f0
  Read of size 1 at addr ffff8880208f5043 by task caiaq/4967
   add_uevent_var+0x183/0x3a0
   input_dev_uevent+0x162/0x900
   dev_uevent+0x2f1/0x870
   uevent_show+0x1ca/0x3a0
   ...

Unregister the input device on the probe error path, as
snd_disconnect() does. snd_usb_caiaq_input_disconnect() is a no-op when
no input device was registered.

Reproduced with a raw-gadget Audio Kontrol 1 and a temporary hack that
makes snd_usb_caiaq_control_init() fail.

Fixes: 28abd224db4a ("ALSA: caiaq: Handle probe errors properly")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2a123f6269da57ffefaa
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260925170717.22462-1-ngocthang2710.1999@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -562,6 +562,9 @@ static int snd_probe(struct usb_interfac
 	ret = init_card(caiaqdev(card));
 	if (ret < 0) {
 		dev_err(&usb_dev->dev, "unable to init card! (ret=%d)\n", ret);
+#ifdef CONFIG_SND_USB_CAIAQ_INPUT
+		snd_usb_caiaq_input_disconnect(caiaqdev(card));
+#endif
 		snd_card_free(card);
 		return ret;
 	}


