Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C3E490BFA;
	Sat, 12 Sep 2026 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237360; cv=none; b=SzfyCW8PozsByvlEekpZv73/gMEOu3TRzWEslfU9WveDMS6dGa1hBiYkKN2AJ1QemlYFkfRkQf39k7kVFwYhaBVM0jjm0h/PF3sTkFahXGqqXchHYxxGb1XQsAw+IMR1y4sC0qTMK+CYiBbBBg5UJarfGqzTdWfB8u5ZyBiYNDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237360; c=relaxed/simple;
	bh=kQPAe4P7M3PtRYVHL4RdvUL87AQjOghpjTavZ68E0Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7kdiw1XCd75AudW9XN7+hnoWW9CnJz6KVX7nK4daRbnKrXGeU29J0SOVKiLiK1IAlvxDfriuYI0zBVoAwiNVM/5OePRdN61ahu8VbG78oPb6PP/FUze9aeCB71RhRG0jPqUdqeXZJU3gDDcNA/sO6E+Kl4JNH3SzzAdKW5VT/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9oSwMBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9oSwMBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8821F000FF;
	Sat, 12 Sep 2026 18:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237356;
	bh=ikFlYQx6+apEDCfRaiqpdpFyyf4ZtRGivknaB6lVgVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9oSwMBmUgBjuaLmmzko3afeCwEhgDgrcDRGFvUKO7Hu4JfP06Rm5VQlRwt+/TvrH
	 OzvQCz8y2LIIrsAA1rqda8MjrDE32dB+f8fHSGC6ldTY/OljgWMvsYOWp56BUgsels
	 ptXWpOegznfsfdJxh/JMsuvUSVlvflzoF17RcZ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 5.15 242/935] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Sat, 12 Sep 2026 08:54:32 +0200
Message-ID: <20260912065532.375707014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


