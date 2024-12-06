Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1BE1494D9;
	Fri,  6 Dec 2024 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496118; cv=none; b=bPrvuzocMkTTYhBtd8wCTW2rvyxBsN+9wpaidud+xydxg/8me8s16xF7fd2By3e/YKr0YJdgImHVhwSWV/QWNL0mywlWr7jttPnFcpBmoS+pDzp7PlkWqocw9JEm6zFf5Sbr1pH39JDA00ni/jMGIzRlw56haKbWE3OVNj7n85o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496118; c=relaxed/simple;
	bh=zznU40bJ5NMvVuPckZnkDnrBHPV8aeJbFERu+2WWkcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQeqU45GJZXr2O26fLtzFBYSY2GgyI2N2Pz9YInfhpCEFkuokQnNBIcurKlIzvqodzPDynewPGoWiVXZ/BNigBxcQMWr7jn8kKx+cEEgtmMzEwk+DXMNzTjzLRN7Yo2Vx42mvMytPlELoaVpuaUZS/5LlPuVEuoZEQTQ4JZMb+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxjaExpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxjaExpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E663C4CED1;
	Fri,  6 Dec 2024 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496118;
	bh=zznU40bJ5NMvVuPckZnkDnrBHPV8aeJbFERu+2WWkcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxjaExpBHImfhzsjuFhK3zgy6/QVveLvpsN4HhtaQ/R7EDS3YQEHCoX++CqxHos5B
	 wm/lqCNM5N/lFh62rTAgiAQ2tGNxBFcNWwQBFPGmoy08dDn4V8Cvico/GN+hxBdgF5
	 lN+2jFHJSPcYoYnK+rTv9xcNOVT2Nmu9duIIwDoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	stable <stable@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Subject: [PATCH 6.12 057/146] driver core: fw_devlink: Stop trying to optimize cycle detection logic
Date: Fri,  6 Dec 2024 15:36:28 +0100
Message-ID: <20241206143529.857324807@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

commit bac3b10b78e54b7da3cede397258f75a2180609b upstream.

In attempting to optimize fw_devlink runtime, I introduced numerous cycle
detection bugs by foregoing cycle detection logic under specific
conditions. Each fix has further narrowed the conditions for optimization.

It's time to give up on these optimization attempts and just run the cycle
detection logic every time fw_devlink tries to create a device link.

The specific bug report that triggered this fix involved a supplier fwnode
that never gets a device created for it. Instead, the supplier fwnode is
represented by the device that corresponds to an ancestor fwnode.

In this case, fw_devlink didn't do any cycle detection because the cycle
detection logic is only run when a device link is created between the
devices that correspond to the actual consumer and supplier fwnodes.

With this change, fw_devlink will run cycle detection logic even when
creating SYNC_STATE_ONLY proxy device links from a device that is an
ancestor of a consumer fwnode.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Closes: https://lore.kernel.org/all/1a1ab663-d068-40fb-8c94-f0715403d276@ideasonboard.com/
Fixes: 6442d79d880c ("driver core: fw_devlink: Improve detection of overlapping cycles")
Cc: stable <stable@kernel.org>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20241030171009.1853340-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |   55 ++++++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1989,10 +1989,10 @@ static struct device *fwnode_get_next_pa
  *
  * Return true if one or more cycles were found. Otherwise, return false.
  */
