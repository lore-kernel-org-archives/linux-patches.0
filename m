Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E653A264FBD;
	Mon, 29 Dec 2025 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026005; cv=none; b=Sz/rvHKaH7xcNlIQQ3GhWT+xuQx0NAbBF4Phummase3KUPh0ekiWxPsNVe6i2XTnABu26vAINOoVJI50Z7SRFALURnOq8RnFd0HM0z8zABU4Gkx534GziM6prCnxmj4Dh5sy+8RZl1O/YJkEbIv3pTSKpG0NFMBB3GtRNH7Q+uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026005; c=relaxed/simple;
	bh=4FgrF0GD4z3z/1ZBVGpZLO3c65bsDMX8BzkuIxZD2xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaR9xzn8y/VrISgQFG4eWTk+V52BvsCtf58x0PSqXTXbS7gNHFPTRBNHCR29tZ7eO9x4k+THQmJBG4CLA9W3Xa87xsfWU7ZEZExa8TE/KmoWltFAADyfQIEK/pWuG2o+/9y/r5BTm7TWnQcDlHyOKrgxQ+sFqSlqVka3i3F+z0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTBE9zP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTBE9zP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D838C4CEF7;
	Mon, 29 Dec 2025 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026004;
	bh=4FgrF0GD4z3z/1ZBVGpZLO3c65bsDMX8BzkuIxZD2xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTBE9zP//ScLpR8R2QsnSIXvLR2C7OaZ0bxf4FsZ1WJ9xlljmMlkLRlr11wPrF29x
	 sf/L3dakLO7WjGDWxWo6SuqPg/SPkWwbXMEHLEqQkeutXLBWiEAfrcv0JqrAvO1Srg
	 GrxZLOyw/yqAyttEumbe1F+12WL/ygm4uCmRs64Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 412/430] rpmsg: glink: fix rpmsg device leak
Date: Mon, 29 Dec 2025 17:13:34 +0100
Message-ID: <20251229160739.476882175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit a53e356df548f6b0e82529ef3cc6070f42622189 upstream.

While testing rpmsg-char interface it was noticed that duplicate sysfs
entries are getting created and below warning is noticed.

Reason for this is that we are leaking rpmsg device pointer, setting it
null without actually unregistering device.
Any further attempts to unregister fail because rpdev is NULL,
resulting in a leak.

Fix this by unregistering rpmsg device before removing its reference
from rpmsg channel.

sysfs: cannot create duplicate filename '/devices/platform/soc@0/3700000.remot
eproc/remoteproc/remoteproc1/3700000.remoteproc:glink-edge/3700000.remoteproc:
glink-edge.adsp_apps.-1.-1'
[  114.115347] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not
 tainted 6.16.0-rc4 #7 PREEMPT
[  114.115355] Hardware name: Qualcomm Technologies, Inc. Robotics RB3gen2 (DT)
[  114.115358] Workqueue: events qcom_glink_work
[  114.115371] Call trace:8
[  114.115374]  show_stack+0x18/0x24 (C)
[  114.115382]  dump_stack_lvl+0x60/0x80
[  114.115388]  dump_stack+0x18/0x24
[  114.115393]  sysfs_warn_dup+0x64/0x80
[  114.115402]  sysfs_create_dir_ns+0xf4/0x120
[  114.115409]  kobject_add_internal+0x98/0x260
[  114.115416]  kobject_add+0x9c/0x108
[  114.115421]  device_add+0xc4/0x7a0
[  114.115429]  rpmsg_register_device+0x5c/0xb0
[  114.115434]  qcom_glink_work+0x4bc/0x820
[  114.115438]  process_one_work+0x148/0x284
[  114.115446]  worker_thread+0x2c4/0x3e0
[  114.115452]  kthread+0x12c/0x204
[  114.115457]  ret_from_fork+0x10/0x20
[  114.115464] kobject: kobject_add_internal failed for 3700000.remoteproc:
glink-edge.adsp_apps.-1.-1 with -EEXIST, don't try to register things with
the same name in the same directory.
[  114.250045] rpmsg 3700000.remoteproc:glink-edge.adsp_apps.-1.-1:
device_add failed: -17

Fixes: 835764ddd9af ("rpmsg: glink: Move the common glink protocol implementation to glink_native.c")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250822100043.2604794-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/qcom_glink_native.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1399,6 +1399,7 @@ static void qcom_glink_destroy_ept(struc
 {
 	struct glink_channel *channel = to_glink_channel(ept);
 	struct qcom_glink *glink = channel->glink;
+	struct rpmsg_channel_info chinfo;
 	unsigned long flags;
 
 	spin_lock_irqsave(&channel->recv_lock, flags);
@@ -1406,6 +1407,13 @@ static void qcom_glink_destroy_ept(struc
 	spin_unlock_irqrestore(&channel->recv_lock, flags);
 
 	/* Decouple the potential rpdev from the channel */
+	if (channel->rpdev) {
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
+		chinfo.src = RPMSG_ADDR_ANY;
+		chinfo.dst = RPMSG_ADDR_ANY;
+
+		rpmsg_unregister_device(glink->dev, &chinfo);
+	}
 	channel->rpdev = NULL;
 
 	qcom_glink_send_close_req(glink, channel);


