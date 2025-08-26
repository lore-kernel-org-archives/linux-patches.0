Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFA734AB0D;
	Tue, 26 Aug 2025 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218289; cv=none; b=a6psMarZ3NHGHPdcRqlsBdqZTGN2oBgZOXibvEXO2WphBJV8kLBi18C9G78Nt+pGXBWB2iSlbwC4Je73BMyrOf31qmjito5AiIrCVhHvKMig4OQhFAt7562ovrmPDZtfA82OJr308wrei73eE05KEpZ+1IQ3wWLVLx3TuEq7RFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218289; c=relaxed/simple;
	bh=kPkV3vh8azYB0z3FLRFYfYfg22RhmsUPCS8izjyrnW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2tacqQ+AQ0jJWAwKrBHd+C4JN4c3/asg+n5TiiyhjI0HfXPzslzqDtUdtL10AS0gwJoOC1QQNGeFhbmUustq84YblXjPaV/+c+hEUswTEpLwUhuxRD1XEO2axF+WFIj+hJE6mvhMk6PtpipNcwCi8fFxPZ3v/45dypGgI7znMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WST0BP6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WST0BP6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B836AC4CEF1;
	Tue, 26 Aug 2025 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218289;
	bh=kPkV3vh8azYB0z3FLRFYfYfg22RhmsUPCS8izjyrnW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WST0BP6U9//KklPa0p1BMwe6HY3U10mJNRsyN31CssCfjsXPhxSUbnnttlcqEMCTl
	 3eom0xSKYG5hrZxVXDhNIysC2+X5URilYev8Jy6HtCZURGcg2YCB8lpmWB73WiCDjX
	 XopJbq9RTcyURtzBJ1BbUhnwqPKQyisRSjSIm5QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 438/523] ptp: Fix possible memory leak in ptp_clock_register()
Date: Tue, 26 Aug 2025 13:10:48 +0200
Message-ID: <20250826110935.258689354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 4225fea1cb28370086e17e82c0f69bec2779dca0 upstream.

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff88800906c618 (size 8):
  comm "i2c-idt82p33931", pid 4421, jiffies 4294948083 (age 13.188s)
  hex dump (first 8 bytes):
    70 74 70 30 00 00 00 00                          ptp0....
  backtrace:
    [<00000000312ed458>] __kmalloc_track_caller+0x19f/0x3a0
    [<0000000079f6e2ff>] kvasprintf+0xb5/0x150
    [<0000000026aae54f>] kvasprintf_const+0x60/0x190
    [<00000000f323a5f7>] kobject_set_name_vargs+0x56/0x150
    [<000000004e35abdd>] dev_set_name+0xc0/0x100
    [<00000000f20cfe25>] ptp_clock_register+0x9f4/0xd30 [ptp]
    [<000000008bb9f0de>] idt82p33_probe.cold+0x8b6/0x1561 [ptp_idt82p33]

When posix_clock_register() returns an error, the name allocated
in dev_set_name() will be leaked, the put_device() should be used
to give up the device reference, then the name will be freed in
kobject_cleanup() and other memory will be freed in ptp_clock_release().

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Shivani: Modified to apply on 5.10.y, Removed kfree(ptp->vclock_index) in
  the ptach, since vclock_index is introduced in later versions ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_clock.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -283,15 +283,20 @@ struct ptp_clock *ptp_clock_register(str
 	/* Create a posix clock and link it to the device. */
 	err = posix_clock_register(&ptp->clock, &ptp->dev);
 	if (err) {
+		if (ptp->pps_source)
+			pps_unregister_source(ptp->pps_source);
+
+		if (ptp->kworker)
+			kthread_destroy_worker(ptp->kworker);
+
+		put_device(&ptp->dev);
+
 		pr_err("failed to create posix clock\n");
-		goto no_clock;
+		return ERR_PTR(err);
 	}
 
 	return ptp;
 
-no_clock:
-	if (ptp->pps_source)
-		pps_unregister_source(ptp->pps_source);
 no_pps:
 	ptp_cleanup_pin_groups(ptp);
 no_pin_groups:


