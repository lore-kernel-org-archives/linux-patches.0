Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ED4198A20;
	Thu,  6 Jun 2024 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683055; cv=none; b=lzEpEjz8o5R8dJgadDVpEt8HngTlf2UiiODDkpHdqftzWL9k+L5vuyjCiVfYDumfqgeWDT6t9QGr1geCIMcj9azCYkM5uCqLTELJslJmf1e9bvcfnC/A/UnfGEWlwyAjYlJlU9R0EXU03BGh59KzdyTX73lVJwnV1cLZN19jEIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683055; c=relaxed/simple;
	bh=KeDd/VFCEHYbL4SGNba/gFdhOWAstbF6I9Mbjiwr+24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEiqsGBa9UWjCpJFcCWZ3sE04aZhUuF4Jy8mWY+SursM3cxYfEw2u0FRAXNf9LJevh3VrR+aQQleqgt3/agdtdNUzflRLSpwLHGjs4II3AisgB5dSESajexdHkCep+K64qXTVOpMcmzYfpMz5G6a7g5ruiEN6PwsKKOPJsgOK7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQot+D4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQot+D4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D487EC4AF0F;
	Thu,  6 Jun 2024 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683054;
	bh=KeDd/VFCEHYbL4SGNba/gFdhOWAstbF6I9Mbjiwr+24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQot+D4HUP0NTgqzL8LUrv0oynNT6THF9MzeCp44BYDF4e0mDOMRzy2hwCw1J+1jA
	 E79XSj41lw10+cPaF1FVxiXIc6zQZcrIg4jL6lNpL/je/NACQlYLUYgJJL76Faxi1t
	 wXMIJY+dgawf2gjf00SZIR/8bYWExBXA4PVqrcFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Wang <xin.wang2@amd.com>,
	Michal Orzel <michal.orzel@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 272/374] drivers/xen: Improve the late XenStore init protocol
Date: Thu,  6 Jun 2024 16:04:11 +0200
Message-ID: <20240606131701.011286183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Wang <xin.wang2@amd.com>

[ Upstream commit a3607581cd49c17128a486a526a36a97bafcb2bb ]

Currently, the late XenStore init protocol is only triggered properly
for the case that HVM_PARAM_STORE_PFN is ~0ULL (invalid). For the
case that XenStore interface is allocated but not ready (the connection
status is not XENSTORE_CONNECTED), Linux should also wait until the
XenStore is set up properly.

Introduce a macro to describe the XenStore interface is ready, use
it in xenbus_probe_initcall() to select the code path of doing the
late XenStore init protocol or not. Since now we have more than one
condition for XenStore late init, rework the check in xenbus_probe()
for the free_irq().

Take the opportunity to enhance the check of the allocated XenStore
interface can be properly mapped, and return error early if the
memremap() fails.

Fixes: 5b3353949e89 ("xen: add support for initializing xenstore later as HVM domain")
Signed-off-by: Henry Wang <xin.wang2@amd.com>
Signed-off-by: Michal Orzel <michal.orzel@amd.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20240517011516.1451087-1-xin.wang2@amd.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 36 ++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 3205e5d724c8c..1a9ded0cddcb0 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -65,13 +65,17 @@
 #include "xenbus.h"
 
 
-static int xs_init_irq;
+static int xs_init_irq = -1;
 int xen_store_evtchn;
 EXPORT_SYMBOL_GPL(xen_store_evtchn);
 
 struct xenstore_domain_interface *xen_store_interface;
 EXPORT_SYMBOL_GPL(xen_store_interface);
 
+#define XS_INTERFACE_READY \
+	((xen_store_interface != NULL) && \
+	 (xen_store_interface->connection == XENSTORE_CONNECTED))
+
 enum xenstore_init xen_store_domain_type;
 EXPORT_SYMBOL_GPL(xen_store_domain_type);
 
@@ -751,19 +755,19 @@ static void xenbus_probe(void)
 {
 	xenstored_ready = 1;
 
-	if (!xen_store_interface) {
+	if (!xen_store_interface)
 		xen_store_interface = memremap(xen_store_gfn << XEN_PAGE_SHIFT,
 					       XEN_PAGE_SIZE, MEMREMAP_WB);
-		/*
-		 * Now it is safe to free the IRQ used for xenstore late
-		 * initialization. No need to unbind: it is about to be
-		 * bound again from xb_init_comms. Note that calling
-		 * unbind_from_irqhandler now would result in xen_evtchn_close()
-		 * being called and the event channel not being enabled again
-		 * afterwards, resulting in missed event notifications.
-		 */
+	/*
+	 * Now it is safe to free the IRQ used for xenstore late
+	 * initialization. No need to unbind: it is about to be
+	 * bound again from xb_init_comms. Note that calling
+	 * unbind_from_irqhandler now would result in xen_evtchn_close()
+	 * being called and the event channel not being enabled again
+	 * afterwards, resulting in missed event notifications.
+	 */
+	if (xs_init_irq >= 0)
 		free_irq(xs_init_irq, &xb_waitq);
-	}
 
 	/*
 	 * In the HVM case, xenbus_init() deferred its call to
@@ -822,7 +826,7 @@ static int __init xenbus_probe_initcall(void)
 	if (xen_store_domain_type == XS_PV ||
 	    (xen_store_domain_type == XS_HVM &&
 	     !xs_hvm_defer_init_for_callback() &&
-	     xen_store_interface != NULL))
+	     XS_INTERFACE_READY))
 		xenbus_probe();
 
 	/*
@@ -831,7 +835,7 @@ static int __init xenbus_probe_initcall(void)
 	 * started, then probe.  It will be triggered when communication
 	 * starts happening, by waiting on xb_waitq.
 	 */
-	if (xen_store_domain_type == XS_LOCAL || xen_store_interface == NULL) {
+	if (xen_store_domain_type == XS_LOCAL || !XS_INTERFACE_READY) {
 		struct task_struct *probe_task;
 
 		probe_task = kthread_run(xenbus_probe_thread, NULL,
@@ -1014,6 +1018,12 @@ static int __init xenbus_init(void)
 			xen_store_interface =
 				memremap(xen_store_gfn << XEN_PAGE_SHIFT,
 					 XEN_PAGE_SIZE, MEMREMAP_WB);
+			if (!xen_store_interface) {
+				pr_err("%s: cannot map HVM_PARAM_STORE_PFN=%llx\n",
+				       __func__, v);
+				err = -EINVAL;
+				goto out_error;
+			}
 			if (xen_store_interface->connection != XENSTORE_CONNECTED)
 				wait = true;
 		}
-- 
2.43.0



