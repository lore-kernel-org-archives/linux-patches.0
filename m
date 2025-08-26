Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47F0352FDF;
	Tue, 26 Aug 2025 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218211; cv=none; b=KndyqiATtoShlY1F2yGO1YsSup4AczFjzpvsBZFWtCw70DOlXRmzxEhbXNr8JnmFOGXY9skEieMUorq7up53vQItKOlqKjwxQmBOw7tFC5SN3pPuUBNYdUN6qMBKQCnvCD+lU96NFZLEAUcm+75SmYAaHuRvb2RorZtZoyq23fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218211; c=relaxed/simple;
	bh=RsvSGIJRFGFU1Vo6h7eVsMkhlTVQTdxB3ZR+wt9Avyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaxx9m/+/BRFI8AdqcNuLgXO5TdEM8HOX2aYtb3b7kKwtmTgdUM/3RarhR82G4OrT435slsWWJtYLy+mDfxxXLg/DExbyDg57xGXt8WOyrN81P5ZPlok7jkJ62lb7xUOJT1/H2DUucFG3ImNn3h0gmz1yaDXbah/SUh0eY74RHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWEiF8op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWEiF8op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441BEC4CEF1;
	Tue, 26 Aug 2025 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218211;
	bh=RsvSGIJRFGFU1Vo6h7eVsMkhlTVQTdxB3ZR+wt9Avyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWEiF8opbEL4ONAeWCMLN1wwmKRGCrJqJB2PVGhqPA6ailtGzoIKNRB7WePnL3eG3
	 AQxhCbbI29CjUGRHoEDYXrgH6z1i0+vIht03iRimPZJVhNuIAnpRh9mJH1Sg3tNNU/
	 Y76gOStkCvtI2RT52VOzNDDXP5lIW6EIAl8pcry4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/523] hv_netvsc: Fix panic during namespace deletion with VF
Date: Tue, 26 Aug 2025 13:10:44 +0200
Message-ID: <20250826110935.161205865@linuxfoundation.org>
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

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 33caa208dba6fa639e8a92fd0c8320b652e5550c ]

The existing code move the VF NIC to new namespace when NETDEV_REGISTER is
received on netvsc NIC. During deletion of the namespace,
default_device_exit_batch() >> default_device_exit_net() is called. When
netvsc NIC is moved back and registered to the default namespace, it
automatically brings VF NIC back to the default namespace. This will cause
the default_device_exit_net() >> for_each_netdev_safe loop unable to detect
the list end, and hit NULL ptr:

[  231.449420] mana 7870:00:00.0 enP30832s1: Moved VF to namespace with: eth0
[  231.449656] BUG: kernel NULL pointer dereference, address: 0000000000000010
[  231.450246] #PF: supervisor read access in kernel mode
[  231.450579] #PF: error_code(0x0000) - not-present page
[  231.450916] PGD 17b8a8067 P4D 0
[  231.451163] Oops: Oops: 0000 [#1] SMP NOPTI
[  231.451450] CPU: 82 UID: 0 PID: 1394 Comm: kworker/u768:1 Not tainted 6.16.0-rc4+ #3 VOLUNTARY
[  231.452042] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 11/21/2024
[  231.452692] Workqueue: netns cleanup_net
[  231.452947] RIP: 0010:default_device_exit_batch+0x16c/0x3f0
[  231.453326] Code: c0 0c f5 b3 e8 d5 db fe ff 48 85 c0 74 15 48 c7 c2 f8 fd ca b2 be 10 00 00 00 48 8d 7d c0 e8 7b 77 25 00 49 8b 86 28 01 00 00 <48> 8b 50 10 4c 8b 2a 4c 8d 62 f0 49 83 ed 10 4c 39 e0 0f 84 d6 00
[  231.454294] RSP: 0018:ff75fc7c9bf9fd00 EFLAGS: 00010246
[  231.454610] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 61c8864680b583eb
[  231.455094] RDX: ff1fa9f71462d800 RSI: ff75fc7c9bf9fd38 RDI: 0000000030766564
[  231.455686] RBP: ff75fc7c9bf9fd78 R08: 0000000000000000 R09: 0000000000000000
[  231.456126] R10: 0000000000000001 R11: 0000000000000004 R12: ff1fa9f70088e340
[  231.456621] R13: ff1fa9f70088e340 R14: ffffffffb3f50c20 R15: ff1fa9f7103e6340
[  231.457161] FS:  0000000000000000(0000) GS:ff1faa6783a08000(0000) knlGS:0000000000000000
[  231.457707] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  231.458031] CR2: 0000000000000010 CR3: 0000000179ab2006 CR4: 0000000000b73ef0
[  231.458434] Call Trace:
[  231.458600]  <TASK>
[  231.458777]  ops_undo_list+0x100/0x220
[  231.459015]  cleanup_net+0x1b8/0x300
[  231.459285]  process_one_work+0x184/0x340

