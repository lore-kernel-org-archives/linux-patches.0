Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAF525783C;
	Wed,  9 Sep 2026 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961718; cv=none; b=J3Ppp/rBOQ0mSjfLnMFvWYQjYu19/R1rqQFUKYnUtsZihsp25LxYrzx3OsrWdWSyWDV39vGmBx6BlqhVBZv+oYqD5Nj3Yj9G6dbRGUy/4lSxeQn+5gL0tDuetNl2p7kCdmS8wqF5BT37fMF3/XGwRysOxFHEPTmJGjnobQOIthw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961718; c=relaxed/simple;
	bh=S5/gHBtVG3mV4naRdZ48BESbipoF94gSrkJNvvXi+HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeEE7Ti6VLDZQ0EhPTHwAt+JjY4T9rdP3YT6dx5JhmKnRxaHbBVNrZk/ohwkyH0G5RklzoTab5S60JLzl2t5xDqGwo1mDGvRbGcsxw+SFwhKKaS92DVyyR0HWJLJaYsnsu98XVw5sk2yv+aGg2A79Cd7YqBa6zhf6cJRRjqjmK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5ivHHSG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5ivHHSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA06F1F00A3A;
	Wed,  9 Sep 2026 13:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961717;
	bh=rcBZ2WM8Kdc2sS6TugrGgjGEFrVyXwMyqMQrUryqJ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5ivHHSGnq6Su5NskxPz1P6IgPa1WSUu2pJ/Vk1U5Kbu+sItgA3girZov8Ef8VbTd
	 IASUju1MQNLF94/qzQzfUDET0Wc2GxO3xbT9Qup+WibklNI996tkTVR3fOR3vo59XY
	 Uu1zJc1vd2Koux+qLQSSW9t30LjPhEXN6vm7lqEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.2 045/556] usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()
Date: Wed,  9 Sep 2026 15:35:25 +0200
Message-ID: <20260909134232.071337763@linuxfoundation.org>
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

commit 2c0f5ca48674a5b5f9fa4a9c3325aa48053af0bc upstream.

Previously fsg_num_buffers_validate() was removed as it was not
necessary due to Kconfig setting the limits for n from 2 to 256 with
default as 2. However, setting the page content in such a way that
kstrtou8() reflects n value as either 0 or 1 bypasses these
restrictions leading to a null pointer dereference if n is 0. Fix
this by adding a check for n < 2 and returning -EINVAL if n is
either 0 or 1 consistent with Kconfig logic.

Reported-by: syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=791be35f1fbcc85d06d7
Fixes: fe5a6c48fd95 ("usb: gadget: storage: get rid of fsg_num_buffers_validate()")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260818035904.10324-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2748,6 +2748,9 @@ int fsg_common_set_num_buffers(struct fs
 	struct fsg_buffhd *bh, *buffhds;
 	int i;
 
+	if (n < 2)
+		return -EINVAL;
+
 	buffhds = kzalloc_objs(*buffhds, n);
 	if (!buffhds)
 		return -ENOMEM;


