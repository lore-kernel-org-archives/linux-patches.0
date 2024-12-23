Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C762F17A597;
	Mon, 23 Dec 2024 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970761; cv=none; b=Va/xVSgnRirFkksSaBvud+3+CdkxP05ROYN8tW94ehelTeSwQAc/R36EIbFrKbFfdMVcRoLEYeHwYeueTKCJezlEfgY+B31VmqlSd+oc8WnIxQRESJkqk2k5APPbL06TYaDQLqdFcdH+hR1S8RCWFAk0HPmaR6sbevBsBBdhH7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970761; c=relaxed/simple;
	bh=vgoCrlvSW/8GY9U9dbaEHgooTugww803Ag2CQ2HvHV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4m0Vbe0ueZD8O9od6SCwWLElJfgTb5gA4TIrjxPjACQ0Sfx5AIo3WCdr5iKH52T0mjsR6LfD+8dulnYWww86ocfsMuyyv1Rei4/JvAP96fM3sdQK6XFK8Ts8xh+e2zfijtjR6+u+1gOQzTmOwee3jLy23Es24VWPis8Sj354LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTCjJWmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTCjJWmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3501BC4CED3;
	Mon, 23 Dec 2024 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970761;
	bh=vgoCrlvSW/8GY9U9dbaEHgooTugww803Ag2CQ2HvHV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTCjJWmPCF0OXaXKLL57i0oM8PNODsq/CVINsUok+glwa+ePeurBFTwKtao7tYlOU
	 7kaoWZDnpl6B/vPDWs82h7SgRHXUMZCBcPA4XXcc71Qw43ng2kJ6XpYXqAYKLe8Q92
	 J1DWIRw/aJgUK1sUXLYobUlhB0xKrVy9EJ+kooOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.1 60/83] Drivers: hv: util: Avoid accessing a ringbuffer not initialized yet
Date: Mon, 23 Dec 2024 16:59:39 +0100
Message-ID: <20241223155355.952185182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

commit 07a756a49f4b4290b49ea46e089cbe6f79ff8d26 upstream.

If the KVP (or VSS) daemon starts before the VMBus channel's ringbuffer is
fully initialized, we can hit the panic below:

hv_utils: Registering HyperV Utility Driver
hv_vmbus: registering driver hv_utils
...
BUG: kernel NULL pointer dereference, address: 0000000000000000
CPU: 44 UID: 0 PID: 2552 Comm: hv_kvp_daemon Tainted: G E 6.11.0-rc3+ #1
RIP: 0010:hv_pkt_iter_first+0x12/0xd0
Call Trace:
...
 vmbus_recvpacket
 hv_kvp_onchannelcallback
 vmbus_on_event
 tasklet_action_common
 tasklet_action
 handle_softirqs
 irq_exit_rcu
 sysvec_hyperv_stimer0
 </IRQ>
 <TASK>
 asm_sysvec_hyperv_stimer0
...
 kvp_register_done
 hvt_op_read
 vfs_read
 ksys_read
 __x64_sys_read

This can happen because the KVP/VSS channel callback can be invoked
even before the channel is fully opened:
1) as soon as hv_kvp_init() -> hvutil_transport_init() creates
/dev/vmbus/hv_kvp, the kvp daemon can open the device file immediately and
register itself to the driver by writing a message KVP_OP_REGISTER1 to the
file (which is handled by kvp_on_msg() ->kvp_handle_handshake()) and
reading the file for the driver's response, which is handled by
hvt_op_read(), which calls hvt->on_read(), i.e. kvp_register_done().

2) the problem with kvp_register_done() is that it can cause the
channel callback to be called even before the channel is fully opened,
and when the channel callback is starting to run, util_probe()->
vmbus_open() may have not initialized the ringbuffer yet, so the
callback can hit the panic of NULL pointer dereference.

To reproduce the panic consistently, we can add a "ssleep(10)" for KVP in
__vmbus_open(), just before the first hv_ringbuffer_init(), and then we
unload and reload the driver hv_utils, and run the daemon manually within
the 10 seconds.

