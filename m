Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9531A6166;
	Tue, 30 Jul 2024 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356849; cv=none; b=q7JDtIQ83oUnE4UazlPiapcYCRTWrH+druyDC9aFPDjEAPDdtmOzG/PA02R0+AEbC5Nj7uMcN9iauPRK4/Kgwg3R8UULqnRjig5gvzaVja4/o44JdLOIeybGrY+XBb0bBVPZP8z5WkxQVfkRQXqr0gWE2TBqtiIpfdkmc1otAnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356849; c=relaxed/simple;
	bh=jo8IuULDXzkqbYUKKP3RosyNbfa0IlNKEb32rTr9MVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+e/coEB7p5poCptW4gvvCptfQ2dRKw3jQ6LxsWe0G2jbCaTTPJbk9RlwZ2CGoRhJNmdkSfn4iREsUBeJ44NU9QiPcL1K9pdPaDn+po9473kJ0n1LcxoF6N/6F3BGmHNlban8YWebXKEd6XIgOL0Lj2SlN7s4z5lz8yebKio1zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+WU8xkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+WU8xkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CDBC32782;
	Tue, 30 Jul 2024 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356849;
	bh=jo8IuULDXzkqbYUKKP3RosyNbfa0IlNKEb32rTr9MVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+WU8xktzjfBUmOtMssFyhUirlk8mXFNQZMF0uBcWAmIuJ9CFTt7vx3u5ONxMZPKy
	 2ypIkPteUgC/fzQ95icwMD/rfJx86IZc0jOCzPBjpBkD8URpwhNj8Tvsg0r0BJ3rG4
	 ozLuzWYqioMLbNbzcqhC6xYJ4zVGthEStLi8VnZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/568] media: dvb-usb: Fix unexpected infinite loop in dvb_usb_read_remote_control()
Date: Tue, 30 Jul 2024 17:44:57 +0200
Message-ID: <20240730151647.304071003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]

Infinite log printing occurs during fuzz test:

  rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
  ...
  dvb-usb: schedule remote query interval to 100 msecs.
  dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
  dvb-usb: bulk message failed: -22 (1/0)
  dvb-usb: bulk message failed: -22 (1/0)
  dvb-usb: bulk message failed: -22 (1/0)
  ...
  dvb-usb: bulk message failed: -22 (1/0)

Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
that is in rc_core_dvb_usb_remote_init() create a work that will call
dvb_usb_read_remote_control(), and this work will reschedule itself at
'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
see following code snippet:

  rc_core_dvb_usb_remote_init() {
    ...
    INIT_DELAYED_WORK(&d->rc_query_work, dvb_usb_read_remote_control);
    schedule_delayed_work(&d->rc_query_work,
                          msecs_to_jiffies(rc_interval));
    ...
  }

  dvb_usb_read_remote_control() {
    ...
    err = d->props.rc.core.rc_query(d);
    if (err)
      err(...)  // Did not return even if query failed
    schedule_delayed_work(&d->rc_query_work,
                          msecs_to_jiffies(rc_interval));
  }

When the infinite log printing occurs, the query callback
'd->props.rc.core.rc_query' is cxusb_rc_query(). And the log is due to
the failure of finding a valid 'generic_bulk_ctrl_endpoint'
in usb_bulk_msg(), see following code snippet:

  cxusb_rc_query() {
    cxusb_ctrl_msg() {
      dvb_usb_generic_rw() {
        ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
                           d->props.generic_bulk_ctrl_endpoint),...);
        if (ret)
          err("bulk message failed: %d (%d/%d)",ret,wlen,actlen);
          ...
      }
  ...
  }

By analyzing the corresponding USB descriptor, it shows that the
bNumEndpoints is 0 in its interface descriptor, but
the 'generic_bulk_ctrl_endpoint' is 1, that means user don't configure
a valid endpoint for 'generic_bulk_ctrl_endpoint', therefore this
'invalid' USB device should be rejected before it calls into
dvb_usb_read_remote_control().

To fix it, we need to add endpoint check for 'generic_bulk_ctrl_endpoint'.
And as Sean suggested, the same check and clear halts should be done for
'generic_bulk_ctrl_endpoint_response'. So introduce
dvb_usb_check_bulk_endpoint() to do it for both of them.

Fixes: 4d43e13f723e ("V4L/DVB (4643): Multi-input patch for DVB-USB device")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-init.c | 35 +++++++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index fbf58012becdf..22d83ac18eb73 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -23,11 +23,40 @@ static int dvb_usb_force_pid_filter_usage;
 module_param_named(force_pid_filter_usage, dvb_usb_force_pid_filter_usage, int, 0444);
 MODULE_PARM_DESC(force_pid_filter_usage, "force all dvb-usb-devices to use a PID filter, if any (default: 0).");
 
+static int dvb_usb_check_bulk_endpoint(struct dvb_usb_device *d, u8 endpoint)
+{
+	if (endpoint) {
+		int ret;
+
+		ret = usb_pipe_type_check(d->udev, usb_sndbulkpipe(d->udev, endpoint));
+		if (ret)
+			return ret;
+		ret = usb_pipe_type_check(d->udev, usb_rcvbulkpipe(d->udev, endpoint));
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static void dvb_usb_clear_halt(struct dvb_usb_device *d, u8 endpoint)
+{
+	if (endpoint) {
+		usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, endpoint));
+		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, endpoint));
+	}
+}
+
 static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 {
 	struct dvb_usb_adapter *adap;
 	int ret, n, o;
 
+	ret = dvb_usb_check_bulk_endpoint(d, d->props.generic_bulk_ctrl_endpoint);
+	if (ret)
+		return ret;
+	ret = dvb_usb_check_bulk_endpoint(d, d->props.generic_bulk_ctrl_endpoint_response);
+	if (ret)
+		return ret;
 	for (n = 0; n < d->props.num_adapters; n++) {
 		adap = &d->adapter[n];
 		adap->dev = d;
@@ -103,10 +132,8 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 	 * when reloading the driver w/o replugging the device
 	 * sometimes a timeout occurs, this helps
 	 */
-	if (d->props.generic_bulk_ctrl_endpoint != 0) {
-		usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
-		usb_clear_halt(d->udev, usb_rcvbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
-	}
+	dvb_usb_clear_halt(d, d->props.generic_bulk_ctrl_endpoint);
+	dvb_usb_clear_halt(d, d->props.generic_bulk_ctrl_endpoint_response);
 
 	return 0;
 
-- 
2.43.0



