Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B5B40DB22;
	Mon, 17 Aug 2026 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976964; cv=none; b=f/dpzyreq46qbpKiAOmbaYk0aZ204O7+M7rQ9C7ZAc2qgKY9xMOJJK/PKoRl0683dCCaI3O/LHfi8fY45KgmJSSRM3crG/MAZM7BOnQPD8WgIlQ4yvSZla53Sn6E5WMGO0TsQY563cFhuSBSVpckaRjq4Mp2uIUZKz9wR/XM52M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976964; c=relaxed/simple;
	bh=3FpLqbGylOTPP7hz+GWC7cjDYUPlf6b36ojzDzuTiA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPOkKcrvCK38uucfS0xUJ4bxf32db6LhAR4BMHxqdHN/SqIDPJGCzgBG19tlDOZkMZZGj4PUUmyAQRwmuLg0XUWYobVmTHeXlDQaBfxFhRXYccVd0Gq2mySDpGCpcpV8TKY4Eb8im2tuPPQXuGPmKxz0m5K0JaRVUSyd6aoLgog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp5e61k1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp5e61k1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7054E1F000E9;
	Mon, 17 Aug 2026 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976963;
	bh=1wxoKEfyMo72fW31XTgHntNStMzcqckey1qi5o6RiSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pp5e61k1h1qeTVgFcxAW4xyrk5UnMo2JlfYwgcXDDyFeikg0+0XYR5gs/KMp78teA
	 fHgps44R6mczGnfZjOs04mRuAelqSd+fqtEtlZ5GOFRu5aKDBwAcJJEsPwx0tG+lfT
	 DGyRrmIho/zKd1JxdnJkyU9DhyZwAoJ/oDzX+Bw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valery Borovsky <vebohr@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 165/456] media: pwc: Drain fill_buf on start_streaming() failure
Date: Mon, 17 Aug 2026 15:29:15 +0200
Message-ID: <20260817132546.544937345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
 


