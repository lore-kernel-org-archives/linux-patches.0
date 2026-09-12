Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F8F2C1586;
	Sat, 12 Sep 2026 11:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213001; cv=none; b=JoSXdCRKf0n9B/YA79qK8taU+NhVCUhsfza5r7Hhr4Kd+j4bkt5OKUUJmHTjpvHidBBScoC/kfVji0nUBvbRVOkD0i5AxySGU4mCtqV5OPZ6tI9HJZFlw8m93oGCvgZBEuonEKMXDmplBh1wbRBslZ3NBHmHot/Ujopv8WwlwS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213001; c=relaxed/simple;
	bh=6uGmrCqL9l/Rtv+GzMKH73Vx8KzsjzIKbnojjhbLjxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8hRy2+F9hWKTucGuOTKSH1qzggAtZ7kTjB4m0hK+Pc2gq6AQf04U7g/o5I+hGxLNhi0EHMfkVZqkN/DGUtFgWFKPO1Nesdi5X0X9KuYjHDmqOYsbNik8v5pWZsh3d8eBjsUApOLJmY7HpqpJoUFUak35fh/X6wiz8NKya+0q1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxVYbBqi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxVYbBqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E48A1F000FF;
	Sat, 12 Sep 2026 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213000;
	bh=ti9Rcj05tOBm7ucgiXKDuGsqMVQcNwt8yd69qXWxzHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxVYbBqifLWThimB2y6SVzikQtSU0CHoxSQA45g9YBIIiU8o651q3oiji0Knkj4/G
	 4/AvaAuNf16JyflMJYyCWJ4FJEme5bqfQ8xROUzcceXfMVQLSbYN5J5CIW+twfFqJ0
	 f2rv6BGGQkT6hPIr2BSOshdQhtOLUkYrIXoxi0JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd6ef980cf1c722be639@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 6.12 0031/1376] usb: gadget: fix null pointer dereference in usb_put_function_instance()
Date: Sat, 12 Sep 2026 08:40:57 +0200
Message-ID: <20260912065608.247315445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


