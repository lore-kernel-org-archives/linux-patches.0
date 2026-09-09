Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E55625ED;
	Wed,  9 Sep 2026 13:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961732; cv=none; b=MD7qzQIlq+f0s6wfytzFKHP9E8ir0TGioNUdcHFkXvv877JEcljLY0XkBEkyaSTIQr4HcHcG5RtrTkoM8vB7A3jTGz5TXL6R93QQDWsfbnCH8KBQ7lWCu1YbHKBuLx9IGY/a1kIvrkJ3f2mQ4NyGYA+USXRLkg6VX10yDGn7Nxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961732; c=relaxed/simple;
	bh=syAyRczKg7/iGeYsbLaAAv42N0iIv8uoOhg9CwulwIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chsaqAkRZFzIYtITQnbr/dUstSIDudLiyJqCJxjY5Xd6QyvPxHSWmqmvALeFOqZKXzgRoJuREFEPejJux3+TiDMUaB4sm+NsdHUK6INQL1j8TdTfjvK/XNOM7d20/uLIQ+89qf3mOOgMX2kjRTw6PfRmGzs/TRxRn+L/yxbE9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppxzU7+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppxzU7+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2558F1F00A3A;
	Wed,  9 Sep 2026 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961729;
	bh=XKB6p1gHNZnutlZReiZ49qKoTuXIvYnSjVeDrL9Os+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppxzU7+EbxeLFIo79gCQ714c4eqt62iKns97aYTxJR1y1vBHercqmw6g7OEnvYOov
	 /Qipvsyc/ohzFqbmuMKJB+46Af8CYGb4EjrMpyXTnJ+QttNLJNf0pjxl9aEZmWIWj/
	 k5knsnQ2vXNLYhaWbKg6aBJciSdnRzO2IegKL0dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 7.2 049/556] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Wed,  9 Sep 2026 15:35:29 +0200
Message-ID: <20260909134232.205341400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

commit 6e74ac5c596fd246e37eadfc354567179ccbe9aa upstream.

usb_put_function_instance() attempts to dereference fd inside fi struct
to get mod in uvc_alloc_inst() error path. However, fd is not allocated
until later in try_get_usb_function_instance() after allocating fi in
uvc_alloc_inst() and thus guranteed to be null in error path. Fix this
by adding a null check for fi->fd that returns if fd is null.

Reported-by: syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd6ef980cf1c722be639
Fixes: 0062f6e56f70 ("usb: gadget: add a forward pointer from usb_function to its "instance"")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Link: https://patch.msgid.link/20260816061712.15547-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/functions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/functions.c
+++ b/drivers/usb/gadget/functions.c
@@ -70,7 +70,7 @@ void usb_put_function_instance(struct us
 {
 	struct module *mod;
 
-	if (!fi)
+	if (!fi || !fi->fd)
 		return;
 
 	mod = fi->fd->mod;


