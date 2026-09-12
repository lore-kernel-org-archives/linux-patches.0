Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E072F8EB0;
	Sat, 12 Sep 2026 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221198; cv=none; b=mPZkMPF4n/bHavSx48MVs2Gs7Eag1TncYKdScfU8HI5QJuobVB43yLGfT4TNv9N3r3oV00mi/yjZQNMdCNXNcCWaShXspNo60EANGaIT3MzUEINWQXzgqu2qvvmZLwhwOREwBQsKjulQS42Mk/nN5xibONV4IXqc2sorjjcwtSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221198; c=relaxed/simple;
	bh=hoIi5FAB0UMqljNLeNzgpZh3E9sR4OTCJHD+Oe3rt54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7LvwWtvmZUsf4eQbhujEfS5+Q4t3sot9RTpo9GMMg/qlfT3E/Tk1dNW6dv6TMlEu95NI2nazCCM9gZLGNhLL63mY+MRzK65ZdwOSJJpSA8J/li1K9HhggI0IsXY5nFWTgGWAbdHJCELIDC40HgN8sh6Q6k0Xmo4grQaATdGWoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNUC2UdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNUC2UdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87981F000FF;
	Sat, 12 Sep 2026 13:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221197;
	bh=dvckzZTLA1BO+iQfPNkbM8Yo5fsNAhyrmWsRF2klLFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNUC2UdE7tLYE00HNDeh0atr3cTHc7MUBfXcEecuIz+UqoEMhR6pPgif6sdKf+SYj
	 pdsQ0qU+lub3gcTkJp5EDB3hzBPl4kw8mGsiY9n/GiphfM9EgrRvYCRbj133katMdU
	 6R54uxleAZFJidCsEiAwwYcc/vWnqjU1aK1gYP+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 6.6 0333/1424] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Sat, 12 Sep 2026 08:46:05 +0200
Message-ID: <20260912065614.744214364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


