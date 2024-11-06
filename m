Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A4D1EABA1;
	Wed,  6 Nov 2024 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897904; cv=none; b=Wvvh51MqfsHba5r5hijaQKgw+/otV5CWHXEndtTZALbGw4bkColv0DKMpQtKgbzM0zIVjlfol9abJpYr67czN7k7F4+/YQhm0OVUUW6uvFmpbXoN3mu2pR+XZet+nM3HORwpLZ6Jl+YRbjxTPeEvuVxgrRJ2Cgzn/7D+S3++krI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897904; c=relaxed/simple;
	bh=RiLpxqoJt/kVHbqQOOpPxblUJLjjIUZK0XSonS2UFxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6JgSWg8fVX8OYnkBbBGv+VPEnF3yNJV4Ru77EGlVsRwXtu/muvffMsrauu318Nl0VFDGnFnwA+YAPyDWNTDgfJmiMof3tB5kBzFLDN69tsSGNzUx/fPUzVHMIfaKq5e1Ti2nCohDl2z44hydg5khRAORHsk+YbBx695YXaev8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVkQbkBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVkQbkBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F70BC4CED3;
	Wed,  6 Nov 2024 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897904;
	bh=RiLpxqoJt/kVHbqQOOpPxblUJLjjIUZK0XSonS2UFxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVkQbkBl7Y5YuHSnk8OxuIBSZoIlSWzr1SlvtqVEzwd4mSGh2GGOW4RECCxvvARaD
	 muO83l6HBMh+fY+DPtFoTGGoelMrwDcC6L1MDoQ1m/YRyBZEXcnkLiBRbqoDeCe2un
	 vO/2gMQQFWHlYxCUcsSi5eNyUqJv3imElgiLCI4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	stable <stable@kernel.org>,
	syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Subject: [PATCH 5.4 031/462] USB: usbtmc: prevent kernel-usb-infoleak
Date: Wed,  6 Nov 2024 12:58:44 +0100
Message-ID: <20241106120332.287793676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 625fa77151f00c1bd00d34d60d6f2e710b3f9aad upstream.

The syzbot reported a kernel-usb-infoleak in usbtmc_write,
we need to clear the structure before filling fields.

Fixes: 4ddc645f40e9 ("usb: usbtmc: Add ioctl for vendor specific write")
Reported-and-tested-by: syzbot+9d34f80f841e948c3fdb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d34f80f841e948c3fdb
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/tencent_9649AA6EC56EDECCA8A7D106C792D1C66B06@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -724,7 +724,7 @@ static struct urb *usbtmc_create_urb(voi
 	if (!urb)
 		return NULL;
 
-	dmabuf = kmalloc(bufsize, GFP_KERNEL);
+	dmabuf = kzalloc(bufsize, GFP_KERNEL);
 	if (!dmabuf) {
 		usb_free_urb(urb);
 		return NULL;


