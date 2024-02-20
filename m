Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD4E133987;
	Tue, 20 Feb 2024 21:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463568; cv=none; b=fWBKRQtp1TCKscvr0sjmftKF6f9iaUf2sc6Pb0m3B2BRx4WCIuQEfJttYsyqXtTqXag+uPpvqmWdm36sA7pK2Q4ZsILWmcvrs0H/MJXAV16pkjMAAN2Mx+G+TDERkzuc3C0uvRFbvprAdQNr2ijpEKaHixiBDhCIWe7ngI7sdKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463568; c=relaxed/simple;
	bh=dFdXi2SN2lYXc/ejpB2IG6sfT/H9l+5V0TArBax6/Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijDsrG2d0cSqmNtvDYfDXubuBsOrm/PS20zY0k4JnBlX8uiIgsP/hnQbIYUXlPDe1IOjryd8iMjvjnhP4PUrZr6u2gHTzpupoOj6IuOYp/us6AyjXGOeeYOyYT31y/s5QmwBm4ZevU5balOQqRu1yYdiWAxS3Ft/Hrl/m44yWiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ntoug3uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ntoug3uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2789AC433C7;
	Tue, 20 Feb 2024 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463567;
	bh=dFdXi2SN2lYXc/ejpB2IG6sfT/H9l+5V0TArBax6/Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ntoug3uIIMtE0zsqwCUjISaTk+/sKByhGs1WAWuuJkgTrJTD/JuEVKiBaDTIYVQKY
	 LVXQ0w5b52TNtw7CJFPfpeuEY1RkCl3aDP+VO6KqI4fZo+bpk7i8GZqXq4khDRHOn1
	 b1Sa6IAIjw9NRq6k5rYM4yc4X/JrGIsQBD2N8vi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.6 082/331] usb: chipidea: core: handle power lost in workqueue
Date: Tue, 20 Feb 2024 21:53:18 +0100
Message-ID: <20240220205640.176763677@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit cc509b6a47e7c8998d9e41c273191299d5d9d631 upstream.

When power is recycled in usb controller during system power management,
the controller will recognize it and switch role if role has been changed
during power lost. In current design, it will be completed in resume()
function. However, this may bring issues since usb class devices have
their pm operations too and these device's resume() functions are still
not being called at this point. When usb controller recognized host role
should be stopped, these usb class devices will be removed at this point.
But these usb class devices can't be removed in some cases, such as scsi
devices. Since scsi driver may sync data to U-disk, however it will block
there because scsi drvier can only handle pm request when is in suspended
state. Therefore, there may exist a dependency between ci_resume() and usb
class device's resume(). To break this potential dependency, we need to
handle power lost work in a workqueue.

Fixes: 74494b33211d ("usb: chipidea: core: add controller resume support when controller is powered off")
cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240119123537.3614838-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci.h   |    2 ++
 drivers/usb/chipidea/core.c |   44 ++++++++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 20 deletions(-)

--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -176,6 +176,7 @@ struct hw_bank {
  * @enabled_otg_timer_bits: bits of enabled otg timers
  * @next_otg_timer: next nearest enabled timer to be expired
  * @work: work for role changing
+ * @power_lost_work: work for power lost handling
  * @wq: workqueue thread
  * @qh_pool: allocation pool for queue heads
  * @td_pool: allocation pool for transfer descriptors
@@ -226,6 +227,7 @@ struct ci_hdrc {
 	enum otg_fsm_timer		next_otg_timer;
 	struct usb_role_switch		*role_switch;
 	struct work_struct		work;
+	struct work_struct		power_lost_work;
 	struct workqueue_struct		*wq;
 
 	struct dma_pool			*qh_pool;
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -856,6 +856,27 @@ static int ci_extcon_register(struct ci_
 	return 0;
 }
 
+static void ci_power_lost_work(struct work_struct *work)
+{
+	struct ci_hdrc *ci = container_of(work, struct ci_hdrc, power_lost_work);
+	enum ci_role role;
+
+	disable_irq_nosync(ci->irq);
+	pm_runtime_get_sync(ci->dev);
+	if (!ci_otg_is_fsm_mode(ci)) {
+		role = ci_get_role(ci);
+
+		if (ci->role != role) {
+			ci_handle_id_switch(ci);
+		} else if (role == CI_ROLE_GADGET) {
+			if (ci->is_otg && hw_read_otgsc(ci, OTGSC_BSV))
+				usb_gadget_vbus_connect(&ci->gadget);
+		}
+	}
+	pm_runtime_put_sync(ci->dev);
+	enable_irq(ci->irq);
+}
+
 static DEFINE_IDA(ci_ida);
 
 struct platform_device *ci_hdrc_add_device(struct device *dev,
@@ -1045,6 +1066,8 @@ static int ci_hdrc_probe(struct platform
 
 	spin_lock_init(&ci->lock);
 	mutex_init(&ci->mutex);
+	INIT_WORK(&ci->power_lost_work, ci_power_lost_work);
+
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
@@ -1396,25 +1419,6 @@ static int ci_suspend(struct device *dev
 	return 0;
 }
 
-static void ci_handle_power_lost(struct ci_hdrc *ci)
-{
-	enum ci_role role;
-
-	disable_irq_nosync(ci->irq);
-	if (!ci_otg_is_fsm_mode(ci)) {
-		role = ci_get_role(ci);
-
-		if (ci->role != role) {
-			ci_handle_id_switch(ci);
-		} else if (role == CI_ROLE_GADGET) {
-			if (ci->is_otg && hw_read_otgsc(ci, OTGSC_BSV))
-				usb_gadget_vbus_connect(&ci->gadget);
-		}
-	}
-
-	enable_irq(ci->irq);
-}
-
 static int ci_resume(struct device *dev)
 {
 	struct ci_hdrc *ci = dev_get_drvdata(dev);
@@ -1446,7 +1450,7 @@ static int ci_resume(struct device *dev)
 		ci_role(ci)->resume(ci, power_lost);
 
 	if (power_lost)
-		ci_handle_power_lost(ci);
+		queue_work(system_freezable_wq, &ci->power_lost_work);
 
 	if (ci->supports_runtime_pm) {
 		pm_runtime_disable(dev);


