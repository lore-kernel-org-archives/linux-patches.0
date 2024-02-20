Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDE114AD15;
	Tue, 20 Feb 2024 21:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463672; cv=none; b=h/c3i9ulIkB271spG2mh1klTk2QiV5YhFk6oLbGdiRDPolCCG3/10POJV2dCXcdL7qFHoMfFU93LSwOPto1AxcK5pxam96FzV80gLLjMtRbGT+p2tFKcDt9s8jktLDfLNoFGJitP3x8kOZc4iTShkAMYu9wYaC9VmWmiTckZAIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463672; c=relaxed/simple;
	bh=2PRZuZPUOvEhhILWuCrRF6gUiArF7CU7T71AGEl8rxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4zfJKMFy5sqVZacc1SwvF3Qe7inVNyBofSVmSfaBslKxrrRVrQnftn5AIhADSgHBJ6T5HnlEDMi0SL6WMX+at1PpBv0pQw7hz3ivA7h3+QYOgr2VgtA21RjZ17Be328X0EY/xl66raK18CakJ8VxEX+sUd82o1ehcbU3zOVZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcCJXBcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcCJXBcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B1AC433F1;
	Tue, 20 Feb 2024 21:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463672;
	bh=2PRZuZPUOvEhhILWuCrRF6gUiArF7CU7T71AGEl8rxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcCJXBcERfRaQqjo7ZAj+pZiwq+D+XWiMG+R5a34RgEY9fBvjq1o3wldG+EO0mQCY
	 2fQ7zv6N6zRJBbEt/mtlIjDD7Z3RWb9WkBrB200Iz1qn3bnJ7Ml7wfH+ReAnVgOibT
	 YQHescqBr3/27m29BnrELraDxSed7gJIX+MvOpn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Saravana Kannan <saravanak@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/331] driver core: fw_devlink: Improve detection of overlapping cycles
Date: Tue, 20 Feb 2024 21:53:24 +0100
Message-ID: <20240220205640.355998217@linuxfoundation.org>
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

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 6442d79d880cf7a2fff18779265d657fef0cce4c ]

fw_devlink can detect most overlapping/intersecting cycles. However it was
missing a few corner cases because of an incorrect optimization logic that
tries to avoid repeating cycle detection for devices that are already
marked as part of a cycle.

Here's an example provided by Xu Yang (edited for clarity):

                    usb
                  +-----+
   tcpc           |     |
  +-----+         |  +--|
  |     |----------->|EP|
  |--+  |         |  +--|
  |EP|<-----------|     |
  |--+  |         |  B  |
  |     |         +-----+
  |  A  |            |
  +-----+            |
     ^     +-----+   |
     |     |     |   |
     +-----|  C  |<--+
           |     |
           +-----+
           usb-phy

Node A (tcpc) will be populated as device 1-0050.
Node B (usb) will be populated as device 38100000.usb.
Node C (usb-phy) will be populated as device 381f0040.usb-phy.

The description below uses the notation:
consumer --> supplier
child ==> parent

1. Node C is populated as device C. No cycles detected because cycle
   detection is only run when a fwnode link is converted to a device link.

2. Node B is populated as device B. As we convert B --> C into a device
   link we run cycle detection and find and mark the device link/fwnode
   link cycle:
   C--> A --> B.EP ==> B --> C

3. Node A is populated as device A. As we convert C --> A into a device
   link, we see it's already part of a cycle (from step 2) and don't run
   cycle detection. Thus we miss detecting the cycle:
   A --> B.EP ==> B --> A.EP ==> A

Looking at it another way, A depends on B in one way:
A --> B.EP ==> B

But B depends on A in two ways and we only detect the first:
B --> C --> A
B --> A.EP ==> A

To detect both of these, we remove the incorrect optimization attempt in
step 3 and run cycle detection even if the fwnode link from which the
device link is being created has already been marked as part of a cycle.

Reported-by: Xu Yang <xu.yang_2@nxp.com>
Closes: https://lore.kernel.org/lkml/DU2PR04MB8822693748725F85DC0CB86C8C792@DU2PR04MB8822.eurprd04.prod.outlook.com/
Fixes: 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240202095636.868578-3-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a81bc8844a8f..2cc0ab854168 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2059,9 +2059,14 @@ static int fw_devlink_create_devlink(struct device *con,
 
 	/*
 	 * SYNC_STATE_ONLY device links don't block probing and supports cycles.
-	 * So cycle detection isn't necessary and shouldn't be done.
+	 * So, one might expect that cycle detection isn't necessary for them.
+	 * However, if the device link was marked as SYNC_STATE_ONLY because
+	 * it's part of a cycle, then we still need to do cycle detection. This
+	 * is because the consumer and supplier might be part of multiple cycles
+	 * and we need to detect all those cycles.
 	 */
-	if (!(flags & DL_FLAG_SYNC_STATE_ONLY)) {
+	if (!device_link_flag_is_sync_state_only(flags) ||
+	    flags & DL_FLAG_CYCLE) {
 		device_links_write_lock();
 		if (__fw_devlink_relax_cycles(con, sup_handle)) {
 			__fwnode_link_cycle(link);
-- 
2.43.0



