Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB1342CB1C;
	Sat, 12 Sep 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227918; cv=none; b=lUWdLDmtpK0O5AUMjoWzkr1XGNroJWAhBsBvyHTvGfotVo6ECt7M03hpA+hl20fZEsIXTujl9uRCjpbTn8drMq+TFeb9CHjkiynY3f/fJ/h9rGnEt5/OYLq89lMcrfeNfvU2dJa8ckMxdD+xyPazCPi+YZrl8/wXmIe/8j9oAjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227918; c=relaxed/simple;
	bh=HmiYvLUCTFd7TCtlxn+VZqUAlQqciGxQuNDTn7QU6zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ythx3Ewu+l9w8Cr4FhUF4bg/HlhFYMhHeXk9BaX++KcMT/RK/YBsNt8jRTzdWVoZ3U49iRtXLvZV+E3DRqi9xGq4hYdcKaaSAvpp+qKNDqCbNcNXv94axapKyB1xZRAGSnWEAaQsP1S9TGtMKpzxHRhHY46tpR0NoWCtBftSumA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEAhMQ8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEAhMQ8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9594F1F000FF;
	Sat, 12 Sep 2026 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227916;
	bh=9PsD8oI+QeaYUJ4HFfit7jt+LVtsAeB+Lkf19jVYLpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEAhMQ8oW+inLxH2TxP/f5yNRQdna36S/5gYf95iaMWxQHxl7rg0eFIsAjb/baXXc
	 xb28W9KAG5Y6qkc6yp/41huMiGTiPbqiPELMj8FcjOm0Wro0pQ/7L94Sa1FVZ4Ld9s
	 i68XPbxhPr9MQAOjjTZYDL7LHHsRw8dCQ2S6DMmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 6.1 0277/1191] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Sat, 12 Sep 2026 08:50:05 +0200
Message-ID: <20260912065554.447973332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