-static bool __fw_devlink_relax_cycles(struct device *con,
+static bool __fw_devlink_relax_cycles(struct fwnode_handle *con_handle,
 				 struct fwnode_handle *sup_handle)
 {
-	struct device *sup_dev = NULL, *par_dev = NULL;
+	struct device *sup_dev = NULL, *par_dev = NULL, *con_dev = NULL;
 	struct fwnode_link *link;
 	struct device_link *dev_link;
 	bool ret = false;
@@ -2009,22 +2009,22 @@ static bool __fw_devlink_relax_cycles(st
 
 	sup_handle->flags |= FWNODE_FLAG_VISITED;
 
-	sup_dev = get_dev_from_fwnode(sup_handle);
-
 	/* Termination condition. */
-	if (sup_dev == con) {
+	if (sup_handle == con_handle) {
 		pr_debug("----- cycle: start -----\n");
 		ret = true;
 		goto out;
 	}
 
+	sup_dev = get_dev_from_fwnode(sup_handle);
+	con_dev = get_dev_from_fwnode(con_handle);
 	/*
 	 * If sup_dev is bound to a driver and @con hasn't started binding to a
 	 * driver, sup_dev can't be a consumer of @con. So, no need to check
 	 * further.
 	 */
 	if (sup_dev && sup_dev->links.status ==  DL_DEV_DRIVER_BOUND &&
-	    con->links.status == DL_DEV_NO_DRIVER) {
+	    con_dev && con_dev->links.status == DL_DEV_NO_DRIVER) {
 		ret = false;
 		goto out;
 	}
@@ -2033,7 +2033,7 @@ static bool __fw_devlink_relax_cycles(st
 		if (link->flags & FWLINK_FLAG_IGNORE)
 			continue;
 
-		if (__fw_devlink_relax_cycles(con, link->supplier)) {
+		if (__fw_devlink_relax_cycles(con_handle, link->supplier)) {
 			__fwnode_link_cycle(link);
 			ret = true;
 		}
@@ -2048,7 +2048,7 @@ static bool __fw_devlink_relax_cycles(st
 	else
 		par_dev = fwnode_get_next_parent_dev(sup_handle);
 
-	if (par_dev && __fw_devlink_relax_cycles(con, par_dev->fwnode)) {
+	if (par_dev && __fw_devlink_relax_cycles(con_handle, par_dev->fwnode)) {
 		pr_debug("%pfwf: cycle: child of %pfwf\n", sup_handle,
 			 par_dev->fwnode);
 		ret = true;
@@ -2066,7 +2066,7 @@ static bool __fw_devlink_relax_cycles(st
 		    !(dev_link->flags & DL_FLAG_CYCLE))
 			continue;
 
-		if (__fw_devlink_relax_cycles(con,
+		if (__fw_devlink_relax_cycles(con_handle,
 					      dev_link->supplier->fwnode)) {
 			pr_debug("%pfwf: cycle: depends on %pfwf\n", sup_handle,
 				 dev_link->supplier->fwnode);
@@ -2114,11 +2114,6 @@ static int fw_devlink_create_devlink(str
 	if (link->flags & FWLINK_FLAG_IGNORE)
 		return 0;
 
-	if (con->fwnode == link->consumer)
-		flags = fw_devlink_get_flags(link->flags);
-	else
-		flags = FW_DEVLINK_FLAGS_PERMISSIVE;
-
 	/*
 	 * In some cases, a device P might also be a supplier to its child node
 	 * C. However, this would defer the probe of C until the probe of P
@@ -2139,25 +2134,23 @@ static int fw_devlink_create_devlink(str
 		return -EINVAL;
 
 	/*
-	 * SYNC_STATE_ONLY device links don't block probing and supports cycles.
-	 * So, one might expect that cycle detection isn't necessary for them.
-	 * However, if the device link was marked as SYNC_STATE_ONLY because
-	 * it's part of a cycle, then we still need to do cycle detection. This
-	 * is because the consumer and supplier might be part of multiple cycles
-	 * and we need to detect all those cycles.
+	 * Don't try to optimize by not calling the cycle detection logic under
+	 * certain conditions. There's always some corner case that won't get
+	 * detected.
 	 */
-	if (!device_link_flag_is_sync_state_only(flags) ||
-	    flags & DL_FLAG_CYCLE) {
-		device_links_write_lock();
-		if (__fw_devlink_relax_cycles(con, sup_handle)) {
-			__fwnode_link_cycle(link);
-			flags = fw_devlink_get_flags(link->flags);
-			pr_debug("----- cycle: end -----\n");
-			dev_info(con, "Fixed dependency cycle(s) with %pfwf\n",
-				 sup_handle);
-		}
-		device_links_write_unlock();
+	device_links_write_lock();
+	if (__fw_devlink_relax_cycles(link->consumer, sup_handle)) {
+		__fwnode_link_cycle(link);
+		pr_debug("----- cycle: end -----\n");
+		pr_info("%pfwf: Fixed dependency cycle(s) with %pfwf\n",
+			link->consumer, sup_handle);
 	}
+	device_links_write_unlock();
+
+	if (con->fwnode == link->consumer)
+		flags = fw_devlink_get_flags(link->flags);
+	else
+		flags = FW_DEVLINK_FLAGS_PERMISSIVE;
 
 	if (sup_handle->flags & FWNODE_FLAG_NOT_DEVICE)
 		sup_dev = fwnode_get_next_parent_dev(sup_handle);


