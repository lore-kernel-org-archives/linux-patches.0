Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8681D269826;
	Tue,  8 Apr 2025 12:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115482; cv=none; b=bqy5CNt+qk48RCuFXD5h8UMttYGNblkUsqiVg8+5dFa+1ja2VcqEVX4+n2dldaaHHqPM4F/ShVwXga221p7gDF5U3poY6TnZ+F931pZti/BfBEX58+5kgh8yJMkSJiJEAjWiCxFjE78uK8pu4EAZBFiyQrdqg2gvLvVib7bCYuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115482; c=relaxed/simple;
	bh=zVbck+xKMFwoUs1n3tTKkV1MuNv1Bv3wjVwfsO8drNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHyzN2Tqx47+pUj9pEOpLnwMTdvy4KwtRXtuRwznPC+yK+adTPPkD40lezgxYV87zrhOKneTXgyaV3XmXhfKaEU3rU81GouIwgZW5AY3Tbw96ntoWQ9eJJUXm3Me5+PQsJoeM+6+U/zlMFR2j8xONgmvCFp6Lh+kMQb9dXlGiqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErvPmZEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErvPmZEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFD9C4CEE5;
	Tue,  8 Apr 2025 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115482;
	bh=zVbck+xKMFwoUs1n3tTKkV1MuNv1Bv3wjVwfsO8drNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErvPmZECVOtDherZSqAXlTgT9lO6hcI4qOaiEGJVkxHQkS2tl85p3YzVfCipuVvaD
	 1oZHWMVkrOEPnv5dD3CXL3KdHqGhhRIJ/4OnXU9HXhpLl7TFnYDWCP96QvU1ED43lO
	 SIQJsd6jVEhFqGiy67BORyqEJSH8vC7EQLLje7uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+34008406ee9a31b13c73@syzkaller.appspotmail.com,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 491/499] media: streamzap: fix race between device disconnection and urb callback
Date: Tue,  8 Apr 2025 12:51:43 +0200
Message-ID: <20250408104903.604257427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

commit f656cfbc7a293a039d6a0c7100e1c846845148c1 upstream.

Syzkaller has reported a general protection fault at function
ir_raw_event_store_with_filter(). This crash is caused by a NULL pointer
dereference of dev->raw pointer, even though it is checked for NULL in
the same function, which means there is a race condition. It occurs due
to the incorrect order of actions in the streamzap_disconnect() function:
rc_unregister_device() is called before usb_kill_urb(). The dev->raw
pointer is freed and set to NULL in rc_unregister_device(), and only
after that usb_kill_urb() waits for in-progress requests to finish.

If rc_unregister_device() is called while streamzap_callback() handler is
not finished, this can lead to accessing freed resources. Thus
rc_unregister_device() should be called after usb_kill_urb().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 8e9e60640067 ("V4L/DVB: staging/lirc: port lirc_streamzap to ir-core")
Cc: stable@vger.kernel.org
Reported-by: syzbot+34008406ee9a31b13c73@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=34008406ee9a31b13c73
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/streamzap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -385,8 +385,8 @@ static void streamzap_disconnect(struct
 	if (!sz)
 		return;
 
-	rc_unregister_device(sz->rdev);
 	usb_kill_urb(sz->urb_in);
+	rc_unregister_device(sz->rdev);
 	usb_free_urb(sz->urb_in);
 	usb_free_coherent(usbdev, sz->buf_in_len, sz->buf_in, sz->dma_in);
 


