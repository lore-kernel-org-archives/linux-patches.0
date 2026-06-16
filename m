Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC091477995;
	Tue, 16 Jun 2026 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628773; cv=none; b=FVwqs/zU6HvG7AKx8ULMSiGDJbkDbokNGu38C9TCq1N3LMFk9mYy+3GHOrdQ5HsQ3bG8QdcKFkG+qzZ9cyk/VZCkRmk1embOSIf/nwz1oiz/19lbFW1e+TdEUd1pmTJYLXiJEp7GKmjURt4iiHwySrWEns8CCTXrHgTLFhIuwts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628773; c=relaxed/simple;
	bh=zQC3cnStZj1rOhwIpk0vZqe/SQHezxx826UlIEJ0BVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGdukdXXGRvbNdK0ezeglad31dK4k8I2W6VZNLs4EwJIG18d4CBUvYUcMvDAnqj31HipYseC+J194UO71+IZyDRBXe8sR6aA5q5bzLv72CAQHgNjqyS+lyI1YXTjrK41wmhbBeqGKmI/31TEMuopZvRvDZlYLvgPf/s3/yegsNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwRLPxaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwRLPxaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87E61F000E9;
	Tue, 16 Jun 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628772;
	bh=hYPfCqhHgXCJ0e7F29JdR2QnKpmOHkjxsLUW4hVFChI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwRLPxaqDHMR3HDSI5Z4fhu3owWtaHxDOBUkSy6Giia9oS4/QqrBGKPYvyXg00rT2
	 wxumP73YvdYlVXMAuFnfjOfd315m1EPSucbUj+kufiTz2aT5yS+cyBcVQibhwP70Vy
	 onMxFG1HnouipvWEa/AYq4XN2a9PfiwwKFGZkF/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 160/452] USB: serial: belkin_sa: validate interrupt status length
Date: Tue, 16 Jun 2026 20:26:27 +0530
Message-ID: <20260616145126.171950120@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

commit 4ce058df2ee02cc2a0f0fd5cd64ce6f1482a0b65 upstream.

The Belkin interrupt callback treats interrupt data as a four-byte
status report and reads LSR/MSR fields at offsets 2 and 3. The
interrupt-in buffer length is derived from endpoint wMaxPacketSize, and
short interrupt transfers may complete successfully with a smaller
actual_length.

Check the completed interrupt packet length before parsing status
fields so short interrupt endpoints and short successful packets are
ignored instead of causing out-of-bounds or stale status-byte reads.

KASAN report as below:

BUG: KASAN: slab-out-of-bounds in belkin_sa_read_int_callback()
Read of size 1
Call trace:
  belkin_sa_read_int_callback() (drivers/usb/serial/belkin_sa.c:202)
  __usb_hcd_giveback_urb() (drivers/usb/core/hcd.c:1630)
  dummy_timer() (?:?)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/belkin_sa.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -195,6 +195,9 @@ static void belkin_sa_read_int_callback(
 
 	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
 
+	if (urb->actual_length < BELKIN_SA_MSR_INDEX + 1)
+		goto exit;
+
 	/* Handle known interrupt data */
 	/* ignore data[0] and data[1] */
 


