Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE0224EABF;
	Tue, 29 Apr 2025 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947281; cv=none; b=lz343zsu72fJ8z3FYhIxa2ypQJ6nPC++uA8OyS/BzGSbHnxowmuASEcy888okvqO9CNNoNzVDWQAXvMlMeGPmklJNNyz/5W+nclmRmTVfzYW3HysHfcNVitxlEmjPw56lwW2hfLr2MTF9hAI/AsfZkIevnchu6/RAEK1YZ5g5K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947281; c=relaxed/simple;
	bh=kv4y1C3BgTurkJ0D06yDAUo/inzyDj4OkZMYG7Aw8kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZMKg4DbC2Gw0HH3ZVbtfGEARut8WisBjlHCGgvgqRO41/m2MBEehSSd7Jdg2tXa2+hJ9MUjBghM+dqqz/8qGbkBR/oq+Gn8FBlCy3uYqirZox4xCBgL/Z/HkXcn4JQJ6nWr0GxOwsuMyYcGXlv7I/pgfBd3kj9HaNtiHQqzDMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpmsCUEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpmsCUEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B97C4CEEA;
	Tue, 29 Apr 2025 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947281;
	bh=kv4y1C3BgTurkJ0D06yDAUo/inzyDj4OkZMYG7Aw8kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpmsCUEFvFMTl3Mq5/gru0ErDozDilIOZCnMC7tzUzZmSR/3yzJWwlRwFoB03vT75
	 LRAa/jUVgp+m+1o/P34JKU4c4fmsT3VfKXYTU3C+PGxyHPx+5JLw4+hCBgQZlL+eBW
	 IrTfVbO3OUOnmn6TYQ5Jsd5dmp8xunSJCh4CqWPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+34008406ee9a31b13c73@syzkaller.appspotmail.com,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/286] media: streamzap: fix race between device disconnection and urb callback
Date: Tue, 29 Apr 2025 18:41:45 +0200
Message-ID: <20250429161116.224536267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit f656cfbc7a293a039d6a0c7100e1c846845148c1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index cd994e27362eb..c0a48f991d9d2 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -433,8 +433,8 @@ static void streamzap_disconnect(struct usb_interface *interface)
 	if (!sz)
 		return;
 
-	rc_unregister_device(sz->rdev);
 	usb_kill_urb(sz->urb_in);
+	rc_unregister_device(sz->rdev);
 	usb_free_urb(sz->urb_in);
 	usb_free_coherent(usbdev, sz->buf_in_len, sz->buf_in, sz->dma_in);
 
-- 
2.39.5