To fix it, move the ns change to a workqueue, and take rtnl_lock to avoid
changing the netdev list when default_device_exit_net() is using it.

Cc: stable@vger.kernel.org
Fixes: 4c262801ea60 ("hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/1754511711-11188-1-git-send-email-haiyangz@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/hyperv_net.h |    3 +++
 drivers/net/hyperv/netvsc_drv.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -985,6 +985,7 @@ struct net_device_context {
 	struct net_device __rcu *vf_netdev;
 	struct netvsc_vf_pcpu_stats __percpu *vf_stats;
 	struct delayed_work vf_takeover;
+	struct delayed_work vfns_work;
 
 	/* 1: allocated, serial number is valid. 0: not allocated */
 	u32 vf_alloc;
@@ -999,6 +1000,8 @@ struct net_device_context {
 	struct netvsc_device_info *saved_netvsc_dev_info;
 };
 
+void netvsc_vfns_work(struct work_struct *w);
+
 /* Per channel data */
 struct netvsc_channel {
 	struct vmbus_channel *channel;
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2541,6 +2541,7 @@ static int netvsc_probe(struct hv_device
 	spin_lock_init(&net_device_ctx->lock);
 	INIT_LIST_HEAD(&net_device_ctx->reconfig_events);
 	INIT_DELAYED_WORK(&net_device_ctx->vf_takeover, netvsc_vf_setup);
+	INIT_DELAYED_WORK(&net_device_ctx->vfns_work, netvsc_vfns_work);
 
 	net_device_ctx->vf_stats
 		= netdev_alloc_pcpu_stats(struct netvsc_vf_pcpu_stats);
@@ -2679,6 +2680,8 @@ static int netvsc_remove(struct hv_devic
 	cancel_delayed_work_sync(&ndev_ctx->dwork);
 
 	rtnl_lock();
+	cancel_delayed_work_sync(&ndev_ctx->vfns_work);
+
 	nvdev = rtnl_dereference(ndev_ctx->nvdev);
 	if (nvdev) {
 		cancel_work_sync(&nvdev->subchan_work);
@@ -2721,6 +2724,7 @@ static int netvsc_suspend(struct hv_devi
 	cancel_delayed_work_sync(&ndev_ctx->dwork);
 
 	rtnl_lock();
+	cancel_delayed_work_sync(&ndev_ctx->vfns_work);
 
 	nvdev = rtnl_dereference(ndev_ctx->nvdev);
 	if (nvdev == NULL) {
@@ -2814,6 +2818,27 @@ static void netvsc_event_set_vf_ns(struc
 	}
 }
 
+void netvsc_vfns_work(struct work_struct *w)
+{
+	struct net_device_context *ndev_ctx =
+		container_of(w, struct net_device_context, vfns_work.work);
+	struct net_device *ndev;
+
+	if (!rtnl_trylock()) {
+		schedule_delayed_work(&ndev_ctx->vfns_work, 1);
+		return;
+	}
+
+	ndev = hv_get_drvdata(ndev_ctx->device_ctx);
+	if (!ndev)
+		goto out;
+
+	netvsc_event_set_vf_ns(ndev);
+
+out:
+	rtnl_unlock();
+}
+
 /*
  * On Hyper-V, every VF interface is matched with a corresponding
  * synthetic interface. The synthetic interface is presented first
@@ -2824,10 +2849,12 @@ static int netvsc_netdev_event(struct no
 			       unsigned long event, void *ptr)
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
+	struct net_device_context *ndev_ctx;
 	int ret = 0;
 
 	if (event_dev->netdev_ops == &device_ops && event == NETDEV_REGISTER) {
-		netvsc_event_set_vf_ns(event_dev);
+		ndev_ctx = netdev_priv(event_dev);
+		schedule_delayed_work(&ndev_ctx->vfns_work, 0);
 		return NOTIFY_DONE;
 	}
 


