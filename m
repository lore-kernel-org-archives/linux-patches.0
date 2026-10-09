Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C61231C91;
	Fri,  9 Oct 2026 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556391; cv=none; b=hbUGgYpWX+CuKepYo2fymJ8LlElDOxjb8+CAEpVwzFJHCQS8TBZVOToo+0ngkdXBiXlVrPqAa+nvn6UDE+Zd+thPZE4RDNqHei8RVeUq8Ru3ZH2x2//XlCuPuz5zb/5+e58HpWbo2M86YYZo4EQxDszE+DJ7bjvH5ppjeOSVdaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556391; c=relaxed/simple;
	bh=p8glZ66iAb8wBKrVql0ARCk4+e009Nsx2qD4mKk94q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB/gfV67FFglAQA2LhzApEmjy45kCzwc7jgp0QQEnQ1sqolz9YI+AijGJNlV/hZb1QTD7LfOUGYer0rQj9AHA5fB+gsAvZJrEAWxHtqXlULsuwJ/x8LDrO8jxsmUhysvq/1di0nT+JWR2GbYM9MH6dt/Svm2OSbXVd0hcmt63fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGgIqSNO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGgIqSNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7EE1F000FF;
	Fri,  9 Oct 2026 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556390;
	bh=qBX/AzbN0T/umS08zlukkwT4owwXDVc1B1dc8Dg5Ozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGgIqSNO/P4QHBdyppf3hp+nrNAxIznRTcfMr1GAnjNF/Km1Qwn7jv0JUJZh+wf55
	 b3up4EzdxDKsrPwwc7a3l60c/iBjWj+OC2JwZz43dN6jrbUc/xa6wpeblbwTJKJfJz
	 BYY9W0TbzHFbCv522+75T6j6Vqo6Niqqhm75qsdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 226/403] Bluetooth: RFCOMM: Fix initial port reference race
Date: Fri,  9 Oct 2026 16:09:47 +0200
Message-ID: <20261009140957.435916619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 2d696c1ed3468dcb62578a3911e687110d463520 upstream.

For RFCOMM_RELEASE_ONHUP devices, rfcomm_tty_install() and
__rfcomm_release_dev() both use RFCOMM_TTY_OWNED to decide who drops the
initial tty_port reference. The release path tests the bit separately
from the install path setting it, so both can drop that reference.

The synchronous hangup does not prevent this race: port->tty is not
assigned until tty_port_open(), after installation. The following
interleaving is possible:

  1. Install and release each obtain a reference with rfcomm_dev_get().
  2. Release observes RFCOMM_TTY_OWNED clear.
  3. Install sets RFCOMM_TTY_OWNED and drops the initial reference.
  4. Release drops the same initial reference again.
  5. TTY cleanup drops its reference and frees the device.
  6. Release performs its final tty_port_put() on the freed port.

KASAN reported:

  BUG: KASAN: slab-use-after-free in tty_port_put+0x22/0x190
  Write of size 4 at addr ffff8881001d3d5c by task poc/92

  Call Trace:
   tty_port_put+0x22/0x190
   rfcomm_dev_ioctl+0x1d4/0x1930
   sock_do_ioctl+0x110/0x260
   sock_ioctl+0x380/0x590
   __x64_sys_ioctl+0x134/0x1c0

  Allocated by task 88:
   rfcomm_dev_ioctl+0x8f6/0x1930
   sock_do_ioctl+0x110/0x260
   sock_ioctl+0x380/0x590
   __x64_sys_ioctl+0x134/0x1c0

  Freed by task 65:
   kfree+0x131/0x3c0
   rfcomm_dev_destruct+0x23b/0x2f0
   release_one_tty+0xc1/0x370
   process_one_work+0x661/0x1090

Use test_and_set_bit() in both paths so that only the caller that changes
RFCOMM_TTY_OWNED from clear to set drops the initial reference. Each path
keeps its own lookup reference until release or TTY cleanup, preserving
the existing callback ordering and error handling.

Fixes: 80ea73378af4 ("Bluetooth: Fix unreleased rfcomm_dev reference")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -465,7 +465,7 @@ static int __rfcomm_release_dev(void __u
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
 	tty_port_tty_vhangup(&dev->port);
 
-	if (!test_bit(RFCOMM_TTY_OWNED, &dev->status))
+	if (!test_and_set_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);
 
 	tty_port_put(&dev->port);
@@ -727,10 +727,9 @@ static int rfcomm_tty_install(struct tty
 	 * when the last process closes the tty. The behaviour is expected by
 	 * userspace.
 	 */
-	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
-		set_bit(RFCOMM_TTY_OWNED, &dev->status);
+	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags) &&
+	    !test_and_set_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);
-	}
 
 	return 0;
 }


