Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8419927932D;
	Tue,  8 Apr 2025 12:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116069; cv=none; b=DRymHLLjrRwC1/L8skjqT5dOqBVGerTRXdgeiWJ05jdnV+4E521eLaCLntMZaqpxNCx8eRtU9UwPE/zqicw4vOU4NeYZy7bwQsuGtIwQPQJMgX9fOFJBJboLt2i3QAkjLt5qaHFCpsCx2ZDUTL/gSeqi02Sk36g6w4gI38NtHgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116069; c=relaxed/simple;
	bh=l8iNcYeM6ChrNpXZY5iM+3szAUCr8pxjGnCPcBYNfOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ip4WVAyYEGAvex788ioaz1FCLYCe8FMrR5KWdWP+81rDPLj9C0ODMf5aaf4g0lhnKse7n1200WhBBdLMprbUo86DW8/3dWukihhQsoHGsUPmXBew3U5k11IJ8z2vFmAJzduabz13+8n/qlkAOefqN7tN6RKP3cBP46tVsZA7P+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=likI+4Mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="likI+4Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1403AC4CEE5;
	Tue,  8 Apr 2025 12:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116069;
	bh=l8iNcYeM6ChrNpXZY5iM+3szAUCr8pxjGnCPcBYNfOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=likI+4Mk+cJtCMgIyJ46rb60RsP8RfrQoe91FEeAGA5hwTqUdOeJdXPiznZ7nMGDG
	 iJq5QYTvDy1Lmi6XTZhCIV5LkhAn74KwwpnHODJ/8sjVWLwKr0tCn5QdoEDUuQLnpi
	 67ZupR77TQpH/ECNJW25g0Rya0ae3/gmSm9F27qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+34008406ee9a31b13c73@syzkaller.appspotmail.com,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 202/204] media: streamzap: fix race between device disconnection and urb callback
Date: Tue,  8 Apr 2025 12:52:12 +0200
Message-ID: <20250408104826.248611418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


