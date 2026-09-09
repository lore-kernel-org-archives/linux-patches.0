Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21341577E5D;
	Wed,  9 Sep 2026 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963303; cv=none; b=l4bndmLvNiJ2e7R460CkvozhjzRzmO2VNU20xS66ms6qg9RioesLMTV0YsvnerOio6vYWxVoVgGXFO3zWAlp2Y8MP9c4RuaJxEJvZAj+Q9lT7dqFH2B5C6gqqWUWJcTvx1pfCrStpA4OFl8JYi9lz9HCLmMxvlwBZZ3yLFr875I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963303; c=relaxed/simple;
	bh=9b3k4H/nrC0VFftsS6cHIBdr8OgJjX4CQ7FFxz3KXCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTE3UGB+2fBay2oZFHwz0PMb8ddyLGdc0l795As2Zq+P/aqQE5wkA9ZV619ZnMpY4UjSjNm2fpP9bg84vJROJjd56ehjXqOY0EGVljfTPv2A05JRF4cQBurLZKXmbz7f78NNmpsgL+zXDMNttON5UvE5vEEfomd7eWPZu0OspJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po4m10WC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po4m10WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6749C1F00A3D;
	Wed,  9 Sep 2026 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963302;
	bh=N0QMJkPHa+/yfJa97ei/IhaOt4V7JpqaE6y2i3rPAnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Po4m10WCUPsYQujGXaZ4l5R3fwjAwYDfL6vwr+7ZlyKbRXTq7AIoo0lxET9GokvzS
	 uB6oocx7Z+W+5HpzmfJc5Noj6bjlF7Ij0iP9AaxMJclaU23m4U1YmzlhzE8iu6L7Ew
	 vHxKIwvx4oRuwc0XT3vm1XzH3tGiQIbfrFKVS9Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 6.18 031/583] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Wed,  9 Sep 2026 15:35:16 +0200
Message-ID: <20260909134238.911151048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


