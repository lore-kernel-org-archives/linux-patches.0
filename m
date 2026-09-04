Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE562264A3;
	Fri,  4 Sep 2026 05:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500508; cv=none; b=F6AkxI6KCvquXQ8LQ8gNKORZIUMYVRUCYwW83ByzEdF4UQxJ4fTdwYZKvEppr9Su8O0yTohXDu53BuFyp/XMIWiZOToUQqOzW8RDvh839shzzW6ntserh93CEO215QhM4q8Gfjaq+W5mgVs4dI+m52/UOp8ZpoZg6q4d0bmrQjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500508; c=relaxed/simple;
	bh=xcBlsHEFGovYD0JnwVNVBcNrR16RTWkkgnkHOtmsFiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQp2xyhuFpGm1XmL7Y5g4/TiWDStyBUosi1idwTD1SNpswXkIWk8LuT2OWZZwFaCkwOX/f88Xldqzgu1dGFo5NvRgKwZJzujGPhg0/IggtN/M1b3BvpkV7djjNUSTmfzDraKHgRFl3db6Wpdz2IkqsI6A55POvQkTUKzAbJIfgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJvK2kkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJvK2kkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD5E1F00A3D;
	Fri,  4 Sep 2026 05:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500507;
	bh=YrQcWmXTZEwafXVhLyRUml3Ui5OSOCuYhe75rgfHSow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJvK2kkRkPri5/b2UQeKaoQ5CSYpnNgiIQvgn3dKs3qdy5z/lAIGqSINvAea0b1Zq
	 +96lnq/C1iEw2UWPvL1Fe3j6xvKJ53QcyM88j5Wj/rTZopOiSHlAWI5igzwFH8uNUA
	 hkeovzsAfx3pmDqHZyzhj1z5LsPsgiDW7sXwpmOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8dcac923582c28505fd7@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.18 082/552] usb: gadget: uvc: Fix null pointer dereference in uvcg_video_init()
Date: Fri,  4 Sep 2026 06:53:59 +0200
Message-ID: <20260904045749.727357469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

commit 5b1da38592efdc1a263d4c0353298cba19e9d6fc upstream.

In uvcg_video_init(), if kthread_run_worker() fails,
the error logged uses uvcg_err(), however, the pointer it uses:
video->uvc is not assigned at this point, triggering a null
pointer dereference. Fix this by directly using uvc->func which
is assigned already.

Reported-by: syzbot+8dcac923582c28505fd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8dcac923582c28505fd7
Fixes: f0bbfbd16b3b ("usb: gadget: uvc: rework to enqueue in pump worker from encoded queue")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260804034338.7976-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -821,7 +821,7 @@ int uvcg_video_init(struct uvc_video *vi
 	/* Allocate a kthread for asynchronous hw submit handler. */
 	video->kworker = kthread_run_worker(0, "UVCG");
 	if (IS_ERR(video->kworker)) {
-		uvcg_err(&video->uvc->func, "failed to create UVCG kworker\n");
+		uvcg_err(&uvc->func, "failed to create UVCG kworker\n");
 		return PTR_ERR(video->kworker);
 	}
 


