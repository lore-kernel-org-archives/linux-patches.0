Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F4F423782;
	Thu, 30 Jul 2026 15:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423714; cv=none; b=TMXQErqV74IYeFzWOxZyWW+VY2gAiG7+7lMZnFkJJMZ3gyNoc7KuEfwcDipta4dxRSRNIQ7Fwn4aCUUMRpN4i8L1QaZUAhh/9T6P5GQMsmqOzt+dIYwHEaAe7Mxp6idlN2kkvXguYKwrq/AIcLJT2NdhXHwRORwXuKzCXTP2UNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423714; c=relaxed/simple;
	bh=YulG9bRmGL2z12hp6ZVhu/ldYc4AHhIovku9r9G6D6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwBuZCGLbjVyGtcuJYZqpaWLGvRQg5iSxR+wWd2WTcvUKln5kem6jbFzQtT8C1FSNix6w4d5vGrRDcsQvbUZzsQb15YhJJWzw5fIpMhVMlt/IX4WKAaLXk45fEQsIIiuGkYFv4R495ry1+FjyJ69B8xGm7w8Qke6Q/5yLVbomw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcgXtW0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcgXtW0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538D91F000E9;
	Thu, 30 Jul 2026 15:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423712;
	bh=QMfxXi4ELoiy1KD7LB8iMMSCn8V+3JtTsw4pWhsJxPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcgXtW0dyIvJI1NanCeRpLBXdfH2KcXLtAx4iusr/o3z/9cOI9HfJFO+FBh2E8atO
	 DcMrEihH6R3eQ5n9guWnWHZD28OFMOZVRENF0hmaMEP6qWJuyoLqYODdvKPGGrZ9eD
	 CYtd67lkib8dYb/dLOy00X3htSN55Vgcq3rX9F5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 141/675] usb: core: port: Deattach Type-C connector on component unbind
Date: Thu, 30 Jul 2026 16:07:51 +0200
Message-ID: <20260730141448.133786340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

commit e0b291fe117964037e0ba382eff4bb365d531c3a upstream.

connector_unbind() is the mirror of connector_bind(), but it is missing
the symmetric call to typec_deattach() that connector_bind() makes via:

    if (port_dev->child)
        typec_attach(port_dev->connector, &port_dev->child->dev);

When a Thunderbolt dock is unplugged, two teardown paths race:

1. The component framework calls connector_unbind() first, which sets
   port_dev->connector = NULL without calling typec_deattach().  This
   leaves port->usb2_dev/port->usb3_dev in struct typec_port pointing at
   the USB device that is about to be freed.

2. usb_disconnect() then calls typec_deattach(port_dev->connector, ...),
   but port_dev->connector is already NULL, so the call is a no-op and
   port->usb2_dev is never cleared.

3. Concurrently, UCSI detects a PD partner-disconnect event and calls
   typec_unregister_partner(), which reads port->usb2_dev (now a dangling
   pointer to freed memory) and passes it to typec_partner_unlink_device()
   -> sysfs_remove_link() -> dev_name() on the freed device, corrupting
   the typec/UCSI partner state.

This corruption leaves the Thunderbolt tunnel in an inconsistent state on
the next dock hot-plug.  On affected hardware the dock's I225/igc NIC fails
to enumerate: AER fires a slot reset while the igc driver is still
initialising ("PCIe link lost"), and the subsequent igc_reset attempt hits
igc_rd32 on an already-detached device:

    igc 0000:2e:00.0 eth0: PCIe link lost, device now detached
    igc: Failed to read reg 0x0!
    WARNING: CPU: 9 PID: 129 at drivers/net/ethernet/intel/igc/igc_main.c:7005
             igc_rd32+0xa4/0xc0 [igc]
    Call Trace:
     igc_disable_pcie_master+0x16/0xa0 [igc]
     igc_reset_hw_base+0x14/0x170 [igc]
     igc_reset+0x63/0x110 [igc]
     igc_io_slot_reset+0x9e/0xd0 [igc]
     report_slot_reset+0x5d/0xc0
     pcie_do_recovery+0x209/0x400
     aer_isr_one_error_type+0x235/0x430
     aer_isr+0x4e/0x80
     irq_thread+0xf4/0x1f0

4. UCSI later handles the PD partner-disconnect and calls
   typec_unregister_partner(), which still sees the stale port->usb2_dev
   and tries to remove its sysfs link a second time:

   kernfs: can not remove 'typec', no directory
   WARNING: CPU: 6 PID: 55 at fs/kernfs/dir.c:1706 kernfs_remove_by_name_ns+0xe9/0xf0
   Workqueue: events ucsi_handle_connector_change [typec_ucsi]
   Call Trace:
    sysfs_remove_link+0x19/0x50
    typec_unregister_partner+0x6e/0x120 [typec]
    ucsi_unregister_partner+0x107/0x150 [typec_ucsi]
    ucsi_handle_connector_change+0x3ec/0x490 [typec_ucsi]
    process_one_work+0x18e/0x3e0
    worker_thread+0x2e3/0x420
    kthread+0x10a/0x230
    ret_from_fork+0x121/0x140
    ret_from_fork_asm+0x1a/0x30

   With worse timing the same stale pointer is dereferenced after the
   backing memory is freed, turning the warning into a use-after-free.

Fix the asymmetry: call typec_deattach() before clearing
port_dev->connector, matching what connector_bind() does on the bind side.
typec_partner_deattach() is already protected by port->partner_link_lock,
so it serialises safely with the concurrent typec_unregister_partner() path.

Fixes: 11110783f5ea ("usb: Inform the USB Type-C class about enumerated devices")
Cc: stable <stable@kernel.org>
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260611071201.1235545-1-acelan.kao@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/port.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -726,6 +726,8 @@ static void connector_unbind(struct devi
 
 	sysfs_remove_link(&connector->kobj, dev_name(dev));
 	sysfs_remove_link(&dev->kobj, "connector");
+	if (port_dev->child)
+		typec_deattach(port_dev->connector, &port_dev->child->dev);
 	port_dev->connector = NULL;
 }
 


