Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803988F5E;
	Tue,  8 Jul 2025 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993792; cv=none; b=GI1RkpNePyuf5iZ5JNm3FhbRmyAM/ZdnTOiSuulDZqSB/6yPu4xmR1+1GvlD1A/N/22gcFMsnULa3kZRZQT9g3zOIstmCpePZW9c9Wjs3s1ALBK5H+c18YJR6E3eNO7a5XP0LG6E5tPLBDNxVYM6UZJ5nBsmZZ7tZqu/kk9ojmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993792; c=relaxed/simple;
	bh=KG345HwKongGRET+bwpHy1erZolIvwFC2kEVWeXwLY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbCxRJdjzyefOIHdym8lIbX2r+GiMLWexyc1dMvKrp1WBiFSy32Jfg3BPlVOLtaRPc+Hdm3+JGs33QLf40nnTXbgIWLH3m/cMmrpD6eoah6h1Fue67p6PP8T1gVMBAYI/CQl3zjT4AC1dkRD3gLUmLmKPjfMmUwxqeUwUxndRTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Uuujqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Uuujqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08154C4CEF0;
	Tue,  8 Jul 2025 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993792;
	bh=KG345HwKongGRET+bwpHy1erZolIvwFC2kEVWeXwLY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6Uuujqvv9V83JhKShJEt9GGS61nvc1/ZpxbT2ix04ZabD6e0AU4DKYzsnp8wBwv8
	 6HgMGrW1WL1cRnRHCC/fZG/pDYeuV6rAgaFOEoYWhzEy4wbypHk84qEV1PU380NwIE
	 0QpL25eZeA+rB3JlXilvnK9U1phihdgmNdkFovv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hodaszi <robert.hodaszi@digi.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/160] usb: cdc-wdm: avoid setting WDM_READ for ZLP-s
Date: Tue,  8 Jul 2025 18:20:57 +0200
Message-ID: <20250708162232.067054013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hodaszi <robert.hodaszi@digi.com>

[ Upstream commit 387602d8a75574fafb451b7a8215e78dfd67ee63 ]

Don't set WDM_READ flag in wdm_in_callback() for ZLP-s, otherwise when
userspace tries to poll for available data, it might - incorrectly -
believe there is something available, and when it tries to non-blocking
read it, it might get stuck in the read loop.

For example this is what glib does for non-blocking read (briefly):

  1. poll()
  2. if poll returns with non-zero, starts a read data loop:
    a. loop on poll() (EINTR disabled)
    b. if revents was set, reads data
      I. if read returns with EINTR or EAGAIN, goto 2.a.
      II. otherwise return with data

So if ZLP sets WDM_READ (#1), we expect data, and try to read it (#2).
But as that was a ZLP, and we are doing non-blocking read, wdm_read()
returns with EAGAIN (#2.b.I), so loop again, and try to read again
(#2.a.).

With glib, we might stuck in this loop forever, as EINTR is disabled
(#2.a).

Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250403144004.3889125-1-robert.hodaszi@digi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-wdm.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index a4be6dba756b3..4b5cf1a5e30d8 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -92,7 +92,6 @@ struct wdm_device {
 	u16			wMaxCommand;
 	u16			wMaxPacketSize;
 	__le16			inum;
-	int			reslength;
 	int			length;
 	int			read;
 	int			count;
@@ -214,6 +213,11 @@ static void wdm_in_callback(struct urb *urb)
 	if (desc->rerr == 0 && status != -EPIPE)
 		desc->rerr = status;
 
+	if (length == 0) {
+		dev_dbg(&desc->intf->dev, "received ZLP\n");
+		goto skip_zlp;
+	}
+
 	if (length + desc->length > desc->wMaxCommand) {
 		/* The buffer would overflow */
 		set_bit(WDM_OVERFLOW, &desc->flags);
@@ -222,18 +226,18 @@ static void wdm_in_callback(struct urb *urb)
 		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
 			memmove(desc->ubuf + desc->length, desc->inbuf, length);
 			desc->length += length;
-			desc->reslength = length;
 		}
 	}
 skip_error:
 
 	if (desc->rerr) {
 		/*
-		 * Since there was an error, userspace may decide to not read
-		 * any data after poll'ing.
+		 * If there was a ZLP or an error, userspace may decide to not
+		 * read any data after poll'ing.
 		 * We should respond to further attempts from the device to send
 		 * data, so that we can get unstuck.
 		 */
+skip_zlp:
 		schedule_work(&desc->service_outs_intr);
 	} else {
 		set_bit(WDM_READ, &desc->flags);
@@ -585,15 +589,6 @@ static ssize_t wdm_read
 			goto retry;
 		}
 
-		if (!desc->reslength) { /* zero length read */
-			dev_dbg(&desc->intf->dev, "zero length - clearing WDM_READ\n");
-			clear_bit(WDM_READ, &desc->flags);
-			rv = service_outstanding_interrupt(desc);
-			spin_unlock_irq(&desc->iuspin);
-			if (rv < 0)
-				goto err;
-			goto retry;
-		}
 		cntr = desc->length;
 		spin_unlock_irq(&desc->iuspin);
 	}
@@ -1015,7 +1010,7 @@ static void service_interrupt_work(struct work_struct *work)
 
 	spin_lock_irq(&desc->iuspin);
 	service_outstanding_interrupt(desc);
-	if (!desc->resp_count) {
+	if (!desc->resp_count && (desc->length || desc->rerr)) {
 		set_bit(WDM_READ, &desc->flags);
 		wake_up(&desc->wait);
 	}
-- 
2.39.5



