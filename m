Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E8F448D11;
	Tue, 25 Aug 2026 13:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666323; cv=none; b=Eqvmc5lPHAZ4ppRITx/hxdQ9pAcr8LSnUiakl0CHNUX1c/8D31XvOPpbmDQnDVjbd/p85qLroa+aMKoRwHZJfzrBHp9Eq/hy1Pj9s8ptND17mhrkOn5oVhT7mYQ1E8wDHs3ehRQZDdfXxo3XxggCiKF8JEWvpW9568OpMgUHReE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666323; c=relaxed/simple;
	bh=Luf5KHsF9q6Fbma4qznxrFkGkYLx8ZuE+/ZWDw5L7xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgrT8PIw9Y6xL7MA/AdvGC37Q5j/HK2h04Ui+xjT9l4DZ6lW2ozze5v1BRBK1CkRLxTEvpM7jK6GPb4Zc5Zs6tz9xvIB+wuavrZqkTeJF0hnEIp4c9qX8lN9xnhKctVo+C2jdTawoLI0oMft+fLKj4fRp4tMcTwpgu9W5xTOz1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+0qZmPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+0qZmPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37D71F00A3A;
	Tue, 25 Aug 2026 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666322;
	bh=po362stAC94Om3n+0F+ozb3ae+NP4wkw2LDMoO/gzNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+0qZmPfhMnZbuAYk6ykHAYvTvCqcO8hlzvR6u51njENMQpx/wNe9jOo2647W5BGe
	 0b6JLtLN+E4RU3BLTrdJiKgPAKxnekwg5JIaK9UH+XWAbW9r93nafMUjz3t4St1x3g
	 up6cOh6/kUV875iYtrp9xSonOvl3l737mdW4H4sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/76] s390/vfio_ccw: Selectively expand io_mutex
Date: Tue, 25 Aug 2026 15:26:40 +0200
Message-ID: <20260825132543.414980512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 34f4feff3e90bd09308fad0974e97113b23b812a ]

The io_mutex was defined to serialize the io_regions, but then has
also sort of been associated with the I/O themselves because of
the close relationship they share.

With the handful of races that are possible, the choices are either to:
 A) expand the scope of io_mutex to close these remaining windows, or
 B) reduce the scope of io_mutex to just io_region, and introduce a new
    lock mechanism for the remaining I/O resources

This patch implements A, since B brings with it a lot more interactions
that would need to be tracked and kept in a correct hierarchy. It also
takes advantage of the workqueue element for cp_free() that now gets
called out of fsm_notoper(), which could be invoked out of an interrupt
context and thus cannot acquire a mutex itself.

Fixes: 4f76617378ee ("vfio-ccw: protect the I/O region")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Stable-dep-of: 16b0798024c0 ("s390/vfio_ccw: Implement a crw lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_chp.c     |    2 +-
 drivers/s390/cio/vfio_ccw_cp.c      |    9 ++++++++-
 drivers/s390/cio/vfio_ccw_drv.c     |    4 ++--
 drivers/s390/cio/vfio_ccw_private.h |    3 ++-
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -97,13 +97,13 @@ static ssize_t vfio_ccw_crw_region_read(
 	if (pos + count > sizeof(*region))
 		return -EINVAL;
 
+	mutex_lock(&private->io_mutex);
 	crw = list_first_entry_or_null(&private->crw,
 				       struct vfio_ccw_crw, next);
 
 	if (crw)
 		list_del(&crw->next);
 
-	mutex_lock(&private->io_mutex);
 	if (i >= private->num_regions) {
 		ret = -EINVAL;
 		goto out;
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -16,6 +16,7 @@
 #include <asm/idals.h>
 
 #include "vfio_ccw_cp.h"
+#include "vfio_ccw_private.h"
 
 struct pfn_array {
 	/* Starting guest physical I/O address. */
@@ -852,17 +853,23 @@ void cp_update_scsw(struct channel_progr
  */
 bool cp_iova_pinned(struct channel_program *cp, u64 iova)
 {
+	struct vfio_ccw_private *private =
+		container_of(cp, struct vfio_ccw_private, cp);
 	struct ccwchain *chain;
 	int i;
 
 	if (!cp->initialized)
 		return false;
 
+	mutex_lock(&private->io_mutex);
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++)
-			if (pfn_array_iova_pinned(chain->ch_pa + i, iova))
+			if (pfn_array_iova_pinned(chain->ch_pa + i, iova)) {
+				mutex_unlock(&private->io_mutex);
 				return true;
+			}
 	}
+	mutex_unlock(&private->io_mutex);
 
 	return false;
 }
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -93,6 +93,7 @@ static void vfio_ccw_sch_io_todo(struct
 
 	is_final = !(scsw_actl(&irb->scsw) &
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
+	mutex_lock(&private->io_mutex);
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
 		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
@@ -100,9 +101,7 @@ static void vfio_ccw_sch_io_todo(struct
 			cp_is_finished = true;
 		}
 	}
-	mutex_lock(&private->io_mutex);
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
-	mutex_unlock(&private->io_mutex);
 
 	/*
 	 * Reset to IDLE only if processing of a channel program
@@ -111,6 +110,7 @@ static void vfio_ccw_sch_io_todo(struct
 	 */
 	if (private->mdev && cp_is_finished)
 		private->state = VFIO_CCW_STATE_IDLE;
+	mutex_unlock(&private->io_mutex);
 
 	if (private->io_trigger)
 		eventfd_signal(private->io_trigger, 1);
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -74,7 +74,8 @@ struct vfio_ccw_crw {
  * @mdev: pointer to the mediated device
  * @nb: notifier for vfio events
  * @io_region: MMIO region to input/output I/O arguments/results
- * @io_mutex: protect against concurrent update of I/O regions
+ * @io_mutex: protect against concurrent update of I/O resources
+ *            and @cp lifecycle
  * @region: additional regions for other subchannel operations
  * @cmd_region: MMIO region for asynchronous I/O commands other than START
  * @schib_region: MMIO region for SCHIB information


