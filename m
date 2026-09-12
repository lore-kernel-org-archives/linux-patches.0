Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F37C2D0C94;
	Sat, 12 Sep 2026 19:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241848; cv=none; b=WIgief41XmYOWlW5Vv/to5qyFcH4EZxCSTkSC8F1EJhwQXJQwy6LwnQaaG3hRuPS3CLyFJTyQ+fMHWECTMK04nl9jleGy0C3Mu3J5QU/s5ybmdqn5D2R6s2F6iKuJVEFsQ+kRTOS1nma+xTGh4PDGWgncP3CTZzDyhFChfzfoio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241848; c=relaxed/simple;
	bh=zlIn99PmF57OENtvz9+W9cW4ffqBFp3JJHyU3BiK6HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odcBi/xHEtdmjBc12g6NBp0VBahzkd+K/22woXolbMoYEhzOo8dJrjbhMCB/02qytR6GHevEs5fkZPZV4i0FqOrsVEh/rF3ueGbHEk2RGO1FiJrb+DRSGVTmYxPvzS2XTWa138+1lwVCaNJeAaNXwRxsvRKLUOflRrINd2omOCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2TiMEpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2TiMEpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474A41F000FF;
	Sat, 12 Sep 2026 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241847;
	bh=Rko+v+jvnP2xB3kqfFvLeobmTEB2KaVfwcH1CRmEDV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2TiMEplyOgYZPv3qvE0ZcIdsDVOPEAWKZUZaKHsbuGGpLLApQSLmVu1nKKMW+8/Z
	 r38ghTsTdbUis0MZYZDVRTkkXuoEbV2ZX6JBZSbKvqlozwdQrtM0lDKbl52uxVJhfg
	 5VJwtF25uhnu3fMhIwvXZ6S2y5ybNuxENIclUMXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 5.10 220/798] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065522.165237255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


