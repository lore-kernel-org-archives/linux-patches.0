Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D711221DA0;
	Thu, 12 Dec 2024 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017825; cv=none; b=UDCDgEhzB2ytRglRpCmEN+QP5csqKpS/qHe16mFHJ34EM9nRfnaARfcentHuzHcGUd1GMudUEqmj/Og9Zg0Jslk6kiAlCbnBHEBlDpODF+zmIG/uJumRgYsgYJxFTydI7704FNVVU3ERldBRuqbFuoV871O19K73uaKaYlkqcS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017825; c=relaxed/simple;
	bh=NyQ+psfD32HZnSbYODGJ8joy84UrVG82fAmn5VIhpXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlJaQu/zLeW29k5Z+wgFpC/vrJNsLN/azcLGwI6a32zmEh4V50h09ftBH1lAZKyfAfzaaJ46KQOw8Tn7PQIGxD7TQU7eIsTvLweUO9WTWW4AQqNc3SiZHZlDSa8AerF3IXA3O5augbMTR4rLlz25QrwP/iJKiPKf7Y2/mBx4Aro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6fLD3pa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6fLD3pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC69C4CECE;
	Thu, 12 Dec 2024 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017825;
	bh=NyQ+psfD32HZnSbYODGJ8joy84UrVG82fAmn5VIhpXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6fLD3pat8uHMSdqLIur1+T6GjB6DSsVYrU7lxq+/5KY/xjuQzWukYpi0EcYJWg2l
	 EwHpL7Cj5zD3FkSMYgAtQaYNLo5rOXvbV5IGwCUxt5BoMia8mOy4RDY3ZL5WoUHc6m
	 Q1yHCTyojr5Q22zAdYjNIypOf5NqOJHcxTFbVRhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/356] driver core: fw_devlink: Improve logs for cycle detection
Date: Thu, 12 Dec 2024 15:56:53 +0100
Message-ID: <20241212144248.329398208@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 6e7ad1aebb4fc9fed0217dd50ef6e58a53f17d81 ]

The links in a cycle are not all logged in a consistent manner or not
logged at all. Make them consistent by adding a "cycle:" string and log all
the link in the cycles (even the child ==> parent dependency) so that it's
easier to debug cycle detection code. Also, mark the start and end of a
cycle so it's easy to tell when multiple cycles are logged back to back.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240202095636.868578-4-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize cycle detection logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index c9fb3243e353e..499904f1ba6b3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -125,7 +125,7 @@ static void __fwnode_link_del(struct fwnode_link *link)
  */
 static void __fwnode_link_cycle(struct fwnode_link *link)
 {
-	pr_debug("%pfwf: Relaxing link with %pfwf\n",
+	pr_debug("%pfwf: cycle: depends on %pfwf\n",
 		 link->consumer, link->supplier);
 	link->flags |= FWLINK_FLAG_CYCLE;
 }
@@ -1959,6 +1959,7 @@ static bool __fw_devlink_relax_cycles(struct device *con,
 
 	/* Termination condition. */
 	if (sup_dev == con) {
+		pr_debug("----- cycle: start -----\n");
 		ret = true;
 		goto out;
 	}
@@ -1990,8 +1991,11 @@ static bool __fw_devlink_relax_cycles(struct device *con,
 	else
 		par_dev = fwnode_get_next_parent_dev(sup_handle);
 
-	if (par_dev && __fw_devlink_relax_cycles(con, par_dev->fwnode))
+	if (par_dev && __fw_devlink_relax_cycles(con, par_dev->fwnode)) {
+		pr_debug("%pfwf: cycle: child of %pfwf\n", sup_handle,
+			 par_dev->fwnode);
 		ret = true;
+	}
 
 	if (!sup_dev)
 		goto out;
@@ -2007,6 +2011,8 @@ static bool __fw_devlink_relax_cycles(struct device *con,
 
 		if (__fw_devlink_relax_cycles(con,
 					      dev_link->supplier->fwnode)) {
+			pr_debug("%pfwf: cycle: depends on %pfwf\n", sup_handle,
+				 dev_link->supplier->fwnode);
 			fw_devlink_relax_link(dev_link);
 			dev_link->flags |= DL_FLAG_CYCLE;
 			ret = true;
@@ -2086,6 +2092,7 @@ static int fw_devlink_create_devlink(struct device *con,
 		if (__fw_devlink_relax_cycles(con, sup_handle)) {
 			__fwnode_link_cycle(link);
 			flags = fw_devlink_get_flags(link->flags);
+			pr_debug("----- cycle: end -----\n");
 			dev_info(con, "Fixed dependency cycle(s) with %pfwf\n",
 				 sup_handle);
 		}
-- 
2.43.0



