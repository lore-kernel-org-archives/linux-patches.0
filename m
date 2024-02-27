Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECA013B2B4;
	Tue, 27 Feb 2024 13:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042002; cv=none; b=B24ECGkAA0dRtaHf2TDdYdyC4KHKOGraDcmNtPj4LDXReNf/GY1R5AIoQg1fhAEUeJoCsohH+4T9juHByFnEa/FZrIC9wFA0dnVmNrKZcDpXAqkECKGVGXcB6h+pgodSinQ9L98MfNitcojecBvHb4brI/9kVoHgWh4RDT6UE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042002; c=relaxed/simple;
	bh=5/cOZD4GnLElK6fWf2XOQ3G50v4/Cpxx6LKhlXBt4MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTrYIec9sSE94kYx9sPiJgCe+MqxCBBhcGOMY2n1D73IZ16dREhlxQ3tcgfaYLmjaElK08L0+StW6k0DsCK3CYYXvFsvCRvsNTuj7ZoNUMbvqvIasx0HpmFGR+l9aOTjIrLrpsLZvLtooSAgcwGVU/V2s/np7tFNQkJgpp3f104=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=la6q3LhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="la6q3LhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44672C433F1;
	Tue, 27 Feb 2024 13:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042002;
	bh=5/cOZD4GnLElK6fWf2XOQ3G50v4/Cpxx6LKhlXBt4MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la6q3LhQ6Lj3oziMpNOjM5zNuaW8IHOpm+KhZDitSVCafSBRLRQ8KrlZ6zhgaZw8T
	 g6lVS3ZRzEvpmY+d6tdgrangxosKBOf48WKmzu5fUDFGxjuenqpwqA8NswAKE7Bh9L
	 FhuDzdbwfSBvGTX7yQj4kiH8/7a4yiFqMrV41ZyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 143/299] s390/cio: fix invalid -EBUSY on ccw_device_start
Date: Tue, 27 Feb 2024 14:24:14 +0100
Message-ID: <20240227131630.464096678@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit 5ef1dc40ffa6a6cb968b0fdc43c3a61727a9e950 upstream.

The s390 common I/O layer (CIO) returns an unexpected -EBUSY return code
when drivers try to start I/O while a path-verification (PV) process is
pending. This can lead to failed device initialization attempts with
symptoms like broken network connectivity after boot.

Fix this by replacing the -EBUSY return code with a deferred condition
code 1 reply to make path-verification handling consistent from a
driver's point of view.

The problem can be reproduced semi-regularly using the following process,
while repeating steps 2-3 as necessary (example assumes an OSA device
with bus-IDs 0.0.a000-0.0.a002 on CHPID 0.02):

1. echo 0.0.a000,0.0.a001,0.0.a002 >/sys/bus/ccwgroup/drivers/qeth/group
2. echo 0 > /sys/bus/ccwgroup/devices/0.0.a000/online
3. echo 1 > /sys/bus/ccwgroup/devices/0.0.a000/online ; \
   echo on > /sys/devices/css0/chp0.02/status

Background information:

The common I/O layer starts path-verification I/Os when it receives
indications about changes in a device path's availability. This occurs
for example when hardware events indicate a change in channel-path
status, or when a manual operation such as a CHPID vary or configure
operation is performed.

If a driver attempts to start I/O while a PV is running, CIO reports a
successful I/O start (ccw_device_start() return code 0). Then, after
completion of PV, CIO synthesizes an interrupt response that indicates
an asynchronous status condition that prevented the start of the I/O
(deferred condition code 1).

If a PV indication arrives while a device is busy with driver-owned I/O,
PV is delayed until after I/O completion was reported to the driver's
interrupt handler. To ensure that PV can be started eventually, CIO
reports a device busy condition (ccw_device_start() return code -EBUSY)
if a driver tries to start another I/O while PV is pending.

In some cases this -EBUSY return code causes device drivers to consider
a device not operational, resulting in failed device initialization.

Note: The code that introduced the problem was added in 2003. Symptoms
started appearing with the following CIO commit that causes a PV
indication when a device is removed from the cio_ignore list after the
associated parent subchannel device was probed, but before online
processing of the CCW device has started:

2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")

During boot, the cio_ignore list is modified by the cio_ignore dracut
module [1] as well as Linux vendor-specific systemd service scripts[2].
When combined, this commit and boot scripts cause a frequent occurrence
of the problem during boot.

[1] https://github.com/dracutdevs/dracut/tree/master/modules.d/81cio_ignore
[2] https://github.com/SUSE/s390-tools/blob/master/cio_ignore.service

Cc: stable@vger.kernel.org # v5.15+
Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Tested-By: Thorsten Winkler <twinkler@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device_ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -202,7 +202,8 @@ int ccw_device_start_timeout_key(struct
 		return -EINVAL;
 	if (cdev->private->state == DEV_STATE_NOT_OPER)
 		return -ENODEV;
-	if (cdev->private->state == DEV_STATE_VERIFY) {
+	if (cdev->private->state == DEV_STATE_VERIFY ||
+	    cdev->private->flags.doverify) {
 		/* Remember to fake irb when finished. */
 		if (!cdev->private->flags.fake_irb) {
 			cdev->private->flags.fake_irb = FAKE_CMD_IRB;
@@ -214,8 +215,7 @@ int ccw_device_start_timeout_key(struct
 	}
 	if (cdev->private->state != DEV_STATE_ONLINE ||
 	    ((sch->schib.scsw.cmd.stctl & SCSW_STCTL_PRIM_STATUS) &&
-	     !(sch->schib.scsw.cmd.stctl & SCSW_STCTL_SEC_STATUS)) ||
-	    cdev->private->flags.doverify)
+	     !(sch->schib.scsw.cmd.stctl & SCSW_STCTL_SEC_STATUS)))
 		return -EBUSY;
 	ret = cio_set_options (sch, flags);
 	if (ret)