Fix the panic by reordering the steps in util_probe() so the char dev
entry used by the KVP or VSS daemon is not created until after
vmbus_open() has completed. This reordering prevents the race condition
from happening.

Reported-by: Dexuan Cui <decui@microsoft.com>
Fixes: e0fa3e5e7df6 ("Drivers: hv: utils: fix a race on userspace daemons registration")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
Link: https://lore.kernel.org/r/20241106154247.2271-3-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20241106154247.2271-3-mhklinux@outlook.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_kvp.c       |    6 ++++++
 drivers/hv/hv_snapshot.c  |    6 ++++++
 drivers/hv/hv_util.c      |    9 +++++++++
 drivers/hv/hyperv_vmbus.h |    2 ++
 include/linux/hyperv.h    |    1 +
 5 files changed, 24 insertions(+)

--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -767,6 +767,12 @@ hv_kvp_init(struct hv_util_service *srv)
 	 */
 	kvp_transaction.state = HVUTIL_DEVICE_INIT;
 
+	return 0;
+}
+
+int
+hv_kvp_init_transport(void)
+{
 	hvt = hvutil_transport_init(kvp_devname, CN_KVP_IDX, CN_KVP_VAL,
 				    kvp_on_msg, kvp_on_reset);
 	if (!hvt)
--- a/drivers/hv/hv_snapshot.c
+++ b/drivers/hv/hv_snapshot.c
@@ -388,6 +388,12 @@ hv_vss_init(struct hv_util_service *srv)
 	 */
 	vss_transaction.state = HVUTIL_DEVICE_INIT;
 
+	return 0;
+}
+
+int
+hv_vss_init_transport(void)
+{
 	hvt = hvutil_transport_init(vss_devname, CN_VSS_IDX, CN_VSS_VAL,
 				    vss_on_msg, vss_on_reset);
 	if (!hvt) {
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -141,6 +141,7 @@ static struct hv_util_service util_heart
 static struct hv_util_service util_kvp = {
 	.util_cb = hv_kvp_onchannelcallback,
 	.util_init = hv_kvp_init,
+	.util_init_transport = hv_kvp_init_transport,
 	.util_pre_suspend = hv_kvp_pre_suspend,
 	.util_pre_resume = hv_kvp_pre_resume,
 	.util_deinit = hv_kvp_deinit,
@@ -149,6 +150,7 @@ static struct hv_util_service util_kvp =
 static struct hv_util_service util_vss = {
 	.util_cb = hv_vss_onchannelcallback,
 	.util_init = hv_vss_init,
+	.util_init_transport = hv_vss_init_transport,
 	.util_pre_suspend = hv_vss_pre_suspend,
 	.util_pre_resume = hv_vss_pre_resume,
 	.util_deinit = hv_vss_deinit,
@@ -592,6 +594,13 @@ static int util_probe(struct hv_device *
 	if (ret)
 		goto error;
 
+	if (srv->util_init_transport) {
+		ret = srv->util_init_transport();
+		if (ret) {
+			vmbus_close(dev->channel);
+			goto error;
+		}
+	}
 	return 0;
 
 error:
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -365,12 +365,14 @@ void vmbus_on_event(unsigned long data);
 void vmbus_on_msg_dpc(unsigned long data);
 
 int hv_kvp_init(struct hv_util_service *srv);
+int hv_kvp_init_transport(void);
 void hv_kvp_deinit(void);
 int hv_kvp_pre_suspend(void);
 int hv_kvp_pre_resume(void);
 void hv_kvp_onchannelcallback(void *context);
 
 int hv_vss_init(struct hv_util_service *srv);
+int hv_vss_init_transport(void);
 void hv_vss_deinit(void);
 int hv_vss_pre_suspend(void);
 int hv_vss_pre_resume(void);
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1567,6 +1567,7 @@ struct hv_util_service {
 	void *channel;
 	void (*util_cb)(void *);
 	int (*util_init)(struct hv_util_service *);
+	int (*util_init_transport)(void);
 	void (*util_deinit)(void);
 	int (*util_pre_suspend)(void);
 	int (*util_pre_resume)(void);


