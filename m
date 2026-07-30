Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B02737A494;
	Thu, 30 Jul 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427668; cv=none; b=uWee/TSFZOFlEtfRVsuQtNGibC0dfcaMc/YxmmpdOfkLohIau3y8AZ0IS+rw/pgzGnjNdbhhwrmGzm1r/5/9nVEixBFCoZzgorqacaNR5Rp3k4NGjY/qE3Sr4vCmbgziSJ7UdC2q/IbcLbcJhwqeIFngR7u3ibHKS++5DT4DD/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427668; c=relaxed/simple;
	bh=1LE6YzqWUj9IwoH1nYP2lHSFCzXpo3+YokC2j4kCRXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxPirKLhW2QAB+j1s2UAmMomsc8nZGfeenMDEU5RqXPhwinMwM32AtitBD53nEgkHvLFGlPODpJ8t0Ce0zA+M6HBJWab8RzBcNsbjY7iZTaYtb0ER8ggX3pk+zoHXqZOZAac6UkHhng7WUswF6+GgYxL3KTUYXnb8meBTHbYwHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAqSmQsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAqSmQsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01491F000E9;
	Thu, 30 Jul 2026 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427667;
	bh=TIhxrYc+pZdwLHl76kgeh1d+wZ0kwfKMmREkoSu4vVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAqSmQsiu4JhjDPAdxGqhnR61r9LPWoWbdv68WJz8F0vLvgwIt0QiAV1k0Noq2dce
	 JpJldGJo6sgTHX2/apvLqYcr98DNdSEBjFi3CQROAMXiTlyq+gpCQKse7iA9upqP2y
	 DAXgs+gXNlZIZBgxSNBXulxJNlt1HLl8i6vkszT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 251/484] media: pwc: Drain fill_buf on start_streaming() failure
Date: Thu, 30 Jul 2026 16:12:28 +0200
Message-ID: <20260730141428.940722774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Valery Borovsky <vebohr@gmail.com>

commit 906e410dcffbbd99fb4081abab817a830033aa28 upstream.

pwc_isoc_init() submits its isochronous URBs with
usb_submit_urb(.., GFP_KERNEL) in a loop. After the first URB is
submitted, its completion handler pwc_isoc_handler() can run on another
CPU before the loop finishes:

  start_streaming()
    pwc_isoc_init()
      usb_submit_urb(urbs[0], GFP_KERNEL)
                                  pwc_isoc_handler(urbs[0])
                                    pdev->fill_buf =
                                      pwc_get_next_fill_buf(pdev)
      usb_submit_urb(urbs[i>0], ..)  -> fails
      pwc_isoc_cleanup(pdev)           /* kills URBs */
      return ret;
    pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_QUEUED)

pwc_get_next_fill_buf() detaches a buffer from pdev->queued_bufs and
stores it in pdev->fill_buf. The error path in start_streaming() only
drains pdev->queued_bufs, so the buffer parked in pdev->fill_buf is
leaked. vb2_start_streaming() then triggers
WARN_ON(owned_by_drv_count).

stop_streaming() already handles this since commit 80b0963e1698
("[media] pwc: fix WARN_ON"), which added the fill_buf drain in the
teardown path but not in the start_streaming() error path. Mirror that
handling on failure so start_streaming() returns with no buffer owned
by the driver.

Issue identified by automated review of the INV-003 series at
https://sashiko.dev/

Fixes: 885fe18f5542 ("[media] pwc: Replace private buffer management code with videobuf2")
Cc: stable@vger.kernel.org
Signed-off-by: Valery Borovsky <vebohr@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pwc/pwc-if.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -727,6 +727,11 @@ static int start_streaming(struct vb2_qu
 		pwc_camera_power(pdev, 0);
 		/* And cleanup any queued bufs!! */
 		pwc_cleanup_queued_bufs(pdev, VB2_BUF_STATE_QUEUED);
+		if (pdev->fill_buf) {
+			vb2_buffer_done(&pdev->fill_buf->vb.vb2_buf,
+					VB2_BUF_STATE_QUEUED);
+			pdev->fill_buf = NULL;
+		}
 	}
 	mutex_unlock(&pdev->v4l2_lock);
 


